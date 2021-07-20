import 'dart:async';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signup_ui/Screens/Maps.dart';
import 'HomeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

class Savelocation extends StatefulWidget {
  Savelocation({this.username});
  final String username;
  @override
  _HomepageState createState() => _HomepageState();
}

class NewObject {
  final String title;
  final IconData icon;

  NewObject(this.title, this.icon);
}

class _HomepageState extends State<Savelocation> {
  _HomepageState({this.username});
  String username = FirebaseAuth.instance.currentUser.email;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  GoogleMapController googleMapController;
  BitmapDescriptor icon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  TextEditingController location = TextEditingController();
  TextEditingController details = TextEditingController();
  DateTime _currentdate = new DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay picker;
  Position position;
  String _hour, _minute, _time;
  String addressLocation = '';
  String country;
  String postalCode;
  String user;
  String _formattime;
  String _formattedate;
  String imgurl;
  String crime;
  String _myActivity;
  GeoPoint _latitude;
  int reportid;
  String report;
  //String _myActivityResult;
  //String details;
  File galleryFile;

  CollectionReference imgRef;
  CollectionReference refer;
  double val = 0;
  var images_captured = List<Widget>();

  List<File> images = [];
  // images.add(await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 20););

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(title: "crimelocation", snippet: 'Address : $addressLocation'),
        draggable: true,
        onDragEnd: (dragEndPostion) {});
    setState(() {
      markers[markerId] = _marker;
    });
  }

  Future<void> retrieveLostData() async {
    final LostData response = (await ImagePicker.retrieveLostData()) as LostData;
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        images.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future showdialog(BuildContext context, String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext build) => new AlertDialog(
              title: new Text(message),
              actions: <Widget>[
                new FlatButton(
                    splashColor: Colors.teal,
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      upload();
                    },
                    child: new Text('Ok')),
                new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("Cancel"))
              ],
            ));
  }

  Future showdialog2(BuildContext context, String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext build) => new AlertDialog(
              title: new Text(message),
              actions: <Widget>[
                new FlatButton(
                    splashColor: Colors.teal,
                    onPressed: () {
                      upload2();
                    },
                    child: new Text('Ok'))
              ],
            ));
  }

  Future upload() async {
    //List<String> _imageUrls = List();
    String username = FirebaseAuth.instance.currentUser.email;
    int i = 1;
    for (var img in images) {
      setState(() {
        val = i / images.length;
      });
      final Reference storageReference = FirebaseStorage().ref().child("multiple2/$img}");
      await storageReference.putFile(img).whenComplete(() async {
        await storageReference.getDownloadURL().then((value) {
          imgRef.doc('$reportid').set({
            'url': value,
            'name': username,
            "user address": user,
            "Crime Location": addressLocation,
            "latitude": _latitude,
            "Date": _formattedate,
            "Time": _formattime,
            "Details": details.text,
            "crime": _myActivity,
          });
          i++;
        });
      });
      showdialog2(context, "your Report has been recorded.");
    }
  }

  void upload2() async {
    String username = FirebaseAuth.instance.currentUser.email;
    int i = 1;
    for (var img in images) {
      setState(() {
        val = i / images.length;
      });
      final Reference storageReference = FirebaseStorage().ref().child("multiple2/$img}");
      await storageReference.putFile(img).whenComplete(() async {
        await storageReference.getDownloadURL().then((value) {
          FirebaseFirestore.instance.collection('$username').add({
            'url': value,
            'Report ID': reportid,
            'name': username,
            "user address": user,
            "Crime Location": addressLocation,
            "latitude": _latitude,
            "Date": _formattedate,
            "Time": _formattime,
            "Details": details.text,
            "crime": _myActivity,
          }).then((_) {
            Fluttertoast.showToast(msg: 'success', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Maps(username: username)),
            );
          });
          i++;
        });
      });
    }
  }

  //display image selected from gallery
  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    images.add(File(galleryFile?.path));
    print("You selected gallery image : " + galleryFile.path);
    setState(() {});
  }

  //display image selected from camera
  imageSelectorCamera() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      //maxHeight: 50.0,
      //maxWidth: 50.0,
    );
    images.add(File(galleryFile?.path));
    //print("You selected camera image : " + cameraFile.path);
    setState(() {});
  }

  Future<Null> _selectdate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        initialDate: _currentdate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2021),
        context: context,
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (_seldate != null) {
      setState(() {
        _currentdate = _seldate;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _formattime = _time;
        _formattime = formatDate(DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute), [hh, ':', nn, " ", am]).toString();
      });
  }

  static final List<NewObject> items = <NewObject>[
    NewObject('Apple', Icons.mail),
    NewObject('Banana', Icons.mail),
    NewObject('Orange', Icons.account_balance_wallet),
    NewObject('Other Fruit', Icons.account_box),
  ];
  NewObject value = items.first;
  //String crime = items.first as String;

  Widget button3() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          markers.clear();
          addressLocation = '';
        });
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.location_off,
        size: 30.0,
      ),
    );
  }

  Widget buildDropdown() => Container(
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
          border: Border.all(color: Colors.grey[300]),
        ),
        child: DropDownFormField(
          titleText: 'Crime',
          hintText: 'select a crime',
          value: _myActivity,
          onSaved: (value) {
            setState(() {
              _myActivity = value;
            });
          },
          onChanged: (value) {
            setState(() {
              _myActivity = value;
            });
          },
          dataSource: [
            {
              "display": "SUSPICIOUS ACTIVITY",
              "value": "SUSPICIOUS ACTIVITY",
            },
            {
              "display": "PROPERTY CRIME",
              "value": "PROPERTY CRIME",
            },
            {
              "display": "MURDER",
              "value": "MURDER",
            },
            {
              "display": "DRUG CRIME",
              "value": "DRUG CRIME",
            },
            {
              "display": "ACCIDENT",
              "value": "ACCIDENT",
            },
            {
              "display": "ROBBERY",
              "value": "ROBBERY",
            },
            {
              "display": "MISSING OR WANTED",
              "value": "MISSING OR WANTED",
            },
            {
              "display": "OTHER CRIMES",
              "value": "OTHER CRIMES",
            },
          ],
          textField: 'display',
          valueField: 'value',
        ),
      );

  void _getCurrentLocation() async {
    Position currentPosition = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
    upload();
    _selectdate(context);
    _formattime = formatDate(DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [hh, ':', nn, " ", am]).toString();
    imgRef = FirebaseFirestore.instance.collection('users');
    var list = new List<int>.generate(10000000, (int index) => index);
    list.shuffle();
    reportid = list[0];
  }

  @override
  Widget build(BuildContext context) {
    _formattedate = new DateFormat.yMMMd().format(_currentdate);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Report',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 35.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 300.0,
                  child: GoogleMap(
                      mapType: MapType.normal,
                      onTap: (tapped) async {
                        final coordinated = new Coordinates(tapped.latitude, tapped.longitude);

                        var address = await Geocoder.local.findAddressesFromCoordinates(coordinated);
                        var firstAddress = address.first;
                        country = firstAddress.countryName;
                        postalCode = firstAddress.postalCode;
                        addressLocation = firstAddress.addressLine;
                        getMarkers(tapped.latitude, tapped.longitude);
                        _latitude = new GeoPoint(tapped.latitude, tapped.longitude);
                        final coord = new Coordinates(position.latitude, position.longitude);
                        var address1 = await Geocoder.local.findAddressesFromCoordinates(coord);
                        var firstAddress1 = address1.first;
                        user = firstAddress1.addressLine;
                        /*  await Firestore.instance
                        .collection('location')
                        .add({
                      'latitude': tapped.latitude,
                      'longitude': tapped.longitude,
                      'User Address': firstAddress1.addressLine,
                      'Crime Location': firstAddress.addressLine,
                      'Country': firstAddress.countryName,
                      'PostalCode': firstAddress.postalCode
                    }); */
                      },
                      compassEnabled: true,
                      trafficEnabled: false,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        setState(
                          () {
                            googleMapController = controller;
                          },
                        );
                      },
                      initialCameraPosition: CameraPosition(target: LatLng(11.75954897, 79.76633952), zoom: 14.0),
                      markers: Set<Marker>.of(markers.values)),
                ),

                //Text('User Address : $user',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                //Text('Crime location: $addressLocation',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
                //Text('PostalCode : $postalCode'),
                //Text('Country : $country',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.0))
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 40.0),
                  child: Align(
                    // alignment: Alignment.topRight,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 6, left: 6),
                                child: TextFormField(
                                  enabled: false,
                                  focusNode: FocusNode(),
                                  enableInteractiveSelection: false,
                                  controller: location..text = '$addressLocation',
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.location_on),
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: 'Mark location',
                                    fillColor: Colors.grey[300],
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Mark crime location on above map', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
                                    }
                                    return null;
                                  },
                                ))),
                        Padding(
                          padding: EdgeInsets.only(right: 7.0, top: 0.0),
                          child: Align(
                            // alignment: Alignment(0.0),
                            child: Column(
                              children: <Widget>[
                                button3(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 20.0),
                  child: Align(
                    // alignment: Alignment(0.0),
                    child: Row(
                      children: <Widget>[
                        FlatButton.icon(
                          height: 45,
                          onPressed: () {
                            _selectdate(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.grey[300],
                          // filled: true,
                          icon: Icon(Icons.calendar_today),
                          label: Text('Date: $_formattedate '),
                          // Text('Date: $_formattedate ')
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 0.0),
                          child: Align(
                            // alignment: Alignment(0.0),
                            child: Row(
                              children: <Widget>[
                                FlatButton.icon(
                                  height: 45,
                                  minWidth: 170,
                                  onPressed: () {
                                    _selectTime(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.grey[300],
                                  // filled: true,
                                  icon: Icon(Icons.alarm),
                                  label: Text('Time: $_formattime'),
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
                Padding(
                  padding: EdgeInsets.only(left: 13.0, top: 15.0, right: 13.0),
                  child: Align(
                    // alignment: Alignment(0.0),
                    child: Column(
                      children: <Widget>[buildDropdown()],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 13.0, top: 15.0, right: 13.0),
                  child: Align(
                    // alignment: Alignment(0.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          controller: details,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300]),
                            ),
                            hintText: 'Add details...',
                            fillColor: Colors.grey[300],
                            filled: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please give detail ';
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Align(
                    // alignment: Alignment(0.0),
                    child: Row(
                      children: <Widget>[
                        FlatButton.icon(
                          height: 45,
                          minWidth: 170,
                          onPressed: () {
                            imageSelectorGallery();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.black,
                          // filled: true,
                          icon: Icon(Icons.add_photo_alternate),
                          textColor: Colors.white,
                          label: Text('GALLERY'),
                          // Text('Date: $_formattedate ')
                        ),
                        SizedBox(width: 30),
                        FlatButton.icon(
                          height: 45,
                          minWidth: 170,
                          onPressed: () {
                            imageSelectorCamera();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.black,
                          // filled: true,
                          icon: Icon(Icons.add_a_photo),
                          textColor: Colors.white,
                          label: Text('CAMERA'),
                          // Text('Date: $_formattedate ')
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Add 1 photo about incident for proof!'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 150,
                  child: GridView.count(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 5,
                    crossAxisCount: 3,
                    children: List.generate(images.length, (index) {
                      return Column(children: <Widget>[
                        Container(
                            height: 100,
                            width: 125,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              child: Image.file(images[index], fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              images.removeAt(index);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Icon(Icons.clear, color: Colors.black, size: 30),
                            ),
                          ),
                        ),
                      ]);
                    }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 0.0),
                  child: Align(
                    // alignment: Alignment(0.0),
                    child: Row(
                      children: <Widget>[
                        FlatButton.icon(
                          height: 45,
                          minWidth: 170,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              showdialog(context, "Are you sure you want to submit");
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.black,
                          // filled: true,
                          icon: Icon(Icons.save),
                          textColor: Colors.white,
                          label: Text('save'),
                          // Text('Date: $_formattedate ')
                        ),
                        SizedBox(width: 30),
                        FlatButton.icon(
                          height: 45,
                          minWidth: 170,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.black,
                          // filled: true,
                          icon: Icon(Icons.cancel),
                          textColor: Colors.white,
                          label: Text('cancel'),
                          // Text('Date: $_formattedate ')
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // color: Colors.grey[300],
          ),
        )));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget displaySelectedFile(File file) {
    return new SizedBox(
      height: 200.0,
      width: 300.0,
//child: new Card(child: new Text(''+galleryFile.toString())),
//child: new Image.file(galleryFile),
      child: file == null ? new Text('Sorry nothing selected!!') : new Image.file(file),
    );
  }
}
