import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:spotiblind/services/dio_client.dart';

import '../../models/playlist.dart';
import '../game/game.dart';

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

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  const PlaylistCard({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (playlist.images.isNotEmpty) Cover(playlist: playlist),
            const SizedBox(height: 10),
            Text(playlist.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}

class Cover extends StatelessWidget {
  final Playlist playlist;
  const Cover({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: FittedBox(
        child: Image.network(
          playlist.images
              .where((element) => element.height == element.width)
              .first
              .url,
        ),
      ),
    );
  }
}
