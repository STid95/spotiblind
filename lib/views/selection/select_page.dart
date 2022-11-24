import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotiblind/views/commons/page.dart';
import 'package:spotiblind/views/commons/widgets.dart';

import '../../models/playlist.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    Get.delete<Playlist>(tag: "currentPlaylist", force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Playlist playlist = Get.find(tag: "currentPlaylist");
    return Scaffold(
      appBar: const GenAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
            child: Text(
              "Choisir les morceaux à utiliser",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                  shrinkWrap: true,
                  children: playlist.tracks.map((e) {
                    return SettingSwitch(
                        label: " ${e.name} - ${e.artists.join(", ")}",
                        value: e.selected,
                        onChanged: ((value) => setState(() {
                              e.selected = value;
                            })));
                  }).toList()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
                onPressed: (() => Get.defaultDialog(
                    title: "Entrez un code pour la partie",
                    content: CodeForm(playlist: playlist))),
                child: const Text("OK")),
          )
        ],
      ),
    );
  }
}
