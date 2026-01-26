import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  bool _acceptTerms = true;
  bool _showPass = false;

  static const _bg = Color(0xFF1E1E1E);
  static const _panel = Color(0xFF3C3C3C);
  static const _accent = Color(0xFFCE4E32);
  static const _muted = Color(0xFFB7B7B7);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa aceitar os termos.')),
      );
      return;
    }

    setState(() => _loading = true);

    // MVP: simula criação (depois entra backend/Firebase)
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _loading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF343434),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Conta criada!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: Text(
          'Bem-vindo(a), ${_nameCtrl.text.trim()}.\nAgora você já pode entrar no GoodFood.',
          style: const TextStyle(color: _muted, height: 1.35),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // fecha dialog
              Navigator.of(context).pop(); // volta pro login
            },
            child: const Text('Ir para o login'),
          ),
        ],
      ),
    );
  }

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
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, color: Colors.black54),
                        ),
                        Expanded(
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                                children: [
                                  TextSpan(text: 'Good', style: TextStyle(color: Colors.white)),
                                  TextSpan(text: 'Food', style: TextStyle(color: _accent)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Criar conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Entre pra comunidade e comece a avaliar restaurantes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted, height: 1.35),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameCtrl,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                                hintText: 'Seu nome',
                              ),
                              validator: (v) {
                                final s = (v ?? '').trim();
                                if (s.isEmpty) return 'Informe seu nome';
                                if (s.length < 2) return 'Nome muito curto';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'seuemail@exemplo.com',
                              ),
                              validator: (v) {
                                final s = (v ?? '').trim();
                                if (s.isEmpty) return 'Informe seu email';
                                if (!s.contains('@')) return 'Email inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _passCtrl,
                              obscureText: !_showPass,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                hintText: 'Mínimo 6 caracteres',
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _showPass = !_showPass),
                                  icon: Icon(
                                    _showPass ? Icons.visibility_off : Icons.visibility,
                                    color: _muted,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                final s = (v ?? '');
                                if (s.isEmpty) return 'Informe uma senha';
                                if (s.length < 6) return 'Senha precisa ter pelo menos 6';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _confirmCtrl,
                              obscureText: !_showPass,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: const InputDecoration(
                                labelText: 'Confirmar senha',
                              ),
                              validator: (v) {
                                final s = (v ?? '');
                                if (s.isEmpty) return 'Confirme sua senha';
                                if (s != _passCtrl.text) return 'Senhas não conferem';
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF343434),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _acceptTerms,
                                    onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                                    activeColor: _accent,
                                  ),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      'Aceito os termos e políticas do GoodFood',
                                      style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _accent,
                                foregroundColor: const Color(0xFF1A1A1A),
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2.2),
                                    )
                                  : const Text('Criar conta'),
                            ),

                            const SizedBox(height: 10),

                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Já tenho conta'),
                            ),
                          ],
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
