import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<int> scoreLeaderboard = [0, 0, 0];
List<String> leaderboardUser = ["", "", ""];
bool animated = false;
late Timer _timer;
double opacityLevel = 0;

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
      body: ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: Text("High Scores",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              alignment: Alignment.center),
          AnimatedOpacity(
            opacity: opacityLevel,
            duration: const Duration(seconds: 2),
            child: Image.asset("assets/images/rank1.png",
                height: 60, alignment: Alignment.topLeft),
          ),
          AnimatedOpacity(
            opacity: opacityLevel,
            duration: const Duration(seconds: 2),
            child: Image.asset("assets/images/rank2.jpg",
                height: 60, alignment: Alignment.topLeft),
          ),
          AnimatedOpacity(
            opacity: opacityLevel,
            duration: const Duration(seconds: 2),
            child: Image.asset("assets/images/rank3.jpg",
                height: 60, alignment: Alignment.topLeft),
          ),
          Container(
            height: 100.0,
            alignment: Alignment.topLeft,
            child: ListView.builder(
              itemCount: leaderboardUser.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, idx) {
                return Column(
                  children: [
                    Container(
                      height: 200.0,
                      width: 300.0,
                      child: Column(children: [
                        Column(
                          children: [
                            Container(
                              height: 25,
                              width: 150,
                              child: Text(
                                leaderboardUser[idx],
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 25,
                              width: 150,
                              child: Text(
                                scoreLeaderboard[idx].toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        )
                      ]),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
