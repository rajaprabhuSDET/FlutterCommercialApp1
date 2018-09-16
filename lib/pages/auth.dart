import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> {
  final Map<String, dynamic> authCredentials = {
    'email': null,
    'password': null,
    'acceptSwitch': false
  };
  final GlobalKey<FormState> _authState = GlobalKey<FormState>();

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
        authCredentials['email'] = value;
      },
    );
  }

  Widget _acceptSwitch() {
    return SwitchListTile(
      value: authCredentials['acceptSwitch'],
      title: Text('Accept Terms !'),
      onChanged: (bool value) {
        setState(() {
          authCredentials['acceptSwitch'] = value;
        });
      },
    );
  }

  Widget _passwordTextfield() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
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
        authCredentials['password'] = value;
      },
    );
  }

  void _submitForm() {
    if (!_authState.currentState.validate()) {
      return;
    }
    _authState.currentState.save();
    Navigator.pushReplacementNamed(context, '/home');
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
                    _acceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      textColor: Colors.white,
                      child: Text('LOGIN'),
                      onPressed: _submitForm,
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
