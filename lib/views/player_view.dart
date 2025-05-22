import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/download_item.dart';
import '../controllers/player_controller.dart';

class PlayerView extends StatelessWidget {
  final DownloadItem item;
  final PlayerController controller = Get.put(PlayerController());

  PlayerView({Key? key, required this.item}) : super(key: key) {
    controller.loadAndPlay(item);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Now Playing'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Done'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Thumbnail
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        item.thumbnailUrl != null
                            ? Image.network(
                              item.thumbnailUrl!,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              color: CupertinoColors.systemGrey5,
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.music_note_2,
                                  size: 50,
                                  color: CupertinoColors.systemGrey2,
                                ),
                              ),
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Track Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (item.videoTitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        item.videoTitle!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.systemGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (item.videoAuthor != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        item.videoAuthor!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.systemGrey2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Progress Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Time labels
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.currentTime.value,
                              style: TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              controller.totalTime.value,
                              style: TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: Obx(
                        () => CupertinoSlider(
                          value: controller.progress.value,
                          onChanged: (value) {
                            controller.seek(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Media Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      CupertinoIcons.backward_fill,
                      size: 35,
                      color: CupertinoColors.black,
                    ),
                    onPressed: () {
                      // TODO: Implement previous
                    },
                  ),
                  Obx(
                    () => CupertinoButton(
                      padding: const EdgeInsets.all(20),
                      child: Icon(
                        controller.isPlaying.value
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        size: 50,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        controller.togglePlayPause();
                      },
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      CupertinoIcons.forward_fill,
                      size: 35,
                      color: CupertinoColors.black,
                    ),
                    onPressed: () {
                      // TODO: Implement next
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
