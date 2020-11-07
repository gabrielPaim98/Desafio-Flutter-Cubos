import '../model/actor.dart';
import '../model/movie_details.dart';
import 'package:http/http.dart' as http;
import '../model/movie.dart';
import 'dart:convert';
import '../tmdb_key.dart';

class TmdbApi {
  TmdbApi(this.httpClient);

  http.Client httpClient;

  Future<List<Movie>> fetchPopularMovies(int page) async {
    List<Movie> movies;
    var body;
    final response =
        await httpClient.get('${TmdbConsts.popularMoviesUrl}$page');

    if (response.statusCode == 200) {
      body = jsonDecode(response.body)['results'];
      movies =
          List<Movie>.from(body.map((movie) => Movie.fromJson(movie))).toList();
    }
    return movies;
  }

  Future<MovieDetail> fetchMovieDetails(int id) async {
    var body;
    MovieDetail movieDetail;
    final response = await httpClient.get('${TmdbConsts.movieDetailsUrl(id)}');

    if (response.statusCode == 200) {
      body = jsonDecode(response.body);
      movieDetail = MovieDetail.fromJson(body);
    }

    return movieDetail;
  }

  Future<List<Actor>> fetchActors(int id) async {
    var body;
    List<Actor> actors;

    final response = await httpClient.get('${TmdbConsts.movieActorsUrl(id)}');

    if (response.statusCode == 200) {
      body = jsonDecode(response.body)['cast'];
      actors =
          List<Actor>.from(body.map((actor) => Actor.fromJson(actor))).toList();
    }

    return actors;
  }

  Future<List<Genre>> fetchGenreList() async {
    List<Genre> genres;
    var body;
    final response = await httpClient.get(TmdbConsts.genreListUrl);

    if (response.statusCode == 200) {
      body = jsonDecode(response.body)['genres'];
      genres =
          List<Genre>.from(body.map((genre) => Genre.fromJson(genre))).toList();
    }

    return genres;
  }

  Future<List<Movie>> fetchMoviesByGenres(int page, List<int> genres) async {
    List<Movie> movies;
    var body;
    final response =
        await httpClient.get(TmdbConsts.moviesByGenresUrl(page, genres));

    if (response.statusCode == 200) {
      body = jsonDecode(response.body)['results'];
      movies =
          List<Movie>.from(body.map((movie) => Movie.fromJson(movie))).toList();
    }

    return movies;
  }
}

class TmdbConsts {
  static const apiKey = 'api_key=$key';

  static const pt_br = 'pt-BR';
  static const language = 'language=$pt_br';

  static const imagePath = 'https://image.tmdb.org/t/p/w500/';
  static const imagePathOriginal = 'https://image.tmdb.org/t/p/original';
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const page = '&page=';

  static const popularMoviesUrl =
      '$baseUrl/movie/popular?$apiKey&$language$page';
  static const genreListUrl = '$baseUrl/genre/movie/list?$apiKey&$language';

  static String movieDetailsUrl(int id) =>
      '$baseUrl/movie/$id?$apiKey&$language';

  static String moviesByGenresUrl(int page, List<int> genres) {
    String pageList = '';
    for (int i = 0; i < genres.length; i++) {
      if (i == genres.length - 1) pageList += '${genres[i]}';
      else pageList += '${genres[i]},';
    }

    return '$baseUrl/discover/movie?$apiKey&$language$page&with_genres=$pageList';
  }

  static String movieActorsUrl(int id) =>
      '$baseUrl/movie/$id/credits?$apiKey&$language';
}
