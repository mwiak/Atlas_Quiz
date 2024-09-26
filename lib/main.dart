import 'package:atlas_quiz/view_model/question_provider.dart';
import 'package:atlas_quiz/view_model/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas_quiz/view/screens/intro.dart';
import 'view_model/play_screen_provider.dart';

void main() // the start point of a Dart program.
{
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // the root of a flutter application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // MultiProvider is wrapped around the materialApp to make the providers accessible to all of the material app children
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        ChangeNotifierProvider(create: (_) => PlayScreenProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
      ],
      child: MaterialApp(
        title: 'Quiz App',
        home: const Intro(), // the default screen in which data is fetched
        theme: ThemeData.light(),
      ),
    );
  }
}
