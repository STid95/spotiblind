import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    Get.to(() => Game(
                          playlistId: e.id,
                        ));
                  },
                  child: Card(
                    shadowColor: Theme.of(context).colorScheme.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (e.images.isNotEmpty)
                          Image.network(
                            e.images.first.url,
                          ),
                        const SizedBox(height: 10),
                        Text(e.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                ))
            .toList());
  }
}
