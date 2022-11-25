import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';

final gamesCollection = FirebaseFirestore.instance.collection("games");

class FirestoreManager {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  String gameId;
  FirestoreManager({
    required this.gameId,
  });

  static Future<DocumentReference<Map<String, dynamic>>> createGame(Game game) {
    return FirebaseFirestore.instance.collection("games").add(game.toJson());
  }

  Stream<Game> getGame() {
    return gamesCollection.doc(gameId).snapshots().map(gameFromSnapshot);
  }

  void updateRemainingSongs(int remainingSongs) async {
    gamesCollection.doc(gameId).update({'remaining_songs': remainingSongs});
  }
}
