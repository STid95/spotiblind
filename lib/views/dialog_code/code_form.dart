import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/game.dart';
import '../../models/playlist.dart';
import '../../services/dio_client.dart';
import '../game/game.dart';
import 'text_form.dart';

class CodeForm extends StatefulWidget {
  const CodeForm({
    super.key,
    this.playlist,
  });

  final Playlist? playlist;

  @override
  State<CodeForm> createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  bool loading = false;
  bool error = false;
  final codeController = TextEditingController();
  bool gameFound = false;

  @override
  Widget build(BuildContext context) {
    bool isMaster = Get.find<bool>(tag: "isMaster");
    final formKey = GlobalKey<FormState>();

    return Column(
      children: [
        if (!gameFound)
          Row(
            children: [
              Expanded(
                  child: TextForm(
                      formKey: formKey, codeController: codeController)),
              ElevatedButton(
                  onPressed: (() async {
                    if (formKey.currentState!.validate()) {
                      gameFound = await searchGame();
                      if (!gameFound) {
                        error = true;
                      }
                      setState(() {});
                    }
                  }),
                  child: const Text("OK"))
            ],
          ),
        if (error)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Partie non trouvée",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red)),
          ),
        if (gameFound)
          Column(
            children: [
              const Text("Pseudo"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(),
              ),
            ],
          ),
        if (gameFound || isMaster)
          ElevatedButton(
              onPressed: (() async {
                if (formKey.currentState!.validate()) {
                  if (isMaster) {
                    await createGame(codeController.text);
                  } else {
                    Get.off(const GamePage());
                  }
                }
              }),
              child: loading
                  ? CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Theme.of(context).colorScheme.background)
                  : const Text("C'est parti !"))
      ],
    );
  }

  Future<bool> searchGame() async {
    return Game.searchInFirestore(codeController.text);
  }

  Future<void> createGame(String code) async {
    if (Get.find<bool>(tag: "selectTracks") == false) {
      await loadTracks();
    }
    Get.put<Playlist>(widget.playlist!, tag: "currentPlaylist");
    final created = await Game.createInFirestore(
        widget.playlist!.tracks.length, codeController.text);
    if (created) {
      Get.off(() => const GamePage());
    } else {
      setState(() {
        error = true;
      });
    }
  }

  Future<void> loadTracks() async {
    setState(() {
      loading = true;
    });
    widget.playlist!.tracks = await Get.find<DioClient>()
        .getPlaylistTracks(widget.playlist!)
        .whenComplete(() => setState(() {
              loading = false;
            }));
  }
}
