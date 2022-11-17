import 'package:flutter/material.dart';

import '../commons/page.dart';
import 'user_infos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GenAppBar(),
      body: Center(child: UserInfos()),
    );
  }
}
