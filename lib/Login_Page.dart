import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_firebase/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constraints.dart';
import 'SignUp.dart';
import 'Home.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  SharedPreferences localStroage;
  bool newuser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Drivers");
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState()
  {

    super.initState();
    check_if_already_login();
  }
  void check_if_already_login()async{
    localStroage =await SharedPreferences.getInstance();
    newuser = (localStroage.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Home()));
    }
    
  }
  Widget _buildSignUpButton() {
    User result = FirebaseAuth.instance.currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Don't have an account?",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            ])),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        cursorColor: Colors.blueGrey,
        keyboardType: TextInputType.emailAddress,
        controller: email,
        decoration: InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black)),
          prefix: Icon(
            Icons.email,
            color: Colors.teal,
          ),
          labelText: 'Email',
        ),
      ),
    );
  }

  Widget _buildPassRow() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        obscureText: true,
        controller: password,
        decoration: InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black)),
          prefix: Icon(
            Icons.lock,
            color: Colors.teal,
          ),
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget _builderlogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '  ',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 40,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
          '   ',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 30,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildForgetButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text(
            "Forgot Password",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildloginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 13),
          margin: EdgeInsets.only(bottom: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: Color(0x99FFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              if (!email.text.contains("@")) {
                displayToastMessage("Enter Valid Email", context);
              } else if (password.text.isEmpty) {
                displayToastMessage("Please fill password field", context);
              } else {
                localStroage.setBool('login', false);
                localStroage.setString('username', email.text.toString());
                loginUser(context);

              }
//              ClearText();

            },
            child: Text(
              "LOGIN",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 50,
                letterSpacing: 1.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _builderContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
          elevation: 7.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child:ClipRRect(

          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPassRow(),
                _buildForgetButton(),
                _buildloginButton(),
              ],
            ),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(70),
                  bottomRight: const Radius.circular(70),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _builderlogo(),
              _builderContainer(),
              _buildSignUpButton(),
            ],
          ),
        ],
      ),
    ));
  }

  void loginUser(BuildContext context) async {
  //  await MyApp.init();
    // localStroage.setString('email', email.text.toString());
    // localStroage.setString('password', password.text.toString());
    firebaseAuth
        .signInWithEmailAndPassword(email: email.text, password: password.text)
        .then((result) {


      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      displayToastMessage("Logged In Successfully", context);
    });

  }

  displayToastMessage(String msg, BuildContext context) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
  void ClearText()
  {
    email.clear();
    password.clear();

  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
