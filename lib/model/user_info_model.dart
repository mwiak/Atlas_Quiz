import 'dart:developer';

import 'package:atlas_quiz/model/sqflite.dart';

//the class responsible of storing, updating user nickname and high score
class UserInfoModel {
  SqlDb dataHelper = SqlDb(); //instance of database helper object
  String _nickname = '';
  int _highScore = 0;

  String get nickname => _nickname;
  int get highScore => _highScore;

  void setUsername(String newName) {
    _nickname = newName;
  }

  void setHighScore(int newScore) {
    _highScore = newScore;
  }

  // this method creates a new user entry with nickname provided from user input coming from Registration screen
  Future<int> createNewUser(String nickname) async {
    int response = await dataHelper.insertData(
        ''' INSERT INTO user (nickname, high_score) VALUES ('$nickname', 0 )''');

    return response; // the response will be 0 in case the SQL command has not been preformed successfully and will return the primary key of row if the operation was successful
  }

  Future<void> getUsername() async {
    List data = await dataHelper.readData(
        '''SELECT * FROM user WHERE id = 1 '''); // read method from the package Sqflite returns a List<Map<String,dynamic>> by default
    String retrievedName = data[0]['nickname'] ?? '';
    setUsername(retrievedName);
  }

  Future<void> getHighScore() async {
    List data =
        await dataHelper.readData('''SELECT * FROM user WHERE id = 1''');
    int retrievedScore = data[0]['high_score'] ?? 0;
    setHighScore(retrievedScore);
  }

  Future<int> saveNewHighScoreToDatabase(int newHighScore) async {
    int response = await dataHelper.updateData(
        '''UPDATE user SET high_score = $newHighScore WHERE id = 1  ''');
    setHighScore(newHighScore);
    return response;
  }
}
