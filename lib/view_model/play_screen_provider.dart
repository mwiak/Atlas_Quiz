import 'package:flutter/material.dart';

//this class has two purposes: prevent Choice widget from accepting user input during evaluation and keep a score for each quiz

class PlayScreenProvider extends ChangeNotifier {
  bool _clickable =
      true; // a boolean flag that's when true the Choice widgets button can be pressed
  int score = 0; // a temporary score for each quiz
  List<Widget> scoreBarItems =
      []; /* a list of widgets that populated after
  each questions answer with either an a check icon if the user got the question right or a close icon otherwise */

  get clickable =>
      _clickable; // a getter for the boolean flag it is necessary when using Selector to listen for the flag value changes

  void updateClickable() {
    // method for toggling the boolean flag
    _clickable = !_clickable;
    notifyListeners(); // notify listeners to rebuild if flag value has changed
  }
}
