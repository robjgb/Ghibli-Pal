final String tableFilms = 'films';

class FilmFields{
  static final List<String> values = [
    id, title, original_title, original_title_romanised, image, movie_banner, description, director, producer, release_date, running_time, rt_score, watch_status
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String original_title = 'original_title';
  static final String original_title_romanised = 'original_title_romanised';
  static final String image = 'image';
  static final String movie_banner = 'movie_banner';
  static final String description = 'description';
  static final String director = 'director';
  static final String producer = 'producer';
  static final String release_date = 'release_date';
  static final String running_time = 'running_time';
  static final String rt_score = 'rt_score';
  static final String watch_status = 'watch_status';
}

class Movie {
  final int? id;
  final String title;
  final String original_title;
  final String original_title_romanised;
  final String image;
  final String movie_banner;
  final String description;
  final String director;
  final String producer;
  final String release_date;
  final String running_time;
  final String rt_score;
  late  String? watch_status;

   Movie({
    this.id,
    required this.title,
    required this.original_title,
    required this.original_title_romanised,
    required this.image,
    required this.movie_banner,
    required this.description,
    required this.director,
    required this.producer,
    required this.release_date,
    required this.running_time,
    required this.rt_score,
    this.watch_status,
  });

  factory Movie.fromJson(Map<String, dynamic> json){
    return Movie(
      id: json[FilmFields.id] as int?,
      title: json['title'] as String,
      original_title: json['original_title'] as String,
      original_title_romanised: json['original_title_romanised'] as String,
      image: json['image'] as String,
      movie_banner: json['movie_banner'] as String,
      description: json['description'] as String,
      director: json['director'] as String,
      producer: json['producer'] as String,
      release_date: json['release_date'] as String,
      running_time: json['running_time'] as String,
      rt_score: json['rt_score'] as String,
      watch_status: json['watch_status'] as String?,
    );
  }

  
  
  Map<String, Object?> toJson() => {
      FilmFields.id: id,
      FilmFields.title: title,
      FilmFields.original_title: original_title,
      FilmFields.original_title_romanised: original_title_romanised,
      FilmFields.image: image,
      FilmFields.movie_banner: movie_banner,
      FilmFields.description: description,
      FilmFields.director: director,
      FilmFields.producer: producer,
      FilmFields.release_date: release_date,
      FilmFields.running_time: running_time,
      FilmFields.rt_score: rt_score,
      FilmFields.watch_status: watch_status,
  };

  Movie copy({
  int? id,
  String? title,
  String? original_title,
  String? original_title_romanised,
  String? image,
  String? movie_banner,
  String? description,
  String? director,
  String? producer,
  String? release_date,
  String? running_time,
  String? rt_score,
  String? watch_status,
  }) =>
      Movie(
          id: id ?? this.id,
          title: title ?? this.title,
          original_title: original_title ?? this.original_title,
          original_title_romanised: original_title_romanised ?? this.original_title_romanised,
          image: image ?? this.image,
          movie_banner: movie_banner ?? this.movie_banner,
          description: description ?? this.description,
          director: director ?? this.director,
          producer: producer ?? this.producer,
          release_date: release_date ?? this.release_date,
          running_time: running_time ?? this.running_time,
          rt_score: rt_score ?? this.rt_score,
          watch_status: watch_status ?? this.watch_status,
      );


}