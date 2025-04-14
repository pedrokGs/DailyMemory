import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

import '../app_colors.dart';

class AgendaVirtualPage extends StatefulWidget {
  const AgendaVirtualPage({super.key});

  @override
  State<AgendaVirtualPage> createState() => _AgendaVirtualPageState();
}

class _AgendaVirtualPageState extends State<AgendaVirtualPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Map<DateTime, List<String>> _compromissos;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _compromissos = {};
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _loadCompromissos();
  }

  Future<void> _loadCompromissos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:4000/compromissos'));

    if (response.statusCode == 200) {
      List<dynamic> compromissosJson = json.decode(response.body);

      setState(() {
        _compromissos.clear();
        for (var compromisso in compromissosJson) {
          final dataString = compromisso['data'] as String;
          final data = DateTime.parse(dataString);

          final somenteData = DateTime(data.year, data.month, data.day);

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
    final compromissosDoDia = _compromissos[DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    )] ?? [];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Calendário Virtual"),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
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

      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24),

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
                      return GestureDetector(
                        onTap: () =>
                        Navigator.pushNamed(context, "/compromissosList"),
                        child: ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(compromissosDoDia[index]),
                        ),
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
