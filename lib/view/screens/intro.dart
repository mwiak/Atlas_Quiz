import 'dart:convert';
import 'package:atlas_quiz/view_model/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:atlas_quiz/view/screens/home_page.dart';
import 'package:atlas_quiz/model/sqflite.dart';
import 'registration_page.dart';

//this screen starts when the application is opened.
class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  late UserInfoProvider userInfoProvider;
  List<dynamic> questions = [];

  SqlDb dataHelper = SqlDb();

  // getting user data nickname and highest score
  Future<void> getUserData() async {
    List<Map> userdata = await dataHelper.readData('''SELECT * FROM user ''');
    if (userdata.isEmpty) //if the application is opened for the first time
    {
      await loadJson(); // it saves the questions from the JSON file to the database
      Navigator.of(context).pushReplacement(
        // and redirects the user to register its nickname
        MaterialPageRoute(builder: (context) => const RegistrationPage()),
      );
    } else {
      //if the user has registered before
      await userInfoProvider.getUserData(); // it fetches the user's data
      Navigator.of(context).pushReplacement(
        // and redirects the user to the main menu
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  Future<void> loadJson() async {
    // Load the JSON file as a string
    String jsonString = await rootBundle.loadString('assets/questions.json');

    // Decode the JSON string into a Map
    List<dynamic> jsonMap = json.decode(jsonString);

    questions = jsonMap;
    saveQuestions();
  }

  Future<void> saveQuestions() async {
    for (Map questionMap in questions) {
      String questionBody = questionMap['questionText'];
      int questionId = questionMap['questionId'];
      List choicesMap = questionMap['choices'];
      String choices = json.encode(choicesMap);

      int response = await dataHelper.insertData('''INSERT INTO questions
       ( question_body,question_id,choices ) VALUES ('$questionBody',$questionId,'$choices')''');
    }
  }

  /* assign providers value in this overridden method since its called everytime the widget dependencies change.
   yet it is not the perfect place for doing this but the initState method can't access the context parameter since it is only ready when the widget built  */
  @override
  void didChangeDependencies() {
    userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    getUserData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
