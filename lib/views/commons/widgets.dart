import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class CodeForm extends StatelessWidget {
  const CodeForm({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();

    return Column(
      children: [
        Padding(
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
        ),
        ElevatedButton(
            onPressed: (() {
              if (formKey.currentState!.validate()) {
                createGame(codeController.text);
              }
            }),
            child: const Text("C'est parti !"))
      ],
    );
  }

  void createGame(String code) {
    Get.lazyReplace<Playlist>(() => playlist);
    FirebaseFirestore.instance.collection("games").add({"entry_code": code});
    Get.put(true, tag: "isMaster");
    Get.to(() => const Game());
  }
}
