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
  bool end = false;
  int offset = 0;
  List<Playlist> playlists = [];
  final ScrollController _controller = ScrollController();
  bool showInfos = true;
  TextEditingController controller = TextEditingController();
  List<Playlist> filteredPlaylists = [];
  String currentQuery = '';

  @override
  void initState() {
    playlists = Get.find(tag: "playlists");
    offset = playlists.length;
    filteredPlaylists = List.from(playlists);
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
        resizeToAvoidBottomInset: false,
        appBar: const GenAppBar(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Theme.of(context).colorScheme.primary),
                        hintText: 'Recherche...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onChanged: searchPlaylist,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: PlaylistGrid(
                      controller: _controller,
                      playlists:
                          currentQuery != '' ? filteredPlaylists : playlists),
                ),
              ]),
        ));
  }

  Future<void> getFuturePlaylists() {
    if (!end) {
      Get.defaultDialog(
          radius: 20,
          title: end ? "Plus de playlists !" : "Chargement...",
          content: end ? null : const CircularProgressIndicator());
      DioClient client = Get.find();
      return client.getFuturePlaylists(offset).then((value) {
        if (mounted) {
          final previousLength = playlists.length;
          setState(() {
            playlists.addAll(value);
            filteredPlaylists.addAll(currentQuery != ''
                ? value.where((element) => element.name
                    .toLowerCase()
                    .contains(currentQuery.toLowerCase()))
                : value);
            offset = offset + 20;
            if (previousLength == playlists.length) end = true;
            setState(() {});
          });
        }
        Navigator.pop(context);
      });
    } else {
      return noMore();
    }
  }

  void searchPlaylist(String query) {
    currentQuery = query;
    if (currentQuery != '') {
      filteredPlaylists = playlists
          .where((element) =>
              element.name.toLowerCase().contains(currentQuery.toLowerCase()))
          .toList();
    } else {
      filteredPlaylists = playlists;
    }

    setState(() {});
  }

  Future<void> noMore() async {}
}
