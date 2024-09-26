import 'package:atlas_quiz/view_model/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas_quiz/view/screens/home_page.dart';
import '../../view_model/play_screen_provider.dart';
import '../widgets/choice.dart';
import 'results.dart';
import 'package:atlas_quiz/model/sqflite.dart';

//the screen where the quiz takes place

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool isLoading =
      true; // a boolean flag that is turn false if generating questions process has completed.
  SqlDb dataHelper = SqlDb();
  late List questionsSet =
      []; // a list to store questions in this widget's state and iterate over each question to display it.
  int currentQuestion = 0; // the initial index of the list questionsSet.
  List<Widget> scoreBar = [];
  late PlayScreenProvider
      playScreenProvider; // provider used to prevent user from clicking again on a question choice until the next question appears.
  late QuestionProvider
      questionProvider; // provider(view model layer) that calls fetching questions from database methods.

  // the methods that iterate over the questionsSet elements
  void nextQuestion() async {
    if (currentQuestion <
        questionsSet.length -
            1) // if there are questions move to next questions
    {
      setState(() {
        currentQuestion++;
      });
    } else // if there is no questions left, redirects the user to Results page passing the current score to the page also
    {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => Results(
                  currentScore: playScreenProvider.score,
                )),
      );
    }
  }

  // methods that return the current question's text
  String showQuestionText() {
    return questionsSet[currentQuestion].title;
  }

  //showing an alert dialog to confirm user quiting
  Future<void> showQuitAlertDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you want to quit ?'),
            content: const Text(
                'your current score will not be saved when quitting'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Stay')),
              TextButton(
                  onPressed: () {
                    //resetting when user quits
                    playScreenProvider.scoreBarItems = [];
                    playScreenProvider.score = 0;
                    questionProvider.resetProvider();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                    );
                  },
                  child: const Text(
                    'Quit',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

// assigning providers objects and fetching the questions
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playScreenProvider = Provider.of<PlayScreenProvider>(context);
    questionProvider = Provider.of<QuestionProvider>(context, listen: true);
    questionProvider.fetchQuestions(); // fetching questions
    isLoading =
        questionProvider.isLoading; // assigning the flag to the provider flag
    questionsSet =
        questionProvider.questionSet; // getting the questions once ready
  }

  // dispose is automatically called when widget leaves the widget tree. it was overridden to reset the provider when the quiz ends
  @override
  void dispose() {
    playScreenProvider.scoreBarItems = [];
    playScreenProvider.score = 0;
    questionProvider.resetProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            showQuitAlertDialog();
                          },
                          child: const Text('Quit'))
                    ],
                  )),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Center(
                                child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            showQuestionText(),
                            textAlign: TextAlign.center,
                          ),
                        ))),
                      )),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        //showing the choices in a gridview
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 6),
                        itemCount: questionsSet[currentQuestion].choices.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Choice(
                              key:
                                  UniqueKey(), //UniqueKey was used because Flutter framework could mix between identical widgets' state when they are inserted in the same place in widget tree
                              questionId: questionsSet[currentQuestion].id,
                              choiceText: questionsSet[currentQuestion]
                                  .choices[index]
                                  .keys
                                  .first,
                              isCorrect: questionsSet[currentQuestion]
                                  .choices[index]
                                  .values
                                  .first,
                              onPressed: nextQuestion);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                          'Score: ' + playScreenProvider.score.toString())),
                  Expanded(
                    child: Row(
                      children: playScreenProvider.scoreBarItems,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
