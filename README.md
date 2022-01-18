# Ghibli Pal

A Studio Ghibli companion app made in Flutter

## Wireframes
<img src="Digital Wireframe.png" width=600>


## User Stories: 
**MVP Stories**
- User can view a list of Studio Ghibli films.
- Films are clickable to see details about each film.
- Search bar to easily find films.

**Optional Stories**
- Modern UI design. 
- Library to store films.
- Filter library by watch status. 
- CRUD functionalities:
  - Create a readable film using the Movie model and store in SQLite database. 
  - Multiselect mode in grid view.
  - Update watch status: (Watching, Watch Later, Dropped).
  - Delete film.


## Schema 
### Movie Model
| Property  | Type | Description |
| ------------- | ------------- | -------------|
| id | int  | unique id for each film when storing in database |
| title | String  | unique title of each film |
| original_title | String  | title of each film in original Japanese language |
| original_title_romanised | String  | Romanised title of each film's original Japanese title |
| image  | String  | Unique url link to an film poster image |
| movie_banner  | String  | Unique url link to a background film banner image |
| description  | String  | Unique url link to an film poster image |
| director  | String  | Film director(s) |
| producer  | String  | Film producer(s) |
| release_date  | String  | Film year of release |
| running_time  | String  | Film run time/ length formatted in minutes|
| rt_score  | String  | Rotten Tomatoes film rating percentage |
| watch_status  | String  | Current watch status set as either one of three 'Watching', 'Watch Later', 'Dropped' |


### Networking
- Home Screen
  - (HTTP GET) Query list of movies:
     ```swift
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
     ```


