import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../models/user.dart';
import 'auth_manager.dart';

class DioClient {
  final dio.Dio _dio = dio.Dio();
  final String? accessToken;
  static DioClient? _client;
  final _baseUrl = 'https://api.spotify.com/v1';

  DioClient({
    required this.accessToken,
  });

  static Future<DioClient> init() async {
    final AuthenticationManager authmanager = Get.put(AuthenticationManager());

    _client = DioClient(accessToken: authmanager.getToken());
    Get.put(_client);
    return _client!;
  }

  Future<User?> getCurrentUser() async {
    try {
      dio.Response userData = await _dio.get('$_baseUrl/me',
          options: dio.Options(headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          }));
      User user = User.fromJson(userData.data);
      Get.put(user);
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
