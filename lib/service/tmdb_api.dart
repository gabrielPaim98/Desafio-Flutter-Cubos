import '../model/movie_credits.dart';
import '../model/movie_details.dart';
import 'package:http/http.dart' as http;
import '../model/movie.dart';
import 'dart:convert';
import '../tmdb_key.dart';

class TmdbApi {
  TmdbApi(this.httpClient );

  http.Client httpClient;

  Future<List<Movie>> fetchPopularMovies(int page) async {
    List<Movie> movies;
    var body;
    try {
      final response =
          await httpClient.get('${TmdbConsts.popularMoviesUrl}$page');

      if (response.statusCode == 200) {
        body = jsonDecode(response.body)['results'];
        movies = List<Movie>.from(body.map((movie) => Movie.fromJson(movie)))
            .toList();
      }
    } catch (e) {
      print('error fetching popular movies: $e');
      return null;
    }
    return movies;
  }

  Future<List<Movie>> fetchMovieQuery(int page, String query) async {
    List<Movie> movies;
    var body;
    try {
      final response =
          await httpClient.get(TmdbConsts.movieQueryUrl(page, query));

      if (response.statusCode == 200) {
        body = jsonDecode(response.body)['results'];
        movies = List<Movie>.from(body.map((movie) => Movie.fromJson(movie)))
            .toList();
      }
    } catch (e) {
      print('error fetching movie query: $e');
    }
    return movies;
  }

  Future<MovieDetail> fetchMovieDetails(int id) async {
    var body;
    MovieDetail movieDetail;

    try {
      final response =
          await httpClient.get('${TmdbConsts.movieDetailsUrl(id)}');

      if (response.statusCode == 200) {
        body = jsonDecode(response.body);
        movieDetail = MovieDetail.fromJson(body);
      }
    } catch (e) {
      print('error fetching movie details: $e');
    }

    return movieDetail;
  }

  Future<MovieCredits> fetchMovieCredits(int id) async {
    var body;
    MovieCredits credits;

    try {
      final response =
          await httpClient.get('${TmdbConsts.movieCreditsUrl(id)}');

      if (response.statusCode == 200) {
        body = jsonDecode(response.body);
        credits = MovieCredits.fromJson(body);
      }
    } catch (e) {
      print('error fetching movie credits: $e');
    }

    return credits;
  }

  Future<List<Genre>> fetchGenreList() async {
    List<Genre> genres;
    var body;
    try {
      final response = await httpClient.get(TmdbConsts.genreListUrl);

      if (response.statusCode == 200) {
        body = jsonDecode(response.body)['genres'];
        genres = List<Genre>.from(body.map((genre) => Genre.fromJson(genre)))
            .toList();
      }
    } catch (e) {
      print('error fetching genreList: $e');
      return null;
    }

    return genres;
  }

  Future<List<Movie>> fetchMoviesByGenres(int page, List<int> genres) async {
    List<Movie> movies;
    var body;

    try {
      final response =
          await httpClient.get(TmdbConsts.moviesByGenresUrl(page, genres));

      if (response.statusCode == 200) {
        body = jsonDecode(response.body)['results'];
        movies = List<Movie>.from(body.map((movie) => Movie.fromJson(movie)))
            .toList();
      }
    } catch (e) {
      print('error fetching movies by genre: $e');
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
      if (i == genres.length - 1)
        pageList += '${genres[i]}';
      else
        pageList += '${genres[i]},';
    }

    return '$baseUrl/discover/movie?$apiKey&$language$page&with_genres=$pageList';
  }

  static String movieQueryUrl(int page, String query) {
    String _query = query.replaceAll(' ', '%20');

    return '$baseUrl/search/movie?$apiKey&$language&query=$_query&page=$page';
  }

  static String movieCreditsUrl(int id) =>
      '$baseUrl/movie/$id/credits?$apiKey&$language';
}
