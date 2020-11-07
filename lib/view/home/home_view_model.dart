import 'dart:async';

import 'package:desafiocubos/model/movie_details.dart';
import 'package:desafiocubos/service/tmdb_api.dart';
import 'package:desafiocubos/view/details/details_view.dart';
import 'package:desafiocubos/view/details/details_view_model.dart';
import 'package:desafiocubos/view/home/home_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../model/movie.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  int page = 1;
  final scrollController = ScrollController();
  List<MovieContainer> movieContainers = [];
  TmdbApi tmdbApi = TmdbApi(new http.Client());
  bool isLoading = true;
  List<Genre> genres;
  bool hasError = false; //TODO: implement error catching
  List<Genre> genreFilter = [];
  Timer _timer;

  void onMoviePressed(BuildContext context, int movieId, String urlTest) {
    Provider.of<DetailsViewModel>(context, listen: false).setMovieId(movieId);
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return DetailsView(
              movieId: movieId,
              urlTest: urlTest,
            );
          },
          transitionDuration: Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation =
                CurvedAnimation(curve: Curves.decelerate, parent: animation);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }),
    );
  }

  Future<void> initCalls() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        getMovies();
      }
    });

    await getGenres();
    await getMovies();
    isLoading = false;
    notifyListeners();
  }

  Future<void> getGenres() async {
    genres = await tmdbApi.fetchGenreList();
    notifyListeners();
  }

  Future<void> getMovies() async {
    List<Movie> movies = await tmdbApi.fetchPopularMovies(page);

    _movieToMovieContainer(movies);
    notifyListeners();
  }

  Future<void> getMoviesByGenre() async {
    List<int> genreIds = [];
    genreFilter.forEach((e) => genreIds.add(e.id));
    List<Movie> movies = await tmdbApi.fetchMoviesByGenres(page, genreIds);

    movieContainers.clear();
    _movieToMovieContainer(movies);
    notifyListeners();
  }

  Future<void> onGenreFilterPressed(Genre selectedGenre) async {
    this.page = 1;

    if (genreFilter.contains(selectedGenre))
      genreFilter.removeWhere((element) => element.id == selectedGenre.id);
    else
      genreFilter.add(selectedGenre);

    if (genreFilter.isEmpty) {
      movieContainers.clear();
      await getMovies();
    } else
      await getMoviesByGenre();

    notifyListeners();
  }

  void _movieToMovieContainer(List<Movie> movies) {
    movies.forEach((movie) {
      String movieGenres = '';

      for (int i = 0; i < movie.genreIds.length; i++) {
        if (i == movie.genreIds.length - 1)
          movieGenres += genres
              .firstWhere((element) => element.id == movie.genreIds[i])
              .name;
        else
          movieGenres += genres
                  .firstWhere((element) => element.id == movie.genreIds[i])
                  .name +
              ' - ';
      }

      movieContainers.add(MovieContainer(
        movie: movie,
        genres: movieGenres,
      ));
    });
  }

  void onSearchChanged(String query) {
    if (_timer?.isActive ?? false) _timer.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty)
        getMovieQuery(query);
      else {
        movieContainers.clear();
        getMovies();
      }
    });
  }

  Future<void> getMovieQuery(String query) async {
    this.page = 1;
    List<Movie> movies = await tmdbApi.fetchMovieQuery(page, query);

    movieContainers.clear();
    _movieToMovieContainer(movies);
    notifyListeners();
  }
}
