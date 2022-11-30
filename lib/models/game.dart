import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:spotiblind/services/game_manager.dart';

class Game {
  String uid;
  String currentSong;
  String lastBuzz;
  Duration position;
  int remainingSongs;
  Duration totalDuration;
  String entryCode;
  int totalSongs;
  bool started;
  bool hasBuzzed;
  Game(
      {this.uid = '',
      this.currentSong = '',
      this.lastBuzz = '',
      this.position = Duration.zero,
      required this.remainingSongs,
      this.totalDuration = Duration.zero,
      required this.entryCode,
      required this.totalSongs,
      this.started = false,
      this.hasBuzzed = false});

  static Future<bool> createInFirestore(
      int totalSongs, String entrycode) async {
    final game = Game(
        entryCode: entrycode,
        remainingSongs: totalSongs,
        totalSongs: totalSongs);
    final doc = await GameManager.createGame(game);
    if (doc != null) {
      doc.update({"uid": doc.id});
      game.uid = doc.id;
      Get.put<String>(game.uid, tag: "gameId");
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> searchInFirestore(String entrycode) async {
    final games = await GameManager.searchForGame(entrycode);
    if (games.docs.isEmpty) {
      return false;
    } else {
      final String id = games.docs.first.id;
      Get.put<String>(id, tag: "gameId");
      return true;
    }
  }

  void updateCurrentPosition() {
    GameManager(gameId: uid).updateCurrentPosition(position);
  }

  void updateDuration() {
    GameManager(gameId: uid).updateTotalDuration(totalDuration);
  }

  void updateRemainingSongs() {
    GameManager(gameId: uid).updateRemainingSongs(remainingSongs);
  }

  void setBuzz() {
    GameManager(gameId: uid).setBuzz();
  }

  void resetBuzz() {
    GameManager(gameId: uid).resetBuzz();
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'current_song': currentSong});
    result.addAll({'last_buzz': lastBuzz});
    result.addAll({'position': position.inSeconds});
    result.addAll({'remaining_songs': remainingSongs});
    result.addAll({'total_duration': totalDuration.inSeconds});
    result.addAll({'entry_code': entryCode});
    result.addAll({'total_songs': totalSongs});
    result.addAll({'started': started});
    result.addAll({'has_buzzed': hasBuzzed});

    return result;
  }

  factory Game.fromJson(Map<String, dynamic> map) {
    return Game(
        currentSong: map['current_song'] ?? '',
        lastBuzz: map['last_buzz'] ?? '',
        position: Duration(seconds: map['position']),
        remainingSongs: map['remaining_songs']?.toInt() ?? 0,
        totalDuration: Duration(seconds: map['total_duration']),
        entryCode: map['entry_code'] ?? '',
        totalSongs: map['total_songs']?.toInt() ?? 0,
        started: map['started'] ?? false,
        hasBuzzed: map['has_buzzed'] ?? false,
        uid: map['uid']);
  }
}

Game gameFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("game not found");
  return Game.fromJson(data);
}
