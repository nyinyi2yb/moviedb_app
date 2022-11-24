import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymovies/model/movie.model.dart';
import 'package:mymovies/network/api.dart';
import 'package:mymovies/page/sub-page/details-page.dart';

class SeeAllMoviesList extends StatefulWidget {
  SeeAllMoviesList({super.key, required this.moviesList});

  List<Movie> moviesList;

  @override
  State<SeeAllMoviesList> createState() => _SeeAllMoviesListState();
}

class _SeeAllMoviesListState extends State<SeeAllMoviesList> {
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('See All'),
        elevation: 1.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: widget.moviesList.length,
            itemBuilder: ((context, i) {
              return InkWell(
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 0.5, color: Color.fromARGB(255, 219, 219, 219)))),
                  child: Row(
                    children: [
                      widget.moviesList[i].posterPath == null
                          ? SizedBox(
                              height: 185,
                              child: Image.network(
                                  'https://static.thenounproject.com/png/34546-200.png',
                                  fit: BoxFit.cover),
                            )
                          : CachedNetworkImage(
                              imageUrl: API().getImageUrl() +
                                  widget.moviesList[i].posterPath.toString(),
                              placeholder: ((context, url) => spinkit),
                              errorWidget: (context, url, error) => spinkit,
                            ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                widget.moviesList[i].title.toString(),
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,color: Colors.amber,size: 14,),
                                Text(
                                  widget.moviesList[i].voteAverage.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return DetailsPage(details: widget.moviesList[i]);
                  })));
                },
              );
            })),
      ),
    );
  }
}
