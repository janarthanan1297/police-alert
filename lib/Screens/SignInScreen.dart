import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'HomeScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  String username;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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
                        image: AssetImage('asset/img/login.jpg'))),
              ),
              SizedBox(
                height: 20,
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
                              controller: emailController,
                              decoration:
                                  InputDecoration(hintText: 'Enter email-id'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Email Address';
                                } else if (!value.contains('@')) {
                                  return 'Please enter a valid email address!';
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
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters!';
                                }
                                return null;
                              },
                            ))),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: 
                     RaisedButton(
                        color: Colors.teal,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            logInToEmail();
                            
                          }
                         
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign in with Google",
                    onPressed: () async {
                      // sign in Google with a returning user profile
                      UserCredential userCredential = await signInWithGoogle();
                      Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
                     );
                    },
                  )),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'SignUp');
                },
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'SIGN UP',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void logInToEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
              // Navigator.pushNamed(context, 'Home');
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
        );
    } catch (err) {
      // updated Nov 1, 2020
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
    } //finally {
    //isLoading = false;
    //}
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}