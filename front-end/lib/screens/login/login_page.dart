import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../../state/app_state.dart';
import '../auth/forgot_password_page.dart';
import '../auth/sign_up_page.dart';
import '../../data/token_storage.dart';
import '../../data/api_client.dart';
import '../../data/auth_service.dart';
import '../../data/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.appState});
  final AppState appState;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _hidePass = true;
  bool _loading = false;

  late final AuthService _auth;
  late final UserService _user;

  @override
  void initState() {
    super.initState();
    final storage = TokenStorage();
    final api = ApiClient(storage);
    _auth = AuthService(api, storage);
    _user = UserService(api);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _loading = true);

    try {
      final dto = await _auth.login(
        email: _emailCtrl.text,
        password: _passCtrl.text,
      );

      // salva sessão (nome e token)
      widget.appState.setSession(name: dto.name, token: dto.token);

      // busca /user/me e salva no AppState
      try {
        final userService = UserService(ApiClient(TokenStorage()));
        final me = await userService.me();
        widget.appState.setUserFromMe(me);
      } catch (_) {
        // se /me falhar, não quebra o login (MVP)
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(appState: widget.appState)),
      );
    } catch (e) {
      if (!mounted) return;

      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // Logo "GoodFood"
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Good',
                          style: TextStyle(color: Color(0xFFF2F2F2)),
                        ),
                        TextSpan(
                          text: 'Food',
                          style: TextStyle(color: Color(0xFFCE4E32)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Avalie restaurantes de verdade.\nSem publis disfarçada.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFB7B7B7),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'seuemail@exemplo.com',
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Informe seu email';
                                if (!value.contains('@'))
                                  return 'Email inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _hidePass,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                hintText: '••••••••',
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      setState(() => _hidePass = !_hidePass),
                                  icon: Icon(
                                    _hidePass
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Informe sua senha';
                                if (value.length < 6)
                                  return 'Mínimo 6 caracteres';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text('Esqueci a senha'),
                              ),
                            ),

                            const SizedBox(height: 8),

                            ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                      ),
                                    )
                                  : const Text('Entrar'),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Não tem conta?',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFFB7B7B7),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SignUpPage(
                                          appState: widget.appState,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Criar conta'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Uma comunidade feita por pessoas reais.\nSem publi, sem fake, só experiência de verdade.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF8E8E8E),
                      height: 1.4,
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
