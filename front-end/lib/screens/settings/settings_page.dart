import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.appState});
  final AppState appState;

  static const _bg = Color(0xFF1E1E1E);
  static const _panel = Color(0xFF3C3C3C);
  static const _muted = Color(0xFFB7B7B7);
  static const _accent = Color(0xFFCE4E32);

  @override
  Widget build(BuildContext context) {
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
                  const _TopBar(title: 'Configurações'),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      children: [
                        _Tile(
                          title: 'Conta',
                          subtitle: 'Email, senha e privacidade',
                          onTap: () => _toast(context, 'TODO: Conta'),
                        ),
                        _Tile(
                          title: 'Notificações',
                          subtitle: 'Curtidas, comentários e amigos',
                          onTap: () => _toast(context, 'TODO: Notificações'),
                        ),
                        _Tile(
                          title: 'Aparência',
                          subtitle: 'Tema e cores (MVP já está fosco)',
                          onTap: () => _toast(context, 'TODO: Aparência'),
                        ),
                        const SizedBox(height: 10),
                        _DangerButton(
                          text: 'Sair',
                          onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'GoodFood • MVP UX',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                        ),
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

  void _toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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

class _Tile extends StatelessWidget {
  const _Tile({required this.title, required this.subtitle, required this.onTap});
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  static const _muted = Color(0xFFB7B7B7);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF343434),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: _muted, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _muted),
          ],
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  const _DangerButton({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  static const _accent = Color(0xFFCE4E32);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _accent, width: 1.2),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _accent, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
