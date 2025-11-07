import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../viewmodels/contato_viewmodel.dart';

class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  String filtro = '';

  String _nomeUsuarioAtual() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 'Usuário';
    final meta = user.userMetadata ?? {};
    final nome = (meta['full_name'] ?? meta['nome'] ?? '').toString().trim();
    if (nome.isNotEmpty) return nome;
    // fallback: parte antes do @ do email
    final email = user.email ?? 'Usuário';
    return email.contains('@') ? email.split('@').first : email;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContatoViewModel>();
    final nome = _nomeUsuarioAtual();

    // Filtra a lista conforme o texto digitado
    final contatosFiltrados =
        viewModel.contatos.where((contato) {
          final nomeLower = contato.nome.toLowerCase();
          final emailLower = contato.email.toLowerCase();
          final filtroLower = filtro.toLowerCase();
          return nomeLower.contains(filtroLower) ||
              emailLower.contains(filtroLower);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF811844),
        title: Text('Contatos • $nome', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final confirma = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Confirmação'),
                      content: const Text('Deseja realmente sair?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sair'),
                        ),
                      ],
                    ),
              );

              if (confirma == true) {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Campo de busca
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Pesquisar contato...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF811844),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF811844),
                            width: 2,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF811844)),
                        ),
                      ),
                      onChanged: (valor) => setState(() => filtro = valor),
                    ),
                  ),

                  // Lista filtrada
                  Expanded(
                    child:
                        contatosFiltrados.isEmpty
                            ? const Center(
                              child: Text('Nenhum contato encontrado'),
                            )
                            : ListView.builder(
                              itemCount: contatosFiltrados.length,
                              itemBuilder: (context, index) {
                                final contato = contatosFiltrados[index];

                                Widget leading;
                                if ((contato.avatar ?? '').isNotEmpty) {
                                  leading = CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      contato.avatar!,
                                    ),
                                  );
                                } else {
                                  // se não tiver avatar, mostra iniciais
                                  final iniciais = _iniciais(contato.nome);
                                  leading = CircleAvatar(child: Text(iniciais));
                                }

                                return Dismissible(
                                  key: Key(contato.id),
                                  background: Container(color: Colors.red),
                                  onDismissed:
                                      (_) => context
                                          .read<ContatoViewModel>()
                                          .delete(contato.id),
                                  child: ListTile(
                                    onTap:
                                        () => Navigator.pushNamed(
                                          context,
                                          '/edita',
                                          arguments: contato,
                                        ),
                                    leading: leading,
                                    title: Text(contato.nome),
                                    subtitle: Text(contato.email),
                                    trailing: const Icon(Icons.chevron_right),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF811844),
        onPressed: () => Navigator.pushNamed(context, '/novo'),
        label: const Text('Novo', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _iniciais(String nome) {
    final partes =
        nome.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }
}
