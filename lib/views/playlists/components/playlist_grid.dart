import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:spotiblind/services/dio_client.dart';

import '../../../models/playlist.dart';
import '../../game/game.dart';
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
                    FirebaseFirestore.instance
                        .collection("games")
                        .add({"entry_code": "0000"});
                    Get.to(() => Game(
                          playlistId: e.id,
                        ));
                  },
                  child: PlaylistCard(
                    playlist: e,
                  ),
                ))
            .toList());
  }
}
