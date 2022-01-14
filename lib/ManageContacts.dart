import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'EditContact.dart';
import 'AddContacts.dart';
class ManageContacts extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ManageContactsState();
  }

}
class ManageContactsState extends State<ManageContacts>
{
  static var query;
  DatabaseReference dbref= FirebaseDatabase.instance.reference().child("Contact");



@override
void initState()
{
  super.initState();
  query=FirebaseDatabase.instance.reference().child("Contact").orderByChild('Name');
}
showDeleteDialog({  Map contact})
 {
  showDialog(context: context, builder: (context){

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text("Delete ${contact['Name']}"),
      content: Text('Are you sure ?'),
      actions: [
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel")),
        FlatButton(onPressed: (){
          dbref.child(contact['key']).remove().whenComplete(() =>Navigator.pop(context));
          
        }, child: Text("Delete"),)
        
      ],
    );
  });


}

Widget _buildContactList({ Map contact})
{
  return Container(
    margin: EdgeInsets.all(7),
    padding: EdgeInsets.all(5),
    height: 150,
    color: Colors.white,
     child: Card(
       color: Colors.teal,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12),
       ),
     elevation: 5.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Row(
         children:[
        Icon(Icons.person,color: Colors.white,size: 20,),
        SizedBox(
          width: 6,
        ),
        Text(contact['Name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)]
       ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Icon(Icons.phone_iphone,size: 20,color: Colors.white,),
            SizedBox(
              width: 6,
            ),
            Text(contact['Phone'],style: TextStyle(fontSize: 16),),
            SizedBox(
              width: 16,
            ),
            Icon(Icons.group_work,size: 20,color: Colors.white,),
            SizedBox(
              width: 6,
            ),
            Text(contact['Type'],style: TextStyle(fontSize: 16),),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: (){
              showDeleteDialog(contact: contact);
            }, icon: Icon(Icons.delete),iconSize: 20,color: Colors.white,),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditContacts(contactKey: contact['key'])));
            }, icon: Icon(Icons.edit),iconSize: 20,color: Colors.white,),

          ],
        ),

      ],
    ),),
  );
}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Text("ManageContacts",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(query: query,itemBuilder:(BuildContext context,DataSnapshot snapshot,Animation<double> animation,int index){
          Map contact = snapshot.value;
          contact['key'] = snapshot.key;
          return _buildContactList(contact: contact) ;

        } ,),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),

        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddContacts()),);


        },
      ),
    );
  }

}