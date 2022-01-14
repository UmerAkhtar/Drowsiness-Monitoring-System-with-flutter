import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ManageContacts.dart';

class EditContacts extends StatefulWidget {
 String contactKey;
 EditContacts({ this.contactKey});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditContactsState();
  }
}

class EditContactsState extends State<EditContacts> {
  DatabaseReference dbref =
  FirebaseDatabase.instance.reference().child("Contact");
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  String _typeSelected = '';
  void initState()
  {
    super.initState();
    getContactDetail();
  }

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
        title: Text("Update Contacts",style:TextStyle(color: Colors.white)),
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
                    child: Text("Update"),
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
 getContactDetail() async
 {
   DataSnapshot snapshot = await dbref.child(widget.contactKey).once();
   Map contact = snapshot.value;
   name.text=contact['Name'];
   phone.text = contact['Phone'];
   setState(() {
     _typeSelected =contact["Type"];
   });


 }
  void SaveContact() {
    Map<String, String> contact = {
      'Name': name.text,
      'Phone': phone.text,
      'Type': _typeSelected,
    };
    dbref.child(widget.contactKey).update(contact).then((value) => Navigator.pop(context));
  }

  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
  }
}
