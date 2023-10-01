import 'package:flutter/material.dart';
import 'package:onepref/onepref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OnePref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter demo",
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        themeMode: ThemeMode.dark,
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("cloned/"),
      ),
    );
  }
}
