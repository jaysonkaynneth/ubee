class DownloadItem {
  final String name;
  final String youtubeLink;
  final String? videoTitle;
  final String? videoAuthor;
  final String? thumbnailUrl;
  final String? duration;
  final bool isDownloading;
  final double downloadProgress;

  DownloadItem({
    required this.name,
    required this.youtubeLink,
    this.videoTitle,
    this.videoAuthor,
    this.thumbnailUrl,
    this.duration,
    this.isDownloading = false,
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
      'downloadProgress': downloadProgress,
    };
  }

  factory DownloadItem.fromJson(Map<String, dynamic> json) {
    return DownloadItem(
      name: json['name'],
      youtubeLink: json['youtubeLink'],
      videoTitle: json['videoTitle'],
      videoAuthor: json['videoAuthor'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['duration'],
      isDownloading: json['isDownloading'] ?? false,
      downloadProgress: json['downloadProgress'] ?? 0.0,
    );
  }
}
