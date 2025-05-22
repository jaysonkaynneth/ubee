import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:get/get.dart';
import '../models/download_item.dart';
import '../controllers/form_controller.dart';
import '../views/player_view.dart';

class DownloadItemCard extends StatelessWidget {
  final DownloadItem item;
  final int index;

  const DownloadItemCard({Key? key, required this.item, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormController>();

    return Dismissible(
      key: Key(item.youtubeLink),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoColors.destructiveRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
      ),
      onDismissed: (direction) {
        controller.deleteItem(index);
      },
      child: GestureDetector(
        onTap: () {
          if (!item.isDownloading) {
            Get.to(
              () => PlayerView(item: item),
              transition: Transition.rightToLeft,
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail with duration
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
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
                                        CupertinoIcons.play_rectangle_fill,
                                        size: 40,
                                        color: CupertinoColors.systemGrey2,
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                      if (item.duration != null)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.duration!,
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Video details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item.videoTitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.videoTitle!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                        if (item.videoAuthor != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.videoAuthor!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.systemGrey2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (item.isDownloading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CupertinoActivityIndicator(),
                        const SizedBox(height: 8),
                        Text(
                          item.isConverting
                              ? 'Finishing up...'
                              : 'Downloading... ${(item.downloadProgress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: item.downloadProgress,
                              backgroundColor: CupertinoColors.systemGrey6,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
