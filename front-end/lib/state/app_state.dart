import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _seed();
  }

  // =========================
  // Sessão / usuário logado
  // =========================
  String? currentUserName;
  String? currentUserEmail;
  String? authToken;

  /// Dados completos do backend (/api/user/me)
  Map<String, dynamic>? me;

  bool get isLoggedIn => authToken != null && authToken!.isNotEmpty;

  void setSession({required String name, required String token}) {
    currentUserName = name.trim();
    authToken = token;
    notifyListeners();
  }

  /// Salva o retorno do /user/me no estado
  void setUserFromMe(Map<String, dynamic> data) {
    me = data;
    currentUserName = (data['name'] ?? '').toString();
    currentUserEmail = (data['email'] ?? '').toString();
    notifyListeners();
  }

  void clearSession() {
    currentUserName = null;
    currentUserEmail = null;
    authToken = null;
    me = null;
    notifyListeners();
  }

  // =========================
  // Restaurantes / Reviews
  // =========================
  final List<Restaurant> restaurants = [];
  final Map<String, List<Review>> _reviewsByRestaurant = {};

  List<Review> reviewsOf(String restaurantId) =>
      List.unmodifiable(_reviewsByRestaurant[restaurantId] ?? const []);

  double averageStarsOf(String restaurantId) {
    final list = _reviewsByRestaurant[restaurantId];
    if (list == null || list.isEmpty) return 0.0;
    final sum = list.fold<int>(0, (acc, r) => acc + r.stars);
    return sum / list.length;
  }

  int reviewsCountOf(String restaurantId) =>
      (_reviewsByRestaurant[restaurantId]?.length ?? 0);

  void addReview(String restaurantId, Review review) {
    final list = _reviewsByRestaurant.putIfAbsent(restaurantId, () => []);
    list.insert(0, review);
    notifyListeners();
  }

  void _seed() {
    restaurants.addAll(const [
      Restaurant(
        id: 'terra_tupi',
        name: 'TERRA TUPI',
        imageUrl: 'assets/restaurants/terra_tupi.PNG',
      ),
      Restaurant(
        id: 'cactus',
        name: 'CACTUS BURGUER',
        imageUrl: 'assets/restaurants/cactus_burger.PNG',
      ),
      Restaurant(
        id: 'revo',
        name: 'REVO BURGER',
        imageUrl: 'assets/restaurants/revo_burger.PNG',
      ),
      Restaurant(
        id: 'locus',
        name: 'LOCUS BURGER',
        imageUrl: 'assets/restaurants/locus_burger.PNG',
      ),
      Restaurant(
        id: 'galego',
        name: 'GALEGO LANCHES',
        imageUrl: 'assets/restaurants/galego_lanches.PNG',
      ),
      Restaurant(
        id: 'vasco',
        name: 'VASCO LANCHES',
        imageUrl: 'assets/restaurants/vasco_lanches.jpg',
      ),
      Restaurant(
        id: 'esfiha_planet',
        name: 'ESFIHA PLANET',
        imageUrl: 'assets/restaurants/esfiha_planet.PNG',
      ),
      Restaurant(
        id: 'the_sandwich',
        name: 'THE SANDWICH',
        imageUrl: 'assets/restaurants/the_sandwich.PNG',
      ),
      Restaurant(
        id: 'moniery_orla',
        name: 'SORVETERIA MONIERY (ORLA)',
        imageUrl: 'assets/restaurants/moniery_orla.PNG',
      ),
      Restaurant(
        id: 'fabrica',
        name: 'FÁBRICA',
        imageUrl: 'assets/restaurants/fabrica.PNG',
      ),
    ]);

    _reviewsByRestaurant['cactus'] = [
      Review(
        author: 'Maria',
        stars: 5,
        text: 'Atendimento ótimo e lanche absurdo. Voltaria fácil.',
        ticketMedio: 38.0,
        atendimento: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Review(
        author: 'João',
        stars: 4,
        text: 'Muito bom, mas demorou um pouco pra sair.',
        ticketMedio: 42.0,
        atendimento: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    _reviewsByRestaurant['vasco'] = [
      Review(
        author: 'Ana',
        stars: 5,
        text: 'Preço justo e bem servido. Clássico!',
        ticketMedio: 25.0,
        atendimento: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}

// =========================
// Models (ficam aqui mesmo)
// =========================

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String imageUrl;
}

class Review {
  Review({
    required this.author,
    required this.stars,
    required this.text,
    this.ticketMedio, // agora é opcional
    required this.atendimento,
    required this.createdAt,
  });

  final String author;
  final int stars;
  final String text;
  final double? ticketMedio; // <- AQUI
  final int atendimento;
  final DateTime createdAt;
}
