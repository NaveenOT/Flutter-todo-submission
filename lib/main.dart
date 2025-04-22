import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'pages/input.dart';
import 'pages/tasks.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      themeMode: themeProvider.currentTheme,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo List'),
          actions: [
            IconButton(
              icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => themeProvider.toggleTheme(),
            )
          ],
          bottom: const TabBar(tabs: [
            Tab(text: 'Input'),
            Tab(text: 'Tasks'),
          ]),
        ),
        body: const TabBarView(
          children: [
            Input(),
            Tasks(),
          ],
        ),
      ),
    );
  }
}
