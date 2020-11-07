import 'package:desafiocubos/model/movie_details.dart';
import 'package:desafiocubos/service/tmdb_api.dart';
import 'package:desafiocubos/view/home/home_view.dart';
import 'package:http/http.dart' as http;
import '../../model/movie.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  int page = 1;
  final scrollController = ScrollController();
  List<Movie> movies;
  List<MovieContainer> movieContainers = [];
  TmdbApi tmdbApi = TmdbApi(new http.Client());
  bool isLoading = true;
  List<Genre> genres;

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
    movies = await tmdbApi.fetchPopularMovies(page);

    movies.forEach((movie) {
      String movieGenres = '';

      for (int i = 0; i < movie.genreIds.length; i++) {
        if (i == movie.genreIds.length - 1) movieGenres += genres.firstWhere((element) => element.id == movie.genreIds[i]).name;
        else movieGenres += genres.firstWhere((element) => element.id == movie.genreIds[i]).name + ' - ';
      }

      movieContainers.add(MovieContainer(
        movie: movie,
        genres: movieGenres,
      ));
    });
    notifyListeners();
  }
}
