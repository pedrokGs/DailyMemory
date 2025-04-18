import 'dart:convert';
import 'package:daily_memory/models/Compromisso.dart';
import 'package:daily_memory/views/detalhesCompromisso.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../app_colors.dart';

class ListCompromissoPage extends StatefulWidget {
  const ListCompromissoPage({super.key});

  @override
  State<ListCompromissoPage> createState() => _ListCompromissoPageState();
}

class _ListCompromissoPageState extends State<ListCompromissoPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Compromisso>> buscarCompromissos() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/compromissos'),
    );

    if (response.statusCode == 200) {
      final List dados = jsonDecode(response.body);
      return dados.map((e) => Compromisso.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar compromissos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Compromissos"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back))
        ],
      ),

      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.quaternary,
                ),
                width: 20,
                height: 120,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Icon(Icons.cancel, size: 120,),
              ),
            ),

            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, '/');
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.quaternary,
                ),
                width: 20,
                height: 120,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Icon(Icons.home, size: 120,),
              ),
            ),

            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, '/agendaVirtual');
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.quaternary,
                ),
                width: 20,
                height: 120,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Icon(Icons.calendar_month, size: 120),
              ),
            ),

            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.quaternary,
                ),
                width: 20,
                height: 120,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/compromissosList');
                  },
                  icon: Icon(Icons.notifications, size: 120),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Compromisso>>(
              future: buscarCompromissos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final lista = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: lista.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    final item = lista[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        color: Theme.of(context).colorScheme.secondary,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          title: Text(
                            item.titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                                item.descricao,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(item.data)),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalhesCompromissoPage(compromisso: item),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, top: 16),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: const TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastrarCompromisso');
                },
                child: const Text(
                  "Criar Compromisso",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
