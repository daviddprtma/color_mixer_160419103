import 'dart:math';

import 'package:color_mixer_160419103/screens/result.dart';
import 'package:flutter/material.dart';
import 'package:color_mixer_160419103/class/colours.dart';
import 'dart:async';

import 'package:percent_indicator/percent_indicator.dart';

late Timer _timer;
int _initValue = 255;
int _time_game = 0;
bool _isrun = false;
String _calcState = "";
int _sisa_waktu = 0;
Colours _question_color_user = Colours();
Colours _guess_color_question = Colours();
int _guessColor = 0;
int _cur_guess_color = 0;
int _use_hint = 0;
bool _hint_use = false;

int _score = 0;
int _success = 0;

Random rand = new Random();

final TextEditingController _answer_red = TextEditingController();
final TextEditingController _answer_green = TextEditingController();
final TextEditingController _answer_blue = TextEditingController();

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  startTime() {
    _timer = Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState(() {
        _time_game++;
        _sisa_waktu--;
        if (_sisa_waktu < 1) {
          finishGame();
          stopTheGame();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
    setState(() {
      _sisa_waktu = _initValue;
      _question_color_user = Colours(
          redColor: rand.nextInt(255),
          greenColor: rand.nextInt(255),
          blueColor: rand.nextInt(255));

      _guess_color_question =
          Colours(redColor: 255, greenColor: 255, blueColor: 255);
    });
  }

  void stopTheGame() {
    _timer.cancel();
  }

  @override
  void dispose() {
    stopTheGame();
    super.dispose();
  }

  String formatTime(int hitung) {
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void nextQuestion() {
    setState(() {
      _time_game = _initValue;
      _hint_use = false;
      _question_color_user = Colours(
          redColor: rand.nextInt(255),
          greenColor: rand.nextInt(255),
          blueColor: rand.nextInt(255));

      _success++;
      _sisa_waktu = _initValue;
      _cur_guess_color = 0;
      scoreUser();
    });
  }

  void scoreUser() {
    setState(() {
      double _guess_multiplier = 1.0;
      double _hint_user_1 = 1.0;
      double _hint_user_2 = 0.5;

      if (_hint_use == false) {
        _score =
            _score + (_hint_user_1 * _guess_multiplier * _sisa_waktu).floor();
      } else {
        _score =
            _score + (_hint_user_2 * _guess_multiplier * _sisa_waktu).floor();
      }

      if (_guess_multiplier < 5) {
        _guess_multiplier = 5.0 - _cur_guess_color;
      }
    });
  }

  void hintUser() {
    _use_hint++;
    int _hint_color = 0;
    int _hint_idx_color = rand.nextInt(2);

    if (_hint_idx_color == 2) {
      _hint_color = _question_color_user.blueColor;
    } else if (_hint_idx_color == 1) {
      _hint_color = _question_color_user.greenColor;
    } else {
      _hint_color = _question_color_user.redColor;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("HINT COLOR"),
              content: Text(
                  "This is the hint color for you to be guess. $_hint_color"),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sisa_waktu = (_sisa_waktu / 2).round();
                        _hint_use = true;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("SUPP!!"))
              ],
            ));
  }

  void colorGuess() {
    setState(() {
      _guess_color_question = Colours(
          redColor: int.parse(_answer_red.text),
          greenColor: int.parse(_answer_green.text),
          blueColor: int.parse(_answer_blue.text));
      _guessColor++;
      _cur_guess_color++;

      distanceCalcUser();
    });
  }

  void distanceCalcUser() {
    setState(() {
      int distanceGuess =
          _question_color_user.euclideanPredict(_guess_color_question);
      if (distanceGuess > 128) {
        _calcState = "Try again!";
      } else if (distanceGuess > 64 && distanceGuess <= 128) {
        _calcState = "Too far!";
      } else if (distanceGuess > 32 && distanceGuess <= 64) {
        _calcState = "You got this!";
      } else if (distanceGuess > 16 && distanceGuess <= 32) {
        _calcState = "Close enough bro & sis....";
      } else if (distanceGuess == 0) {
        nextQuestion();
      } else {
        _calcState = "Almost!";
      }
    });
  }

  String hexFormat(String hexCode) {
    hexCode = hexCode.replaceAll("Color(0xff", "#");
    return hexCode.replaceAll(")", "").toUpperCase();
  }

  finishGame() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('GAME OVER'),
              content: Text('Good Game Great Eyes! '),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Result(
                            _score != 0 ? _score : 0,
                            formatTime(_time_game),
                            _success != 0 ? _success : 0,
                            _success != 0
                                ? (_guessColor / _success).round()
                                : _guessColor,
                            _use_hint != 0 ? _use_hint : 0)));
                  },
                  child: const Text('Show Result'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Game Color Mixer"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: LinearPercentIndicator(
                center: Text(formatTime(_sisa_waktu)),
                width: MediaQuery.of(context).size.width - 20,
                lineHeight: 20.0,
                percent: min(1 - (_sisa_waktu / _initValue), 1),
                backgroundColor: Colors.grey,
                progressColor: Color.fromRGBO(
                    _question_color_user.redColor,
                    _question_color_user.greenColor,
                    _question_color_user.blueColor,
                    1),
              ),
            ),
            Container(
              alignment: Alignment(0.5, 0.8),
              child: Text(
                "Score: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Guess this color!"),
                Text("Your color"),
              ],
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 1),
                      color: Color.fromRGBO(
                          _question_color_user.redColor,
                          _question_color_user.greenColor,
                          _question_color_user.blueColor,
                          1)),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 1),
                      color: Color.fromRGBO(
                          _guess_color_question.redColor,
                          _guess_color_question.greenColor,
                          _guess_color_question.blueColor,
                          0.1)),
                ),
              ],
            ),
            Container(
              alignment: Alignment(-0.5, -0.8),
              child: Text(hexFormat(Color.fromRGBO(
                      _question_color_user.redColor,
                      _question_color_user.greenColor,
                      _question_color_user.blueColor,
                      1)
                  .toString())),
            ),
            Container(
              alignment: Alignment(0.5, 0.8),
              child: Text(
                  hexFormat(Color.fromRGBO(
                          _guess_color_question.redColor,
                          _guess_color_question.greenColor,
                          _guess_color_question.blueColor,
                          1)
                      .toString()),
                  textAlign: TextAlign.justify),
            ),
            Text(_calcState),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Red (0-255)",
                ),
                controller: _answer_red,
                onChanged: (v) {
                  print(_answer_red);
                  print(v);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Green (0-255)",
                ),
                controller: _answer_green,
                onChanged: (v) {
                  print(_answer_green);
                  print(v);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Blue (0-255)",
                ),
                controller: _answer_blue,
                onChanged: (v) {
                  print(_answer_blue);
                  print(v);
                },
              ),
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      colorGuess();
                      distanceCalcUser();
                    },
                    child: const Text("GUESS COLOR")),
                ElevatedButton(
                    onPressed: !_hint_use
                        ? () {
                            hintUser();
                          }
                        : null,
                    child: const Text("SHOW HINT")),
                ElevatedButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                  title: Text("Quit game"),
                                  content: Text(
                                      "Are you sure that you want to give up and quit this game?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          finishGame();
                                          stopTheGame();
                                        },
                                        child: Text("Stop the game")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No"))
                                  ]));
                    },
                    child: const Text("GIVE UP")),
              ],
            )
          ],
        )),
      ),
    );
  }
}
