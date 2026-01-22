import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.appState});

  final AppState appState;

  static const _bg = Color(0xFF1E1E1E);
  static const _panel = Color(0xFF3C3C3C);
  static const _muted = Color(0xFFB7B7B7);

  @override
  Widget build(BuildContext context) {
    // MVP: “usuário mock”
    const userName = 'Vinicius';

    // total de avaliações (todas somadas)
    final totalReviews = appState.restaurants.fold<int>(
      0,
      (acc, r) => acc + appState.reviewsCountOf(r.id),
    );

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: _panel,
              child: Column(
                children: [
                  _TopBar(title: 'Perfil'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: Color(0xFF2A2A2A),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '@1vinicius1',
                                style: TextStyle(
                                  color: _muted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        _StatCard(label: 'Avaliações', value: '$totalReviews'),
                        const SizedBox(width: 12),
                        _StatCard(label: 'Amigos', value: '12'),
                        const SizedBox(width: 12),
                        _StatCard(label: 'Listas', value: '2'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      children: [
                        const _SectionTitle('Recentes'),
                        const SizedBox(height: 10),
                        ...appState.restaurants.take(3).map((r) {
                          final avg = appState.averageStarsOf(r.id);
                          final count = appState.reviewsCountOf(r.id);
                          return _MiniRow(
                            title: r.name,
                            subtitle: count == 0
                                ? 'Sem avaliações'
                                : '${avg.toStringAsFixed(1)} • $count avaliações',
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  static const _muted = Color(0xFFB7B7B7);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF343434),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 16,
      ),
    );
  }
}

class _MiniRow extends StatelessWidget {
  const _MiniRow({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  static const _muted = Color(0xFFB7B7B7);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF343434),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: _muted, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
