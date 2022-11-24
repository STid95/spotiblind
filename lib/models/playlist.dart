import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:spotiblind/models/track.dart';
import 'package:spotiblind/models/user.image.dart';

class Playlist extends GetxController {
  String href;
  String id;
  List<SpotifyImage> images;
  String name;
  List<Track> tracks;
  Playlist(
      {required this.href,
      required this.id,
      required this.images,
      required this.name,
      this.tracks = const []});

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
