import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:spotiblind/views/commons/page.dart';
import 'package:spotiblind/views/commons/widgets.dart';

import '../../models/playlist.dart';
import '../../services/dio_client.dart';
import '../dialog_code/code_form.dart';

class SelectPage extends StatefulWidget {
  final Playlist playlist;

  const SelectPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    setTracks().whenComplete(() => setState(() {}));
    super.initState();
  }

  Future<void> setTracks() async {
    widget.playlist.tracks =
        await Get.find<DioClient>().getPlaylistTracks(widget.playlist);
  }

  @override
  Widget build(BuildContext context) {
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
          if (widget.playlist.tracks.isNotEmpty) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                    shrinkWrap: true,
                    children: widget.playlist.tracks.map((e) {
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
                      content: CodeForm(playlist: widget.playlist))),
                  child: const Text("OK")),
            )
          ] else
            Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  Text("Récupération des morceaux...")
                ],
              ),
            )
        ],
      ),
    );
  }
}
