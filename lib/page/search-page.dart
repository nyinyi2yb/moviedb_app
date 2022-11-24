import 'package:flutter/material.dart';
import 'package:mymovies/components/search-list.component.dart';
import 'package:mymovies/controller/search.controller.dart';
import 'package:mymovies/network/api.dart';
import 'package:mymovies/page/home-page.dart';

import '../model/movie.model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late FocusNode myFocusNode;
  var isFocus = false;

  List<Movie>? searchResult;

  TextEditingController _textControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.addListener(() {
      setState(() {
        isFocus = myFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1.5,
          title: TextField(
            focusNode: myFocusNode,
            controller: _textControler,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Search'),
            onChanged: ((value) {
              if (value != "") {     
                SearchController().getSearchResult(value).then((value) {
                  setState(() {
                    searchResult = value;
                  });
                });
              }
            }),
          ),
          leading: const Icon(Icons.search),
          actions: [
            TextButton(
                onPressed: () {
                  _textControler.text = "";
                },
                child: isFocus ? Icon(Icons.close) : Text('Cancel'))
          ],
        ),
        body: searchResult == null
            ? Container()
            : SearchList(result: searchResult!));
  }
}
