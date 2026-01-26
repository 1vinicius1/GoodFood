import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'auth_models.dart';
import 'token_storage.dart';

class AuthService {
  AuthService(this._api, this._storage);

  final ApiClient _api;
  final TokenStorage _storage;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _api.dio.post(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final dto = LoginResponse.fromJson(Map<String, dynamic>.from(res.data));
      await _storage.save(token: dto.token, name: dto.name);
      return dto;
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  /// register: backend espera multipart com:
  /// - data: JSON (name,email,password) (como string)
  /// - profilePic: file (opcional)
  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    File? profilePic,
  }) async {
    try {
      final form = FormData.fromMap({
        'data': {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        }.toString().replaceAll("'", '"'), // vira JSON string
        if (profilePic != null)
          'profilePic': await MultipartFile.fromFile(profilePic.path),
      });

      final res = await _api.dio.post(
        '/auth/register',
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );

      final dto = LoginResponse.fromJson(Map<String, dynamic>.from(res.data));
      await _storage.save(token: dto.token, name: dto.name);
      return dto;
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<void> logout() async {
    await _storage.clear();
  }

  String _friendlyError(DioException e) {
    // Se o GlobalExceptionHandler estiver retornando mensagem, tentamos pegar
    final data = e.response?.data;
    if (data is Map && data['message'] != null) return data['message'].toString();
    if (data is String && data.isNotEmpty) return data;
    return 'Erro na requisição (${e.response?.statusCode ?? 'sem status'}).';
  }
}
