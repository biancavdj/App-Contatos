import 'package:contato_app/models/contato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/contato_viewmodel.dart';

class EditaPage extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  EditaPage({super.key});

  void salvar(BuildContext context, Contato contato) {
    contato.nome = _nomeController.text;
    contato.email = _emailController.text;

    Provider.of<ContatoViewModel>(context, listen: false).update(contato);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Contato contato =
        ModalRoute.of(context)!.settings.arguments as Contato;
    _nomeController.text = contato.nome;
    _emailController.text = contato.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edita Contato", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF811844),
        iconTheme: const IconThemeData(
          color: Colors.white, // muda a cor do botão de voltar
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                filled: false,
                labelText: "Nome",
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
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _emailController,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
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
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 50),

            ElevatedButton(
              onPressed: () => salvar(context, contato),
              child: Text("Salvar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF811844), // fundo rosado escuro
                foregroundColor: Colors.white, // texto branco
                minimumSize: const Size(200, 45), // largura e altura mínimas
              ),
            ),
          ],
        ),
      ),
    );
  }
}
