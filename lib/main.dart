import 'package:color_mixer_160419103/screens/game.dart';
import 'package:color_mixer_160419103/screens/highscore.dart';
import 'package:color_mixer_160419103/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUserActive() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUserActive().then((String result) {
    if (result == '') {
      runApp(MyLogin());
    } else {
      active_user = result;
      runApp(const MyApp());
    }
  });
}

void logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("user_id");
  main();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Mixer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Color Mixer'),
      routes: {
        'game': (context) => Game(),
        'highscore': (context) => HighScore(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currIdx = 0;
  final List<Widget> _screens = [Game(), HighScore()];

  Widget myDrawer() {
    return Drawer(
      elevation: 15.0,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              active_user,
              style: TextStyle(fontSize: 30),
            ),
            accountEmail: null,
          ),
          ListTile(
            title: Text("High Score"),
            onTap: () {
              Navigator.popAndPushNamed(context, 'highscore');
            },
            leading: Icon(Icons.list),
          ),
          ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                logoutUser();
              }),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: myDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(20),
          child: Center(
              child: Column(
            children: <Widget>[
              Text(
                "Welcome, $active_user!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 20,
              ),
              Text(
                "The goal of the game is to produce the exact color as shown within a time limit.Provide the red,green,and blue values (0 to 255), then press the Guess Color button to answer. Your score is determined by the remaining time. When the time is up, then it's game over! See if you can reach top 5!",
                style: TextStyle(
                  fontSize: 20,
                  wordSpacing: 8,
                ),
              ),
              Divider(
                height: 80,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, 'game');
                  },
                  child: Text("Play Game"))
            ],
          )),
        )));
  }
}
