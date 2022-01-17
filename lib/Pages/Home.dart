import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ghibli_pal/main.dart';
import '../movie.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ghibli_pal/Widgets/search_widget.dart';
import 'package:ghibli_pal/film_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:ghibli_pal/database/film_database.dart';

import 'Library.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _focusedIndex = 0;
  List<Movie> allMovies = <Movie>[];
  List<Movie> movies = <Movie>[];
  String query = '';
  bool movieInit = false;
  GlobalKey<ScrollSnapListState> sslKey = GlobalKey();
  late List<Movie> moviesDB;
  bool doesExist = false;

  void initState()  {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      print("SchedulerBinding");
    });
  }

  _onItemFocus(int index) async {
    doesExist = await FilmDatabase.instance.checkMovie(movies[index].title);
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
    return Container(
          margin: const EdgeInsets.only(top:25),
          width: 300,
          child: SearchWidget(
            text: query,
            hintText: 'Search Film Name...',
            onChanged: searchFilm,
          ),
        );
  }

  void searchFilm(String query) {
    _focusedIndex = 0;
    sslKey.currentState!.focusToItem(_focusedIndex);
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

  // Movie Title
  Widget _buildItemTitle(){
    return Container(
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
    );
  }

  // Movie description
  Widget _buildItemDetail() {
    return Container(
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
              height: 120,
              width: 325,
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
    );
  }

  // Build each individual list item
  Widget _buildItemList(BuildContext context, int index){
    if(index == movies.length) {
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
                sslKey.currentState!.focusToItem(index);
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

  // Future Builder waits for http request, builds the horizontal scrollable list if no error
  @override
  Widget build(BuildContext context) {

    return Container(
        child: FutureBuilder<List<Movie>>(
          future: fetchMovies(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError){
              debugPrint('${snapshot.error}');
              return const Center(
                child: Text('An error has occurred, please restart the application.'),
              );
            }
            else if (snapshot.hasData) {
              allMovies = snapshot.data!;
              setMovies();
            return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 12,child: buildSearchBar()),
                      Expanded(flex: 5, child: _buildItemTitle()),
                      Expanded(
                        flex: 40,
                        child: ScrollSnapList(
                          key: sslKey,
                          itemCount: movies.length,
                          onItemFocus: _onItemFocus,
                          itemBuilder: _buildItemList,
                          itemSize: 200,
                          dynamicItemSize: true,
                        ),
                      ),
                       Expanded(flex: 20, child: _buildItemDetail()),
                    Expanded(flex: 10, child: _buildLibraryButton()),
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
    );
  }

  void addOrRemoveFilm() async {
    await checkExists();

    if (doesExist == false){
      addFilm();
      debugPrint("Added");
    }
    else{
      removeFilm();
      debugPrint("Removed");
    }
  }

  Future addFilm() async {
   final movie = movies[_focusedIndex];
   movie.watch_status = "Watching";
   await FilmDatabase.instance.create(movie);
  }

  Future removeFilm() async{
    String title = movies[_focusedIndex].title;
    Movie movie = await FilmDatabase.instance.readMovie(title);
    final int? id = movie.id;
    await FilmDatabase.instance.delete(id!);
  }

  Future removeAllFilms() async{
    await FilmDatabase.instance.deleteAll();
  }

  Future checkExists() async{
    doesExist = await FilmDatabase.instance.checkMovie(movies[_focusedIndex].title);
    setState(() {
      this.doesExist = doesExist;
    });
  }

  Future<bool> checkExistsFuture() async{
    bool result =  await FilmDatabase.instance.checkMovie(movies[_focusedIndex].title);
    return result;
  }

  late String buttonLabel;

Widget _buildLibraryButton()  {
  return FutureBuilder<bool>(
    future: checkExistsFuture(),
    initialData: false,
    builder: (context, snapshot){
      if (snapshot.data!){
        buttonLabel = 'Remove from library';
      }
      else{
        buttonLabel = 'Add to library';
      }
      return SizedBox(
        child: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(bottom: 25, right: 40),
          child: ElevatedButton.icon(
            onPressed: (){
              addOrRemoveFilm();
            },
            label: Text(buttonLabel),
            icon:  !snapshot.data!? Icon(Icons.add): Icon(Icons.delete),
            style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(245, 245, 245, 1.0),
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
        ),
      );
    }

    );
  }

}

