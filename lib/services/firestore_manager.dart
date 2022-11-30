import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';

final gamesCollection = FirebaseFirestore.instance.collection("games");

class FirestoreManager {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  String gameId;
  FirestoreManager({
    required this.gameId,
  });

  static Future<DocumentReference<Map<String, dynamic>>>? createGame(
      Game game) {
    try {
      return FirebaseFirestore.instance.collection("games").add(game.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Game> getGame() {
    return gamesCollection.doc(gameId).snapshots().map(gameFromSnapshot);
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
}
