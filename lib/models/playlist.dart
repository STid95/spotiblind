import 'package:spotiblind/models/user.image.dart';

class Playlist {
  String href;
  String id;
  List<SpotifyImage> images;
  String name;
  Playlist({
    required this.href,
    required this.id,
    required this.images,
    required this.name,
  });

  factory Playlist.fromJson(Map<String, dynamic> map) {
    return Playlist(
      href: map['href'] ?? '',
      id: map['id'] ?? '',
      images: List<SpotifyImage>.from(
          map['images']?.map((x) => SpotifyImage.fromJson(x))),
      name: map['name'] ?? '',
    );
  }
}
