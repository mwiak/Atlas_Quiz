import 'package:atlas_quiz/view_model/user_info_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit(); //necessary to access the database without android runtime
  databaseFactory =
      databaseFactoryFfi; //necessary to access the database without android runtime
  late UserInfoProvider sut;

  setUp(() {
    sut = UserInfoProvider();
  });

  test('initial data are correct', () {
    expect(sut.nickname, '');
    expect(sut.highScore, 0);
  });

  test('create new user and assign new high score', () async {
    await sut.createNewUser('Ahmed');
    await sut.assignNewHighScore(1000);
    await sut.getUserData();
    expect(sut.highScore, 1000);
    await sut.assignNewHighScore(900);
    expect(sut.highScore, 1000);
  });
}
