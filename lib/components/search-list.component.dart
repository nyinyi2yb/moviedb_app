import 'package:flutter/material.dart';
import 'package:mymovies/page/sub-page/details-page.dart';

import '../model/movie.model.dart';
import '../network/api.dart';

class SearchList extends StatefulWidget {
  SearchList({super.key, required this.result});

  List<Movie> result;

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        itemCount: widget.result.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var movie = widget.result[index];
          return InkWell(
            onTap: (() {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return DetailsPage(details: movie);
              })));
            }),
            child: Container(
              height: 120,
              child: Row(
                children: [
                  movie.posterPath == null
                      ? Container(
                          width: 80,
                          color: Colors.grey.withOpacity(0.2),
                          child: const Center(
                              child: Icon(
                            Icons.local_movies,
                            size: 60,
                            color: Colors.grey,
                          )),
                        )
                      : Image(
                          image: NetworkImage(
                              API().getImageUrl() + movie.posterPath!),
                          width: 80,
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 180,
                    child: movie.title == null
                        ? Text('title')
                        : Text(
                            movie.title!,
                            overflow: TextOverflow.ellipsis,
                          ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
