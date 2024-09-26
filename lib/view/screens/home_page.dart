import 'package:atlas_quiz/view_model/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas_quiz/view_model/play_screen_provider.dart';
import 'play_menu.dart';
import '../../model/sqflite.dart';
import '../widgets/reusable.dart';

// home screen widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SqlDb databaseManager = SqlDb();

  late PlayScreenProvider provider;
  late UserInfoProvider userInfoProvider;
  late String nickname;
  late int highScore;

  /* assign providers value in this overridden method since its called everytime the widget dependencies change.
   yet it is not the perfect place for doing this but the initState method can't access the context parameter since it is only ready when the widget built  */

  @override
  void didChangeDependencies() {
    provider = Provider.of<PlayScreenProvider>(context);
    userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    userInfoProvider.getUserData();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Consumer<UserInfoProvider>(
                  builder: (BuildContext context, provider, child) {
                    return PlayerCard(
                      nickName: userInfoProvider.nickname,
                      highScore: userInfoProvider.highScore,
                    );
                  },
                ),
                const SizedBox(
                  height: 180,
                ),
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/Earth.png"),
                        fit: BoxFit.fill,
                      )),
                  width: 150,
                  height: 150,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    shape: const CircleBorder(),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        // navigate to the play screen
                        MaterialPageRoute(
                            builder: (context) => const PlayScreen()),
                      );
                    },
                    child: const Icon(
                      Icons.play_arrow,
                      size: 100,
                      color: Color(0xFFD3D3D3),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Play',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
