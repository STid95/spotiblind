import 'package:flutter/material.dart';

import '../../../models/playlist.dart';

class Cover extends StatelessWidget {
  final Playlist playlist;
  const Cover({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: FittedBox(
        child: Image.network(
          playlist.images
              .where((element) => element.height == element.width)
              .first
              .url,
        ),
      ),
    );
  }
}
