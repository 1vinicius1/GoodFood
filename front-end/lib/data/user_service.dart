import 'api_client.dart';

class UserService {
  UserService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> me() async {
    final res = await _api.dio.get('/user/me');
    return Map<String, dynamic>.from(res.data as Map);
  }
}
