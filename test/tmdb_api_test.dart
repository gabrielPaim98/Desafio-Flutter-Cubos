import 'dart:io';

import '../lib/model/movie_credits.dart';
import '../lib/model/movie_details.dart';
import '../lib/model/movie.dart';
import '../lib/service/tmdb_api.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main(){
  group('Tmdb Service', () {
    test('should successfully fetch popular movies and return a list of movies', () async{
      final popMoviesResponse = new File('test/fixtures/pop_movies.json');
      final client = MockClient();
      when(client.get('${TmdbConsts.popularMoviesUrl}1')).thenAnswer((_) async => http.Response(popMoviesResponse.readAsStringSync(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      List<Movie> movies = await TmdbApi(client).fetchPopularMovies(1);

      expect(movies, isA<List<Movie>>());
      expect(movies, hasLength(greaterThan(0)));
    });

    test('should return null when something goes wrong during the fetch movie list process', () async {
      final client = MockClient();
      when(client.get('${TmdbConsts.popularMoviesUrl}1')).thenAnswer((_) async => http.Response('Something went wrong', 500));

      List<Movie> movies = await TmdbApi(client).fetchPopularMovies(1);

      expect(movies, isNull);
    });

    test('should successfully fetch and return the given movie details', () async{
      final movieDetailsResponse = new File('test/fixtures/movie_details.json');
      final client = MockClient();
      when(client.get(TmdbConsts.movieDetailsUrl(1))).thenAnswer((_) async => http.Response(movieDetailsResponse.readAsStringSync(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      MovieDetail movieDetail = await TmdbApi(client).fetchMovieDetails(1);

      expect(movieDetail, isA<MovieDetail>());
      expect(movieDetail, isNotNull);
    });

    test('should return null when something goes wrong during the fetch movie details process', () async {
      final client = MockClient();
      when(client.get(TmdbConsts.movieDetailsUrl(1))).thenAnswer((_) async => http.Response('Something went wrong', 500));

      MovieDetail movieDetail = await TmdbApi(client).fetchMovieDetails(1);

      expect(movieDetail, isNull);
    });

    test('should successfully fetch and return the given movie credits', () async{
      final movieCreditsResponse = new File('test/fixtures/movie_credits.json');
      final client = MockClient();
      when(client.get(TmdbConsts.movieCreditsUrl(1))).thenAnswer((_) async => http.Response(movieCreditsResponse.readAsStringSync(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      MovieCredits credits = await TmdbApi(client).fetchMovieCredits(1);

      expect(credits, isA<MovieCredits>());
      expect(credits, isNotNull);
    });

    test('should return null when something goes wrong during the fetch movie credits process', () async {
      final client = MockClient();
      when(client.get(TmdbConsts.movieCreditsUrl(1))).thenAnswer((_) async => http.Response('Something went wrong', 500));

      MovieCredits credits = await TmdbApi(client).fetchMovieCredits(1);

      expect(credits, isNull);
    });

    test('should successfully fetch and return all available genres', () async{
      final genresResponse = new File('test/fixtures/genres.json');
      final client = MockClient();
      when(client.get(TmdbConsts.genreListUrl)).thenAnswer((_) async => http.Response(genresResponse.readAsStringSync(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      List<Genre> genres = await TmdbApi(client).fetchGenreList();

      expect(genres, isA<List<Genre>>());
      expect(genres, isNotNull);
    });

    test('should return null when something goes wrong during the fetch genres process', () async {
      final client = MockClient();
      when(client.get(TmdbConsts.genreListUrl)).thenAnswer((_) async => http.Response('Something went wrong', 500));

      List<Genre> genres = await TmdbApi(client).fetchGenreList();

      expect(genres, isNull);
    });

    test('should successfully fetch and return all movies from the given genres', () async{
      final moviesResponse = new File('test/fixtures/movies_by_genres.json');
      final client = MockClient();
      when(client.get(TmdbConsts.moviesByGenresUrl(1, [1, 2]))).thenAnswer((_) async => http.Response(moviesResponse.readAsStringSync(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      List<Movie> movies = await TmdbApi(client).fetchMoviesByGenres(1, [1, 2]);

      expect(movies, isA<List<Movie>>());
      expect(movies, isNotNull);
    });

    test('should return null when something goes wrong during the fetching movies by genres process', () async {
      final client = MockClient();
      when(client.get(TmdbConsts.moviesByGenresUrl(1, [1, 2]))).thenAnswer((_) async => http.Response('Something went wrong', 500));

      List<Movie> movies = await TmdbApi(client).fetchMoviesByGenres(1, [1, 2]);

      expect(movies, isNull);
    });

    test('should successfully fetch a movie query and return a list of movies', () async{
      final movieQueryResponse = new File('test/fixtures/movie_query.json');
      final client = MockClient();
      when(client.get(TmdbConsts.movieQueryUrl(1, 'filme'))).thenAnswer((_) async => http.Response(movieQueryResponse.readAsStringSync(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }));
      List<Movie> movies = await TmdbApi(client).fetchMovieQuery(1, 'filme');

      expect(movies, isA<List<Movie>>());
      expect(movies, hasLength(greaterThan(0)));
    });

    test('should return null when something goes wrong during the fetch movie query process', () async {
      final client = MockClient();
      when(client.get(TmdbConsts.movieQueryUrl(1, 'filme'))).thenAnswer((_) async => http.Response('Something went wrong', 500));

      List<Movie> movies = await TmdbApi(client).fetchMovieQuery(1, 'filme');

      expect(movies, isNull);
    });
  });
}