import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghibli_pal/Pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'Pages/Home.dart';
import 'Pages/Library.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;
final List<Widget> screens = [
  HomeScreen(),
  LibraryScreen(),
];

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white60, // navigation bar color
      statusBarColor: const Color.fromRGBO(245, 245, 245, 1.0), // status bar color
      statusBarBrightness: Brightness.dark,//status bar brightness
      statusBarIconBrightness:Brightness.dark , //status barIcon Brightness
      systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
      ));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // Clear when presenting demo
  debugPrint(prefs.getInt('onBoard').toString());
  isViewed = prefs.getInt('onBoard');
  runApp(
    const MyApp(), // Wrap your app
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
      ),
        home: isViewed !=0 ? OnboardingScreen() : const MyHomePage(title: "Home"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Handles screen changing from bottom navigation bar
  void _navigateBottomBar(int index){
    setState(() {
      screens.removeAt(1);                                // Refresh library on navigation
      screens.insert(1, LibraryScreen(key: GlobalKey())); // to check updated CRUD status
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
       body: IndexedStack(
         index: _selectedIndex,
         children: screens,
       ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Library'),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}




