import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'api_client.dart';
import 'auth_models.dart';
import 'token_storage.dart';

class AuthService {
  AuthService(this._api, this._storage);

  final ApiClient _api;
  final TokenStorage _storage;

  /// ======================
  /// LOGIN
  /// ======================
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _api.dio.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      final dto =
          LoginResponse.fromJson(Map<String, dynamic>.from(res.data));

      await _storage.save(
        token: dto.token,
        name: dto.name,
      );

      return dto;
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  /// ======================
  /// REGISTER
  /// backend espera multipart:
  /// - data (JSON STRING)
  /// - profilePic (file opcional)
  /// ======================
  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    File? profilePic,
  }) async {
    try {
      final form = FormData();

      /// CAMPO "data" → JSON STRING (CORRETO)
      form.fields.add(
        MapEntry(
          'data',
          jsonEncode({
            'name': name.trim(),
            'email': email.trim(),
            'password': password,
          }),
        ),
      );

      /// FOTO (opcional)
      if (profilePic != null) {
        form.files.add(
          MapEntry(
            'profilePic',
            await MultipartFile.fromFile(profilePic.path),
          ),
        );
      }

      final res = await _api.dio.post(
        '/auth/register',
        data: form,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final dto =
          LoginResponse.fromJson(Map<String, dynamic>.from(res.data));

      await _storage.save(
        token: dto.token,
        name: dto.name,
      );

      return dto;
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  /// ======================
  /// LOGOUT
  /// ======================
  Future<void> logout() async {
    await _storage.clear();
  }

  /// ======================
  /// ERRO AMIGÁVEL
  /// ======================
  String _friendlyError(DioException e) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return 'Erro na requisição (${e.response?.statusCode ?? 'sem status'})';
  }
}
