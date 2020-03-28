import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/providers/authservices.dart';
import 'package:flutter_auth/screens/home_page.dart';
import 'package:flutter_auth/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: Provider.of<AuthService>(context).getUser(),
          builder: (contex, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.error != null) {
                print("ini error");
                return Text(snapshot.error.toString());
              }
              return snapshot.hasData ? HomePage(currentUser: snapshot.data) : LoginPage();
            } else {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment(0.0, 0.0),
                ),
              );
            }
          }),
    );
  }
}
