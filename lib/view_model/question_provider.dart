import 'package:atlas_quiz/model/question_model.dart';
import 'package:flutter/material.dart';

import '../model/question.dart';

// provider class that calls QuestionModel retrieving questions data from database
class QuestionProvider extends ChangeNotifier {
  QuestionModel questionModel = QuestionModel(); // reference to QuestionModel
  bool isLoading =
      true; // // boolean flag that only when it is true, it calls retrieving questions method

  List get questionSet => questionModel.questionsSet;

  Future<void> fetchQuestions() async {
    if (isLoading ==
        true) /* this boolean is needed because fetchingQuestions is called in widget didChangeDependencies method,
                              so this flag prevent continuous calling for generateQuestions()*/
    {
      await questionModel
          .generateQuestions(questionModel.getQuestionsCountInBank());
      isLoading = false;
      notifyListeners();
    }
  }

  void resetProvider() {
    isLoading = true;
    questionModel.resetQuestionSet();
  }
}
