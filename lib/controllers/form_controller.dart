import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import '../models/download_item.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

class FormController extends GetxController {
  final RxList<DownloadItem> items = <DownloadItem>[].obs;
  final _yt = YoutubeExplode();
  static const _metadataFileName = 'downloads_metadata.json';

  @override
  void onInit() {
    super.onInit();
    loadExistingDownloads();
  }

  @override
  void onClose() {
    _yt.close();
    super.onClose();
  }

  // Helper method to sanitize filename
  String _sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
  }

  Future<String> get _metadataFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$_metadataFileName';
  }

  Future<void> saveMetadata() async {
    try {
      final file = File(await _metadataFilePath);
      final data = items.map((item) => item.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
      await loadExistingDownloads();
    } catch (e) {
      print('Error saving metadata: $e');
    }
  }

  Future<void> loadExistingDownloads() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final List<DownloadItem> allItems = [];
      Map<String, dynamic> metadata = {};

      // Print all files in directory
      print('\nFiles in ${dir.path}:');
      dir.listSync().forEach((entity) {
        print('  ${entity.path.split('/').last}');
      });
      print('');

      // Load metadata if exists
      final metadataFile = File(await _metadataFilePath);
      if (await metadataFile.exists()) {
        final jsonString = await metadataFile.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        metadata = {
          for (var item in jsonList.map((json) => DownloadItem.fromJson(json)))
            _sanitizeFileName(item.name): item,
        };
      }

      // Scan directory for all audio files
      final audioFiles = dir.listSync().where((entity) {
        if (entity is File) {
          final extension = entity.path.split('.').last.toLowerCase();
          return extension == 'mp3' || extension == 'webm';
        }
        return false;
      });

      // Create items for each audio file
      for (var file in audioFiles) {
        final fileName = file.path.split('/').last;
        final nameWithoutExt = fileName.substring(0, fileName.lastIndexOf('.'));

        // Check if we have metadata for this file
        if (metadata.containsKey(nameWithoutExt)) {
          allItems.add(metadata[nameWithoutExt]!);
        } else {
          // Create basic item for files without metadata
          allItems.add(
            DownloadItem(
              name: nameWithoutExt,
              youtubeLink: '', // Empty since we don't know the source
              isDownloading: false,
              downloadProgress: 1.0, // Mark as complete since file exists
            ),
          );
        }
      }

      // Update the items list
      items.value = allItems;
    } catch (e) {
      print('Error loading existing downloads: $e');
    }
  }

  Future<void> addItem(String name, String youtubeLink) async {
    try {
      final video = await _yt.videos.get(youtubeLink);

      final item = DownloadItem(
        name: name,
        youtubeLink: video.id.value,
        videoTitle: video.title,
        videoAuthor: video.author,
        thumbnailUrl: video.thumbnails.highResUrl,
        duration: video.duration?.toString().split('.').first ?? '',
        isDownloading: true,
      );

      final index = items.length;
      items.add(item);

      await downloadAudio(video.id.value, index, name);
      await saveMetadata();
    } catch (e) {
      print('Error fetching video info: $e');
      final item = DownloadItem(name: name, youtubeLink: youtubeLink);
      items.add(item);
      await saveMetadata();
    }
  }

  Future<void> downloadAudio(
    String videoId,
    int itemIndex,
    String customName,
  ) async {
    try {
      print('Starting download for video ID: $videoId');
      final manifest = await _yt.videos.streams.getManifest(videoId);

      final audioStreams = manifest.audioOnly;
      if (audioStreams.isEmpty) {
        throw Exception('No audio streams available for this video');
      }

      final audioStream = audioStreams.withHighestBitrate();
      if (audioStream == null) {
        throw Exception('Could not find a suitable audio stream');
      }

      final dir = await getApplicationDocumentsDirectory();
      final fileName = _sanitizeFileName(customName);
      // First save as webm
      final webmPath = '${dir.path}/$fileName.webm';
      final mp3Path = '${dir.path}/$fileName.mp3';
      print('Saving temporary webm to: $webmPath');

      final file = File(webmPath);
      final fileStream = file.openWrite();

      final stream = _yt.videos.streams.get(audioStream);
      final len = audioStream.size.totalBytes;
      var count = 0;

      try {
        await for (final data in stream) {
          count += data.length;
          final progress =
              (count / len * 0.5) * 2; // Multiply by 2 to show full range

          if (itemIndex < items.length) {
            final currentItem = items[itemIndex];
            items[itemIndex] = currentItem.copyWith(
              downloadProgress: progress,
              isDownloading: true,
            );
          } else {
            throw Exception('Item index out of bounds');
          }

          fileStream.add(data);
        }

        await fileStream.flush();
        await fileStream.close();

        // Convert webm to mp3 using FFmpeg
        print('Converting webm to mp3...');
        if (itemIndex < items.length) {
          final currentItem = items[itemIndex];
          items[itemIndex] = currentItem.copyWith(
            downloadProgress: 1.0, // Set to 1.0 to indicate conversion phase
            isDownloading: true,
            isConverting: true, // Add this field to DownloadItem model
          );
        }

        final session = await FFmpegKit.execute(
          '-i "$webmPath" -vn -acodec libmp3lame -q:a 2 "$mp3Path"',
        );

        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          // Delete the temporary webm file
          if (await file.exists()) {
            await file.delete();
          }

          if (itemIndex < items.length) {
            final completedItem = items[itemIndex];
            items[itemIndex] = completedItem.copyWith(
              isDownloading: false,
              downloadProgress: 1.0,
            );
            await saveMetadata();
            print('Download and conversion completed successfully');
          }
        } else {
          final logs = await session.getLogs();
          print('FFmpeg conversion failed. Logs:');
          for (final log in logs) {
            print(log.getMessage());
          }
          throw Exception('FFmpeg conversion failed');
        }
      } catch (e, stackTrace) {
        print('Error during download or conversion: $e');
        print('Stack trace: $stackTrace');
        await fileStream.close();
        // Clean up both webm and mp3 files if they exist
        if (await file.exists()) {
          await file.delete();
        }
        final mp3File = File(mp3Path);
        if (await mp3File.exists()) {
          await mp3File.delete();
        }
        throw e;
      }
    } catch (e, stackTrace) {
      print('Error downloading audio: $e');
      print('Stack trace: $stackTrace');
      if (itemIndex < items.length) {
        final failedItem = items[itemIndex];
        items[itemIndex] = failedItem.copyWith(
          isDownloading: false,
          downloadProgress: 0.0,
        );
        await saveMetadata();
      }
      Get.snackbar(
        'Download Failed',
        'Could not download or convert audio. Please try again.',
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteItem(int index) async {
    try {
      final item = items[index];
      final dir = await getApplicationDocumentsDirectory();
      final fileName = _sanitizeFileName(item.name);

      // Try to delete both .mp3 and .webm versions if they exist
      final mp3File = File('${dir.path}/$fileName.mp3');
      final webmFile = File('${dir.path}/$fileName.webm');

      if (await mp3File.exists()) {
        await mp3File.delete();
      }
      if (await webmFile.exists()) {
        await webmFile.delete();
      }

      items.removeAt(index);
      await saveMetadata();

      print('\nFiles in ${dir.path} after deletion:');
      dir.listSync().forEach((entity) {
        print('  ${entity.path.split('/').last}');
      });
      print('');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}
