import 'dart:convert';

import 'package:atlas_quiz/model/sqflite.dart';
import 'package:atlas_quiz/model/question.dart';
import 'package:flutter/services.dart';

//the class responsible for retrieving questions from database
class QuestionModel {
  SqlDb dataHelper = SqlDb();
  List _questionsSet = []; // storing the retrieved question in this list
  String testFlag = ''; // a test flag that has no other functional role

  List get questionsSet => _questionsSet;

  //method that empties the retrieved question after the quiz had been completed or the user had quited
  void resetQuestionSet() {
    _questionsSet = [];
  }

  //
  Future<void> generateQuestions(Future<int> input) async {
    int total =
        await input; // the input here is always getQuestionsCountInBank() to check the number of total questions in the database
    int rest = 6 - total;
    if (total > 20) {
      //if the total is greater than 20, it retrieved 6 random new questions or question that user never got right before
      getRandomQuestions();
      testFlag = 'all new';
    } else if (total == 0) {
      //if there is no question entries in questions table it will retrieved 6 random questions that have been guessed before
      getRandomQuestionsFromGuessed();
      testFlag = 'all old';
    } else {
      if (total < 4) {
        //if the total is less than 4 but greater than zero, it will get all the available new questions and fills the remaining with old questions
        testFlag = 'hybrid';
        getRandomQuestionsHybrid(total, rest);
      } else {
        //if the total is less than 20 but greater or equals to 4, it will retrieve 2 old question and 4 new questions
        testFlag = 'hybrid_fixed';
        getRandomQuestionsHybrid(4, 2);
      }
    }
  }

  // methods that retrieved random 6 question form questions table
  Future<void> getRandomQuestions() async {
    var data = await dataHelper
        .readData('''SELECT * FROM questions ORDER BY RANDOM() LIMIT 6 ''');
    _questionsSet = data.map((qMap) {
      return Question(
          id: qMap['question_id'],
          title: qMap['question_body'],
          choices: jsonDecode(qMap['choices']));
    }).toList();
  }

  // methods that retrieved random 6 question form guessed_questions table
  Future<void> getRandomQuestionsFromGuessed() async {
    //TODO add question generating strategy
    var data = await dataHelper.readData(
        '''SELECT * FROM guessed_questions ORDER BY RANDOM() LIMIT 6 ''');
    _questionsSet = data.map((qMap) {
      return Question(
          id: qMap['question_id'],
          title: qMap['question_body'],
          choices: jsonDecode(qMap['choices']));
    }).toList();
  }

  // methods that retrieved random 6 question form guessed_questions table
  Future<void> getRandomQuestionsHybrid(int newCount, int oldCount) async {
    //TODO add question generating strategy
    var dataNew = await dataHelper.readData(
        '''SELECT * FROM questions ORDER BY RANDOM() LIMIT $newCount ''');
    var dataOld = await dataHelper.readData(
        '''SELECT * FROM guessed_questions ORDER BY RANDOM() LIMIT $oldCount ''');

    var data = dataNew + dataOld;
    data.shuffle(); // sort the elements inside randomly

    _questionsSet = data.map((qMap) {
      return Question(
          id: qMap['question_id'],
          title: qMap['question_body'],
          choices: jsonDecode(qMap['choices']));
    }).toList();
  }

  // method that gets the total count of rows in the questions table
  Future<int> getQuestionsCountInBank() async {
    var data = await dataHelper
        .readData(''' SELECT COUNT(*) as total FROM questions ''');
    int total = data[0]['total'];
    return total;
  }

  //decodes the json string into a list of maps
  Future<List> loadJson() async {
    // load the JSON file as a string from the assets folder
    String jsonString = await rootBundle.loadString('assets/questions.json');

    // decode the JSON string into a Map
    List<dynamic> jsonMap = json.decode(jsonString);

    List questions = jsonMap;
    return questions;
  }

  //save the decoded json file into the database
  Future<List<int>> saveQuestionsForFirstTime() async {
    List questions = await loadJson();
    List<int> resposneList = [];
    for (Map questionMap in questions) {
      String questionBody = questionMap['questionText'];
      int questionId = questionMap['questionId'];
      List choicesMap = questionMap['choices'];
      String choices = json.encode(choicesMap);

      int response = await dataHelper.insertData('''INSERT INTO questions
       ( question_body,question_id,choices ) VALUES ('$questionBody',$questionId,'$choices')''');
      resposneList.add(response);
    }
    return resposneList;
  }
}
