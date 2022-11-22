import 'package:flutter/material.dart';

import '../../../models/track.dart';

class TrackInfos extends StatelessWidget {
  const TrackInfos({
    Key? key,
    required this.currentTrack,
  }) : super(key: key);

  final Track currentTrack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AlbumCover(currentTrack: currentTrack),
        TrackName(currentTrack: currentTrack),
        ArtistsNames(currentTrack: currentTrack)
      ],
    );
  }
}

class ArtistsNames extends StatelessWidget {
  const ArtistsNames({
    Key? key,
    required this.currentTrack,
  }) : super(key: key);

  final Track currentTrack;

  @override
  Widget build(BuildContext context) {
    return Text(currentTrack.artists.join(","),
        style: Theme.of(context).textTheme.headline6);
  }
}

class TrackName extends StatelessWidget {
  const TrackName({
    Key? key,
    required this.currentTrack,
  }) : super(key: key);

  final Track currentTrack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(currentTrack.name,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }
}

class AlbumCover extends StatelessWidget {
  const AlbumCover({
    Key? key,
    required this.currentTrack,
  }) : super(key: key);

  final Track currentTrack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(image: NetworkImage(currentTrack.image))),
    );
  }
}
