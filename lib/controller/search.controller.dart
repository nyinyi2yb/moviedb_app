import 'package:mymovies/network/api.dart';

import '../model/movie.model.dart';

class SearchController {
  Future<List<Movie>> getSearchResult(String name) async {
    return await API().getSearch(name);
  }
}
