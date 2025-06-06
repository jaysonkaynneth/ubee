import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import '../models/download_item.dart';
import '../controllers/form_controller.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/player_controller.dart';

class UbeeAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  FormController get _formController => Get.find<FormController>();

  DownloadItem? _currentItem;
  int _currentIndex = -1;
  bool _isLooping = false;

  AudioPlayer get player => _player;

  UbeeAudioHandler() {
    _init();
  }

  void _init() {
    _player.playingStream.listen((playing) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: playing,
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },
        ),
      );
    });

    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    _player.durationStream.listen((duration) {
      if (duration != null && _currentItem != null) {
        mediaItem.add(
          MediaItem(
            id: _currentItem!.name,
            album: _currentItem!.videoAuthor ?? 'Unknown',
            title: _currentItem!.videoTitle ?? _currentItem!.name,
            artist: _currentItem!.videoAuthor ?? 'Unknown',
            duration: duration,
            artUri:
                _currentItem!.thumbnailUrl != null
                    ? Uri.parse(_currentItem!.thumbnailUrl!)
                    : null,
          ),
        );

        playbackState.add(
          playbackState.value.copyWith(updatePosition: _player.position),
        );
      }
    });

    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }

  Future<void> loadItem(DownloadItem item, String filePath) async {
    _currentItem = item;
    _currentIndex = _formController.items.indexWhere(
      (i) => i.name == item.name,
    );

    try {
      final playerController = Get.find<PlayerController>();
      playerController.currentItem.value = item;
      playerController.loadCaptions(item.youtubeLink);
    } catch (e) {}

    await _player.setFilePath(filePath);

    await _player.seek(Duration.zero);

    Duration? duration = _player.duration;
    if (duration == null) {
      await _player.durationStream.first;
      duration = _player.duration;
    }

    mediaItem.add(
      MediaItem(
        id: item.name,
        album: item.videoAuthor ?? 'Unknown',
        title: item.videoTitle ?? item.name,
        artist: item.videoAuthor ?? 'Unknown',
        duration: duration,
        artUri:
            item.thumbnailUrl != null ? Uri.parse(item.thumbnailUrl!) : null,
      ),
    );

    await _player.play();
  }

  void setLooping(bool looping) {
    _isLooping = looping;
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    if (_currentIndex < _formController.items.length - 1) {
      final nextItem = _formController.items[_currentIndex + 1];
      _currentIndex++;
      _currentItem = nextItem;

      final dir = await getApplicationDocumentsDirectory();
      final fileName = nextItem.name
          .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
          .replaceAll(RegExp(r'\s+'), '_');
      final filePath = '${dir.path}/$fileName.mp3';

      await loadItem(nextItem, filePath);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final currentPosition = _player.position;

    if (currentPosition.inSeconds < 5 && _currentIndex > 0) {
      final previousItem = _formController.items[_currentIndex - 1];
      _currentIndex--;
      _currentItem = previousItem;

      final dir = await getApplicationDocumentsDirectory();
      final fileName = previousItem.name
          .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
          .replaceAll(RegExp(r'\s+'), '_');
      final filePath = '${dir.path}/$fileName.mp3';

      await loadItem(previousItem, filePath);
    } else {
      await _player.seek(Duration.zero);
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }
}
