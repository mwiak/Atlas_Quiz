import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas_quiz/model/sqflite.dart';

import '../../view_model/play_screen_provider.dart';

// a custom widget that is mapped to each choice of a question choices
class Choice extends StatefulWidget {
  final String choiceText;
  final bool isCorrect;
  final int
      questionId; // questions id need to be passed to move the question if it has been answered correctly from questions table to guessed_questions  table.

  final Function onPressed; //passing a function that takes to the next question

  const Choice(
      {super.key,
      required this.questionId,
      required this.choiceText,
      required this.isCorrect,
      required this.onPressed});

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  Color buttonColor = Colors.blue[100]!; // a variable to store the button color
  late Color
      buttonEvaluationColor; // a variable to store the button color when the button is disabled
  bool isSelected = false; // boolean flag to detect which button is selected
  late PlayScreenProvider
      playScreenProvider; // a reference to PlayScreenProvider

  // a method that adds an icon to the progress bar
  void addToScoreBar() {
    if (widget.isCorrect) {
      playScreenProvider.scoreBarItems.add(const Icon(Icons.check));
    } else {
      playScreenProvider.scoreBarItems.add(const Icon(Icons.close));
    }
  }

  // function that move the question from questions table to guessed_questions table if the user answers it correctly
  Future<void> moveCorrectQuestion() async {
    if (widget.isCorrect) {
      SqlDb dataManager = SqlDb();
      await dataManager.moveQuestionToGuessed(widget.questionId);
    }
  }

  @override
  void initState() {
    buttonEvaluationColor = widget.isCorrect
        ? Colors.green
        : Colors
            .red; //assign the disabled color to red if the choice is not correct and to green if correct
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playScreenProvider = Provider.of<PlayScreenProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PlayScreenProvider,
            bool> /* Selector that only rebuild the children if the value of
                                                the boolean clickable has been changed and notifyListener()
                                                has been called from the provider*/
        (
        selector: (context, selectorP) => selectorP.clickable,
        builder: (context, clickable, child) {
          return SizedBox(
            width: 120,
            height: 50,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Set the desired radius here
              ),
              splashColor: Colors.orange,
              onPressed:
                  clickable // if clickable is true the button can be pressed
                      ? () async {
                          moveCorrectQuestion();
                          playScreenProvider.score = widget.isCorrect
                              ? playScreenProvider.score + 100
                              : playScreenProvider
                                  .score; // add 100 or subtract 100

                          addToScoreBar(); // add icon to the progress bar

                          playScreenProvider
                              .updateClickable(); // disable all choices from being clicked until the evaluation completed.

                          await Future.delayed(const Duration(
                              milliseconds: 1500)); // add a 1.5 seconds delay

                          playScreenProvider
                              .updateClickable(); // enable choices to be clicked again
                          widget.onPressed(); // move to the next question
                        }
                      : null,
              color:
                  buttonColor, // assigning color when the button can be pressed
              disabledColor:
                  buttonEvaluationColor, // assigning color when the button is disabled
              child: Text(widget.choiceText),
            ),
          );
        });
  }
}
