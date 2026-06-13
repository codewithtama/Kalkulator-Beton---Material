import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'data/repos/project_repo.dart';
import 'providers/calculator_provider.dart';
import 'providers/history_provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize repository
  final projectRepo = ProjectRepository();
  await projectRepo.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<ProjectRepository>.value(value: projectRepo),
        ChangeNotifierProvider(
          create: (context) => CalculatorProvider(projectRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(projectRepo),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HitungBangun',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
