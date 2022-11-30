import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'package:spotiblind/models/playlist.dart';
import 'package:spotiblind/services/game_manager.dart';
import 'package:spotiblind/views/playlists/playlist_page.dart';

import '../../models/game.dart';
import '../../models/track.dart';
import '../home/home.dart';
import 'components/buttons/buttons.dart';
import 'components/player.dart';
import 'components/track_infos.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool isPlaying = false;
  final player = AudioPlayer();
  Game game = Game(entryCode: "0000", totalSongs: 0, remainingSongs: 0);
  late String gameId;
  int track = 0;
  late Playlist? playlist;
  late StreamSubscription<Duration> subscriptionPosition;
  late StreamSubscription<Duration?> subscriptionDuration;
  Duration totalDuration = Duration.zero;
  Duration currentPosition = Duration.zero;

  void setPlaylist() async {
    final tracklist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: playlist!.tracks
            .where((element) => element.selected)
            .map((e) => (AudioSource.uri(Uri.parse(e.previewUrl))))
            .toList());
    await player.setAudioSource(tracklist,
        initialIndex: 0, initialPosition: Duration.zero);
  }

  @override
  void initState() {
    if (Get.find<bool>(tag: "isMaster") == true) {
      playlist = Get.find<Playlist>(tag: "currentPlaylist");
      playlist!.tracks =
          playlist!.tracks.where((element) => element.selected).toList();
      setPlaylist();
    } else {
      playlist = null;
    }
    gameId = Get.find<String>(tag: "gameId");

    super.initState();
  }

  void setDuration(Game game) async {
    createSubscriptionDuration(game);
    createSubscriptionPosition(game);
  }

  void createSubscriptionPosition(Game game) {
    subscriptionPosition = player
        .createPositionStream(
      steps: 1,
    )
        .listen((position) {
      if (currentPosition.inSeconds.toStringAsFixed(0) !=
          position.inSeconds.toStringAsFixed(0)) {
        currentPosition = position;
        if (currentPosition != totalDuration) {
          game.position = currentPosition;
        } else {
          game.position = Duration.zero;
        }
        game.updateCurrentPosition();
      }
      if (game.position == game.totalDuration && player.playing) {
        showScores(game);
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void createSubscriptionDuration(Game game) {
    subscriptionDuration = player.durationStream.listen((trackDuration) {
      if (trackDuration!.inSeconds != game.totalDuration.inSeconds) {
        game.totalDuration = trackDuration;
        game.updateDuration();
        totalDuration = trackDuration;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void showScores(Game game) {
    player.pause();
    showDashboard(game);
  }

  Future<dynamic> showDashboard(Game game) {
    return Get.defaultDialog(
        title: "Scores",
        content: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  game.remainingSongs--;
                  game.updateRemainingSongs();
                  game.resetBuzz();
                  player.seekToNext();
                  player.play();
                },
                child: const Text("Prochain morceau")),
            if (game.position != game.totalDuration)
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
    Get.delete<String>(tag: "gameId", force: true);
    Get.to(() =>
        Get.find<bool>(tag: "isMaster") ? const PlaylistPage() : const Home());
  }

  @override
  Widget build(BuildContext context) {
    bool showInfos = Get.find(tag: "showInfos");
    bool isMaster = Get.find<bool>(tag: "isMaster");
    Track? currentTrack =
        isMaster ? playlist!.tracks[player.currentIndex ?? 0] : null;
    isPlaying = player.playing;
    if (isMaster) {
      setDuration(game);
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: StreamBuilder(
              stream: GameManager(gameId: gameId).getGame(
                onListen: (eventGame) {
                  pauseIfBuzz(eventGame);
                },
              ),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  game = snapshot.data!;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          showInfos && isMaster
                              ? TrackInfos(currentTrack: currentTrack!)
                              : Text("A vous de deviner !",
                                  style: Theme.of(context).textTheme.headline5),
                          Text("Chansons restantes : ${game.remainingSongs}"),
                          Player(
                              isMaster: isMaster,
                              currentPosition:
                                  isMaster ? currentPosition : game.position,
                              duration:
                                  isMaster ? totalDuration : game.totalDuration,
                              onChangedSlider: (value) {
                                if (isMaster) {
                                  player.seek(Duration(
                                      seconds: (totalDuration.inSeconds * value)
                                          .toInt()));
                                }
                              },
                              onPressedIcon: () {
                                isMaster
                                    ? updatePlayer()
                                    : game.hasBuzzed
                                        ? null
                                        : game.setBuzz();
                              },
                              isPlaying: isPlaying),
                          if (game.hasBuzzed)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text("${game.lastBuzz} a buzzé !",
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                          if (isMaster)
                            BtnBar(
                                hasBuzzed: game.hasBuzzed,
                                player: player,
                                showScores: () => showScores(game))
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
            )),
      ),
    );
  }

  void pauseIfBuzz(Game eventGame) {
    if (eventGame.hasBuzzed && !game.hasBuzzed) {
      player.pause();
    }
  }

  void updatePlayer() {
    if (isPlaying) {
      player.pause();
      subscriptionPosition.pause();
    } else {
      player.play();
      subscriptionPosition.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<bool> _onBackPressed() async {
    disposeEverything();
    return true;
  }
}
