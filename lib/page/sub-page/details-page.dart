import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymovies/controller/movies.controller.dart';
import 'package:mymovies/model/genres.model.dart';
import 'package:mymovies/model/movie.model.dart';
import 'package:mymovies/network/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymovies/network/firebase.api.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({super.key, required this.details});

  Movie details;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  bool isBookmark = false;

  @override
  void initState() {
    getGenres();
    super.initState();
  }

  myOutlineBtn(Icon icon, Text text, Color color) {
    return OutlinedButton.icon(
        style: ButtonStyle(
            side: const MaterialStatePropertyAll(
                BorderSide(color: Colors.transparent)),
            foregroundColor: MaterialStatePropertyAll(color)),
        onPressed: () {},
        icon: icon,
        label: text);
  }

  List<String> genresList = [];

  getGenres() async {
    var res = await MoviesController().getGenresList();
    var id = widget.details.genreIds;
    for (var genres in res) {
      for (var i in id!) {
        if (genres.id == i) {
          setState(() {
            genresList.add(genres.name!);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.5,
        title: Text(widget.details.title!),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: StreamBuilder(
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
          isBookmark = movieIdList.contains(widget.details.id);

          return SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 0, right: 0, top: 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        child: widget.details.backdropPath == null
                            ? Container(
                                height: 200,
                                color: Colors.grey.withOpacity(0.2),
                                child: const Center(
                                    child: Icon(
                                  Icons.local_movies,
                                  size: 60,
                                  color: Colors.grey,
                                )),
                              )
                            : CachedNetworkImage(
                                imageUrl: API().getImageUrl() +
                                    widget.details.backdropPath!,
                                height: 210,
                                placeholder: ((context, url) => spinkit),
                                errorWidget: (context, url, error) => spinkit,
                              ),
                      ),
                      Positioned(
                          left: 15,
                          bottom: 10,
                          right: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 2.5, bottom: 2.5, right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  border: const Border(
                                      left: BorderSide(
                                          color: Colors.red, width: 2.5)),
                                ),
                                child: widget.details.title!.length >
                                        MediaQuery.of(context).size.width
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          widget.details.title!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                        ),
                                      )
                                    : Text(
                                        widget.details.title!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                      ),
                              ),
                              const SizedBox(
                                height: 3.5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 2.5, bottom: 2.5, right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  border: const Border(
                                      left: BorderSide(
                                          color: Colors.red, width: 2.5)),
                                ),
                                child: Text(
                                  widget.details.releaseDate
                                      .toString()
                                      .substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                  //details start------>
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                                width: 0.5))),
                    child: Row(
                      children: [
                        Container(
                          child: widget.details.posterPath == null
                              ? Container(
                                  height: 200,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: const Center(
                                      child: Icon(
                                    Icons.local_movies,
                                    size: 60,
                                    color: Colors.grey,
                                  )),
                                )
                              : CachedNetworkImage(
                                  imageUrl: API().getImageUrl() +
                                      widget.details.posterPath!,
                                  height: 160,
                                  width: 115,
                                  placeholder: ((context, url) => spinkit),
                                  errorWidget: (context, url, error) => spinkit,
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.only(
                              left: 10, top: 15, bottom: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Container(
                                height: 35,
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: genresList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text(
                                              genresList[index],
                                              style: const TextStyle(
                                                  color: Colors.blueAccent),
                                            )),
                                      );
                                    })),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text('Overview',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: Colors.lightBlueAccent,
                                            width: 2.5))),
                                child: InkWell(
                                  child: Text(
                                    widget.details.overview!,
                                    maxLines: 5,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: ((context) {
                                      return showFullOverview();
                                    })));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(
                                  widget.details.voteAverage!
                                      .toStringAsFixed(1)
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                              widget.details.voteCount!.toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            )
                          ],
                        ),
                        myOutlineBtn(const Icon(Icons.star_border_outlined),
                            const Text('Rate this'), Colors.blue),
                        myOutlineBtn(const Icon(Icons.share),
                            const Text('Share'), Colors.blue),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    margin: EdgeInsets.all(15),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 45, 80),
                            foregroundColor: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (isBookmark) {
                              FirebaseAPI().cancelBookmark(widget.details.id);
                              setState(() {
                                isBookmark = true;
                              });
                            } else {
                              FirebaseAPI().addToBookmark(widget.details.id);
                              setState(() {
                                isBookmark = false;
                              });
                            }
                          });
                        },
                        icon: isBookmark
                            ? const Icon(
                                Icons.bookmark,
                                size: 18,
                              )
                            : const Icon(
                                Icons.add,
                                size: 16,
                              ),
                        label: isBookmark
                            ? const Text("Remove from WatchList")
                            : const Text("Add to Watchlist")),
                  ),
                  //     // movie details end ------->
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget showFullOverview() {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(widget.details.title!),
        elevation: 1.5,
      ),
      body: StreamBuilder(
          stream: FirebaseAPI().getSnapshot(),
          builder: ((context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(child: Text(widget.details.overview!)),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        if (isBookmark) {
                          FirebaseAPI().cancelBookmark(widget.details.id);
                          setState(() {
                            isBookmark = true;
                          });
                        } else {
                          FirebaseAPI().addToBookmark(widget.details.id);
                          setState(() {
                            isBookmark = false;
                          });
                        }
                      },
                      icon: isBookmark
                          ? const Icon(
                              Icons.bookmark,
                              size: 18,
                            )
                          : const Icon(
                              Icons.add,
                              size: 16,
                            ),
                      label: isBookmark
                          ? const Text("Remove from WatchList")
                          : const Text("Add to Watchlist")),
                ],
              ),
            );
          })),
    );
  }
}
