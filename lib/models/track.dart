class Track {
  String name;
  String previewUrl;
  String id;
  List<String> artists;
  Track({
    required this.name,
    required this.previewUrl,
    required this.id,
    required this.artists,
  });

  factory Track.fromJson(Map<String, dynamic> map) {
    return Track(
      name: map['name'] ?? '',
      previewUrl: map['preview_url'] ?? '',
      id: map['id'] ?? '',
      artists: List<String>.from(map['artists'].map((e) => e['name']).toList()),
    );
  }
}
