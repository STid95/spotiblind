import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:spotiblind/views/commons/page.dart';

import '../models/track.dart';

class Player extends StatefulWidget {
  final String playlistId;
  const Player({
    Key? key,
    required this.playlistId,
  }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool isPlaying = false;
  final player = AudioPlayer();
  Duration? duration;
  Duration currentPosition = const Duration(seconds: 0);

  void setTrack(List<Track> trackList) async {
    await player.setSourceUrl(trackList.first.previewUrl);
  }

  void setDuration() async {
    duration = await player.getDuration();
    player.onPositionChanged.listen((event) {
      currentPosition = event;
      print(currentPosition.inSeconds);
    });
    setState(() {});
  }

  @override
  void dispose() {
    player.dispose();
    Get.delete(tag: widget.playlistId, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setTrack(Get.find(tag: widget.playlistId));
    setDuration();

    return SafeArea(
      child: Scaffold(
          appBar: const GenAppBar(),
          body: SizedBox(
            width: 300,
            height: 300,
            child: Row(
              children: [
                IconButton(
                    iconSize: 50,
                    icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                    onPressed: () {
                      isPlaying ? player.pause() : player.resume();
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    }),
                if (duration != null)
                  SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(
                        backgroundColor: Colors.cyanAccent,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.red),
                        value: currentPosition.inSeconds.toDouble() /
                            duration!.inSeconds.toDouble()),
                  ),
                if (duration != null && duration != const Duration())
                  Text(
                      "0:${currentPosition.inSeconds.toString()}/0:${duration!.inSeconds.toString()}")
              ],
            ),
          )),
    );
  }
}
