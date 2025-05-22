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
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              controller.totalTime.value,
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        Obx(
                          () => SizedBox(
                            height: 30,
                            child: CupertinoSlider(
                              value: controller.progress.value,
                              onChangeStart: (value) {
                                controller.onSliderChangeStart(value);
                              },
                              onChanged: (value) {
                                controller.onSliderChanged(value);
                              },
                              onChangeEnd: (value) {
                                controller.onSliderChangeEnd(value);
                              },
                              activeColor: CupertinoColors.activeBlue,
                              thumbColor: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Media Controls
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        CupertinoIcons.backward_fill,
                        size: 28,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        // TODO: Implement previous
                      },
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        CupertinoIcons.gobackward,
                        size: 24,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        controller.skipBackward();
                      },
                    ),
                    Obx(
                      () => CupertinoButton(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          controller.isPlaying.value
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          size: 44,
                          color: CupertinoColors.activeBlue,
                        ),
                        onPressed: () {
                          controller.togglePlayPause();
                        },
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        CupertinoIcons.goforward,
                        size: 24,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        controller.skipForward();
                      },
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        CupertinoIcons.forward_fill,
                        size: 28,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        // TODO: Implement next
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Captions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Captions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Obx(
                        () =>
                            controller.captions.isEmpty
                                ? const Center(
                                  child: Text(
                                    'No captions available',
                                    style: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: controller.captions.length,
                                  itemBuilder: (context, index) {
                                    final caption = controller.captions[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Obx(
                                        () => Text(
                                          caption.text,
                                          style: TextStyle(
                                            color:
                                                controller
                                                            .currentCaption
                                                            .value ==
                                                        caption.text
                                                    ? CupertinoColors.activeBlue
                                                    : CupertinoColors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
