import 'package:get/get.dart';
import 'package:spotiblind/services/dio_client.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'cache_manager.dart';

class AuthenticationManager extends GetxController with CacheManager {
  final isLogged = false.obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
  }

  void login(String? token) async {
    await saveToken(token);
    isLogged.value = true;
  }

  void checkLoginStatus() async {
    final token =
        getToken(); //Check if there's a token stocked, which means Spotify is linked
    if (token != null) {
      SpotifySdk.connectToSpotifyRemote(
          clientId: "13f262e800754d799ad89db47aaf5d3d",
          redirectUrl: "https://www.google.fr",
          accessToken: token);
      await saveToken(await SpotifySdk.getAccessToken(
          clientId: "13f262e800754d799ad89db47aaf5d3d",
          redirectUrl: "https://www.google.fr")); //refresh Token
      final client = await DioClient.init();
      print(client.accessToken);
      final spotifyUser = await client.getCurrentUser();
      if (spotifyUser != null) {
        isLogged.value = true;
      }
    }
  }
}
