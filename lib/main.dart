import 'package:flutter/material.dart';
import 'package:pharmifind/loginModel.dart';
import 'package:pharmifind/loginService.dart';
import 'package:pharmifind/registrationPage.dart';
import 'dashboard_one.page.dart';
import 'package:localstorage/localstorage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Breakdown Assistance ',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: MyHomePage(title: 'Vehicle Breakdown Assistance'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Account> _users;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final LocalStorage storage = LocalStorage('pharmifind');

  var _username = TextEditingController();
  var _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _users = [];
  }

  void _loginDet() {
    LoginService.verifyPassword(_username.text, _password.text).then((users) {
      setState(() {
        _users = users;
      });

      if (_users.isNotEmpty) {
        print(_users[0].phoneNumber);

        storage.setItem('name', _users[0].name);
        storage.setItem('surname', _users[0].surname);
        storage.setItem('phoneNumber', _users[0].phoneNumber);

        print(storage.getItem('phoneNumber'));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardOnePage()),
        );
      }
    });
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

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _loginDet();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
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
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 150.0,
                      child: Image.asset(
                        "assets/images/mer.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
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
                    SizedBox(height: 55.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButton,
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()),
                      ),
                      child: Text(
                        'Dont have an account? Register Now',
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
