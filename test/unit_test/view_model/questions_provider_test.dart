import 'package:atlas_quiz/view_model/question_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit(); //necessary to access the database without android runtime
  databaseFactory =
      databaseFactoryFfi; //necessary to access the database without android runtime
  late QuestionProvider sut;

  setUp(() {
    sut = QuestionProvider();
  });

  test('initial values are correct', () {
    expect(sut.isLoading, true);
    expect(sut.questionSet, []);
  });

  test('fetch question method is working', () async {
    await sut.fetchQuestions();
    expect(sut.isLoading, false);
  });

  test('reset method is working', () {
    sut.resetProvider();
    expect(sut.isLoading, true);
    expect(sut.questionSet, []);
  });
}
