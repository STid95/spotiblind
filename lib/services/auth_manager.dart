import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:spotiblind/services/dio_client.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'cache_manager.dart';

class AuthenticationManager extends GetxController with CacheManager {
  final isLogged = false.obs;
  String scopes =
      "app-remote-control, playlist-read-private, playlist-read-collaborative, user-library-read";
  String clientId = dotenv.env['CLIENT_SECRET'] ?? '';
  String redirectUrl = dotenv.env['REDIRECT_URL'] ?? '';

  void logOut() {
    isLogged.value = false;
    Get.find<DioClient>().resetUser();
    removeToken();
  }

  Future login() async {
    String? token = getToken();
    final connect = await SpotifySdk.connectToSpotifyRemote(
      clientId: clientId,
      redirectUrl: redirectUrl,
      accessToken: token,
      scope: scopes,
    );
    if (connect && token == null) {
      var token = await SpotifySdk.getAccessToken(
          clientId: clientId, redirectUrl: redirectUrl, scope: scopes);
      if (token != '') {
        await saveToken(token);
        DioClient client = await DioClient.init();
        final spotifyUser = await client.getCurrentUser();
        if (spotifyUser != null) {
          isLogged.value = true;
        }
      }
    }
  }

  void checkLoginStatus() async {
    final token =
        getToken(); //Check if there's a token stocked, which means Spotify is linked
    if (token != null) {
      SpotifySdk.connectToSpotifyRemote(
          clientId: clientId,
          redirectUrl: redirectUrl,
          accessToken: token,
          scope: scopes);
      await saveToken(await SpotifySdk.getAccessToken(
          clientId: clientId,
          redirectUrl: redirectUrl,
          scope: scopes)); //refresh Token
      final client = await DioClient.init();
      final spotifyUser = await client.getCurrentUser();
      if (spotifyUser != null) {
        isLogged.value = true;
      }
    }
  }
}
