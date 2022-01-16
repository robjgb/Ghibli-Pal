import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:ghibli_pal/Widgets/search_widget.dart';
import 'package:ghibli_pal/film_detail.dart';
import 'package:ghibli_pal/onboarding_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

int? isViewed;

Future<List<Movie>> fetchMovies(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://ghibliapi.herokuapp.com/films'));

  // Use the compute function to run parseMovies in a separate isolate.
  return compute(parseMovies, response.body);
}

// Function converts a response body into a List<Movie>.
List<Movie> parseMovies(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // Clear when presenting demo
  debugPrint(prefs.getInt('onBoard').toString());
  isViewed = prefs.getInt('onBoard');
  runApp(
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) =>
        const MyApp(), // Wrap your app
      // ),
   );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
    ),
      home: isViewed !=0 ? OnboardingScreen() : const MyHomePage(title: "Home"),
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
  int _focusedIndex = 0;
  List<Movie> allMovies = <Movie>[];
  List<Movie> movies = <Movie>[];
  String query = '';
  bool movieInit = false;

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  setMovies() {
    if (movieInit == false){
      movies = allMovies;
      movieInit = true;
    }
  }

  Widget buildSearchBar() {
    return Expanded(
        flex: 4,
        child: Container(
          margin: const EdgeInsets.only(top:25),
          width: 300,
          child: SearchWidget(
            text: query,
            hintText: 'Search Film Name...',
            onChanged: searchFilm,
          ),
        )
    );
  }

  void searchFilm(String query) {
      movies = allMovies.where((movie) {
      final titleLower = movie.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();
      setState(() {
      this.query = query;
      movies = movies;
    });
  }

  Widget _buildItemTitle(){
    if (_focusedIndex > movies.length){
      return Expanded(flex: 2, child: Container(width:350));
    }

    return Expanded(
      flex: 2,
      child: Container(
        width: 350,
        alignment: Alignment.bottomCenter,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            (movies.isNotEmpty && _focusedIndex <= movies.length)
                ? movies[_focusedIndex].title
                : "",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetail() {
    if (_focusedIndex > movies.length){
      return const Expanded(flex: 10, child: SizedBox(height:250,width:300));
    }
      return Expanded(
        flex: 10,
        child: SizedBox(
          height: 250,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(
                 height: 40,
                 child: Text(
                   (movies.isNotEmpty && _focusedIndex <= movies.length)
                   ? "About \n"
                   : "",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
              ),
               ),
              SizedBox(
                height: 150.0,
                width: 300.0,
                child: SingleChildScrollView(
                  child: Text(
                    (movies.isNotEmpty && _focusedIndex <= movies.length)
                    ? movies[_focusedIndex].description
                    : "",
                    style: GoogleFonts.montserrat(
                     textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                     ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildItemList(BuildContext context, int index){
    if(index > movies.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilmDetailPage(movies[index])));
              },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movies[index].image),
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: <BoxShadow>[
                   BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(-6, -6),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade500,
                    offset: const Offset(6, 6),
                    blurRadius: 16,
                  ),
                ],
              ),
              width: 250,
              height: 285,
            ),
          ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
      body: Container(
        child: FutureBuilder<List<Movie>>(
          future: fetchMovies(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError){
              debugPrint('${snapshot.error}');
              return const Center(
                child: Text('An error has occurred'),
              );
            }
            else if (snapshot.hasData) {
              allMovies = snapshot.data!;
              setMovies();
            return Container(
                  child: Column(
                    children: [
                      buildSearchBar(),
                       _buildItemTitle(),
                      Expanded(
                        flex: 15,
                        child: ScrollSnapList(
                          itemCount: movies.length,
                          onItemFocus: _onItemFocus,
                          itemBuilder: _buildItemList,
                          itemSize: 200,
                          dynamicItemSize: true,
                        ),
                      ),
                       _buildItemDetail(),
                    ],
                  ),
                );
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          ),
      ),
    );
  }
}




