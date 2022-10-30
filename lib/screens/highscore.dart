import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<int> scoreLeaderboard = [0, 0, 0];
List<String> leaderboardUser = ["", "", ""];
List<String> gambar = [
  "assets/images/rank1.png",
  "assets/images/rank2.jpg",
  "assets/images/rank3.jpg"
];
bool animated = false;
late Timer _timer;
double opacityLevel = 0;
int _score = 0;
String user_name = "";

class HighScore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HighScoreState();
}

void saveScore(int _score, String user_name) {
  var idx = 0;
  for (int _curr_score in scoreLeaderboard) {
    if (_score > _curr_score) {
      leaderboardUser.insert(idx, user_name);
      scoreLeaderboard.insert(idx, _score);

      leaderboardUser.removeAt(idx);
      scoreLeaderboard.removeAt(idx);
    } else {
      leaderboardUser.insert(idx, user_name);
      scoreLeaderboard.insert(idx, _score);

      leaderboardUser.removeAt(idx + 1);
      scoreLeaderboard.removeAt(idx + 1);
    }
    idx++;
  }
}

void getUserLeaderboard() async {
  final prefs = await SharedPreferences.getInstance();
  var dump = prefs.getStringList('_score') ?? ["0", "0", "0"];
  leaderboardUser = prefs.getStringList("user_name") ?? ["", "", ""];
  scoreLeaderboard = dump.map(int.parse).toList();
}

void saveUserLeaderboard() async {
  final prefs = await SharedPreferences.getInstance();
  var dump = scoreLeaderboard.map((value) => value.toString()).toList();
  prefs.setStringList("_score", dump);
  prefs.setStringList("user_name", leaderboardUser);
}

class _HighScoreState extends State<HighScore> {
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        animated = !animated;
        opacityLevel = 1 - opacityLevel;
        getUserLeaderboard();
        saveScore(_score, user_name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("High Score"),
      ),
      body: ListView.builder(
        itemBuilder: (context, idx) {
          return Card(
            child: ListTile(
                title:
                    Text(leaderboardUser[idx], style: TextStyle(fontSize: 30)),
                subtitle: Text(
                  scoreLeaderboard[idx].toString() + " pts",
                  style: TextStyle(fontSize: 20),
                ),
                leading: AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(seconds: 3),
                  child: Image.asset(gambar[idx]),
                )),
          );
        },
        itemCount: leaderboardUser.length,
      ),
    );
  }
}
