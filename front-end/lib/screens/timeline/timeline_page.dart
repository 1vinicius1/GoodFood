import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key, required this.appState});
  final AppState appState;

  static const _bg = Color(0xFF1E1E1E);
  static const _panel = Color(0xFF3C3C3C);

  @override
  Widget build(BuildContext context) {
    final activities = <String>[
      'Vinicius avaliou CACTUS BURGUER ⭐⭐⭐⭐⭐',
      'Ana avaliou VASCO LANCHES ⭐⭐⭐⭐⭐',
      'João adicionou GALEGO BURGUER na lista “Quero visitar”',
      'Maria curtiu uma avaliação sua',
    ];

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
                  const _TopBar(title: 'Linha do Tempo'),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      itemCount: activities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF343434),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          activities[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                      ),
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
