import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spotiblind/models/playlist.dart';
import 'package:spotiblind/models/track.dart';

import '../models/user.dart';
import 'auth_manager.dart';

class DioClient {
  final dio.Dio _dio = dio.Dio();
  final String? accessToken;
  static late DioClient _client;
  final _baseUrl = 'https://api.spotify.com/v1';

  DioClient({
    required this.accessToken,
  });

  static Future<DioClient> init() async {
    final AuthenticationManager authmanager = Get.put(AuthenticationManager());

    _client = DioClient(accessToken: authmanager.getToken());
    Get.put(_client);
    return _client;
  }

  Future<User?> getCurrentUser() async {
    try {
      dio.Response userData = await _dio.get('$_baseUrl/me',
          options: dio.Options(headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          }));
      User user = User.fromJson(userData.data);
      Get.put(user, tag: "currentUser");
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future getPlaylists() async {
    List<Playlist> playlists = [];
    try {
      dio.Response userData = await _dio.get('$_baseUrl/me/playlists',
          options: dio.Options(headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          }));
      List<dynamic> items = userData.data['items'];
      playlists = items.map((e) => Playlist.fromJson(e)).toList();

      Get.put(playlists, tag: "playlists");
    } catch (e) {
      print(e);
    }
  }

  Future<List<Playlist>> getFuturePlaylists(int offset) async {
    try {
      dio.Response userData = await _dio.get(
          '$_baseUrl/me/playlists?offset=$offset',
          options: dio.Options(headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          }));
      List<dynamic> items = userData.data['items'];
      return items.map((e) => Playlist.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getPlaylistTracks(Playlist playlist) async {
    List<Track> tracks = [];
    try {
      dio.Response userData = await _dio.get(
          '$_baseUrl/playlists/${playlist.id}?market=FR',
          options: dio.Options(headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          }));
      List<dynamic> items = userData.data['tracks']['items'];
      tracks = items.map((e) => Track.fromJson(e['track'])).toList();
      playlist.tracks = tracks;
      Get.put(playlist, tag: playlist.id);
    } catch (e) {
      print(e);
    }
  }
}
