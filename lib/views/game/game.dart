import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'package:spotiblind/models/playlist.dart';
import 'package:spotiblind/views/playlists/playlist_page.dart';

import '../../models/track.dart';
import 'components/player.dart';
import 'components/track_infos.dart';

class Game extends StatefulWidget {
  const Game({
    Key? key,
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
            .where((element) => element.selected)
            .map((e) => (AudioSource.uri(Uri.parse(e.previewUrl))))
            .toList());
    await player.setAudioSource(tracklist,
        initialIndex: 0, initialPosition: Duration.zero);
  }

  @override
  void initState() {
    playlist = Get.find<Playlist>(tag: "currentPlaylist");
    playlist.tracks =
        playlist.tracks.where((element) => element.selected).toList();
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
      if (currentPosition == duration && player.playing) {
        showScores();
      }
      if (mounted) {
        setState(() {});
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  void showScores() {
    player.pause();
    showDashboard();
  }

  Future<dynamic> showDashboard() {
    return Get.defaultDialog(
        title: "Scores",
        content: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  player.seekToNext();
                  player.play();
                },
                child: const Text("Prochain morceau")),
            if (currentPosition != duration)
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    player.play();
                  },
                  child: const Text("Finir morceau")),
          ],
        ));
  }

  @override
  void dispose() {
    disposeEverything();
    super.dispose();
  }

  void disposeEverything() {
    player.dispose();
    subscriptionPosition.cancel();
    subscriptionDuration.cancel();
    Get.delete<Playlist>(tag: "currentPlaylist", force: true);
    Get.to(() => const PlaylistPage());
  }

  @override
  Widget build(BuildContext context) {
    bool showInfos = Get.find(tag: "showInfos");
    bool isMaster = Get.find<bool>(tag: "isMaster");
    Track currentTrack = playlist.tracks[player.currentIndex ?? 0];
    isPlaying = player.playing;
    setDuration();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                    Player(
                        isMaster: isMaster,
                        currentPosition: currentPosition,
                        duration: duration,
                        onChangedSlider: (value) {
                          if (isMaster) {
                            player.seek(Duration(
                                seconds:
                                    (duration!.inSeconds * value).toInt()));
                          }
                        },
                        onPressedIcon: () {
                          isPlaying ? player.pause() : player.play();
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        isPlaying: isPlaying),
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
                                showScores();
                              },
                              child: const Text("Tout trouvé")),
                          ElevatedButton(
                              onPressed: () async {
                                showScores();
                              },
                              child: const Text("Prochain morceau")),
                        ],
                      )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    disposeEverything();
    return true;
  }
}
