import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/Compromisso.dart';

class EditarCompromissoPage extends StatefulWidget {
  final Compromisso compromisso;

  const EditarCompromissoPage({super.key, required this.compromisso});

  @override
  State<EditarCompromissoPage> createState() => _EditarCompromissoPageState();
}

class _EditarCompromissoPageState extends State<EditarCompromissoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController = TextEditingController(
    text: widget.compromisso.titulo,
  );
  late TextEditingController _descricaoController = TextEditingController(
    text: widget.compromisso.descricao,
  );
  late TextEditingController _dataController = TextEditingController(
    text: widget.compromisso.data,
  );

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.compromisso.titulo);
    _descricaoController = TextEditingController(
      text: widget.compromisso.descricao,
    );
    _dataController = TextEditingController(
      text: DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.parse(widget.compromisso.data)),
    );
  }

  void atualizarCompromisso() async {
    if (!_formKey.currentState!.validate()) return;

    final compromissoAtualizado = {
      "titulo": _tituloController.text,
      "descricao": _descricaoController.text,
      "data": widget.compromisso.data,
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:4000/compromissos/${widget.compromisso.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(compromissoAtualizado),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compromisso atualizado com sucesso!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar compromisso.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Compromisso"),
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
                const SizedBox(height: 16),
                TextFormField(
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
                TextFormField(
                  controller: _dataController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final data = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.tryParse(_dataController.text) ??
                          DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (data != null) {
                      _dataController.text =
                          data.toIso8601String().split("T").first;
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                    onPressed: atualizarCompromisso,
                    child: const Text(
                      "Salvar Alterações",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
