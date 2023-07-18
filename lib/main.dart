import 'package:flutter/material.dart';
import './screens/notes_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.amber, scaffoldBackgroundColor: Colors.black87),
      debugShowCheckedModeBanner: false,
      title: '',
      initialRoute: '/',
      routes: {
        '/': (context) => NotesPage(),
      },
    );
  }
}
