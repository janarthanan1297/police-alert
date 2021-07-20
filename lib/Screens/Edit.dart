import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signup_ui/Screens/Update.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ListV.dart';
//import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class Edit extends StatelessWidget {
   User user = FirebaseAuth.instance.currentUser;
  final int index;
  Edit(this.index);
//Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
List<Marker> allMarkers = [];
String crime;
String crimelocation;
String date;
String time;
String details;
String image;
String report;

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
  String username = FirebaseAuth.instance.currentUser.email;
  return Scaffold(
    appBar: AppBar(title: Text("REPORT"),
    centerTitle: true,
    actions: <Widget>[
    IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: Colors.white,
      ),
      onPressed: () {
         Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Update(index)),
              );
      },
      )
     ],
    ),
    body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection(username).snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
         if(!snapshot.hasData){
           return CircularProgressIndicator();
         }
          report = snapshot.data.docs[index]["Report ID"].toString();
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
           SizedBox(
             height: 10,
           )
           ])
            )),
            SizedBox(height: 10,),
             Padding(
                            padding:EdgeInsets.only(left:20.0,top: 0.0),
                              child: Container(
                              width:500,
                          //color: Colors.orange,
                              child:  Text(snapshot.data.docs[index]["Details"].toString()+".",style: new TextStyle(fontSize:24.0,fontWeight:FontWeight.normal,color: Colors.grey[600],)),
                            ),
                          ),
                          SizedBox(
                          height: 10,
                          ),
                  Padding(
                    padding:EdgeInsets.only(left:20.0,top: 0.0),
                  child: Container(
                        alignment: Alignment.centerLeft,
                         height: 230.0,
                         width: 350.0,
                          child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image: snapshot.data.docs[index]['url']),
                        )),
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
                       child: Text(username,style: new TextStyle(fontSize:20.0,fontWeight:FontWeight.bold)),
                      ),
                ]),
                         Container(
                child: Padding(
                padding: EdgeInsets.only(right:1.0,top: 15.0),
                child: RaisedButton(shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(18.0),
                         side: BorderSide(color: Colors.teal)),
                         textColor: Colors.white,
                         color: Colors.teal,
                         child: Text("Delete",
                          style: TextStyle(fontSize: 25)),
                        onPressed: () {
                         //String i= index as String;
                         print(snapshot.data.docs[index]);
                          FirebaseFirestore.instance.collection(username)
                          .doc(snapshot.data.docs[index].id).delete();
                      FirebaseFirestore.instance.collection('users')
                          .doc(report).delete().then((_){
                           Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListV(username: username)),);
                       Fluttertoast.showToast(msg:'Report deleted',
                       toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM );
                        });},)
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