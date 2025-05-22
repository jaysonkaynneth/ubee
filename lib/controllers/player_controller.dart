import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/download_item.dart';

class PlayerController extends GetxController {
  final _player = AudioPlayer();
  final Rx<DownloadItem?> currentItem = Rx<DownloadItem?>(null);
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxString currentTime = '0:00'.obs;
  final RxString totalTime = '0:00'.obs;

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
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

      // Update position
      _player.positionStream.listen((position) {
        currentTime.value = _formatDuration(position);
        if (_player.duration != null) {
          progress.value =
              position.inMilliseconds / _player.duration!.inMilliseconds;
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
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    isPlaying.value = _player.playing;
  }

  Future<void> seek(double value) async {
    if (_player.duration != null) {
      final position = Duration(
        milliseconds: (value * _player.duration!.inMilliseconds).round(),
      );
      await _player.seek(position);
    }
  }
}
