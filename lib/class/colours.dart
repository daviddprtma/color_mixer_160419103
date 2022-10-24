import 'dart:math';

class Colours {
  int redColor;
  int greenColor;
  int blueColor;

  Colours({this.redColor = 0, this.greenColor = 0, this.blueColor = 0});

  int euclideanPredict(Colours predictColor) {
    int calc = sqrt(pow(redColor - predictColor.redColor, 2) +
            (pow(greenColor - predictColor.greenColor, 2) +
                pow(blueColor - predictColor.blueColor, 2)))
        .toInt();
    return calc;
  }
}
