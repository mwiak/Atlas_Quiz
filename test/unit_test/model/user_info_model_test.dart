import 'package:atlas_quiz/model/user_info_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late UserInfoModel sut;

  setUp(() {
    sut = UserInfoModel();
    sqfliteFfiInit(); //necessary to access the database without android runtime
    databaseFactory =
        databaseFactoryFfi; //necessary to access the database without android runtime
  });

  test('initial value are correct', () {
    expect(sut.nickname, '');
    expect(sut.highScore, 0);
  });

  test('set functions are working', () {
    sut.setUsername('newName');
    sut.setHighScore(100);
    expect(sut.nickname, 'newName');
    expect(sut.highScore, 100);
  });

  test('create new user is working', () async {
    bool response = await sut.createNewUser('Ahmed') > 0;
    expect(response, true);
  });

  test('updating highscore in the database', () async {
    bool response = await sut.saveNewHighScoreToDatabase(200) > 0;

    expect(response, true);
  });

  test('successfully retrived nickname from database', () async {
    await sut.getUsername();

    expect(sut.nickname, 'Ahmed');
  });

  test('successfully retrived highscore from database', () async {
    await sut.getHighScore();

    expect(sut.highScore, 200);
  });
}
