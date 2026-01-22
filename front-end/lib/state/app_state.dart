import 'package:flutter/foundation.dart';

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;

  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class Review {
  final String author;
  final int stars; // 1..5
  final String text;
  final double? ticketMedio;
  final int? atendimento; // 1..5
  final DateTime createdAt;

  const Review({
    required this.author,
    required this.stars,
    required this.text,
    this.ticketMedio,
    this.atendimento,
    required this.createdAt,
  });
}

class AppState extends ChangeNotifier {
  AppState() {
    _seed();
  }

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
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipNJmVDLWbF9Q1uvqmbE7VZQyga-JDjDyi77EI6a=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'cactus',
        name: 'CACTUS BURGUER',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipNeFQCDDq0lTiS_vtmNZijixFxCDoiR7NNVCRYt=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'revo',
        name: 'REVO BURGER',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipOms5lOLQhoe1LOxJ9vwqOdi1fdGMVAhqy_gzhL=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'locus',
        name: 'LOCUS BURGER',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipOyjvmdYjtxtx1ZWvaoOhNW7K-cgqGk3YNHrImE=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'galego',
        name: 'GALEGO LANCHES',
        imageUrl:
            'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSy22YMBu2wT8e76_X19l1Sbm2bRc49VWaPaRLItHyHAJYJt596kuztDH_pQl0L8Xd0n3t4JG7ijYTywE2p1IcXHLkJ3mYGykH8_cdf0CzPj6m6DxoWG8WEjREp3L8CyWi9p9wSfmobY9FA=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'vasco',
        name: 'VASCO LANCHES',
        imageUrl:
            'https://scontent.faju2-1.fna.fbcdn.net/v/t39.30808-6/302180455_399742402272812_8712564561260360066_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEl3aRAZmOO-xeoak42e0udMb7AOdMNLgAxvsA50w0uAFIxblm137uQ4QwOgOWJ6nNhePcrv7V5DxCluV46k_S3&_nc_ohc=lntlT_G-xOkQ7kNvwGesYP4&_nc_oc=AdmTQx83g-ZnUugI94tgr78WHpCu73cMzUhqXM4ugd7vgKhT6_k2Iq3o8LFPu-aGEe6Gk0mzTTq7ZA5hLq5d41cR&_nc_zt=23&_nc_ht=scontent.faju2-1.fna&_nc_gid=4q26p-Sr4STG-zLuLPMBLg&oh=00_AfpX4dyl3igs2ELQT4vBXzTWG1mQ8cZcQyfvRs5rrMbGbw&oe=6977D139',
      ),
      Restaurant(
        id: 'esfiha_planet',
        name: 'ESFIHA PLANET',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipO3BGbKAInSxllexCymFR2KHqt3yGGcF4hZ51Tp=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'the_sandwich',
        name: 'THE SANDWICH',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipOlTAW1KbztPys5rsvww_T0DpnUDRlCW7PiOu54=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'moniery_orla',
        name: 'SORVETERIA MONIERY (ORLA)',
        imageUrl:
            'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSyPfNYcWh8NxM_bk2DGSCCWaKxPP_uZaj2OVmJQMRglpl_gSTAufznYLE6VXSkQX2etwy5MlUN06Dnv488FfFsxgLtLyg8Wv8KcJsXSSeb5Hu4M3Rs2-NQvwMFkqwMWUgtJO4GQC6u0uws=s1360-w1360-h1020-rw',
      ),
      Restaurant(
        id: 'fabrica',
        name: 'FÁBRICA',
        imageUrl:
            'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSx1wIqKHUfTZR80b4mGsWQt9tKNZflfhdMdcwyvU9Gf80IkRgscI3rQkOlwd8sVMkdwYTexa5Zq3tWuQNkMKLRPAVn3IlBccOKBmzk4mLCntCWw7BLziEPzQzafgCXWTBV6Hbp--A=s1360-w1360-h1020-rw',
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
