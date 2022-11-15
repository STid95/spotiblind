import 'package:get/get_state_manager/get_state_manager.dart';

import 'user.image.dart';

class User extends GetxController {
  String id;
  List<UserImage> images;
  String displayName;
  User({
    required this.id,
    required this.images,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      images: List<UserImage>.from(
          map['images']?.map((x) => UserImage.fromJson(x))),
      displayName: map['display_name'] ?? '',
    );
  }
}
