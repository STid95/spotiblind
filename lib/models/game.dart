import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:spotiblind/services/firestore_manager.dart';

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
  Game({
    this.uid = '',
    this.currentSong = '',
    this.lastBuzz = '',
    this.position = Duration.zero,
    required this.remainingSongs,
    this.totalDuration = Duration.zero,
    required this.entryCode,
    required this.totalSongs,
    this.started = false,
  });

  static Future<bool> createInFirestore(
      int totalSongs, String entrycode) async {
    final game = Game(
        entryCode: entrycode,
        remainingSongs: totalSongs,
        totalSongs: totalSongs);
    final doc = await FirestoreManager.createGame(game);
    if (doc != null) {
      Get.put<String>(doc.id, tag: "gameId");
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> searchInFirestore(String entrycode) async {
    final games = await FirebaseFirestore.instance
        .collection("games")
        .where("entry_code", isEqualTo: entrycode)
        .get();
    if (games.docs.isEmpty) {
      return false;
    } else {
      final String id = games.docs.first.id;
      Get.put<String>(id, tag: "gameId");
      return true;
    }
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
    );
  }
}

Game gameFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("game not found");
  return Game.fromJson(data);
}
