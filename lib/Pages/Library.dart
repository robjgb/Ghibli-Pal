import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:ghibli_pal/database/film_database.dart';
import '../Models/movie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ghibli_pal/main.dart';
import 'Home.dart';
import 'film_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  String dropdownValue = '';
  HashSet selectedItem = new HashSet();
  bool multipleSelectEnabled = false;
  List<int> selectedMoviesIndexes = [];
  bool itemsChosen = false;

  // Initialize with refreshed movies in database
  @override
  void initState() {
    super.initState();
    refreshMovies();
  }

  // Handle setState errors to prevent memory leak on navigation bar change
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  // Movie initialization for when filtering the movies with watch status
  setMovies() {
    if (movieInit == false) {
      movies = allMovies;
      movieInit = true;
    }
  }

  // Refresh movie from database
  Future refreshMovies() async {
    setState(() => isLoading = true);
    this.allMovies = await FilmDatabase.instance.readAllMovies();
    setMovies();
    setState(() => isLoading = false);
  }

  // Empty view when no films are found
  Widget _buildEmptyView() {
    return Container(
      padding: EdgeInsets.only(bottom: 120.h, left: 20.w, right: 20.w),
      child: Center(
        child: Text(
          'No films added,\n Add films in the home page \n'
              'by clicking on the add to library button.',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20.sp,
              )
          ),
        ),
      ),
    );
  }

  // Library header with filter button
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 30.w, top: 50.h),
            alignment: Alignment.centerLeft,
            child: Text('My Library',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                  )
              ),
            ),
          ),
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 30.w, top: 50.h),
            alignment: Alignment.centerRight,
            child: Material(
              child: InkWell(
                onTap: () {},
                child: DropdownButton(
                  hint: Text('Filter films: ',
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  underline: Container(),
                  icon: const Icon(Icons.filter_list),
                  iconSize: 36.w,
                  iconEnabledColor: Colors.black,
                  items: <String>[
                    'Watching',
                    'Watch Later',
                    'Dropped',
                    'All Films'
                  ]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    dropdownValue = newValue!;
                    if (dropdownValue == 'All Films') {
                      allMovies = await FilmDatabase.instance.readAllMovies();
                      movies = allMovies;
                      setState(() {
                        selectedMoviesIndexes.clear();
                        this.movies = movies;
                      });
                    }
                    else {
                      filterFilm(dropdownValue);
                    };
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Filter film function based on watch status
  Future<void> filterFilm(String status) async {
    allMovies = await FilmDatabase.instance.readAllMovies();
    movies = allMovies.where((movie) {
      final watchStatus = movie.watch_status;
      return watchStatus!.contains(status);
    }).toList();
    setState(() {
      selectedMoviesIndexes.clear();
      this.movies = movies;
    });
  }

  // Enable multiple select mode for CRUD functionalities
  void multipleSelect(int index) {
    if (multipleSelectEnabled) {
      setState(() {
        if (selectedItem.contains(movies[index])) {
          selectedItem.remove(movies[index]);
          selectedMoviesIndexes.remove(index);
        }
        else {
          selectedItem.add(movies[index]);
          selectedMoviesIndexes.add(index);
        }
      });
    }
    else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FilmDetailPage(movies[index])));
    }
  }

  // Create grid view of movies
  Widget buildMovieGrid() {
    return
      GridView.builder(
          itemCount: movies.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 130.w,
            crossAxisSpacing: 15.h,
            mainAxisSpacing: 15.w,
          ),
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          itemBuilder: (context, index) {
            return GridTile(
              child: InkWell(
                onTap: () {
                  multipleSelect(index);
                },
                onLongPress: () {
                  if (!multipleSelectEnabled) {
                    multipleSelectEnabled = true;
                    multipleSelect(index);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                    Text(movies[index].title),
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(selectedItem.contains(
                                    movies[index]) ? 0.75 : 0),
                                BlendMode.color),
                            image: NetworkImage(movies[index].image),
                            fit: BoxFit.fill,
                          )
                      ),
                    ),
                    Visibility(
                      visible: selectedItem.contains(movies[index]),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30.w,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      );
  }

  // Handle changing amounts of films selected
  getSelectedCountText() {
    return selectedItem.isNotEmpty ? selectedItem.length.toString() +
        ' films selected' : 'Select films';
  }

  // Edit film status function
  Future _setFilmStatus(String status) async {
    debugPrint('----------------');
    for (int i = 0; i < selectedMoviesIndexes.length; i++) {
      String title = movies[selectedMoviesIndexes[i]].title;
      debugPrint(title);
      debugPrint("Initial count: "+selectedMoviesIndexes.toString());
      Movie movie = await FilmDatabase.instance.readMovie(title);
      movie.watch_status = status;
      await FilmDatabase.instance.update(movie);
    }
    movies = await FilmDatabase.instance.readAllMovies();
    debugPrint("Finished");
    setState(() {
      multipleSelectEnabled = false;
      selectedItem.clear();
      selectedMoviesIndexes.clear();
      this.movies = movies;
      debugPrint("NewCount: "+ selectedMoviesIndexes.toString());
    });
  }

  // Edit watch status dialog with options to change
  Future editMovies() async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select film watching status'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  String watch_status = 'Watching';
                  _setFilmStatus(watch_status);
                  Navigator.pop(context); },
                child: const Text('Watching'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  String watch_status = 'Watch Later';
                  _setFilmStatus(watch_status);
                  Navigator.pop(context); },
                child: const Text('Watch Later'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  String watch_status = 'Dropped';
                  _setFilmStatus(watch_status);
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

  // Delete currently selected movies
  Future deleteMovies() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Deleting selected film(s)'),
        content: const Text('Are you sure you want to delete the selected film(s)'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              debugPrint('----------------');
              for (int i = 0; i < selectedMoviesIndexes.length; i++) {
                String title = movies[selectedMoviesIndexes[i]].title;
                debugPrint(title);
                debugPrint("Initial count: "+selectedMoviesIndexes.toString());
                Movie movie = await FilmDatabase.instance.readMovie(title);
                final int? id = movie.id;
                await FilmDatabase.instance.delete(id!);
              }
              movies = await FilmDatabase.instance.readAllMovies();
              debugPrint("Finished");
              setState(() {
                multipleSelectEnabled = false;
                selectedItem.clear();
                selectedMoviesIndexes.clear();
                this.movies = movies;
                debugPrint("NewCount: "+ selectedMoviesIndexes.toString());
                screens.removeAt(0);
                screens.insert(0, HomeScreen(key: GlobalKey()));
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  // Root scaffold, handle enable or disable appbar, expanded containers of each widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: multipleSelectEnabled ? AppBar(
        toolbarHeight: 75.h,
        leadingWidth: 50.w,
        leading: IconButton(
          icon: Icon(Icons.close, size: 30.w),
          onPressed: () {
            setState(() {
              multipleSelectEnabled = false;
              selectedItem.clear();
            });
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(getSelectedCountText(), style: TextStyle(fontSize: 16.sp)),
        actions: [
          IconButton(
            onPressed: () {
              if (selectedItem.length == movies.length) {
                setState(() {
                  selectedItem.clear();
                  selectedMoviesIndexes.clear();
                });
              }
              else {
                setState(() {
                  selectedMoviesIndexes.clear();
                });
                for (int i = 0; i < movies.length; i++) {
                  setState(() {
                    selectedItem.add(movies[i]);
                    selectedMoviesIndexes.add(i);
                  });
                }
              }
            },
            icon: Icon(
              Icons.select_all,
              color: (selectedItem.length == movies.length)
                  ? Colors.grey
                  : Colors.black,
              size: 30.w,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 5.w),),
          IconButton(
            onPressed: () {
              if(selectedItem.isNotEmpty){
                editMovies();
              }
            },
            icon: Icon(
              Icons.edit,
              color: (selectedItem.isNotEmpty) ? Colors.black : Colors.grey,
              size: 30.w,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 5.w),),
          IconButton(
            onPressed: () {
              if(selectedItem.isNotEmpty){
                deleteMovies();
              }
            },
            icon: Icon(
              Icons.delete,
              color: (selectedItem.isNotEmpty) ? Colors.black : Colors.grey,
              size: 30.w,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 25.w),)
        ],
      ) : null,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !multipleSelectEnabled ?
            Expanded(flex: 20, child: _buildHeader()) : Container(),
            isLoading ?
            Expanded(
                flex: 80, child: Center(child: CircularProgressIndicator()))
                : movies.isEmpty ?
            Expanded(flex: 80, child: _buildEmptyView())
                : Expanded(flex: 80, child: buildMovieGrid()),
          ],
        ),
      ),
    );
  }
}

