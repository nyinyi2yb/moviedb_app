import 'package:mymovies/model/movie.model.dart';
import 'package:mymovies/network/api.dart';

import '../model/genres.model.dart';

class MoviesController {
  Future<List<Movie>> getPopular() async {
    return await API().getPopular();
  }

  Future<List<Movie>> getUpcoming() async {
    return await API().getUpcoming();
  }

  Future<List<Movie>> getNowPlaying() async {
    return await API().getNowPlaying();
  }

  Future<List<Movie>> getTopRated() async {
    return await API().getTopRated();
  }

  Future<List<Genre>> getGenresList() async {
    return await API().getGenresList();
  }
}
