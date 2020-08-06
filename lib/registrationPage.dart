import 'package:flutter/material.dart';
import 'package:pharmifind/dashboard_one.page.dart';
import 'package:pharmifind/registrationService.dart';
import 'package:localstorage/localstorage.dart';

import 'main.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final LocalStorage storage = LocalStorage('pharmifind');
  var res;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  var _username = TextEditingController();
  var _firstName = TextEditingController();
  var _surname = TextEditingController();
  var _phoneNumber = TextEditingController();
  var _password = TextEditingController();
  var _verifyPassword = TextEditingController();
  var _errorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  void _registerBtn() {
    if (_password.text == _verifyPassword.text) {
      RegistrationService.register(_username.text, _firstName.text,
              _surname.text, _phoneNumber.text, _password.text)
          .then((resp) {
        setState(() {
          this.res = resp;
        });

        if (res == "success") {
          this._errorMsg = "";
          storage.setItem('name', _firstName.text);
          storage.setItem('surname', _surname.text);
          storage.setItem('phoneNumber', _phoneNumber.text);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardOnePage()),
          );
        } else {
          this._errorMsg = "Failed to register";
          print('Failed');
        }
      });
    } else {
      this._errorMsg = "Passwords Not Matching";
      print('password not matching');
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _username,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final nameField = TextField(
      controller: _firstName,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final surnameField = TextField(
      controller: _surname,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Surname",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final phoneNumberField = TextField(
      controller: _phoneNumber,
      obscureText: false,
      keyboardType: TextInputType.number,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone Number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: _password,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordFieldVerify = TextField(
      controller: _verifyPassword,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Verify Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _registerBtn();
        },
        child: Text("REGISTER",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  height: 150.0,
                  child: Image.asset(
                    "assets/images/mer.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'Vehicle Breakdown Assistance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 45.0),
                Text(
                  this._errorMsg,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 10),
                emailField,
                SizedBox(height: 25.0),
                nameField,
                SizedBox(height: 25.0),
                surnameField,
                SizedBox(height: 25.0),
                phoneNumberField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                passwordFieldVerify,
                SizedBox(height: 25.0),
                loginButton,
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  ),
                  child: Text(
                    'Have an account? Login Now',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
