import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastrarCompromissoPage extends StatefulWidget {
  const CadastrarCompromissoPage({super.key});

  @override
  State<CadastrarCompromissoPage> createState() =>
      _CadastrarCompromissoPageState();
}

class _CadastrarCompromissoPageState extends State<CadastrarCompromissoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  Future<void> cadastrarCompromisso() async {
    const url = 'http://10.0.2.2:4000/cadastrarCompromisso';

    final Map<String, dynamic> body = {
      'titulo': _tituloController.text,
      'descricao': _descricaoController.text,
      'data': _dataController.text,
    };

    try {
      print("Enviando requisição...");
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      print("Status code: ${response.statusCode}");
      print("Resposta: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Cadastro bem-sucedido!");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compromisso cadastrado com sucesso!')),
        );

        Navigator.pop(context);
      } else {
        print("Erro na resposta!");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: ${response.statusCode}')));
      }
    } catch (e) {
      print("Exceção: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro na requisição: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Criar Compromisso'),
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
                  "Criar Compromisso",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Campo TÍTULO
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

                // Campo DATA
                TextFormField(
                  controller: _dataController,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode()); // evita abrir o teclado
                    final data = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (data != null) {
                      _dataController.text = data.toIso8601String().split("T").first;
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cadastrarCompromisso();
                      }
                    },
                    child: const Text("Criar", style: TextStyle(color: Colors.black)),
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
