import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotiblind/views/commons/page.dart';

import '../models/track.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  List<Track> tracks = Get.find(tag: "tracks");
  final player = AudioPlayer();

  @override
  void initState() {
    setTrack();
    super.initState();
  }

  void setTrack() async {
    await player.setSourceUrl(tracks.first.previewUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GenPage(
        child: SizedBox(
      width: 300,
      height: 300,
      child: IconButton(
          icon: const Icon(Icons.play_arrow), onPressed: () => player.resume()),
    ));
  }
}
