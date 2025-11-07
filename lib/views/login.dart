import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  String _traduzErro(String msgOriginal) {
    final m = msgOriginal.toLowerCase();
    if (m.contains('invalid login credentials'))
      return 'E-mail ou senha incorretos.';
    if (m.contains('user not found')) return 'Usuário não encontrado.';
    if (m.contains('email not confirmed')) return 'E-mail não confirmado.';
    return 'Erro ao fazer login: $msgOriginal';
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: senhaController.text,
      );

      final user = response.user;
      if (user != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bem-vindo, ${user.email}!')));
        Navigator.pushReplacementNamed(context, '/lista');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha incorretos.')),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_traduzErro(e.message))));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fundo rosado com forma ondulada
          ClipPath(
            clipper: WaveClipper(),
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.asset(
                'assets/images/wave-login.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ), // espaçamento entre texto e linha
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              width: 40, // tamanho da linha
                              height: 2,
                              color: Color(0xFF811844),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF811844),
                          ), // linha normal
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF811844),
                            width: 2,
                          ), // linha ao focar
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Color(
                            0xFF811844,
                          ), // cor do rótulo quando o campo está focado
                        ),
                      ),

                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe seu e-mail';
                        if (!v.contains('@')) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF811844),
                          ), // linha normal
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF811844),
                            width: 2,
                          ), // linha ao focar
                        ),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.isEmpty)
                                  ? 'Informe sua senha'
                                  : null,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF811844,
                          ), // fundo rosado escuro
                          foregroundColor: Colors.white, // texto branco
                          minimumSize: const Size(
                            200,
                            45,
                          ), // largura e altura mínimas
                        ),

                        onPressed: _loading ? null : login,
                        child:
                            _loading
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text("Login"),
                      ),
                    ),

                    // Novo botão: Esqueci minha senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _loading
                            ? null
                            : () {
                                Navigator.pushNamed(context, '/redefineSenha');
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF811844),
                        ),
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF811844),
                        minimumSize: const Size(200, 40),
                      ),
                      onPressed:
                          _loading
                              ? null
                              : () => Navigator.pushNamed(context, '/registro'),
                      child: const Text("Registre-se"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 60);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 120);
    var secondEndPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}