import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/download_item.dart';
import '../controllers/player_controller.dart';
import '../theme/app_colors.dart';

class PlayerView extends StatelessWidget {
  final DownloadItem item;
  final PlayerController controller = Get.put(PlayerController());

  PlayerView({Key? key, required this.item}) : super(key: key) {
    controller.loadAndPlay(item);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: Text(
          'Now Playing',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Done', style: TextStyle(color: AppColors.primary)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Obx(
                    () => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          controller.currentItem.value?.thumbnailUrl != null
                              ? Image.network(
                                controller.currentItem.value!.thumbnailUrl!,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                color: AppColors.cardBackground,
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.music_note_2,
                                    size: 50,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Obx(
                      () => Text(
                        controller.currentItem.value?.name ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Obx(() {
                      final videoTitle =
                          controller.currentItem.value?.videoTitle;
                      if (videoTitle != null) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              videoTitle,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    Obx(() {
                      final videoAuthor =
                          controller.currentItem.value?.videoAuthor;
                      if (videoAuthor != null) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              videoAuthor,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.currentTime.value,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              controller.totalTime.value,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
                          onChangeStart: (value) {
                            controller.onSliderChangeStart(value);
                          },
                          onChanged: (value) {
                            controller.onSliderChanged(value);
                          },
                          onChangeEnd: (value) {
                            controller.onSliderChangeEnd(value);
                          },
                          activeColor: AppColors.sliderActive,
                          thumbColor: AppColors.cardBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                      () => Icon(
                        CupertinoIcons.backward_fill,
                        size: 28,
                        color:
                            controller.hasPrevious
                                ? AppColors.textPrimary
                                : AppColors.disabled,
                      ),
                    ),
                    onPressed: () {
                      if (controller.hasPrevious) {
                        controller.playPrevious();
                      }
                    },
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      CupertinoIcons.gobackward,
                      size: 24,
                      color: AppColors.textPrimary,
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
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        controller.togglePlayPause();
                      },
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      CupertinoIcons.goforward,
                      size: 24,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      controller.skipForward();
                    },
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                      () => Icon(
                        CupertinoIcons.forward_fill,
                        size: 28,
                        color:
                            controller.hasNext
                                ? AppColors.textPrimary
                                : AppColors.disabled,
                      ),
                    ),
                    onPressed: () {
                      if (controller.hasNext) {
                        controller.playNext();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Captions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(
                                CupertinoIcons.location_fill,
                                color: AppColors.textPrimary,
                              ),
                              onPressed: () {
                                controller.scrollToCurrentCaption();
                              },
                            ),
                            const SizedBox(width: 8),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(
                                CupertinoIcons.refresh,
                                color: AppColors.textPrimary,
                              ),
                              onPressed: () {
                                if (controller.currentItem.value?.youtubeLink !=
                                    null) {
                                  controller.loadCaptions(
                                    controller.currentItem.value!.youtubeLink,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.disabled, width: 1),
                      ),
                      child: Obx(
                        () =>
                            controller.captions.isEmpty
                                ? Center(
                                  child: Text(
                                    'No captions available',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  controller:
                                      controller.captionsScrollController,
                                  padding: const EdgeInsets.all(12),
                                  itemCount: controller.captions.length,
                                  itemBuilder: (context, index) {
                                    final caption = controller.captions[index];
                                    final startTime = _formatCaptionTime(
                                      caption.offset.inSeconds.toDouble(),
                                    );
                                    final endTime = _formatCaptionTime(
                                      (caption.offset + caption.duration)
                                          .inSeconds
                                          .toDouble(),
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Obx(
                                        () => Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                controller
                                                            .currentCaption
                                                            .value ==
                                                        caption.text
                                                    ? AppColors.captionHighlight
                                                        .withOpacity(0.1)
                                                    : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$startTime - $endTime',
                                                style: TextStyle(
                                                  color: AppColors.textSecondary
                                                      .withOpacity(0.7),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                caption.text,
                                                style: TextStyle(
                                                  color:
                                                      controller
                                                                  .currentCaption
                                                                  .value ==
                                                              caption.text
                                                          ? AppColors
                                                              .captionHighlight
                                                          : AppColors
                                                              .captionNormal,
                                                  fontSize: 14,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
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

  String _formatCaptionTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
