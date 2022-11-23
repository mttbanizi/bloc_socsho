// ignore_for_file: missing_return

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../bloc/authentication_bloc.dart';

class AccountButtonIconScreens extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountButtonIconScreensState();
  }
}

class _AccountButtonIconScreensState extends State {
  String token = 'Token ';

  @override
  void initState() {
    super.initState();
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

  _body() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              child: Column(
            children: [
              userActivity(),
            ],
          )),
          Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Text(
              'Welcome',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(34.0, 20.0, 0.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.width * 0.16,
              child: RaisedButton(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
                shape: StadiumBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appbar() {
    return PreferredSize(
        child: FutureBuilder<dynamic>(
            future: getUserName(),
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
                        child: new Text(
                          ' ' + snapshot.data.toString(),
                          style: new TextStyle(color: Colors.black87),
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container(child: CircularProgressIndicator());
            }),
        preferredSize: Size.fromHeight(10.0));
  }

  Future<dynamic> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    return username;
  }

  Future<dynamic> getMyProfile() async {
    var url = Uri.http('10.0.2.2:8000', '/drf/accounts/getprofile/');

    // Await the http get response, then decode the json-formatted response.
    print(url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    if (token != null) {
      String currentToken = 'Token ' + token;

      var response =
          await http.get(url, headers: {'Authorization': currentToken});

      if (response.statusCode == 200) {
        print(response.statusCode);
        var jsonResponse = convert.jsonDecode(response.body);
        // jsonResponse.forEach((element) {
        //   print(element);
        // });
        // MyProfile = jsonResponse as List;
        print(jsonResponse);
        return jsonResponse;
      }
      throw Exception('Unexpected error occured!');
    }
  }

  userActivity() {
    return Container(
        height: 250,
        child: FutureBuilder<dynamic>(
            future: getMyProfile(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                print('profile_snapshot.hasData');
                print(snapshot.hasData);
                return Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 90,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data['post_count'].toString(),
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 23),
                                    ),
                                    Text(
                                      "Posts",
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 23),
                                    ),
                                  ],
                                )),
                            Container(
                                height: 90,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data['follower_count']
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 23),
                                    ),
                                    Text(
                                      'Follower',
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 23),
                                    ),
                                  ],
                                )),
                            Container(
                                height: 90,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data['following_count']
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 23),
                                    ),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 23),
                                    )
                                  ],
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Text('Status:  '),
                            Text(
                              snapshot.data['status'].toString(),
                              style:
                                  TextStyle(color: Colors.yellow, fontSize: 23),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text('biography:  '),
                            Text(
                              snapshot.data['bio'].toString(),
                              style:
                                  TextStyle(color: Colors.yellow, fontSize: 23),
                            )
                          ],
                        )
                      ],
                    ));
              }
              return Container(child: CircularProgressIndicator());
            }));
  }
}
