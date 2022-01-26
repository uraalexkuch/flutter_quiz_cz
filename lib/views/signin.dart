import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:testcz/helper/functions.dart';
import 'package:testcz/services/auth.dart';
import 'package:testcz/services/database.dart';
import 'package:testcz/views/home.dart';
import 'package:testcz/views/signup.dart';
import 'package:testcz/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;

  bool _isLoading = false;

  AuthService _authService = new AuthService();

  _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _authService.signInEmailandPassword(email, password).then((value) {
        if (value != null) {
          setState(() {
            _isLoading = false;
          });

          HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Image.asset('image/logodon.webp',
                          height: 20.h, width: 20.w),
                      Spacer(),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Email"),
                        onChanged: (val) {
                          email = val;
                        },
                        validator: (val) {
                          return val!.isEmpty ? "Enter email" : null;
                        },
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Password"),
                        obscureText: true,
                        onChanged: (val) {
                          password = val;
                        },
                        validator: (val) {
                          return val!.isEmpty ? "Enter password" : null;
                        },
                      ),
                      SizedBox(height: 24),
                      GestureDetector(
                          onTap: () {
                            _signIn();
                          },
                          child: orangeButton(
                              context,
                              "Увійти",
                              MediaQuery.of(context).size.width - 48,
                              Colors.amber)),
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: orangeButton(
                                  context,
                                  "Запеєструватися",
                                  MediaQuery.of(context).size.width - 48,
                                  Colors.blue))
                        ],
                      ),
                      SizedBox(height: 260.0)
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
