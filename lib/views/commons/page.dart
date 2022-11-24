import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../services/auth_manager.dart';
import '../home/home.dart';

class GenAppBar extends StatefulWidget with PreferredSizeWidget {
  const GenAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<GenAppBar> createState() => _GenAppBarState();

  @override
  Size get preferredSize => const Size(10, 50);
}

class _GenAppBarState extends State<GenAppBar> {
  final AuthenticationManager _authManager = Get.find();
  String text = '';
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
            onPressed: _authManager.isLogged.value
                ? () => disconnectSpotify()
                : () => connectToSpotifyRemote(),
            icon: Icon(
                _authManager.isLogged.value ? Icons.logout : Icons.login)));
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      await _authManager.login();
      if (_authManager.isLogged.value) {
        setStatus('Connexion réussie');
      } else {
        setStatus('Erreur de connexion');
      }
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }

    Get.snackbar("Résultat", text,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary);
  }

  Future<void> disconnectSpotify() async {
    try {
      bool disconnect = await SpotifySdk.disconnect();
      if (disconnect) {
        _authManager.logOut();
        setStatus("Déconnexion réussie");
      } else {
        setStatus("Erreur de déconnexion");
      }
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }

    if (Get.currentRoute != "/Home") {
      Get.off(() => const Home());
    }
    Get.snackbar("Résultat", text,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary);
  }

  void setStatus(String code, {String? message}) {
    setState(() {
      text = code;
    });
  }
}
