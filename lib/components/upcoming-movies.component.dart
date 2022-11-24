import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymovies/components/list-title.component.dart';
import 'package:mymovies/model/movie.model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mymovies/network/api.dart';

import '../page/sub-page/details-page.dart';

class UpcomingComponent extends StatefulWidget {
  UpcomingComponent({super.key, required this.upcoming});
  List<Movie> upcoming;
  @override
  State<UpcomingComponent> createState() => _UpcomingComponentState();
}

class _UpcomingComponentState extends State<UpcomingComponent> {
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: MovieListTitle(
              title: "Upcoming",
              moviesList: widget.upcoming,
              color: Colors.deepOrange)),
      Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          items: widget.upcoming.map((index) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  child: Stack(
                    children: [
                      Container(
                        child: index.backdropPath == null
                            ? SizedBox(
                                child: Image.network(
                                    'https://static.thenounproject.com/png/34546-200.png',
                                    color: Colors.grey.withOpacity(0.2),
                                    fit: BoxFit.cover),
                              )
                            : CachedNetworkImage(
                                imageUrl: API().getImageUrl() +
                                    index.backdropPath.toString(),
                                placeholder: ((context, url) => Container(
                                    color: Colors.grey.withOpacity(0.2),
                                    child: spinkit)),
                                errorWidget: (context, url, error) =>
                                    const SizedBox(child: spinkit),
                              ),
                      ),
                      Positioned(
                          left: 15,
                          bottom: 5,
                          child: Row(
                            children: [
                              index.posterPath == null
                                  ? SizedBox(
                                      height: 185,
                                      child: Image.network(
                                          'https://static.thenounproject.com/png/34546-200.png',
                                          color: Colors.grey.withOpacity(0.2),
                                          fit: BoxFit.cover),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        imageUrl: API().getImageUrl() +
                                            index.posterPath.toString(),
                                        width: 100,
                                        placeholder: ((context, url) =>
                                            spinkit),
                                        errorWidget: (context, url, error) =>
                                            spinkit,
                                      ),
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 5, bottom: 5, right: 25),
                                margin: const EdgeInsets.only(top: 105),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5.5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color: Colors.orange,
                                                  width: 2.5))),
                                      padding: const EdgeInsets.only(left: 5),
                                      width: 200,
                                      child: Text(
                                        index.title.toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        index.releaseDate
                                            .toString()
                                            .substring(0, 10),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return DetailsPage(
                        details: index,
                      );
                    })));
                  },
                );
              },
            );
          }).toList(),
        ),
      )
    ]));
  }
}
