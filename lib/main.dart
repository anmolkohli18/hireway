import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:milkyway/candidate/create.dart';
import 'package:milkyway/documents/doc_structure.dart';
import 'package:milkyway/firebase/auth/email_page.dart';
import 'package:milkyway/firebase/firebase_config.dart';

void main() async {
  await Firebase.initializeApp(options: FirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milky Way',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple,
      ),
      home: const MyHomePage(
        title: 'Milkyway',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(child: AddCandidate()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
