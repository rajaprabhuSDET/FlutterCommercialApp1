import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scopedmodel/mainmodel.dart';
import '../model/authmodel.dart';

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> {
  final Map<String, dynamic> _authCredentials = {
    'email': null,
    'password': null,
    'acceptSwitch': false
  };
  final GlobalKey<FormState> _authState = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  BoxDecoration _backgroundImage() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'),
      ),
    );
  }

  Widget _usernameTextfield() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Field is required';
        }
      },
      onSaved: (String value) {
        _authCredentials['email'] = value;
      },
    );
  }

  Widget _acceptSwitch() {
    return SwitchListTile(
      value: _authCredentials['acceptSwitch'],
      title: Text('Accept Terms !'),
      onChanged: (bool value) {
        setState(() {
          _authCredentials['acceptSwitch'] = value;
        });
      },
    );
  }

  Widget _passwordTextfield() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Field is required';
        }
      },
      onSaved: (String value) {
        _authCredentials['password'] = value;
      },
    );
  }

  Widget _confirmPasswordTextfield() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      //controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
      },
    );
  }

  void _submitForm(Function authenticate) async {
    Map<String, dynamic> successInformation;
    if (!_authState.currentState.validate()) {
      return;
    }
    _authState.currentState.save();

    successInformation = await authenticate(
        _authCredentials['email'], _authCredentials['password'], _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Occured !'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double customwidth = screenWidth > 550.0 ? 500.0 : screenWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Raja Prabhu Trial1'),
      ),
      body: Container(
        decoration: _backgroundImage(),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: customwidth,
              child: Form(
                key: _authState,
                child: Column(
                  children: <Widget>[
                    _usernameTextfield(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _passwordTextfield(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _authMode == AuthMode.SignUp
                        ? _confirmPasswordTextfield()
                        : Container(),
                    _acceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.SignUp
                              : AuthMode.Login;
                        });
                      },
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'SignUp' : 'Login'}'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                textColor: Colors.white,
                                child: Text(_authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGNUP'),
                                onPressed: () =>
                                    _submitForm(model.authenticate),
                              );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
