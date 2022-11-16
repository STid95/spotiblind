import 'package:get/get_state_manager/get_state_manager.dart';

import 'user.image.dart';

class User extends GetxController {
  String id;
  List<SpotifyImage> images;
  String displayName;
  User({
    required this.id,
    required this.images,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      images: List<SpotifyImage>.from(
          map['images']?.map((x) => SpotifyImage.fromJson(x))),
      displayName: map['display_name'] ?? '',
    );
  }
}
