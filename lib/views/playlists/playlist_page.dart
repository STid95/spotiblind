import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotiblind/services/dio_client.dart';

import '../../models/playlist.dart';
import '../commons/page.dart';
import 'playlist_grid.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  int offset = 20;
  List<Playlist> playlists = [];
  final ScrollController _controller = ScrollController();
  bool showInfos = true;

  @override
  void initState() {
    playlists = Get.find(tag: "playlists");
    Get.put(showInfos, tag: "showInfos");
    super.initState();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
        } else {
          getFuturePlaylists();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const GenAppBar(),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Partage d'écran"),
              Switch(
                  value: !showInfos,
                  onChanged: ((value) {
                    showInfos = !value;
                    Get.replace(showInfos, tag: "showInfos");
                    setState(() {});
                  })),
            ],
          ),
          Text("Choisir une playlist",
              style: Theme.of(context).textTheme.headline4),
          RefreshIndicator(
            onRefresh: () => getFuturePlaylists(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child:
                  PlaylistGrid(controller: _controller, playlists: playlists),
            ),
          ),
        ]));
  }

  Future<void> getFuturePlaylists() {
    DioClient client = Get.find();
    return client.getFuturePlaylists(offset).then((value) {
      setState(() {
        playlists.addAll(value);
        offset = offset + 20;
      });
    });
  }
}
