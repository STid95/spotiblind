class UserImage {
  String url;
  int height;
  int width;
  UserImage({
    required this.url,
    required this.height,
    required this.width,
  });

  factory UserImage.fromJson(Map<String, dynamic> map) {
    return UserImage(
      url: map['url'] ?? '',
      height: map['height']?.toInt() ?? 0,
      width: map['width']?.toInt() ?? 0,
    );
  }
}
