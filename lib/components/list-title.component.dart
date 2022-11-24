import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymovies/components/see-all-movies.component.dart';
import 'package:mymovies/model/movie.model.dart';

class MovieListTitle extends StatefulWidget {
  MovieListTitle(
      {super.key,
      required this.title,
      required this.moviesList,
      required this.color});

  List<Movie> moviesList;
  String title;
  Color color;

  @override
  State<MovieListTitle> createState() => _MovieListTitleState();
}

class _MovieListTitleState extends State<MovieListTitle> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: widget.color, width: 5))),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            child: const Text('SEE ALL',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                )),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return SeeAllMoviesList(moviesList: widget.moviesList);
              })));
            },
          )
        ],
      ),
    );
  }
}
