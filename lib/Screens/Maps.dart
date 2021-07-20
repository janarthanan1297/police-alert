import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signup_ui/Screens/CrimeFeed.dart';
import 'package:signup_ui/Screens/ListV.dart';
import 'package:signup_ui/Screens/Savelocation.dart';
import 'HomeScreen.dart';


class Maps extends StatefulWidget {
  Maps({this.username});
  final String username;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Maps> {  
 _HomepageState({this.username});
  String username;           
  GoogleMapController googleMapController;
  BitmapDescriptor icon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MapType _currentMapType = MapType.normal;
  Position position;
  String addressLocation;
  String country;
  String postalCode;
  String user;

  final List<Widget> _children = [
    HomeScreen(),
    Maps(),
    ListV(),
    CrimeFeed(),
  ];

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(
           title: "crimelocation",
          snippet: 'Address : $addressLocation'),
          //draggable: true,
          //onDragEnd:(dragEndPostion){}
          );
    setState(() {
      markers[markerId] = _marker;
      
    });
    
  }
   _onMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }
   Widget button1() {
    return FloatingActionButton(
      onPressed:(){
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Savelocation(username: username)),
        );
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.add_location,
        size: 30.0,
      ),
    );
  }
  
  void _getCurrentLocation() async {
    Position currentPosition = await GeolocatorPlatform.instance.getCurrentPosition();
     
    setState(() {
      position = currentPosition;
      build(context);
    });
     final coord = new Coordinates(position.latitude, position.longitude);
                      var address1 = await Geocoder.local.findAddressesFromCoordinates(coord);
                       var firstAddress1 = address1.first;
                       user = firstAddress1.addressLine;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _onMapType();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
     title: Text('Crime Report',
     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
     ),
      ),
      drawer: NavigateDrawer(uid: widget.username),
       bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.teal,
        buttonBackgroundColor: Colors.teal,
        height: 50,
        items:<Widget>[
          Icon(Icons.home,size: 20,color: Colors.white,),
          Icon(Icons.add_location,size: 20,color: Colors.white,),
          Icon(Icons.timeline,size: 20,color: Colors.white,),
          Icon(Icons.dynamic_feed,size: 20,color: Colors.white,),
        ],
        index: 1,
        animationDuration: Duration(milliseconds: 200),
        onTap: (index){
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _children[index]),
              );
        },
      ),
      body: Stack(
          children: <Widget>[
               GoogleMap(
                  zoomControlsEnabled: false,
                mapType: MapType.normal,
                        //compassEnabled: true,
                         trafficEnabled: false,
                         myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                         setState(() {
                          googleMapController = controller;
                            },
                            );
                   
                             },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(11.75954897,79.76633952),
                      zoom: 13.0),
                  markers: Set<Marker>.of(markers.values)
                  ),
               
             
           // Text('User Address : $user',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
           // Text('Crime location: $addressLocation',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
            //Text('PostalCode : $postalCode'),
            //Text('Country : $country',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.0))
        
             Padding(
              padding: EdgeInsets.only(left:310.0,top: 580.0),
              child: Align(
               // alignment: Alignment(0.0),
                child: Column(
                  children: <Widget>[
                    button1(),
                  ],
                ),
              ),
            ),
          ],
       
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}