import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotiblind/services/dio_client.dart';
import 'package:spotiblind/views/commons/widgets.dart';
import 'package:spotiblind/views/home_master/home_master.dart';

import '../../models/playlist.dart';
import '../commons/page.dart';
import 'components/playlist_grid.dart';

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
  bool selectTracks = false;
  TextEditingController controller = TextEditingController();
  List<Playlist> filteredPlaylists = [];
  String currentQuery = '';

  @override
  void initState() {
    setPlaylistAndSettings();
    setListenerOnScroll();
    super.initState();
  }

  void setListenerOnScroll() {
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
        } else {
          getFuturePlaylists();
        }
      }
    });
  }

  void setPlaylistAndSettings() {
    playlists = Get.find(tag: "playlists");
    offset = playlists.length;
    filteredPlaylists = List.from(playlists);
    Get.put(showInfos, tag: "showInfos");
    Get.put(selectTracks, tag: "selectTracks");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const GenAppBar(),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        SettingSwitch(
                            label: "Partage d'écran",
                            value: !showInfos,
                            onChanged: ((value) {
                              showInfos = !value;
                              Get.replace(showInfos, tag: "showInfos");
                              setState(() {});
                            })),
                        SettingSwitch(
                            label: "Choisir les morceaux",
                            value: selectTracks,
                            onChanged: ((value) {
                              selectTracks = value;
                              Get.replace(selectTracks, tag: "selectTracks");
                              setState(() {});
                            })),
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                hintText: 'Recherche...',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onChanged: searchPlaylist,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PlaylistGrid(
                        controller: _controller,
                        playlists:
                            currentQuery != '' ? filteredPlaylists : playlists),
                  ),
                ]),
          )),
    );
  }

  Future<bool> _onBackPressed() async {
    Get.to(() => const HomeMaster());
    return true;
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
            addToPlaylist(value);
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

  void addToPlaylist(List<Playlist> value) {
    playlists.addAll(value);
    filteredPlaylists.addAll(currentQuery != ''
        ? value.where((element) =>
            element.name.toLowerCase().contains(currentQuery.toLowerCase()))
        : value);
    offset = offset + 20;
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
