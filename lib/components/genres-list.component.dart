import 'package:flutter/material.dart';
import 'package:mymovies/model/genres.model.dart';
import 'package:mymovies/network/api.dart';

class GenresList extends StatefulWidget {
  GenresList({super.key, required this.genresList});

  List<Genre> genresList;
  @override
  State<GenresList> createState() => _GenresListState();
}

class _GenresListState extends State<GenresList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.genresList.length,
          itemBuilder: ((context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              height: 50,
              child: OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)))),
                  onPressed: () {},
                  child: Text(widget.genresList[index].name!)),
            );
          })),
    );
  }
}
