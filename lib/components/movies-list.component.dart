// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymovies/components/list-title.component.dart';
import 'package:mymovies/network/firebase.api.dart';
import 'package:mymovies/page/sub-page/details-page.dart';
import '../model/movie.model.dart';
import '../network/api.dart';
import 'package:google_fonts/google_fonts.dart';

class MoviesComponent extends StatefulWidget {
  MoviesComponent(
      {super.key,
      required this.moviesList,
      required this.title,
      required this.color});
  List<Movie> moviesList;
  String title;
  Color color;
  @override
  State<MoviesComponent> createState() => _MoviesComponentState();
}

class _MoviesComponentState extends State<MoviesComponent> {
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAPI().getSnapshot(),
        builder: ((context, snapshot) {
          List movieIdList = [];
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            for (var mid in data) {
              var movieId = mid['mID'];
              movieIdList.add(movieId);
            }
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: MovieListTitle(
                      title: widget.title,
                      moviesList: widget.moviesList,
                      color: widget.color),
                ),
                Container(
                  height: 285,
                  padding: const EdgeInsets.only(left: 12),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: widget.moviesList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        var movie = widget.moviesList[index];
                        var isBookmark = movieIdList.contains(movie.id);
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return DetailsPage(
                                details: movie,
                              );
                            })));
                          },
                          child: SizedBox(
                            width: 120,
                            child: Card(
                              elevation: 0,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      movie.posterPath == null
                                          ? Container(
                                              width: 185,
                                              color: Colors.grey.withOpacity(0.2),
                                              child: const Center(
                                                  child: Icon(
                                                Icons.local_movies,
                                                size: 60,
                                                color: Colors.grey,
                                              )),
                                            )
                                          : SizedBox(
                                              height: 170,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: API().getImageUrl() +
                                                      movie.posterPath!,
                                                  width: 170,
                                                  placeholder: ((context, url) =>
                                                      spinkit),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          spinkit,
                                                ),
                                              ),
                                            ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child:isBookmark ? const Icon(Icons.bookmark_border_rounded,size: 30,color: Colors.orangeAccent,) : const SizedBox(),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 16,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(movie.voteAverage!
                                                    .toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          movie.title!,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        OutlinedButton.icon(
                                            onPressed: () {
                                              if (isBookmark) {
                                                FirebaseAPI()
                                                    .cancelBookmark(movie.id);
                                              } else {
                                                FirebaseAPI()
                                                    .addToBookmark(movie.id);
                                              }
                                            },
                                            icon: isBookmark
                                                ? const Icon(
                                                    Icons.bookmark_remove,
                                                    size: 10,
                                                  )
                                                : const Icon(
                                                    Icons.add,
                                                    size: 10,
                                                  ),
                                            label: const Text(
                                              'Watchlist',
                                              style: TextStyle(fontSize: 12),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
          );
        }));
  }
}
