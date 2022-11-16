class SpotifyImage {
  String url;
  int height;
  int width;
  SpotifyImage({
    required this.url,
    required this.height,
    required this.width,
  });

  factory SpotifyImage.fromJson(Map<String, dynamic> map) {
    return SpotifyImage(
      url: map['url'] ?? '',
      height: map['height']?.toInt() ?? 0,
      width: map['width']?.toInt() ?? 0,
    );
  }
}
