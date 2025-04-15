import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}
// what is the void main() - every app in flutter starts with this main function
// it is there to run the app

// the Myapp is a "widget" - every widget has a build method
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), // creating a state for the whole app
      child: MaterialApp(
        title: 'Namer App', // the apps name
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(), // this is setting the home page of the app
      ),
    );
  }
}

// the my app state manages the state of the app
// the change modifier part basically whatever is listening or "watching this will be effected by the modifier"
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Add this. - this is responsable for generating the next random word
  void getNext() {
    current = WordPair.random();
    notifyListeners(); // "hey things that watch me know that i have changed" - basically 
  }
}

// another widget with a build method -but this widget watchs the MyApp state
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // a Scaffold is a widget that provides sctructure
    return Scaffold(
      body: Column(
        children: [
          Text('A random Amazing Totaly cool idea:'),
          Text(appState.current.asLowerCase),

          // ↓ Add this.
          ElevatedButton(
            onPressed: () {
              print('button pressed!');
              appState.getNext(); //this activate the get next when the button is pressed
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
