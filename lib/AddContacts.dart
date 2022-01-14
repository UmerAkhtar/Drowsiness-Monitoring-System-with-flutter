import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddContacts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddContactsState();
  }
}

class AddContactsState extends State<AddContacts> {
  DatabaseReference dbref =
      FirebaseDatabase.instance.reference().child("Contact");
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  String _typeSelected = '';

  Widget _buildContactType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _typeSelected == title
              ? Colors.green
              : Theme.of(context).accentColor,
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Add Contacts",style:TextStyle(color: Colors.white)),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                hintText: "Enter Name",
                prefixIcon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "PhoneNumber",
                prefixIcon: Icon(
                  Icons.phone_iphone,
                  size: 30,
                ),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildContactType("Company"),
                  SizedBox(
                    width: 10,
                  ),
                  _buildContactType("Family"),
                  SizedBox(
                    width: 10,
                  ),
                  _buildContactType("Friends"),
                  SizedBox(
                    width: 10,
                  ),
                  _buildContactType("Other"),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      if (name.text.length <= 3) {
                        displayToast("Name Must be greater than 3 Char");
                      } else if (phone.text.length < 11) {
                        displayToast("Please Enter Valid Number");
                      } else {
                        SaveContact();
                      }
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("Save"),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void SaveContact() {
    Map<String, String> contact = {
      'Name': name.text,
      'Phone': phone.text,
      'Type': _typeSelected,
    };
    dbref.push().set(contact).then((value) => Navigator.pop(context));
  }

  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
  }
}
