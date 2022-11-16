import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../services/auth_manager.dart';
import '../home/home.dart';

class GenPage extends StatefulWidget {
  final Widget child;
  const GenPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<GenPage> createState() => _GenPageState();
}

class _GenPageState extends State<GenPage> {
  final AuthenticationManager _authManager = Get.find();
  String text = '';
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: _authManager.isLogged.value
                        ? () => disconnectSpotify()
                        : () => connectToSpotifyRemote(),
                    icon: Icon(_authManager.isLogged.value
                        ? Icons.logout
                        : Icons.login))),
            body: _loading ? const CircularProgressIndicator() : widget.child));
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
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
    setState(() {
      _loading = false;
    });
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
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
    setState(() {
      _loading = false;
    });
    Get.to(() => const Home());
    Get.snackbar("Résultat", text, snackPosition: SnackPosition.BOTTOM);
  }

  void setStatus(String code, {String? message}) {
    setState(() {
      text = code;
    });
  }
}
