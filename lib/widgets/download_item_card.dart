import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:get/get.dart';
import '../models/download_item.dart';
import '../controllers/form_controller.dart';
import '../views/player_view.dart';
import '../theme/app_colors.dart';

class DownloadItemCard extends StatelessWidget {
  final DownloadItem item;
  final int index;
  final FormController controller = Get.find<FormController>();

  DownloadItemCard({Key? key, required this.item, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PlayerView(item: item));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                                  color: AppColors.disabled,
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.play_rectangle_fill,
                                      size: 40,
                                      color: AppColors.textSecondary,
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
                            color: AppColors.textPrimary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.duration!,
                            style: TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (item.videoTitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.videoTitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (item.videoAuthor != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.videoAuthor!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    CupertinoIcons.delete,
                    size: 16,
                    color: CupertinoColors.black,
                  ),
                ),
                onPressed: () {
                  controller.deleteItem(index);
                },
              ),
            ),
            if (item.isDownloading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground.withOpacity(0.9),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: item.downloadProgress,
                            backgroundColor: AppColors.disabled,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
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
    );
  }
}
