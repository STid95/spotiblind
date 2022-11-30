import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:json_theme/json_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotiblind/views/home/home.dart';
import 'firebase_options.dart';

import 'models/user.dart';

Future<void> main() async {
  await GetStorage.init();
  createUser();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  await dotenv.load(fileName: ".env");
  Get.put(true, tag: "showInfos");
  Get.put(false, tag: "selectTracks");

  runApp(MyApp(theme: theme));
}

void createUser() {
  User user = User(id: '', images: [], displayName: '');
  Get.put<User>(user, tag: "currentUser");
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: theme,
      home: const Home(),
    );
  }
}
