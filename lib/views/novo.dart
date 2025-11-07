import 'package:contato_app/models/contato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../viewmodels/contato_viewmodel.dart';

class NovoPage extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  NovoPage({super.key});

  void salvar(BuildContext context) {
    Contato contato = Contato(
      id: Uuid().v4(),
      nome: _nomeController.text,
      email: _emailController.text,
    );
    // Provider.of<ContatoViewModel>(context, listen: false).create(contato);
    context.read<ContatoViewModel>().create(contato);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Contato", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF811844),
        iconTheme: const IconThemeData(
          color: Colors.white, // muda a cor do botão de voltar
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            TextField(
              controller: _nomeController,
              // minLines: 1,
              // maxLines: 2,
              // autocorrect: false,
              // enabled: false,
              // maxLength: 20,
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
              ),
            ),

            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => salvar(context),
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
