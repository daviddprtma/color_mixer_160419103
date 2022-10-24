import 'package:color_mixer_160419103/main.dart';
import 'package:color_mixer_160419103/screens/highscore.dart';
import 'package:flutter/material.dart';
import 'package:color_mixer_160419103/screens/game.dart';

class Result extends StatelessWidget {
  int _final_score = 0;
  String _total_time = "";
  int _color_mixed = 7;
  int _avg_guess = 0;
  int _hint_used = 0;

  Result(this._final_score, this._total_time, this._color_mixed,
      this._avg_guess, this._hint_used);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Result Screen"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Final Score: $_final_score",
              style: TextStyle(fontSize: 25),
            ),
            Divider(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Total time played: $_total_time",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Color mixed: $_color_mixed ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Average guesses: $_avg_guess ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Hints used: $_hint_used ",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Divider(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Game()));
                },
                child: Text("PLAY AGAIN")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HighScore()));
                },
                child: Text("HIGH SCORE")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MyApp()));
                },
                child: Text("MAIN MENU")),
          ],
        ),
      ),
    );
  }
}
