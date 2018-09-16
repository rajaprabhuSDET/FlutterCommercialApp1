import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> {
  String email;
  String password;
  bool acceptTerms = false;

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
        if (value.isEmpty || value.contains('\@')) {
          return 'Field is required';
        }
      },
      onSaved: (String value) {
        setState(() {
          email = value;
        });
      },
    );
  }

  Widget _acceptSwitch() {
    return SwitchListTile(
      value: acceptTerms,
      title: Text('Accept Terms !'),
      onChanged: (bool value) {
        setState(() {
          acceptTerms = value;
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
        if (value.isEmpty ) {
          return 'Field is required';
        }
      },
      onSaved: (String value) {
        setState(() {
          password = value;
        });
      },
    );
  }

  void _submitForm() {
    if (password == 'winthegame') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/');
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
    );
  }
}
