class Movie {
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

  const Movie({
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
  });

  factory Movie.fromJson(Map<String, dynamic> json){
    return Movie(
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
    );
  }
}