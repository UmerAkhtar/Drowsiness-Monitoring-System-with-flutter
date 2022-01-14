import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_firebase/CameraPreviewScanner.dart';
import 'package:fyp_firebase/Login_Page.dart';
import 'package:fyp_firebase/constraints.dart';
import 'package:fyp_firebase/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ManageContacts.dart';
class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }

}

class HomeState extends State<Home> {

   User result =  FirebaseAuth.instance.currentUser;
  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');

   @override
   void initState()
   {
     initial();
     super.initState();



   }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Home',style: TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(



        child: Column(

          children: <Widget>[
        Container(


          child:  UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal
            ),


          accountName: Text("${" "}",
          style: TextStyle(color: Colors.white),
          ),
            accountEmail: Text("${result.email}", style: TextStyle(color: Colors.black,
            fontSize: 20.0)),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
           child:Text(
             "P",
             style: TextStyle(color:Colors.black),
           ) ,
          ),),),
            ListTile(
              leading:Icon(Icons.logout,color: Colors.black,),
              title: Text(
                "Log Out",style: TextStyle(color: Colors.black),
              ),

              onTap: (){
                localStorage.setBool('login', true);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
              selected: true,
            ),


          ],
        ),

      ),
      body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           SizedBox(
             width: 150.0,

           child:RaisedButton(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
             color: Color(0x99FFFFFF),

             elevation:5.0,
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraPreviewScanner()));
             },
             child: Text("Camera",
             style: TextStyle(
               fontWeight: FontWeight.bold
             ),),
           )),
           SizedBox(
               width: 150.0,

               child:RaisedButton(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                 color: Color(0x99FFFFFF),

                 elevation:5.0,
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageContacts()));
                 },
                 child: Text("Manage Contacts",
                     style: TextStyle(
                         fontWeight: FontWeight.bold
                     )),
               )),


         ],
       ),
      ),
    );

  }

  void initial() async {
     localStorage = await SharedPreferences.getInstance();
  }

}