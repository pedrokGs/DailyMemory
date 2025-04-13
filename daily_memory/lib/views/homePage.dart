import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/agendaVirtual');
                },
                child: Text("Ver agenda", style: TextStyle(color: Colors.black)),
              ),
            ),

            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/compromissosList');
                },
                child: Text("Compromissos", style: TextStyle(color: Colors.black)),
              ),
            ),

            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text("Sair", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
