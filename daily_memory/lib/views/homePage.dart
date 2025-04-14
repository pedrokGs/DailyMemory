import 'package:daily_memory/app_colors.dart';
import 'package:daily_memory/views/agendaVirtual.dart';
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        centerTitle: true,
        title: Image.asset("assets/img/logo.png", height: 110, width: 120,),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
            SizedBox(height: 24),
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
                child: Text(
                  "Ver agenda",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            SizedBox(height: 24),
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
                child: Text(
                  "Compromissos",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            SizedBox(height: 24),
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
