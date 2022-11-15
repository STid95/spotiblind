import 'package:get/get.dart';
import 'package:spotiblind/services/dio_client.dart';

import '../models/user.dart';
import 'cache_manager.dart';

class AuthenticationManager extends GetxController with CacheManager {
  final isLogged = false.obs;
  var user = User(id: '', images: [], displayName: '').obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
    user.value = User(id: '', images: [], displayName: '');
  }

  void login(String? token) async {
    await saveToken(token);
    final client = await DioClient.init();
    user.value = await client.getCurrentUser() as User;
    isLogged.value = true;
  }

  void checkLoginStatus() async {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
      final client = await DioClient.init();
      user.value = await client.getCurrentUser() as User;
    }
  }
}
