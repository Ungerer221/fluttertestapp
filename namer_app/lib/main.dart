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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
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

  // adding the faveriting functionality
  var favorites =
      <WordPair>[]; // the [] is a list - this list will only have wordpairs

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners(); // remember to notify listeners
  }
}

// another widget with a build method -but this widget watchs the MyApp state
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState
        .current; // <- before extractinght random word widget we have to change the appstate

    // ↓ Add this.
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    // a Scaffold is a widget that provides sctructure
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // this will center in vertically
          children: [
            Text('A random Amazing Totaly cool idea:'),

            SizedBox(height: 10),

            // Text(appState.current.asLowerCase), // we want to extrac this to a different widget (previouse version)
            BigCard(
                pair:
                    pair), //<- this line now just depends on one single veriable and not on the app state itself - we did ctrl+. and selected extract widget and renamed it to BigCard

            SizedBox(height: 20),

            // ↓ Add this. -  this is the button
            Row(
              mainAxisSize: MainAxisSize
                  .min, // to use the only what it needs in terms of space
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print('toggled faverite');
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    print('button pressed!');
                    appState
                        .getNext(); //this activate the get next when the button is pressed
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// here is the new extracted widget - we refactored the code
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(
        context); // similare to context.watch on line 47 - this theme.of asks from the top and watched ThemeData
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    // here we clicked on the Text element and did crtl+. and chose wrap with padding
    return Card(
      color: theme.colorScheme.primary, //this must come before the child
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ), // this text should be in the style of style
      ),
    );
  }
}
