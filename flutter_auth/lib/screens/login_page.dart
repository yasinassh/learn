import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/providers/authservices.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Spacer(),
              CircleAvatar(
                radius: 80.0,
              ),
              SizedBox(height: 50.0),
              TextFormField(
                  onSaved: (value) => _email = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address")),
              TextFormField(
                  onSaved: (value) => _password = value,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password")),
              SizedBox(height: 20.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () async {
                    final form = _formKey.currentState;
                    form.save();
                    if (form.validate()) {
                      try {
                        FirebaseUser result =
                          await Provider.of<AuthService>(context, listen: false)
                              .loginUser(email: _email, password: _password);
                          print(result);
                      } on AuthException catch(error) {
                        return _buildShowErrorDialog(context, error.message);
                      } on Exception catch(error) {
                        return _buildShowErrorDialog(context, error.toString());
                      }
                    }
                  },
                  child: Text("Login"),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future _buildShowErrorDialog(BuildContext context, _message) {
    return showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text('Error Message'),
            content: Text(_message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'))
            ],
          );
        },
        context: context);
  }
}
