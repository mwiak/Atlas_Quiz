import 'package:atlas_quiz/model/user_info_model.dart';
import 'package:flutter/material.dart';

//provider class for calling getting user data from UserInfoModel and delivering the data to the UI element PlayerCard
class UserInfoProvider extends ChangeNotifier {
  final UserInfoModel _userInfoModel = UserInfoModel();

  String get nickname => _userInfoModel.nickname; // getter for nickname
  int get highScore => _userInfoModel.highScore; // getter for highscore

  //method that calls UserInfoModel methods that retrieve user data from database
  Future<void> getUserData() async {
    await _userInfoModel.getUsername();
    await _userInfoModel.getHighScore();
    notifyListeners(); // notify widgets to rebuild
  }

  //method that assigns new highscore
  Future<void> assignNewHighScore(int currentScore) async {
    if (currentScore > highScore) {
      _userInfoModel.saveNewHighScoreToDatabase(currentScore);
    }
  }

  //creating user for the first time
  Future<int> createNewUser(String nickname) async {
    int response = await _userInfoModel.createNewUser(nickname);
    return response;
  }
}
