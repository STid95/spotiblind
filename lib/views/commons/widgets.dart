import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotiblind/services/dio_client.dart';

import '../../models/playlist.dart';
import '../game/game.dart';

class IconBtn extends StatelessWidget {
  final double size;
  final Icon icon;
  final VoidCallback onPressed;
  final Color color;
  const IconBtn({
    Key? key,
    required this.size,
    required this.icon,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(20),
      iconSize: size,
      icon: icon,
      onPressed: onPressed,
      color: color,
    );
  }
}

class SettingSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;
  const SettingSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        ),
        Switch(value: value, onChanged: onChanged)
      ],
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    bool isMaster = Get.find<bool>(tag: "isMaster");
    final formKey = GlobalKey<FormState>();

    return Column(
      children: [
        TextForm(formKey: formKey, codeController: codeController),
        if (error)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Partie non trouvée",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red)),
          ),
        ElevatedButton(
            onPressed: (() async {
              if (formKey.currentState!.validate()) {
                if (isMaster) {
                  createGame(codeController.text);
                } else {
                  await searchGame();
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

  Future<void> searchGame() async {
    final game = await FirebaseFirestore.instance
        .collection("games")
        .where("entry_code", isEqualTo: codeController.text)
        .get();
    if (game.docs.isEmpty) {
      setState(() {
        error = true;
      });
    } else {
      joinGame(game);
    }
  }

  void joinGame(QuerySnapshot<Map<String, dynamic>> game) {
    FirebaseFirestore.instance
        .collection("games")
        .doc(game.docs.first.id)
        .snapshots()
        .listen((event) {
      print(event.data());
    });
  }

  void createGame(String code) async {
    if (Get.find<bool>(tag: "selectTracks") == false) {
      setState(() {
        loading = true;
      });
      widget.playlist!.tracks = await Get.find<DioClient>()
          .getPlaylistTracks(widget.playlist!)
          .whenComplete(() => setState(() {
                loading = false;
              }));
    }
    Get.put(widget.playlist, tag: "currentPlaylist");
    FirebaseFirestore.instance.collection("games").add({"entry_code": code});
    Get.put(true, tag: "isMaster");
    Get.to(() => const Game());
  }
}

class TextForm extends StatelessWidget {
  const TextForm({
    Key? key,
    required this.formKey,
    required this.codeController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: TextFormField(
          controller: codeController,
          validator: (value) {
            if (value == null || value.length < 4) {
              return 'Veuillez entrer au moins 4 chiffres';
            }
            return null;
          },
          keyboardType: TextInputType.phone,
        ),
      ),
    );
  }
}
