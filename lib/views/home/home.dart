import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../services/auth_manager.dart';
import 'user_infos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = '';
  bool _loading = false;
  final AuthenticationManager _authManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          body: Center(
              child: _loading
                  ? const CircularProgressIndicator()
                  : _authManager.isLogged.value
                      ? UserInfos(
                          onDisconnect: (() => disconnectSpotify()),
                          authManager: _authManager,
                        )
                      : ElevatedButton(
                          onPressed: () async => await connectToSpotifyRemote(),
                          child: const Text("Se connecter"))),
        ),
      ),
    );
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      String? token = _authManager.getToken();
      final connect = await SpotifySdk.connectToSpotifyRemote(
          clientId: "13f262e800754d799ad89db47aaf5d3d",
          redirectUrl: "https://www.google.fr",
          accessToken: token);
      if (connect && token == null) {
        var token = await SpotifySdk.getAccessToken(
            clientId: "13f262e800754d799ad89db47aaf5d3d",
            redirectUrl: "https://www.google.fr");
        if (token != '') {
          setStatus('connect to spotify successful');
          _authManager.login(token);
        } else {
          setStatus('connect to spotify failed');
        }
      } else {
        setStatus(connect
            ? 'connect to spotify successful'
            : 'connect to spotify failed');
      }

      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
    Get.snackbar("Résultat", text, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> disconnectSpotify() async {
    try {
      bool disconnect = await SpotifySdk.disconnect();
      if (disconnect) {
        _authManager.logOut();
        setStatus("Successfully disconnected");
      } else {
        setStatus("Something went wrong");
      }
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
    Get.snackbar("Résultat", text, snackPosition: SnackPosition.BOTTOM);
  }

  void setStatus(String code, {String? message}) {
    setState(() {
      text = code;
    });
  }
}
