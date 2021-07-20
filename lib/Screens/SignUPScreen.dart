import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup_ui/Screens/HomeScreen.dart';

import 'HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  String username;
  //FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('asset/img/signup.jpg'))),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.person), onPressed: null),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(right: 20, left: 10),
                              child: TextFormField(
                                controller: nameController,
                                decoration:
                                    InputDecoration(hintText: 'Username'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter User Name';
                                  }
                                  return null;
                                },
                              ))),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.mail), onPressed: null),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(right: 20, left: 10),
                              child: TextFormField(
                                controller: emailController,
                                decoration:
                                    InputDecoration(hintText: 'Enter Email id'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter an Email Address';
                                  } else if (!value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                   username= emailController.text;
                                  return null;
                                },
                              )))
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.lock), onPressed: null),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(right: 20, left: 10),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    )),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Password';
                                  } else if (value.trim().length < 6) {
                                    return 'Password must be atleast 6 characters!';
                                  }
                                  return null;
                                },
                              )))
                    ],
                  ),
                ),
                //re-enter password by me
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.lock), onPressed: null),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(right: 20, left: 10),
                              child: TextFormField(
                                controller: retypePasswordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                    hintText: 'Re-Enter Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    )),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Re-enter Password';
                                  } else if (value.trim() !=
                                      passwordController.text.trim()) {
                                    return 'Passwords didn\'t match. Please re-enter password.';
                                  }
                                  return null;
                                },
                              )))
                    ],
                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          color: Colors.teal,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              registerToEmail();
                              Navigator.pushNamed(context, 'Home');
                            }
                          },
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                ),
              ],
            ),
          )),
    );
  }

//added by me
  void registerToEmail() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User user = userCredential.user;
      //FirebaseAuth.instance.currentUser;
      if (user != null) {
        // added "await" Nov 1,2020. new method to update user profile
        user.updateProfile(displayName: nameController.text.trim());
       Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
        );
      }
    } catch (err) {
      isLoading = false;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('asset/img/signup.png'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              )),
        ],
      )),
    );
  }
}
