import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/contato_api_repository.dart';
import '../viewmodels/contato_viewmodel.dart';
import 'lista.dart';
import 'novo.dart';
import 'edita.dart';
import 'login.dart';
import 'registro.dart';

class ContatoApp extends StatelessWidget {
  const ContatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContatoViewModel(ContatoApiRepository())..read(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/lista': (context) => const ListaPage(),
          '/novo': (context) => NovoPage(),
          '/edita': (context) => EditaPage(),
          '/login': (context) => const LoginPage(),
          '/registro': (context) => const RegistroPage(),
        },
        initialRoute: '/login',
      ),
    );
  }
}