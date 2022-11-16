import 'package:bloc_login/Posts/HomeScreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_login/repository/user_repository.dart';

import 'package:bloc_login/bloc/authentication_bloc.dart';
import 'package:bloc_login/model/api_model.dart';

import 'package:bloc_login/splash/splash.dart';
import 'package:bloc_login/login/login_page.dart';
import 'package:bloc_login/home/home.dart';
import 'package:bloc_login/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/user_database.dart';

void main() {
  final userRepository = UserRepository();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      return AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted());
    },
    child: App(userRepository: userRepository),
  ));
}

class App extends StatelessWidget {
  final UserRepository userRepository;
  final dbProvider = DatabaseProvider.dbProvider;

  App({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          }
          if (state is AuthenticationAuthenticated) {
            SetToken(0);
            return HomeScreen();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(
              userRepository: userRepository,
            );
          }
          return LoadingIndicator();
        },
      ),
    );
  }

  Future<String> SetToken(int id) async {
    final db = await dbProvider.database;
    try {
      List<Map> users =
          await db.query(userTable, where: 'id = ?', whereArgs: [id]);
      if (users.length > 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', users.first['token']);
        prefs.setString('username', users.first['username']);
        print("set-token");
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
