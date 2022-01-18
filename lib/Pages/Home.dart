import 'package:flutter/material.dart';
import '../Models/movie.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ghibli_pal/Widgets/search_widget.dart';
import 'package:ghibli_pal/Pages/film_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:ghibli_pal/database/film_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
          margin: EdgeInsets.only(top:25.h),
          height: 50.h,
          width: 285.w,
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
        width: 350.w,
        alignment: Alignment.bottomCenter,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            (movies.isNotEmpty && _focusedIndex <= movies.length)
                ? movies[_focusedIndex].title
                : "",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30.sp,
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
              height: 40.h,
              child: Text(
                (movies.isNotEmpty && _focusedIndex <= movies.length)
                    ? "About \n"
                    : "",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 120.h,
              width: 325.w,
              child: SingleChildScrollView(
                child: Text(
                  (movies.isNotEmpty && _focusedIndex <= movies.length)
                      ? movies[_focusedIndex].description
                      : "",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
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
    return Container(
      width: 200.w,
      alignment: Alignment.center,
      child: Stack(
        children: [
            Container(
              height: 300.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(movies[index].image),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(40.r),
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
              ),
          Container(
            height: 300.h,
            child: Material(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0.r),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(40.0.r),
                onTap: () {
                  sslKey.currentState!.focusToItem(index);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilmDetailPage(movies[index])));
                },
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
                          itemSize: 200.w,
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
      if (snapshot.hasError){
        debugPrint('${snapshot.error}');
        return const Center(
          child: Text('An error has occurred, please restart the application.'),
        );
      }
      else if (snapshot.hasData){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 25.h),
              child: ElevatedButton.icon(
                onPressed: (){
                  addOrRemoveFilm();
                },
                label: !snapshot.data!? Text('Add to library'): Text('Remove from library'),
                icon:  !snapshot.data!? Icon(Icons.add): Icon(Icons.delete),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(245, 245, 245, 1.0),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 25.h, left: 10.w),
              child: snapshot.data!? ElevatedButton.icon(
                onPressed: (){
                  _setFilmStatus();
                },
                label: Text('Edit status'),
                icon:  Icon(Icons.edit),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(245, 245, 245, 1.0),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                  ),
                ),
              ) : Container(),
            ),
          ],
        );
      }
      else{
            return const Center(
            child: CircularProgressIndicator(),
      );
      }
    }
    );
  }

  Future<void> _setFilmStatus() async {
    final movie = await FilmDatabase.instance.readMovie(movies[_focusedIndex].title);

    switch (await showDialog<Movie>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select film watching status'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  movie.watch_status = 'Watching';
                  await FilmDatabase.instance.update(movie);
                  Navigator.pop(context); },
                child: const Text('Watching'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  movie.watch_status = 'Watch Later';
                  await FilmDatabase.instance.update(movie);
                  Navigator.pop(context); },
                child: const Text('Watch Later'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  movie.watch_status = 'Dropped';
                  await FilmDatabase.instance.update(movie);
                  Navigator.pop(context); },
                child: const Text('Dropped'),
              ),
            ],
          );
        }
    )) {
      case null:
      // dialog dismissed
        break;
    }
  }

}

