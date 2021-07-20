import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_ui/Screens/AdminLogin.dart';
import 'package:signup_ui/Screens/CrimeFeed.dart';
import 'package:signup_ui/main.dart';
import 'ListV.dart';
import 'Maps.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  User user = FirebaseAuth.instance.currentUser;
   String username;
   HomeScreen({this.username});
  @override
  HomeState createState() => new HomeState(this.username);
}

class HomeState extends State<HomeScreen>  {
  String username;
  HomeState(this.username);


  final List<Widget> _children = [
    HomeScreen(),
    Maps(),
    ListV(),
    CrimeFeed(),
  ];
  
  var name = '';
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    
     toolbarHeight: 60,
     centerTitle: true,
     title: Text('Home',
     style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
      ),
      ),
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
        onTap: (index){
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _children[index]),
              );
        },
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
           child: Center(child: Text(
                "Find Crime in Your Neighborhood",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start,
              ),),
           height: 250.0,
           width: MediaQuery.of(context).size.width - 0.0,
           decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5),
           color: Colors.grey[300],
           image: DecorationImage(
                image: AssetImage('asset/img/map.jpg'),
          fit: BoxFit.fill
              )
                 ),
              ),
              Container(
                child: Padding(
                padding: EdgeInsets.only(right:1.0,top: 20.0),
                child: Text(
                "What is police Alert ?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              )),
           height: 70.0,
           width: 550,
           color: Colors.white,
              ),
              Container(
              alignment: Alignment.center,
           height: 100.0,
           width: MediaQuery.of(context).size.width - 0.0,
           
           decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5),
           color: Colors.white,
           image: DecorationImage(
                image: AssetImage('asset/img/logo.png'),
          fit: BoxFit.fitHeight
              )
                 ),
              ),
               Container(
                child: Padding(
                  padding: EdgeInsets.only(left:15.0,top: 25.0,right: 3),
                child: Text(
                "Police Alert is a public facing crime map and crime alert service. With Police Alert, it’s easier than ever to check crime anywhere.\n  \n Our goal is to provide the most accurate and timely crime information to the public.\n ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal
                ),
              ),),
           height: 250.0,
           width: MediaQuery.of(context).size.width - 0.0,
            color: Colors.white,
              ),
              Container(
                child: Padding(
                padding: EdgeInsets.only(right:1.0,top: 10.0),
                child: Text(
                "How it Work",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              )),
           height: 50.0,
           width: 550,
           color: Colors.grey[300],
              ),
              Container(
              alignment: Alignment.center,
           height: 100.0,
           width: MediaQuery.of(context).size.width - 0.0,
           
           decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5),
           color: Colors.grey[300],
           image: DecorationImage(
                image: AssetImage('asset/img/settings.png'),
          fit: BoxFit.fitHeight
              )
                 ),
              ),
             Container(
                child: Padding(
                  padding: EdgeInsets.only(left:15.0,top: 10.0),
                child: Text(
                "We collect relevant crime data from police agencies and validated sources to plot it on a Google map.\n  \n We also analyze crime trends in your neighborhood and allow you to search for crime near any address.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal
                ),
              ),),
           height: 210.0,
           width: MediaQuery.of(context).size.width - 0.0,
            color: Colors.grey[300]
              ),
              Container(
                child: Padding(
                padding: EdgeInsets.only(right:1.0,top: 10.0),
                child: Text(
                "Why Trust Police Alert",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              )),
           height: 50.0,
           width: 550,
           color: Colors.white,
              ),
              Container(
              alignment: Alignment.center,
           height: 100.0,
           width: MediaQuery.of(context).size.width - 0.0,
           
           decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5),
           color: Colors.white,
           image: DecorationImage(
                image: AssetImage('asset/img/trust.png'),
          fit: BoxFit.fitHeight
              )
                 ),
              ),
             Container(
                child: Padding(
                  padding: EdgeInsets.only(left:20.0,top: 10.0,right: 3),
                child: Text(
                "Police Alert is 100% independent.\n  \nWith free access to basic crime alerts we hope to encourage public trust, increase police transparency, and promote public safety.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal
                ),
              ),),
           height: 180.0,
           width: MediaQuery.of(context).size.width - 0.0,
            color: Colors.white
              ),
              Container(
                child: Padding(
                padding: EdgeInsets.only(right:1.0,top: 10.0),
                child: RaisedButton(shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(18.0),
                         side: BorderSide(color: Colors.teal)),
                         textColor: Colors.white,
                         color: Colors.teal,
                         child: Text("Report Crime",
                          style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          Navigator.push(
                          context,
                         MaterialPageRoute(
                      builder: (context) => Maps(username: username)),
              );
                        },)
                ),
           height: 70.0,
           width: 550,
           color: Colors.white,
              ),
              SizedBox(height: 40,)
          ],
        )
      )
    );
  }
  
}
class NavigateDrawer extends StatefulWidget {
  User user = FirebaseAuth.instance.currentUser;
  final String uid;
  NavigateDrawer({Key key, this.uid}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  String username = FirebaseAuth.instance.currentUser.email;  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.grey[300],
            child: Padding(
            padding: EdgeInsets.only(left:20.0,top: 70.0,bottom: 10.0),
            child: CircleAvatar(
             backgroundColor: Colors.teal,
             radius: 50,
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
           height: 85,
           color: Colors.grey[300],
           padding: EdgeInsets.only(left:20.0,top:10.0),
           child: Text(username,style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold)),
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.home, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Home'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(username: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.add_location, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Crime Report'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Maps(username: widget.uid)),
              );
            },
          ),
           ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.timeline, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Timeline'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListV(username: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.dynamic_feed, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Crime Feed'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CrimeFeed(username: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Sign Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.admin_panel_settings, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Admin'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminLogin()),
              );
            },
          ),
        ],
      ),
    );
  }
}
