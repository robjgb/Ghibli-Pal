import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Welcome to \n Ghibli Pal!',
              body: 'An unofficial Studio Ghibli Companion app to learn more about Studio Ghibli\u0027s beautiful films.',
              image: buildImage('assets/StudioGhibliLogo.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Track your favorite Ghibli films',
              body: 'Keep track of your favorite films and save them as a list as you watch them.',
              image: buildImage('assets/GhibliBanner.jpg'),
              decoration: getPageDecoration(),
            ),
          ],
          done: const Text('Get Started',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
          ),
          onDone: () {
            _storeOnboardInfo();
            goToHome(context);
          } ,
          showNextButton: false,
        ),
      );

  buildImage(String path) {
    return SizedBox(
      width: 300,
      height: 200,
      child:
      Image(
        image: AssetImage(path),
      ),
    );
  }

  PageDecoration getPageDecoration() => const PageDecoration(
        titleTextStyle:
          TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
          ),

        bodyTextStyle:
          TextStyle(
              fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
          ),
      pageColor: Color.fromRGBO(245, 245, 245, 1.0),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home Page',))
  );

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

}