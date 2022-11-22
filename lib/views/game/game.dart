import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotiblind/models/playlist.dart';

import 'package:spotiblind/views/commons/page.dart';

import '../../models/track.dart';
import '../commons/widgets.dart';
import 'components/duration_infos.dart';
import 'components/track_infos.dart';

class Game extends StatefulWidget {
  final String playlistId;
  const Game({
    Key? key,
    required this.playlistId,
  }) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool isPlaying = false;
  final player = AudioPlayer();
  Duration? duration;
  Duration currentPosition = const Duration(seconds: 0);
  int track = 0;
  late Playlist playlist;
  late StreamSubscription<Duration> subscriptionPosition;
  late StreamSubscription<Duration?> subscriptionDuration;

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
    subscriptionDuration = player.durationStream.listen((trackDuration) {
      duration = trackDuration;
      if (mounted) {
        setState(() {});
      }
    });
    subscriptionPosition = player.positionStream.listen((position) {
      currentPosition = position;
      if (mounted) {
        setState(() {});
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    subscriptionPosition.cancel();
    subscriptionDuration.cancel();
    player.dispose();
    Get.delete(tag: widget.playlistId, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showInfos = Get.find(tag: "showInfos");
    bool isMaster = true;
    Track currentTrack = playlist.tracks[player.currentIndex ?? 0];
    isPlaying = player.playing;
    setDuration();
    return SafeArea(
      child: Scaffold(
          appBar: const GenAppBar(),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  showInfos && isMaster
                      ? TrackInfos(currentTrack: currentTrack)
                      : Text("A vous de deviner !",
                          style: Theme.of(context).textTheme.headline5),
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        Slider(
                            value: currentPosition == const Duration()
                                ? 0
                                : currentPosition.inSeconds.toDouble() /
                                    duration!.inSeconds.toDouble(),
                            onChanged: (value) {
                              if (isMaster) {
                                player.seek(Duration(
                                    seconds:
                                        (duration!.inSeconds * value).toInt()));
                              }
                            }),
                        DurationInfos(
                            currentPosition: currentPosition,
                            duration: duration),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary,
                              ],
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                          ),
                          child: IconBtn(
                              size: isMaster ? 50 : 150,
                              color: Colors.white,
                              icon: isMaster
                                  ? Icon(isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow)
                                  : const Icon(Icons.alarm),
                              onPressed: () {
                                isPlaying ? player.pause() : player.play();
                                setState(() {
                                  isPlaying = !isPlaying;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  if (isMaster)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              player.pause();
                              player.play();
                            },
                            child: const Text("Artiste trouvé")),
                        ElevatedButton(
                            onPressed: () async {
                              player.pause();
                              player.play();
                            },
                            child: const Text("Titre trouvé")),
                        ElevatedButton(
                            onPressed: () async {
                              player.stop();
                              await player.seekToNext();
                              player.load();
                              setDuration();
                            },
                            child: const Text("Tout trouvé")),
                        ElevatedButton(
                            onPressed: () async {
                              player.stop();
                              await player.seekToNext();
                              player.load();
                              setDuration();
                            },
                            child: const Text("Prochain morceau")),
                      ],
                    )
                ],
              ),
            ),
          )),
    );
  }
}
