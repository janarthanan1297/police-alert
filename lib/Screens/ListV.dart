
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup_ui/Screens/CrimeFeed.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signup_ui/Screens/Edit.dart';
import 'package:signup_ui/Screens/Maps.dart';
import 'HomeScreen.dart';

class ListV extends StatefulWidget {
  User user = FirebaseAuth.instance.currentUser;
  String username;
  ListV({username});
  @override
  _HomepageState createState() => _HomepageState();
} 

class _HomepageState extends State<ListV> {
String crime;
String username = FirebaseAuth.instance.currentUser.email;
final List<Widget> _children = [
    HomeScreen(),
    Maps(),
    ListV(),
    CrimeFeed(),
  ];
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Timeline',
     style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
      ),
    centerTitle: true,),
    drawer: NavigateDrawer(uid: widget.username),
     bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[300],
        color: Colors.teal,
        buttonBackgroundColor: Colors.teal,
        height: 50,
        items:<Widget>[
          Icon(Icons.home,size: 20,color: Colors.white,),
          Icon(Icons.add_location,size: 20,color: Colors.white,),
          Icon(Icons.timeline,size: 20,color: Colors.white,),
          Icon(Icons.dynamic_feed,size: 20,color: Colors.white,),
        ],
        animationDuration: Duration(milliseconds: 200),
        index:2,
        onTap: (index){
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _children[index]),
              );
        },
      ),
    body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection(username).snapshots(),
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
              
              child: InkWell(
                 onTap:() {
                   Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Edit(index)),
              );
                 },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Container(
            //alignment: Alignment.centerLeft,
            color: Colors.grey[300],
            child: Padding(
            padding: EdgeInsets.only(left:10.0,top: 20.0),
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
                          Text(snapshot.data.docs[index]["crime"].toString()+",",style: new TextStyle(fontSize:21.0,fontWeight:FontWeight.bold),),
                          Padding(
                              padding:EdgeInsets.only(left:0.0,top: 0.0),
                               child: Container(
                              width: 280,
                              child: Text(snapshot.data.docs[index]["Crime Location"].toString()+',',style: new TextStyle(fontSize:18.0,fontWeight:FontWeight.normal),),
                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.only(left:0.0,top: 0.0),
                              child: Container(
                              width: 280,
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
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  )
                 /*  Text(document["crime"].toString()+",",style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold),),
                  Text(document["Crime Location"].toString()+',',style: new TextStyle(fontSize:20.0),),
                  Text(document["Date"].toString()+" "+"at"+' '+
                  document["Time"].toString(),
                  style: new TextStyle(fontSize:20.0,color: Colors.redAccent),), */
                ],
              )
              
              )));   
          });
           }));
       } 
}