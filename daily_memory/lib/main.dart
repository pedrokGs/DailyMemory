import 'package:daily_memory/app_colors.dart';
import 'package:daily_memory/views/agendaVirtual.dart';
import 'package:daily_memory/views/cadastrarCompromisso.dart';
import 'package:daily_memory/views/cadastro.dart';
import 'package:daily_memory/views/compromissoList.dart';
import 'package:daily_memory/views/detalhesCompromisso.dart';
import 'package:daily_memory/views/homePage.dart';
import 'package:daily_memory/views/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 14, color:AppColors.primary)
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          primaryContainer: AppColors.primaryContainer,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 20),
          bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ),
      initialRoute: '/login',
      routes: {
        "/" : (context) => HomePage(),
        "/cadastro" : (context) => CadastroPage(),
        "/compromissosList" : (context) => ListCompromissoPage(),
        "/cadastrarCompromisso" : (context) => CadastrarCompromissoPage(),
        "/agendaVirtual" : (context) => AgendaVirtualPage(),
        "/login" : (context) => LoginPage(),
      },
    );
  }
}
