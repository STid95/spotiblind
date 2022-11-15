import 'package:flutter/material.dart';

import '../../services/auth_manager.dart';

class UserInfos extends StatelessWidget {
  final void Function() onDisconnect;
  final AuthenticationManager authManager;
  const UserInfos({
    Key? key,
    required this.onDisconnect,
    required this.authManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage:
              NetworkImage(authManager.user.value.images.first.url),
        ),
        Text(authManager.user.value.displayName),
        ElevatedButton(
            onPressed: onDisconnect, child: const Text("Se déconnecter")),
      ],
    );
  }
}
