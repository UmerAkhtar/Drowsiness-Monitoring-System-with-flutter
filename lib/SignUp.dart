import 'package:flutter/material.dart';
import 'Login_Page.dart';
import 'constraints.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Drivers");
  TextEditingController name= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController phone= TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value:SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(

            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4DB6AC),
                      Color(0xFF26A69A),
                      Color(0xFF009688),
                      Color(0xFF00897B),

                    ]
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all( 40),
                      child: Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 40,
                            color: Colors.black,

                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: name,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                            labelText: "Name",
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide())
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                        controller: email,
                        decoration: InputDecoration(

                            labelText: "Email",
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: mainColor))
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: phone,
                        decoration: InputDecoration(
                            labelText: "PhoneNumber",
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: mainColor))
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: password,
                        keyboardType: TextInputType.number,


                        decoration: InputDecoration(
                            labelText: "Password",
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: mainColor))
                        ),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: RaisedButton(
                        elevation: 5.0,
                        color: Color(0x99FFFFFF),
                        onPressed: () {
                          if(name.text.isEmpty||email.text.isEmpty||phone.text.isEmpty||password.text.isEmpty)
                            {
                              displayToastMessage("Please Fill All Fields", context);
                            }
                          else if(name.text.length<3)
                          {
                            displayToastMessage("Name greater than 3 char", context);
                          }
                          else if(!email.text.contains("@"))
                          {
                            displayToastMessage("Enter Valid Email", context);
                          }
                          else if(password.text.length<6)
                          {
                            displayToastMessage("password must be greater than 6 char", context);
                          }
                          else if(phone.text.length<11)
                          {
                            displayToastMessage("Enter Valid PhoneNumber", context);
                          }
                          else {
                            registerUser();
                            displayToastMessage("Data Stored", context);

                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                          }

                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.4,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            color: Color(0x99FFFFFF),
                          ),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "REGISTER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                              ,color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()))
                        },
                        child: Text(
                          "Already Have an Account? LogIn",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ),





                  ],
                ),

              ),
            ],
          ),
        ),
      ),
   );
  }
  displayToastMessage(String msg, BuildContext context)
  {
    Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,);
  }

  void registerUser() {

    firebaseAuth
        .createUserWithEmailAndPassword(
        email: email.text, password: password.text)
        .then((result) {
      dbRef.child(result.user.uid).set({
        "name":name.text.trim(),
        "email": email.text.trim(),
        "Phone": phone.text.trim(),
        "Password": password.text.trim(),
      });
    });
  }
}