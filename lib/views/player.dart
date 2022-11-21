import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotiblind/models/playlist.dart';

import 'package:spotiblind/views/commons/page.dart';

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
  int track = 0;
  late Playlist playlist;
  late StreamSubscription<Duration> subscription;

  void setPlaylist() async {
    final tracklist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: playlist.tracks
            .map((e) => (AudioSource.uri(Uri.parse(e.previewUrl))))
            .toList());
    await player.setAudioSource(tracklist,
        initialIndex: 0, initialPosition: Duration.zero);
  }

  @override
  void initState() {
    playlist = Get.find(tag: widget.playlistId);
    setPlaylist();
    super.initState();
  }

  void setDuration() async {
    player.durationStream.listen((trackDuration) {
      duration = trackDuration;
      if (mounted) {
        setState(() {});
      }
    });
    subscription = player.positionStream.listen((position) {
      currentPosition = position;
      if (mounted) {
        setState(() {});
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    subscription.cancel();
    player.dispose();
    Get.delete(tag: widget.playlistId, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isPlaying = player.playing;
    setDuration();

    return SafeArea(
      child: Scaffold(
          appBar: const GenAppBar(),
          body: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        iconSize: 50,
                        icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                        onPressed: () {
                          isPlaying ? player.pause() : player.play();
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }),
                    SizedBox(
                      width: 150,
                      child: LinearProgressIndicator(
                          backgroundColor: Colors.cyanAccent,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.red),
                          value: currentPosition == const Duration()
                              ? 0
                              : currentPosition.inSeconds.toDouble() /
                                  duration!.inSeconds.toDouble()),
                    ),
                    Text(
                        "0:${currentPosition != const Duration() ? currentPosition.inSeconds.toString() : 0}/0:${duration != null ? duration!.inSeconds.toString() : 0}"),
                  ],
                ),
                TextButton(
                    onPressed: () async {
                      player.stop();
                      await player.seekToNext();
                      player.load();
                      setDuration();
                    },
                    child: const Text("Prochain morceau"))
              ],
            ),
          )),
    );
  }
}
