import 'package:desafiocubos/model/movie_credits.dart';
import 'package:desafiocubos/model/movie_details.dart';
import 'package:desafiocubos/service/tmdb_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsViewModel extends ChangeNotifier {
  MovieDetail movieDetail;
  MovieCredits movieCredits;
  int movieId;
  TmdbApi tmdbApi = TmdbApi(new http.Client());
  bool isLoading = true;
  bool hasError = false;
  String cast;
  String producers;
  String prodComp;
  String duration;

  void setMovieId(int movieId, [bool fetchMovieDetails = true]) {
    isLoading = true;
    this.movieId = movieId;
    if (fetchMovieDetails) getMovieDetails();

    notifyListeners();
  }

  void onReloadButtonPressed() {
    isLoading = true;
    notifyListeners();
    getMovieDetails();
  }

  Future<void> getMovieDetails() async {
    movieDetail = await tmdbApi.fetchMovieDetails(this.movieId);
    movieCredits = await tmdbApi.fetchMovieCredits(this.movieId);

    if (movieDetail == null || movieCredits == null) {
      this.hasError = true;
      return;
    } else
      this.hasError = false;

    setDetailsList();
    isLoading = false;

    notifyListeners();
  }

  void setDetailsList() {
    List<String> aux = [];
    movieCredits.cast.forEach((e) {
      aux.add(e.name);
    });
    cast = aux.toString().replaceAll('[', '').replaceAll(']', '');
    aux.clear();

    movieCredits.crew.forEach((e) {
      if (e.job == 'Director') aux.add(e.name);
    });
    producers = aux.toString().replaceAll('[', '').replaceAll(']', '');
    aux.clear();

    movieDetail.productionCompanies.forEach((e) {
      aux.add(e.name);
    });
    prodComp = aux.toString().replaceAll('[', '').replaceAll(']', '');
    aux.clear();

    Duration _duration = Duration(minutes: movieDetail.runtime);
    int min = movieDetail.runtime - (_duration.inHours * 60);
    duration = '${_duration.inHours}h $min min';
  }
}
