class DownloadItem {
  final String name;
  final String youtubeLink;
  final String? videoTitle;
  final String? videoAuthor;
  final String? thumbnailUrl;
  final String? duration;
  final bool isDownloading;
  final bool isConverting;
  final double downloadProgress;

  DownloadItem({
    required this.name,
    required this.youtubeLink,
    this.videoTitle,
    this.videoAuthor,
    this.thumbnailUrl,
    this.duration,
    this.isDownloading = false,
    this.isConverting = false,
    this.downloadProgress = 0.0,
  });

  DownloadItem copyWith({
    String? name,
    String? youtubeLink,
    String? videoTitle,
    String? videoAuthor,
    String? thumbnailUrl,
    String? duration,
    bool? isDownloading,
    bool? isConverting,
    double? downloadProgress,
  }) {
    return DownloadItem(
      name: name ?? this.name,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      videoTitle: videoTitle ?? this.videoTitle,
      videoAuthor: videoAuthor ?? this.videoAuthor,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      isDownloading: isDownloading ?? this.isDownloading,
      isConverting: isConverting ?? this.isConverting,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'youtubeLink': youtubeLink,
      'videoTitle': videoTitle,
      'videoAuthor': videoAuthor,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'isDownloading': isDownloading,
      'isConverting': isConverting,
      'downloadProgress': downloadProgress,
    };
  }

  factory DownloadItem.fromJson(Map<String, dynamic> json) {
    return DownloadItem(
      name: json['name'] as String,
      youtubeLink: json['youtubeLink'] as String,
      videoTitle: json['videoTitle'] as String?,
      videoAuthor: json['videoAuthor'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: json['duration'] as String?,
      isDownloading: json['isDownloading'] as bool? ?? false,
      isConverting: json['isConverting'] as bool? ?? false,
      downloadProgress: json['downloadProgress'] as double? ?? 0.0,
    );
  }
}
