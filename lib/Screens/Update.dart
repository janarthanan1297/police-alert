import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signup_ui/Screens/Admin.dart';
import 'package:signup_ui/Screens/Update.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ListV.dart';
//import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class Update extends StatelessWidget {
  final int index;
  Update(this.index);
//Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
List<Marker> allMarkers = [];
String crime;
String crimelocation;
String date;
String time;
String details;
String image;
String report;
GeoPoint _latitude;
String username;
String user;

delete(String i){
  FirebaseFirestore.instance.collection('user')
  .doc(i)
  .delete().then((_){
  Fluttertoast.showToast(msg:'success',
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM
  );
 return;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("UPDATE REPORT"),
    centerTitle: true,
    ),
    body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection('users').snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
         if(!snapshot.hasData){
           return CircularProgressIndicator();
         }
          //report = snapshot.data.docs[index]["Report ID"].toString();
          crime = snapshot.data.docs[index]["crime"].toString();
          crimelocation = snapshot.data.docs[index]["Crime Location"].toString();
          date = snapshot.data.docs[index]["Date"].toString();
          time = snapshot.data.docs[index]["Time"].toString();
          image =snapshot.data.docs[index]["url"].toString();
          details = snapshot.data.docs[index]["Details"].toString();
          _latitude= new GeoPoint(snapshot.data.docs[index]["latitude"].latitude,snapshot.data.docs[index]["latitude"].longitude);
          user = snapshot.data.docs[index]["user address"].toString();
          username = snapshot.data.docs[index]["name"].toString();

         allMarkers.add(new Marker(
          markerId: MarkerId('1'),
         // width: 45.0,
          //height: 45.0,
          position: new LatLng(snapshot.data.docs[index]["latitude"].latitude,snapshot.data.docs[index]["latitude"].longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        ));
        return SingleChildScrollView(
         child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 250,
               child: GoogleMap(
                 zoomGesturesEnabled: false,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                initialCameraPosition: CameraPosition(
                      target: LatLng(11.75954897, 79.76633952),
                      zoom: 15.0),
              markers: Set<Marker>.of(allMarkers),
              )
              ),
              SizedBox(height: 10,),
              Container(
             padding: EdgeInsets.only(left:0.0,top: 10.0),
               color: Colors.grey[300],
               width: 500,
              
              child:Card(
              shadowColor: Colors.transparent,
              margin: EdgeInsets.only(left:20.0,top: 0.0),
              color: Colors.grey[300],
             child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
             Text(snapshot.data.docs[index]["crime"].toString()+",",style: new TextStyle(fontSize:25.0,fontWeight:FontWeight.bold)),
            Text(snapshot.data.docs[index]["Date"].toString()+" "+"at"+' '+snapshot.data.docs[index]["Time"].toString()+'.',style: new TextStyle(fontSize:20.0,color: Colors.red,fontWeight:FontWeight.bold),),
            Text(snapshot.data.docs[index]["Crime Location"].toString()+'.',style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold)),
           
           ])
            )),
            SizedBox(height: 10,),
             Container(
            padding: EdgeInsets.only(left:0.0,top: 10.0),
            color: Colors.white,
            width: 500,
           
            child:Card(
            shadowColor: Colors.transparent,
            margin: EdgeInsets.only(left:20.0,top: 0.0),
           color: Colors.white,
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
           Text(snapshot.data.docs[index]["Details"].toString()+".",style: new TextStyle(fontSize:24.0,fontWeight:FontWeight.normal,color: Colors.grey[600],)),
           ])
          )),
                   Container(
                        alignment: Alignment.center,
                         height: 230.0,
                         width: 700.0,
                          child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image: snapshot.data.docs[index]['url']),
                        ),
                        SizedBox(
                           height: 10,
                        ),
                        Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                         Container(
                          height: 90,
                         alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Padding(
                        padding: EdgeInsets.only(left:10.0,top: 0.0),
                        child: CircleAvatar(
                         backgroundColor: Colors.teal,
                        radius: 40,
                         child: Image(
                         image: AssetImage('asset/img/user.png'),
                         height: 90,
                         width: 90,
                         fit: BoxFit.cover,
                         )
                         )
                         ),
                        ),
                        Container(
                       height: 90,
                       width: 300,
                      color: Colors.grey[300],
                         padding: EdgeInsets.only(left:10.0,top:20.0),
                       child: Text(snapshot.data.docs[index]["name"].toString()+",",style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold),),
                      ),
                ]),
                         Container(
                child:  Padding(
                      padding: EdgeInsets.only(left:35.0,top: 20.0),
                       child: Align(
                      // alignment: Alignment(0.0),
                      child: Row(
                      children: <Widget>[
                       FlatButton.icon(
                       height: 45,
                       minWidth: 150,
                       onPressed: (){
                         FirebaseFirestore.instance.collection('crimefeed').add({
                            'url': image,
                           'name': username,
                           "user address": user,
                           "Crime Location": crimelocation,
                           "latitude": _latitude,
                          "Date": date,
                          "Time": time,
                          "Details": details,
                          "crime": crime,
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Admin()),);
                      Fluttertoast.showToast(msg:'updated successfully',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM);
                       },
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        ),
                       color: Colors.teal,
                             // filled: true,
                       icon: Icon(Icons.update),
                       textColor: Colors.white,
                       label: Text('Update',style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold),),
                      // Text('Date: $_formattedate ')
                       ),
                        Padding(
                      padding: EdgeInsets.only(left:30.0,top: 0.0),
                       child: Align(
                      // alignment: Alignment(0.0),
                      child: Row(
                      children: <Widget>[
                       FlatButton.icon(
                       height: 45,
                       minWidth: 150,
                       onPressed: (){
                           FirebaseFirestore.instance.collection('users')
                          .doc(snapshot.data.docs[index].id).delete().then((_){
                        Fluttertoast.showToast(msg:'Report deleted',
                       toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM
                            );
                           Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Admin()),
                     );
                        });
                       },
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        ),
                       color: Colors.teal,
                             // filled: true,
                       icon: Icon(Icons.delete_outline),
                       textColor: Colors.white,
                       label:Text('Delete',style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold),),
                      // Text('Date: $_formattedate ')
                       )
                     ],
                  ),
                 ),
               ),
                     ],
                  ),
                 ),
               ),
           height: 70.0,
           width: 550,
           color: Colors.white,
              ),
              SizedBox(height: 40,)
            ],
          ),
        ));
       
       }));
}
}