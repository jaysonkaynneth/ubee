import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/download_item.dart';

class PlayerController extends GetxController {
  final _player = AudioPlayer();
  final _yt = YoutubeExplode();
  final Rx<DownloadItem?> currentItem = Rx<DownloadItem?>(null);
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxString currentTime = '0:00'.obs;
  final RxString totalTime = '0:00'.obs;
  final RxList<ClosedCaption> captions = <ClosedCaption>[].obs;
  final RxString currentCaption = ''.obs;
  final RxBool isDraggingSlider = false.obs;
  bool wasPlayingBeforeDrag = false;

  @override
  void onClose() {
    _player.dispose();
    _yt.close();
    super.onClose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  Future<void> loadCaptions(String videoId) async {
    try {
      final trackManifest = await _yt.videos.closedCaptions.getManifest(
        videoId,
      );
      final trackInfo = trackManifest.tracks.firstWhereOrNull(
        (track) => track.language.code == 'en',
      );

      if (trackInfo != null) {
        final track = await _yt.videos.closedCaptions.get(trackInfo);
        captions.value = track.captions;
      } else {
        captions.clear();
      }
    } catch (e) {
      print('Error loading captions: $e');
      captions.clear();
    }
  }

  void updateCurrentCaption(Duration position) {
    if (captions.isEmpty) return;

    final caption = captions.firstWhereOrNull(
      (c) => c.offset <= position && position <= (c.offset + c.duration),
    );

    currentCaption.value = caption?.text ?? '';
  }

  Future<void> loadAndPlay(DownloadItem item) async {
    try {
      currentItem.value = item;
      final dir = await getApplicationDocumentsDirectory();
      final fileName = item.name
          .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
          .replaceAll(RegExp(r'\s+'), '_');
      final filePath = '${dir.path}/$fileName.mp3';

      // Stop current playback if any
      await _player.stop();

      // Load captions
      await loadCaptions(item.youtubeLink);

      // Load and play the new audio file
      await _player.setFilePath(filePath);
      _player.play();
      isPlaying.value = true;

      // Update duration
      _player.durationStream.listen((duration) {
        if (duration != null) {
          totalTime.value = _formatDuration(duration);
        }
      });

      // Update position and captions
      _player.positionStream.listen((position) {
        if (!isDraggingSlider.value) {
          currentTime.value = _formatDuration(position);
          if (_player.duration != null) {
            final newProgress =
                position.inMilliseconds / _player.duration!.inMilliseconds;
            // Check if we've reached the end
            if (newProgress >= 1.0) {
              progress.value = 1.0;
              _player.pause();
              isPlaying.value = false;
            } else {
              progress.value = newProgress;
            }
          }
          updateCurrentCaption(position);
        }
      });

      // Update playing state
      _player.playingStream.listen((playing) {
        isPlaying.value = playing;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (progress.value >= 1.0) {
      // If at the end, don't start playing
      return;
    }

    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    isPlaying.value = _player.playing;
  }

  void onSliderChangeStart(double value) {
    isDraggingSlider.value = true;
    wasPlayingBeforeDrag = _player.playing;
    if (wasPlayingBeforeDrag) {
      _player.pause();
      isPlaying.value = false;
    }
  }

  void onSliderChanged(double value) {
    if (_player.duration != null) {
      currentTime.value = _formatDuration(
        Duration(
          milliseconds: (value * _player.duration!.inMilliseconds).round(),
        ),
      );
      progress.value = value;
    }
  }

  Future<void> onSliderChangeEnd(double value) async {
    isDraggingSlider.value = false;
    if (_player.duration != null) {
      final position = Duration(
        milliseconds: (value * _player.duration!.inMilliseconds).round(),
      );
      await _player.seek(position);

      // Only resume playing if we weren't at the end and were playing before
      if (value < 1.0 && wasPlayingBeforeDrag) {
        await _player.play();
        isPlaying.value = true;
      }
    }
  }

  Future<void> skipForward() async {
    if (_player.duration == null) return;
    final newPosition = _player.position + const Duration(seconds: 5);
    // Ensure we don't skip past the end
    if (newPosition <= _player.duration!) {
      await _player.seek(newPosition);
    } else {
      await _player.seek(_player.duration!);
    }
  }

  Future<void> skipBackward() async {
    final newPosition = _player.position - const Duration(seconds: 5);
    // Ensure we don't go below 0
    if (newPosition.isNegative) {
      await _player.seek(Duration.zero);
    } else {
      await _player.seek(newPosition);
    }
  }
}
