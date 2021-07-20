
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup_ui/Screens/Update.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signup_ui/Screens/Edit.dart';
import 'package:signup_ui/Screens/Maps.dart';
import 'HomeScreen.dart';

class Admin extends StatefulWidget {
 // User user = FirebaseAuth.instance.currentUser;
  @override
  _HomepageState createState() => _HomepageState();
} 

class _HomepageState extends State<Admin> {
String crime;
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('ADMIN',
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0), ),
    centerTitle: true,
     leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushNamed(context, 'SignIn');
                },
              );
            }),
    ),
    body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection('users').snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
         if(!snapshot.hasData){
           return CircularProgressIndicator();
         }
         return ListView.builder(
           itemCount: snapshot.data.docs.length,
           itemBuilder: (_,index){
              return Card(
                color: Colors.grey[300],
                 elevation: 10.0,
              child: Container(
              width: 200,
              child: InkWell(
                 //splashColor: Colors.transparent,
                 onTap:() {
                   Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Update(index)),
              );
                 },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Container(
            color: Colors.grey[300],
            child: Padding(
            padding: EdgeInsets.only(left:10.0,top: 30.0),
            child: CircleAvatar(
             backgroundColor: Colors.teal,
             radius: 40,
             child: Image(
               image: AssetImage('asset/img/user.png'),
               height: 100,
               width: 100,
               fit: BoxFit.cover,
             )
            )
            ),
          ),
                        Container(
                   
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Padding(
                            padding:EdgeInsets.only(left:0.0,top: 0.0),
                              child: Container(
                              width: 280,
                            
                              child: Text(snapshot.data.docs[index]["name"].toString()+",",style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold),),
                            ),
                          ),
                          
                           Padding(
                            padding:EdgeInsets.only(left:0.0,top: 0.0),
                              child: Container(
                              width: 260,
                              height: 21,
                              child: Text(snapshot.data.docs[index]["crime"].toString()+",",style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold),),
                            ),
                          ),
                          Padding(
                              padding:EdgeInsets.only(left:0.0,top: 0.0),
                               child: Container(
                              width: 280,
                             
                              color: Colors.transparent,
                              child: Text(snapshot.data.docs[index]["Crime Location"].toString()+',',style: new TextStyle(fontSize:18.0,fontWeight:FontWeight.normal),),
                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.only(left:0.0,top: 0.0),
                              child: Container(
                              width: 280,
                              height: 21,
                              color: Colors.transparent,
                              child:  Text(snapshot.data.docs[index]["Date"].toString()+" "+"at"+' '+
                                      snapshot.data.docs[index]["Time"].toString(),
                                      style: new TextStyle(fontSize:20.0,color: Colors.redAccent),),
                            ),
                          ),
                          Padding(
                           padding:EdgeInsets.only(left:0.0,top: 5.0),
                           child: Container(
                         height: 90.0,
                         width: 90.0,
                          child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image: snapshot.data.docs[index]['url']),
                          ),
                          ),
                          SizedBox(
                          height: 10,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
              
              )));   
          });
           }));
       } 
}