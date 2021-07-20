import 'package:flutter/material.dart';
class AdminLogin extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<AdminLogin> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  String username;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN"),
        centerTitle: true,
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
                        image: AssetImage('asset/img/admin.jpg'))),
              ),
              SizedBox(
                height: 50,
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
                                  InputDecoration(hintText: 'Enter Admin-id'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Email Address';
                                } 
                               // username= emailController.text;
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
              SizedBox(
                height: 20,
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  void logInToEmail() {
      if(emailController.text == "police" && passwordController.text == 'password')
      {
        Navigator.pushNamed(context, 'admin');
      }
      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text('Incorrect username and password'),
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