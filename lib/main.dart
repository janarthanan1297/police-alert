import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:signup_ui/Screens/Admin.dart';
import 'package:signup_ui/Screens/AdminLogin.dart';
import 'package:signup_ui/Screens/CrimeFeed.dart';
import 'package:signup_ui/Screens/Landing.dart';
import 'package:signup_ui/Screens/Maps.dart';
import 'package:signup_ui/Screens/HomeScreen.dart';
import 'package:signup_ui/Screens/ListV.dart';
import 'package:signup_ui/Screens/savelocation.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/SignInScreen.dart';
import 'Screens/SignUPScreen.dart';
import 'Screens/Maps.dart';
import 'package:flutter/services.dart';
import 'module/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // new for Firebase Auth
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: Colors.transparent,
       statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
   return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Authentication(),
        )
      ],
      child: MaterialApp(
      title: 'Police',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         primarySwatch: Colors.teal,
      ),
      //initialRoute: 'adminlogin',
      routes: {
        'SignIn':(context)=>SignInScreen(),
         'SignUp':(context)=>SignUpScreen(),
         'Home':(context)=>HomeScreen(username: user.email),
         'Map':(context)=>Maps(username: user.email),
         'Save':(context)=>Savelocation(),
         'list':(context)=>ListV(username: user.email),
         'land':(context)=>Landing(),
         'adminlogin':(context)=>AdminLogin(),
         'admin':(context)=>Admin(),
         'CrimeFeed':(context)=>CrimeFeed(username: user.email),
      },
      home: (user == null) ? Landing() : HomeScreen(username: user.email),
   ));
  }
}
