// ignore_for_file: prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeButtonIconScreens extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeButtonIconScreensState();
  }
}

class _HomeButtonIconScreensState extends State {
  var posts = [];
  @override
  void initState() {
    super.initState();
    print('initState');
    // TODO: implement initState
    _setData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        bottom: _appbar(),
      ),
      body: _body(),
    );
  }

  _appbar() {
    return PreferredSize(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(onPressed: () {}, icon: Icon(Icons.photo_camera)),
            new Text(
              'socsho',
              style: new TextStyle(fontSize: 15),
            ),
            new IconButton(onPressed: () {}, icon: Icon(Icons.send_sharp))
          ],
        ),
        preferredSize: Size.fromHeight(10.0));
  }

  _body() {
    return Container(
      child: new Column(
        children: [_lsitview()],
      ),
    );
  }

  _lsitview() {
    return Container(
        child: new Expanded(
            child: FutureBuilder(
      future: _setData(),
      builder: (context, snapshot) {
        print('snapshot:' + snapshot.hasData.toString());
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: (index == 0)
                      ? _floatPic()
                      : new Container(
                          height: 450,
                          child: new Column(
                            children: <Widget>[
                              _titleFriend(index),
                              _listImage(index),
                              _listBottom(index),
                              new Container(
                                height: 10,
                              ),
                              new Text(posts[index]['body'])
                            ],
                          ),
                        ),
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return const CircularProgressIndicator();
        }
      },
    )));
  }

  _floatPic() {
    return Container(
      height: 100,
      child: new Column(
        children: [
          new Expanded(
              child: new ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      margin: EdgeInsets.all(10),
                      child: new Column(
                        children: [
                          // ignore: avoid_unnecessary_containers
                          new Container(
                            height: 60,
                            child:
                                new Image.asset('assets/images/friend_acc.png'),
                          ),
                          new Text('friend' + index.toString())
                        ],
                      ),
                    );
                  })),
          new Container(
            height: 3,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _titleFriend(index) {
    var post = posts[index];
    return FutureBuilder<dynamic>(
        future: getUserName(post['user']),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            print('user_snapshot.data');
            print(snapshot.data);
            return Container(
              margin: EdgeInsets.all(8),
              child: new Row(
                children: [
                  new Image.asset(
                    'assets/images/friend_acc.png',
                    height: 40,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: new Text(' ' + snapshot.data.toString()),
                  )
                ],
              ),
            );
          }

          return Container(child: CircularProgressIndicator());
        });
  }

  _listImage(int index) {
    return new Container(
      child: new Image.asset(
        'assets/images/friend_acc.png',
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }

  _listBottom(int index) {
    return new Container(
      margin: EdgeInsets.all(7),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Row(
            children: [
              _liked_icon(index),
              new Padding(
                  child: new Icon(Icons.receipt),
                  padding: EdgeInsets.only(left: 10, right: 10)),
              new Icon(Icons.near_me)
            ],
          ),
          new Icon(
            Icons.bookmark_border,
            size: 30,
          )
        ],
      ),
    );
  }

  Future<List<dynamic>> _setData() async {
    // https://api.covid19api.com/countries
    var url = Uri.http('10.0.2.2:8000', '/drf/posts/posts');

    // Await the http get response, then decode the json-formatted response.
    print(url);

    var response = await http.get(url, headers: {
      'Authorization': 'Token f68ddd61383cb5c223e883425f6c6a0332ab38c0'
    });
    // print(response.body);
    if (response.statusCode == 200) {
      print(200);
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach((element) {
        print(element);
      });
      posts = jsonResponse as List;
      return posts;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Unexpected error occured!');
    }
  }

  Future<dynamic> getUserName(user_id) async {
    var url = Uri.http(
        '10.0.2.2:8000', '/drf/accounts/getusername/' + user_id.toString());

    // Await the http get response, then decode the json-formatted response.
    print(url);

    var response = await http.get(url, headers: {
      'Authorization': 'Token f68ddd61383cb5c223e883425f6c6a0332ab38c0'
    });
    print(response);
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse['full_name']);
      return jsonResponse['full_name'];
    }
    throw Exception('Unexpected error occured!');
  }

  _liked_icon(int index) {
    var post = posts[index];
    return FutureBuilder<dynamic>(
        future: getIsLiked(post['pk']),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            print('icon_snapshot.data');
            print(snapshot.data);
            if (snapshot.data.toString() == 'like') {
              return new Icon(
                Icons.favorite,
                color: Colors.red,
              );
            } else {
              return new Icon(Icons.favorite);
            }
          }

          return Container(child: CircularProgressIndicator());
        });
  }

  Future<dynamic> getIsLiked(int post_id) async {
    var url =
        Uri.http('10.0.2.2:8000', '/drf/posts/like/' + post_id.toString());

    // Await the http get response, then decode the json-formatted response.
    print(url);

    var response = await http.get(url, headers: {
      'Authorization': 'Token f68ddd61383cb5c223e883425f6c6a0332ab38c0'
    });

    //print(response.body);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse['liked']);
      return jsonResponse['liked'];
    }
    throw Exception('Unexpected error occured!');
  }
}
