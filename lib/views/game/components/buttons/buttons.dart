import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BtnBar extends StatelessWidget {
  final AudioPlayer player;
  final VoidCallback showScores;
  final bool hasBuzzed;
  const BtnBar({
    Key? key,
    required this.player,
    required this.showScores,
    required this.hasBuzzed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        if (hasBuzzed) ...[
          FoundArtist(
            onPressed: () {
              player.play();
            },
          ),
          FoundTitle(
            onPressed: () {
              player.play();
            },
          ),
          AllFound(
            onPressed: showScores,
          ),
        ],
        NextSong(
          onPressed: showScores,
        ),
      ],
    );
  }
}

class FoundTitle extends StatelessWidget {
  const FoundTitle({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed, child: const Text("Titre trouvé"));
  }
}

class FoundArtist extends StatelessWidget {
  const FoundArtist({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed, child: const Text("Artiste trouvé"));
  }
}

class AllFound extends StatelessWidget {
  const AllFound({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed, child: const Text("Tout trouvé"));
  }
}

class NextSong extends StatelessWidget {
  const NextSong({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed, child: const Text("Prochain morceau"));
  }
}
