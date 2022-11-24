import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymovies/auth/login.dart';
import 'package:mymovies/components/genres-list.component.dart';
import 'package:mymovies/components/movies-list.component.dart';
import 'package:mymovies/components/upcoming-movies.component.dart';
import 'package:mymovies/controller/movies.controller.dart';
import 'package:mymovies/model/genres.model.dart';
import 'package:mymovies/model/movie.model.dart';
import 'package:mymovies/network/api.dart';
import 'package:mymovies/page/home-page.dart';
import 'package:mymovies/page/profile-page.dart';
import 'package:mymovies/page/search-page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie>? popular;
  List<Movie>? upcoming;
  List<Movie>? nowPlaying;
  List<Movie>? topRated;
  List<Genre>? genresList;

  Future getMoviesList() async {
    var pop = await MoviesController().getPopular();
    var upcom = await MoviesController().getUpcoming();
    var nowPlay = await MoviesController().getNowPlaying();
    var topR = await MoviesController().getTopRated();
    setState(() {
      popular = pop;
      upcoming = upcom;
      nowPlaying = nowPlay;
      topRated = topR;
    });
  }

  _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
      return LoginPage();
    })));
  }

  List itemList = [];

  getList() async {
    CollectionReference bookmarkList =
        FirebaseFirestore.instance.collection('bookmarks');
    try {
      await bookmarkList.get().then((value) {
        for (var element in value.docs) {
          itemList.add(element.data());
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  getGenres() async {
    var genres = await MoviesController().getGenresList();
    setState(() {
      genresList = genres;
    });
  }

  @override
  void initState() {
    super.initState();
    getMoviesList();
    getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MovieDB'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1.5,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: ((context) {
                    return ProfilePage();
                  })));
                },
                icon: const Icon(
                  Icons.account_circle,
                ))
          ],
        ),
        body: popular == null &&
                upcoming == null &&
                nowPlaying == null &&
                topRated == null
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    children: [
                      //upcoming
                      UpcomingComponent(upcoming: upcoming!),
                      //genres
                      GenresList(genresList: genresList!),
                      //popular
                      MoviesComponent(
                        moviesList: popular!,
                        title: 'Popular',
                        color: Colors.red,
                      ),
                      //Intheater
                      MoviesComponent(
                        moviesList: nowPlaying!,
                        title: 'In Theater',
                        color: Colors.teal,
                      ),
                      //toprated
                      MoviesComponent(
                        moviesList: topRated!,
                        title: 'Top Rated',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
