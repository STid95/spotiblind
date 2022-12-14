import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotiblind/views/splash_view.dart';

import '../../models/user.dart';
import '../dialog_code/code_form.dart';
import '../home_master/home_master.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Text("Bienvenue sur Spotiblind !"),
          ElevatedButton(
              onPressed: () {
                Get.replace<bool>(true, tag: "isMaster");
                Get.off(() =>
                    Get.find<User>(tag: "currentUser").displayName != ''
                        ? const HomeMaster()
                        : SplashView());
              },
              child: const Text("Créer une partie")),
          ElevatedButton(
              onPressed: () {
                Get.replace<bool>(false, tag: "isMaster");
                Get.defaultDialog(
                    title: "Entrez le code", content: const CodeForm());
              },
              child: const Text("Rejoindre une partie"))
        ],
      )),
    );
  }
}
