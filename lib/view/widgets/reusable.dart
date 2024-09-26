import 'package:flutter/material.dart';

class PlayerCard extends StatefulWidget {
  // custom widget to display nickname and high score in the main menu
  final String nickName;
  final int highScore;

  const PlayerCard(
      {super.key, required this.nickName, required this.highScore});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.nickName,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.highScore.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const Text(
                'High Score',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
