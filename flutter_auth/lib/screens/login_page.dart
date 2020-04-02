import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/providers/authservices.dart';
import 'package:provider/provider.dart';

enum AuthMode { LOGIN, SIGNUP }

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  AuthMode _authMode = AuthMode.LOGIN;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 80.0,
                ),
                SizedBox(height: 50.0),
                if (_authMode == AuthMode.LOGIN)
                  TextFormField(
                      onSaved: (value) => _firstName = value,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "First Name")),
                if (_authMode == AuthMode.LOGIN)
                  TextFormField(
                      onSaved: (value) => _lastName = value,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Last Name")),
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
                            FirebaseUser result = await Provider.of<AuthService>(
                                    context,
                                    listen: false)
                                .loginUser(email: _email, password: _password);
                            print(result);
                          } on AuthException catch (error) {
                            return _buildShowErrorDialog(context, error.message);
                          } on Exception catch (error) {
                            return _buildShowErrorDialog(
                                context, error.toString());
                          }
                        } else {
                          try {
                            await Provider.of<AuthService>(context, listen: false)
                                .createUser(
                                    firstName: _firstName,
                                    lastName: _lastName,
                                    email: _email,
                                    password: _password);
                          } on AuthException catch (error) {
                            return _buildShowErrorDialog(context, error.message);
                          } on Exception catch (error) {
                            return _buildShowErrorDialog(
                                context, error.toString());
                          }
                        }
                      },
                      child:
                          Text(_authMode == AuthMode.LOGIN ? 'LOGIN' : 'SIGNUP')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Text(
                      _authMode == AuthMode.LOGIN
                          ? "Don't have an account?"
                          : "Already have account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _authMode != AuthMode.LOGIN
                                ? _authMode = AuthMode.LOGIN
                                : _authMode = AuthMode.SIGNUP;
                          });
                        },
                        textColor: Colors.black87,
                        child: Text(_authMode != AuthMode.LOGIN
                            ? "LOGIN"
                            : "Create Account"))
                  ],
                ),
              ],
            ),
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
