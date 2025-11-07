import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  String _traduzErroAuth(String msgOriginal) {
    final m = msgOriginal.toLowerCase();
    if (m.contains('already registered')) return 'E-mail já cadastrado.';
    if (m.contains('password')) return 'Senha inválida ou fraca.';
    if (m.contains('email not confirmed')) {
      return 'E-mail não confirmado. Verifique sua caixa de entrada.';
    }
    return 'Erro ao registrar: $msgOriginal';
  }

  Future<void> registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final supa = Supabase.instance.client;

    try {
      final resp = await supa.auth.signUp(
        email: emailController.text.trim(),
        password: senhaController.text,
        data: {
          'nome': nomeController.text.trim(),
          'full_name': nomeController.text.trim(), // aparece como Display name
        },
      );

      if (resp.user != null) {
        // (Opcional) garantir metadados atualizados
        await supa.auth.updateUser(
          UserAttributes(
            data: {
              'nome': nomeController.text.trim(),
              'full_name': nomeController.text.trim(),
            },
          ),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário criado com sucesso!')),
        );
        Navigator.pop(context); // volta para o login
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao criar usuário.')));
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_traduzErroAuth(e.message))));
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
                              'Cadastrar',
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
                              width: 90, // tamanho da linha
                              height: 2,
                              color: Color(0xFF811844),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    TextFormField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
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
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Informe seu nome'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Informe seu e-mail';
                        if (!v.contains('@')) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: senhaController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
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
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe sua senha';
                        if (v.length < 6) return 'Mínimo de 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
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

                        onPressed: _loading ? null : registrar,
                        child:
                            _loading
                                ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                                : const Text('Registrar'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF811844),
                        minimumSize: const Size(200, 40),
                      ),

                      onPressed: _loading ? null : () => Navigator.pop(context),
                      child: const Text('Voltar para Login'),
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
