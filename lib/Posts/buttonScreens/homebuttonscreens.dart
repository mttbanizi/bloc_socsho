// ignore_for_file: prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'dart:io';

import 'package:bloc_login/model/api_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
// import 'package:flutter_session/flutter_session.dart';

import '../../database/user_database.dart';

class HomeButtonIconScreens extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeButtonIconScreensState();
  }
}

class _HomeButtonIconScreensState extends State {
  final dbProvider = DatabaseProvider.dbProvider;
  var posts = [];
  String token = 'Token ';

  @override
  void initState() {
    super.initState();
    print('initState');
    // TODO: implement initState
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
            new IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.amber,
                )),
            new Text(
              'socsho',
              style: new TextStyle(
                fontSize: 15,
                color: Colors.amber,
              ),
            ),
            new IconButton(
              onPressed: () {},
              icon: Icon(Icons.send_sharp),
              color: Colors.amber,
            )
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
              itemCount: posts.length + 1,
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
                              new Text(posts[index - 1]['body'])
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
    print(index.toString());
    var post = posts[index - 1];
    print(post.toString());
    List lnt = post['user_fields']['user_photo'];
    int length = lnt.length;
    print(length.toString());
    String imageUrl = 'http://10.0.2.2:8000' +
        post['user_fields']['user_photo'][length - 1]['image'];
    print(imageUrl);
    return Container(
      margin: EdgeInsets.all(8),
      child: new Row(
        children: [
          new Image.network(
            imageUrl,
            height: 40,
          ),
          new Padding(
            padding: EdgeInsets.only(left: 10),
            child: new Text(' ' + post['user_fields']['full_name'].toString()),
          )
        ],
      ),
    );
  }

  _listImage(int index) {
    var post = posts[index - 1];
    String imageUrl = 'http://10.0.2.2:8000' + post['image'];
    print(imageUrl);
    // print(post.toString());
    // return FutureBuilder<dynamic>(
    //     future: getUserName(post['user']),
    //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //       if (snapshot.hasData) {
    //         print('user_snapshot.data');
    //         print(snapshot.data);
    return new Container(
      child: new Image.network(
        imageUrl,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          print('error image');
          return Image.asset(
            "assets/images/friend_acc.png",
            height: 300,
            fit: BoxFit.cover,
          );
        },
      ),
    );
    //   }
    //   return Container(child: CircularProgressIndicator());
    // });
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    // if (!prefs.containsKey('token')) {
    //   return false;
    // }
    //String token = await checkToken(0);
    if (token != null) {
      print('currentToken');
      String currentToken = 'Token ' + token;
      print(currentToken);
      var response = await http.get(url, headers: {
        'Authorization': currentToken
        //'Authorization': 'Token f6e4acad2221023c52f8cd79c5aaff2377e510af'
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
  }

  Future<dynamic> getUserName(user_id) async {
    var url = Uri.http(
        '10.0.2.2:8000', '/drf/accounts/getusername/' + user_id.toString());

    // Await the http get response, then decode the json-formatted response.
    print(url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    // if (!prefs.containsKey('token')) {
    //   return false;
    // }
    //String token = await checkToken(0);
    if (token != null) {
      print('currentToken');
      String currentToken = 'Token ' + token;
      print(currentToken);

      var response =
          await http.get(url, headers: {'Authorization': currentToken});
      print(response);
      // print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        //print(jsonResponse['full_name']);
        return jsonResponse['full_name'];
      }
      throw Exception('Unexpected error occured!');
    }
  }

  _liked_icon(int index) {
    var post = posts[index - 1];
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    // if (!prefs.containsKey('token')) {
    //   return false;
    // }
    //String token = await checkToken(0);
    if (token != null) {
      print('currentToken');
      String currentToken = 'Token ' + token;
      print(currentToken);

      var response =
          await http.get(url, headers: {'Authorization': currentToken});

      //print(response.body);
      //print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        //print(jsonResponse['liked']);
        return jsonResponse['liked'];
      }
      throw Exception('Unexpected error occured!');
    }
  }

  Future<String> checkToken(int id) async {
    final db = await dbProvider.database;
    try {
      List<Map> users =
          await db.query(userTable, where: 'id = ?', whereArgs: [id]);
      if (users.length > 0) {
        print("check-token");
        print(users.first['token']);
        return users.length.toString();
      } else {
        return 'false';
      }
    } catch (error) {
      return 'false';
    }
  }
}
