import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class AgendaVirtualPage extends StatefulWidget {
  const AgendaVirtualPage({super.key});

  @override
  State<AgendaVirtualPage> createState() => _AgendaVirtualPageState();
}

class _AgendaVirtualPageState extends State<AgendaVirtualPage> {
  late Map<DateTime, List<String>> _compromissos;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _compromissos = {};
    // Ajuste aqui para uma data que você sabe ter compromisso
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _loadCompromissos();
  }

  // Função para carregar os compromissos da API
  Future<void> _loadCompromissos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:4000/compromissos'));

    if (response.statusCode == 200) {
      List<dynamic> compromissosJson = json.decode(response.body);

      setState(() {
        _compromissos.clear();
        for (var compromisso in compromissosJson) {
          // String no formato "2025-04-16T00:00:00.000Z"
          final dataString = compromisso['data'] as String;
          final data = DateTime.parse(dataString);

          // Ignora o horário, usa só ano-mês-dia
          final somenteData = DateTime(data.year, data.month, data.day);

          // Se ainda não existe uma lista para essa data, cria
          _compromissos[somenteData] ??= [];
          _compromissos[somenteData]!.add(compromisso['titulo']);
        }
      });
    } else {
      throw Exception('Falha ao carregar compromissos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém os compromissos do dia selecionado
    final compromissosDoDia = _compromissos[DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    )] ?? [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Calendário Virtual"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Calendário
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  final somenteData = DateTime(day.year, day.month, day.day);
                  return _compromissos[somenteData] ?? [];
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: MediaQuery.of(context).size.height*0.36,
              child: Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: compromissosDoDia.isEmpty
                      ? const Center(
                    child: Text(
                      'Nenhum compromisso para este dia',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                      : ListView.builder(
                    itemCount: compromissosDoDia.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(compromissosDoDia[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
