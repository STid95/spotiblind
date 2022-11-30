import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';

final gamesCollection = FirebaseFirestore.instance.collection("games");

class GameManager {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  String gameId;
  GameManager({
    required this.gameId,
  });

  static Future<DocumentReference<Map<String, dynamic>>>? createGame(
      Game game) {
    try {
      final doc =
          FirebaseFirestore.instance.collection("games").add(game.toJson());

      return doc;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> searchForGame(
      String entrycode) async {
    return await FirebaseFirestore.instance
        .collection("games")
        .where("entry_code", isEqualTo: entrycode)
        .where("started", isEqualTo: false)
        .get();
  }

  Stream<Game> getGame({Function(Game)? onListen}) {
    final stream =
        gamesCollection.doc(gameId).snapshots().map(gameFromSnapshot);
    stream.listen(onListen);
    return stream;
  }

  void updateRemainingSongs(int remainingSongs) async {
    gamesCollection.doc(gameId).update({'remaining_songs': remainingSongs});
  }

  void updateTotalDuration(Duration totalDuration) async {
    gamesCollection
        .doc(gameId)
        .update({'total_duration': totalDuration.inSeconds});
  }

  void updateCurrentPosition(Duration currentPosition) async {
    gamesCollection.doc(gameId).update({'position': currentPosition.inSeconds});
  }

  void setBuzz() async {
    gamesCollection
        .doc(gameId)
        .update({'has_buzzed': true, 'last_buzz': "STid"});
  }

  void resetBuzz() async {
    gamesCollection.doc(gameId).update({'has_buzzed': false, 'last_buzz': ""});
  }
}
