class LoginResponse {
  final String name;
  final String token;

  LoginResponse({required this.name, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      name: (json['name'] ?? '').toString(),
      token: (json['token'] ?? '').toString(),
    );
  }
}
