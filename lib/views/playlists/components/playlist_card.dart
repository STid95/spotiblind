import 'package:flutter/material.dart';

import '../../../models/playlist.dart';
import 'cover.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  const PlaylistCard({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (playlist.images.isNotEmpty) Cover(playlist: playlist),
            const SizedBox(height: 10),
            Text(playlist.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}
