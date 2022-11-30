import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/playlist.dart';
import '../../dialog_code/code_form.dart';
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
    return GridView.count(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        childAspectRatio: 0.75,
        crossAxisCount: 2,
        children: playlists
            .map((e) => GestureDetector(
                  onTap: () async {
                    if (Get.find<bool>(tag: "selectTracks") == false) {
                      Get.defaultDialog(
                          title: "Entrez un code pour la partie",
                          content: CodeForm(playlist: e));
                    } else {
                      Get.to(() => SelectPage(
                            playlist: e,
                          ));
                    }
                  },
                  child: PlaylistCard(
                    playlist: e,
                  ),
                ))
            .toList());
  }
}
