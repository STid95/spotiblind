import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:spotiblind/services/dio_client.dart';
import 'package:spotiblind/views/playlists/playlist_page.dart';

import '../../models/user.dart';
import '../../services/auth_manager.dart';

class UserInfos extends StatelessWidget {
  const UserInfos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationManager authManager = Get.find();

    User? user;
    if (authManager.isLogged.value) {
      User currentUser = Get.find(tag: "currentUser");
      user = currentUser;
    }
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage:
                user != null ? NetworkImage(user.images.first.url) : null,
            child: user != null ? null : const Icon(Icons.question_mark),
          ),
          Text(user != null
              ? user.displayName
              : "Connectez-vous pour continuer"),
          if (user != null)
            TextButton(
                onPressed: (() async {
                  DioClient client = Get.find();
                  await client.getPlaylists();
                  Get.to(() => const PlaylistPage());
                }),
                child: const Text("Récupérer mes playlists"))
        ],
      ),
    );
  }
}
