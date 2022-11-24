import 'package:flutter/material.dart';

import '../commons/page.dart';
import 'user_infos.dart';

class HomeMaster extends StatefulWidget {
  const HomeMaster({super.key});

  @override
  State<HomeMaster> createState() => _HomeMasterState();
}

class _HomeMasterState extends State<HomeMaster> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GenAppBar(),
      body: Center(child: UserInfos()),
    );
  }
}
