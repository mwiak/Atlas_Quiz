import 'package:atlas_quiz/view_model/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas_quiz/view/screens/home_page.dart';
import 'package:atlas_quiz/view_model/play_screen_provider.dart';
import 'package:atlas_quiz/model/sqflite.dart';

// the page where user will be directed to register nickname if he hadn't done before
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nicknameC =
      TextEditingController(); // to save user input in the TextField widget
  late UserInfoProvider userInfoProvider; // reference to provider class

  //method that contains saving nickname logic
  Future<void> saveUserData() async {
    String nickname = nicknameC.text.trim(); // trim the input from spacings
    int response = await userInfoProvider
        .createNewUser(nickname); // saving user entry in the database

    if (response >
        0) // if response is greater than 0 thats indicates a successful SQL inserting command
    {
      Navigator.of(context).pushReplacement(
        // redirect user to the main menu
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {}
  }

  // checks if user input is not empty
  void validateSave() {
    if (nicknameC.text != '') {
      saveUserData(); // calls saving logic
    }
  }

  @override
  void didChangeDependencies() {
    userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nicknameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('What should we call you?'),
              TextField(
                controller: nicknameC,
                decoration: InputDecoration(
                    label: const Text('Nickname'),
                    focusColor: Colors.greenAccent[200],
                    suffixIcon: IconButton(
                        onPressed: () {
                          validateSave();
                        },
                        icon: const Icon(Icons.arrow_circle_right_outlined))),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
