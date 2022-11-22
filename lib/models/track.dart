class Track {
  String name;
  String previewUrl;
  String id;
  List<String> artists;
  String image;
  Track({
    required this.name,
    required this.previewUrl,
    required this.id,
    required this.artists,
    required this.image,
  });

  factory Track.fromJson(Map<String, dynamic> map) {
    Track t = Track(
        name: map['name'] ?? '',
        previewUrl: map['preview_url'] ?? '',
        id: map['id'] ?? '',
        artists:
            List<String>.from(map['artists'].map((e) => e['name']).toList()),
        image: map['album']['images'][0]['url'] ?? '');
    return t;
  }
}
