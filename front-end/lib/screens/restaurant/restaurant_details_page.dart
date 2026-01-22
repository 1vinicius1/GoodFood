import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../review/create_review_page.dart';

class RestaurantDetailsPage extends StatelessWidget {
  const RestaurantDetailsPage({
    super.key,
    required this.appState,
    required this.restaurant,
  });

  final AppState appState;
  final Restaurant restaurant;

  static const _accent = Color(0xFFCE4E32);
  static const _bg = Color(0xFF1E1E1E);
  static const _panel = Color(0xFF3C3C3C);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final reviews = appState.reviewsOf(restaurant.id);
        final avg = appState.averageStarsOf(restaurant.id);

        return Scaffold(
          backgroundColor: _bg,
          floatingActionButton: FloatingActionButton(
            backgroundColor: _accent,
            foregroundColor: const Color(0xFF1A1A1A),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateReviewPage(
                    appState: appState,
                    restaurant: restaurant,
                  ),
                ),
              );
            },
            child: const Icon(Icons.star, size: 28),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: _panel,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top bar com back + logo
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black54,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Good',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: 'Food',
                                        style: TextStyle(color: _accent),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),

                      // Foto
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              restaurant.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Nome
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Média
                      Center(
                        child: Column(
                          children: [
                            _StarsRow(value: avg, size: 26, color: _accent),
                            const SizedBox(height: 6),
                            Text(
                              avg == 0
                                  ? 'Sem avaliações ainda'
                                  : '${avg.toStringAsFixed(1)} • ${reviews.length} avaliação(ões)',
                              style: const TextStyle(
                                color: Color(0xFFB7B7B7),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Avaliações
                      Expanded(
                        child: reviews.isEmpty
                            ? const Center(
                                child: Text(
                                  'Seja o primeiro a avaliar ⭐',
                                  style: TextStyle(
                                    color: Color(0xFFDBDBDB),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  8,
                                  12,
                                  12,
                                ),
                                itemCount: reviews.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (_, i) {
                                  final r = reviews[i];
                                  return _ReviewCard(review: r);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;
  static const _accent = Color(0xFFCE4E32);

  @override
  Widget build(BuildContext context) {
    final ticket = review.ticketMedio == null
        ? null
        : 'R\$ ${review.ticketMedio!.toStringAsFixed(2)}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF343434),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF2A2A2A),
                child: const Icon(Icons.person, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.author,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _StarsRow(
                value: review.stars.toDouble(),
                size: 16,
                color: _accent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.text,
            style: const TextStyle(color: Color(0xFFDBDBDB), height: 1.3),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (ticket != null) _Chip(text: 'Ticket: $ticket'),
              if (review.atendimento != null)
                _Chip(text: 'Atendimento: ${review.atendimento}/5'),
              _Chip(
                text:
                    '${review.createdAt.day.toString().padLeft(2, '0')}/${review.createdAt.month.toString().padLeft(2, '0')}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFB7B7B7),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow({
    required this.value,
    required this.size,
    required this.color,
  });

  final double value;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final full = value.floor();
    final hasHalf = (value - full) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        if (i < full) {
          icon = Icons.star;
        } else if (i == full && hasHalf) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
