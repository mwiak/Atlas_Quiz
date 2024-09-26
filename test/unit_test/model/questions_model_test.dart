import 'dart:math';

import 'package:atlas_quiz/model/question_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<int> getTotalMock(int total) async {
  int response = await total;
  return response;
}

void main() {
  sqfliteFfiInit(); //necessary to access the database without android runtime
  databaseFactory =
      databaseFactoryFfi; //necessary to access the database without android runtime
  WidgetsFlutterBinding.ensureInitialized(); //necessary to access assets folder

  late QuestionModel sut;

  setUp(() {
    sut = QuestionModel();
  });

  test('initial value are correct', () {
    expect(sut.questionsSet, []);
  });

  test('decoding JSON file', () async {
    List decodedJson = await sut.loadJson();
    expect(decodedJson.length, 30);
  });

  test('save the decoded JSON file to database', () async {
    List<int> responseList = await sut.saveQuestionsForFirstTime();
    expect(responseList.length, 30);
  });

  test('get the total number of questions in the database', () async {
    int total = await sut.getQuestionsCountInBank();
    expect(total, 30);
  });

  test('conditions are executed correctly', () async {
    await sut.generateQuestions(getTotalMock(30));
    expect(sut.testFlag, 'all new');
    await sut.generateQuestions(getTotalMock(10));
    expect(sut.testFlag, 'hybrid_fixed');
    await sut.generateQuestions(getTotalMock(3));
    expect(sut.testFlag, 'hybrid');
    await sut.generateQuestions(getTotalMock(0));
    expect(sut.testFlag, 'all old');
  });

  //
}
