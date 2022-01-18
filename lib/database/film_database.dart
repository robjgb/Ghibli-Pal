import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ghibli_pal/Models/movie.dart';

class FilmDatabase {
  static final FilmDatabase instance = FilmDatabase._init();

  static Database? _database;

  FilmDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('films.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableFilms (
  ${FilmFields.id} $idType,
  ${FilmFields.title} $textType,
  ${FilmFields.original_title} $textType,
  ${FilmFields.original_title_romanised} $textType,
  ${FilmFields.image} $textType,
  ${FilmFields.movie_banner} $textType,
  ${FilmFields.description} $textType,
  ${FilmFields.director} $textType,
  ${FilmFields.producer} $textType,
  ${FilmFields.release_date} $textType,
  ${FilmFields.running_time} $textType,
  ${FilmFields.rt_score} $textType,
  ${FilmFields.watch_status} $textType
)
''');
  }

  Future<Movie> create (Movie movie) async {
    final db = await instance.database;


    final id = await db.insert(tableFilms, movie.toJson());
    return movie.copy(id: id);
  }

  Future<Movie> readMovie(String title) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFilms,
      columns: FilmFields.values,
      where: '${FilmFields.title} = ?',
      whereArgs: [title],
  );

    if (maps.isNotEmpty) {
      return Movie.fromJson(maps.first);
    }
    else{
      throw Exception('ID $title not found');
    }
  }

  Future<bool> checkMovie(String title) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFilms,
      columns: FilmFields.values,
      where: '${FilmFields.title} = ?',
      whereArgs: [title],
    );

    if (maps.isNotEmpty) {
      return true;
    }
    else{
      return false;
    }
  }

  Future<List<Movie>> readAllMovies() async {
    final db = await instance.database;

    final result = await db.query(tableFilms);
    return result.map((json) => Movie.fromJson(json)).toList();
  }

  Future<int> update(Movie movie) async {
    final db = await instance.database;

    return db.update(
      tableFilms,
      movie.toJson(),
      where: '${FilmFields.id} = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> delete(int id) async{
    final db = await instance.database;

    return await db.delete(
      tableFilms,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async{
    final db = await instance.database;

    return await db.delete(
      tableFilms
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}