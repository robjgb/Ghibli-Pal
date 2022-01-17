import 'package:flutter/material.dart';
import 'package:ghibli_pal/database/film_database.dart';
import '../movie.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late List<Movie> allMovies;
  late List<Movie> movies;
  bool movieInit = false;
  bool isLoading = false;
  String dropdownValue = 'One';

  @override
  void initState() {
    super.initState();

    refreshMovies();
  }

  setMovies() {
    if (movieInit == false){
      movies = allMovies;
      movieInit = true;
    }
  }

  Future refreshMovies() async {
    setState(() => isLoading = true);
    this.allMovies = await FilmDatabase.instance.readAllMovies();
    setMovies();
    setState(() => isLoading = false);
  }

  Widget _buildEmptyView(){
    return Container(
      padding: EdgeInsets.only(bottom:120, left: 20, right: 20),
      child: Center(
        child: Text(
          'No films added,\n Add films in the home page \n'
              'by clicking on the add to library button.',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              )
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 30, top: 50),
              alignment: Alignment.centerLeft,
              child: Text('My Library',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                              )
                          ),
                    ),
              ),
    ),

        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 30, top: 50),
            alignment: Alignment.centerRight,
            child: DropdownButton(
              underline: Container(),
              icon: const Icon(Icons.filter_list), iconSize: 36,
              iconEnabledColor: Colors.black,
              items: <String>['Watching', 'Watch Later', 'Dropped', 'All Films']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
                onChanged: (String? newValue) {
                dropdownValue = newValue!;
                if (dropdownValue == 'All Films'){
                  setState(() {
                    movies = allMovies;
                  });
                  }
                else{
                  filterFilm(dropdownValue);
                  };
               },
            ),
          ),
        ),
      ],
    );
  }

  void filterFilm(String status) {
    movies = allMovies.where((movie) {
      final watchStatus = movie.watch_status;
      return watchStatus!.contains(status);
    }).toList();
    setState(() {
      movies = movies;
    });
  }

  Widget buildMovieGrid() {
    return
        GridView.builder(
            itemCount: movies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 130,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
            ),
            padding: EdgeInsets.all(30),
            itemBuilder: (context, index) {
                return Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(movies[index].image),
                            fit: BoxFit.fill,
                          )
                      ),
              );
            }
        );
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 20, child: _buildHeader()),
          isLoading ?
          Expanded(flex:80, child: Center(child: CircularProgressIndicator()))
          : movies.isEmpty ?
          Expanded(flex: 80,child: _buildEmptyView())
          : Expanded(flex:80, child: buildMovieGrid()),
        ],
      ),
    );
  }
}

