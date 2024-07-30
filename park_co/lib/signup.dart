// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:park_co/login.dart';
import 'package:park_co/mainpage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _glsignin = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  Future<void> _handleSignIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final GoogleSignInAccount? googleUser = await _glsignin.signIn();
      // Navigate to the desired page on successful sign-in
      print("got something working soldier\n\n\n\n$googleUser");
      if (googleUser != null) {
        // _user = googleUser;
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        final AuthCredential authCred = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(authCred);
        // ignore: use_build_context_synchronously
        //route to ypur page.
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Mainpage(),
            ));
      } else {
        // Handle sign-in error
        print('Sign-in was not successful.');
        // ignore: use_build_context_synchronously
      }
    } catch (error) {
      // Handle sign-in error

      print('Error signing in with Google: $error');
      showErrorDialog(context, "error occured in loggin in with Google");

      throw (error) {
        showErrorDialog(context, "error occured in loggin in with Google");
      };
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                          duration: Duration(seconds: 1),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1300),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color.fromRGBO(143, 148, 251, 1)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1)))),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email or Phone number",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                ),
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: TextButton(
                            onPressed: () {
                              //
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Mainpage(),
                                  ));
                            },
                            child: Text(
                              'Sign Up',
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 70,
                    ),
                    ElevatedButton(
                      onPressed: _handleSignIn,
                      child: Text("Sign up Wirh gl"),
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 2000),
                        child: TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => Signin(),
                          )),
                          child: Text(
                            "Already have an account? sign in",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
