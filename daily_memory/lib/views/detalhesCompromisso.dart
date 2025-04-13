import 'package:daily_memory/views/editarCompromisso.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/Compromisso.dart';

class DetalhesCompromissoPage extends StatefulWidget {
  final Compromisso compromisso;

  const DetalhesCompromissoPage({super.key, required this.compromisso});

  @override
  State<DetalhesCompromissoPage> createState() =>
      _DetalhesCompromissoPageState();
}

class _DetalhesCompromissoPageState extends State<DetalhesCompromissoPage> {
  @override
  Widget build(BuildContext context) {
    final data = DateTime.parse(widget.compromisso.data);
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _tituloController = TextEditingController(text: widget.compromisso.titulo);
    final TextEditingController _descricaoController = TextEditingController(text: widget.compromisso.descricao);
    final TextEditingController _dataController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(data));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Compromisso",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  readOnly: true,
                  controller: _tituloController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo DATA
                TextFormField(
                  readOnly: true,
                  controller: _dataController,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final data = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (data != null) {
                      _dataController.text = DateFormat('dd/MM/yyyy').format(data);

                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe a data';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  readOnly: true,
                  controller: _descricaoController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe a descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textStyle: Theme.of(context).textTheme.titleLarge,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditarCompromissoPage(
                                    compromisso: widget.compromisso,
                                  ),
                            ),
                          );
                        },
                        child: const Text(
                          "Editar",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textStyle: Theme.of(context).textTheme.titleLarge,
                        ),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Confirmar exclusão"),
                              content: const Text("Tem certeza que deseja excluir este compromisso?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Cancelar")),
                                TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Excluir")),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await excluirCompromisso(widget.compromisso.id);
                          }
                        },
                        child: const Text(
                          "Excluir",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> excluirCompromisso(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:4000/compromissos/$id'),
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compromisso excluído com sucesso!")),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao excluir compromisso")),
        );
      }
    }
  }
}
