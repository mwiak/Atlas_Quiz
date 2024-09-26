import 'package:atlas_quiz/view_model/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'play_menu.dart';

//result screen will be shown to the user if completed the quiz
class Results extends StatefulWidget {
  final int
      currentScore; // current score will be passed by the parent widget (PlayScreen)

  const Results({super.key, required this.currentScore});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late UserInfoProvider userInfoProvider;

  //show score recognition
  Widget showOutro() {
    switch (widget.currentScore) {
      case 0:
        return const Text('You can do better');
      case 100:
        return const Text('Nice try');
      case 200:
        return const Text('Good job');
      case 300:
        return const Text('Good job!');
      case 400:
        return const Text('Excellent work!');
      case 500:
        return const Text('Excellent work!');
      case 600:
        return const Text('Perfect!');
      default:
        return const Text('Score not recognized');
    }
  }

  @override
  void didChangeDependencies() {
    userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    userInfoProvider.assignNewHighScore(widget.currentScore);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SizedBox(
          width: 300,
          height: 450,
          child: Column(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your Score: '),
                  Text(widget.currentScore.toString()),
                ],
              )),
              Expanded(child: showOutro()),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement // redirect user to main menu
                          (
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()),
                      );
                    },
                    child: const Text('Home'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement // redirect user to PlayScreen again
                          (
                        MaterialPageRoute(
                            builder: (context) => const PlayScreen()),
                      );
                    },
                    child: const Text('Play Again'),
                  )
                ],
              ))
            ],
          ),
        ),
      )),
    );
  }
}
