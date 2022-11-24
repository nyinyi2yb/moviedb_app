import 'package:http/http.dart' as http;
import 'package:mymovies/model/genres.model.dart';
import 'package:mymovies/model/movie.model.dart';
import 'package:mymovies/model/response.model.dart';

class API {
  final String _baseUrl = "https://api.themoviedb.org/3";
  final String _apiKey = "cc956f3dffa4de70fc80d31fbf7ff364";
  final String _imageUrl = "https://image.tmdb.org/t/p/w500";

  String getImageUrl() {
    return _imageUrl;
  }

  Future<List<Movie>> getList(String url, {String param = ''}) async {
    var uri = Uri.parse('$_baseUrl$url?api_key=$_apiKey$param');
    String u = "$_baseUrl/movie/238?api_key=cc956f3dffa4de70fc80d31fbf7ff364";
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var res = ApiResponse.fromRawJson(response.body);
      return res.results!;
    } else {
      throw Exception('Cannot get data');
    }
  }

  Future<List<Movie>> getUpcoming() async {
    return getList('/movie/upcoming');
  }

  Future<List<Movie>> getPopular() async {
    return getList('/movie/popular');
  }

  Future<List<Movie>> getNowPlaying() async {
    return getList('/movie/now_playing');
  }

  Future<List<Movie>> getTopRated() async {
    return getList('/movie/top_rated');
  }

  Future<List<Movie>> getSearch(String name) async {
    return getList('/search/movie', param: "&query=$name");
  }

  Future<Movie> getMovieDetails(int movieId) async {
    var uri = Uri.parse("$_baseUrl/movie/$movieId?api_key=$_apiKey");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var res = Movie.fromRawJson(response.body);
      return res;
    } else {
      throw Exception('Cannot get data');
    }
  }

  Future<List<Genre>> getGenresList() async {
    var uri = Uri.parse("$_baseUrl/genre/movie/list?api_key=$_apiKey");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      // var res = Movie.fromRawJson(response.body);
      var res = Genres.fromRawJson(response.body);
      return res.genres!;
    } else {
      throw Exception('Cannot get data');
    }
  }
}
