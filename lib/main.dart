import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'obd2_manager.dart';
import 'dashboard_view.dart'; // Vincula la interfaz deportiva que creamos

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Obd2Manager()..toggleDemoMode(true),
      child: const MyObd2App(),
    ),
  );
}

class MyObd2App extends StatelessWidget {
  const MyObd2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IA OBD2 Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const DashboardView(), // Carga el Dashboard completo con el botón cian
    );
  }
}

