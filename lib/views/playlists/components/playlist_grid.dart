import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:spotiblind/services/dio_client.dart';
import 'package:spotiblind/views/commons/widgets.dart';

import '../../../models/playlist.dart';
import '../../game/game.dart';
import '../../selection/select_page.dart';
import 'playlist_card.dart';

class PlaylistGrid extends StatelessWidget {
  const PlaylistGrid({
    Key? key,
    required ScrollController controller,
    required this.playlists,
  })  : _controller = controller,
        super(key: key);

  final ScrollController _controller;
  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    DioClient client = Get.find();
    return GridView.count(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        childAspectRatio: 0.75,
        crossAxisCount: 2,
        children: playlists
            .map((e) => GestureDetector(
                  onTap: () async {
                    await client.getPlaylistTracks(e);
                    if (Get.find<bool>(tag: "selectTracks") == false) {
                      Get.defaultDialog(
                          title: "Entrez un code pour la partie",
                          content: CodeForm(playlist: e));
                    } else {
                      Get.to(() => const SelectPage());
                    }
                  },
                  child: PlaylistCard(
                    playlist: e,
                  ),
                ))
            .toList());
  }
}
