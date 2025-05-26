import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/download_item.dart';
import '../controllers/form_controller.dart';
import 'package:flutter/widgets.dart';

class PlayerController extends GetxController {
  final _player = AudioPlayer();
  final _yt = YoutubeExplode();
  final formController = Get.find<FormController>();
  final Rx<DownloadItem?> currentItem = Rx<DownloadItem?>(null);
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxString currentTime = '0:00'.obs;
  final RxString totalTime = '0:00'.obs;
  final RxList<ClosedCaption> captions = <ClosedCaption>[].obs;
  final RxString currentCaption = ''.obs;
  final RxBool isDraggingSlider = false.obs;
  bool wasPlayingBeforeDrag = false;
  final ScrollController captionsScrollController = ScrollController();

  int get currentIndex {
    if (currentItem.value == null) return -1;
    return formController.items.indexWhere(
      (item) => item.name == currentItem.value!.name,
    );
  }

  bool get hasNext => currentIndex < formController.items.length - 1;
  bool get hasPrevious => currentIndex > 0;

  Future<void> playNext() async {
    if (!hasNext) return;
    final nextItem = formController.items[currentIndex + 1];
    await loadAndPlay(nextItem);
  }

  Future<void> playPrevious() async {
    if (!hasPrevious) return;
    final previousItem = formController.items[currentIndex - 1];
    await loadAndPlay(previousItem);
  }

  @override
  void onClose() {
    _player.dispose();
    _yt.close();
    captionsScrollController.dispose();
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

    final captionIndex = captions.indexWhere(
      (c) => c.offset <= position && position <= (c.offset + c.duration),
    );

    if (captionIndex != -1) {
      final caption = captions[captionIndex];
      currentCaption.value = caption.text;

      // Auto scroll to the current caption
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (captionsScrollController.hasClients) {
          final itemHeight = 30.0; // Approximate height of each caption item
          final scrollPosition = captionIndex * itemHeight;
          captionsScrollController.animateTo(
            scrollPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    } else {
      currentCaption.value = '';
    }
  }

  Future<void> loadAndPlay(DownloadItem item) async {
    try {
      currentItem.value = item;
      final dir = await getApplicationDocumentsDirectory();
      final fileName = item.name
          .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
          .replaceAll(RegExp(r'\s+'), '_');
      final filePath = '${dir.path}/$fileName.mp3';

      await _player.stop();

      await loadCaptions(item.youtubeLink);

      await _player.setFilePath(filePath);
      _player.play();
      isPlaying.value = true;

      _player.durationStream.listen((duration) {
        if (duration != null) {
          totalTime.value = _formatDuration(duration);
        }
      });

      _player.positionStream.listen((position) {
        if (!isDraggingSlider.value) {
          currentTime.value = _formatDuration(position);
          if (_player.duration != null) {
            final newProgress =
                position.inMilliseconds / _player.duration!.inMilliseconds;
            if (newProgress >= 1.0) {
              progress.value = 1.0;
              _player.pause();
              isPlaying.value = false;
              playNext();
            } else {
              progress.value = newProgress;
            }
          }
          updateCurrentCaption(position);
        }
      });

      _player.playingStream.listen((playing) {
        isPlaying.value = playing;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (progress.value >= 1.0) {
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

      if (value < 1.0 && wasPlayingBeforeDrag) {
        await _player.play();
        isPlaying.value = true;
      }
    }
  }

  Future<void> skipForward() async {
    if (_player.duration == null) return;
    final newPosition = _player.position + const Duration(seconds: 5);
    if (newPosition <= _player.duration!) {
      await _player.seek(newPosition);
    } else {
      await _player.seek(_player.duration!);
    }
  }

  Future<void> skipBackward() async {
    final newPosition = _player.position - const Duration(seconds: 5);
    if (newPosition.isNegative) {
      await _player.seek(Duration.zero);
    } else {
      await _player.seek(newPosition);
    }
  }
}
