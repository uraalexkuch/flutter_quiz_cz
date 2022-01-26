import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:testcz/helper/functions.dart';
import 'package:testcz/services/auth.dart';
import 'package:testcz/views/home.dart';
import 'package:testcz/views/signin.dart';
import 'package:testcz/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, password;

  bool _isLoading = false;

  AuthService _authService = new AuthService();

  _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> userData = {
        "name": name,
        "email": email,
        "result": "",
        "type": "user",
        //'docID': ref.id,
      };

      await _authService.signUpWithEmailandPassword(email, password, userData)

          //.then({userData.})
          .then((value) {
        print(value);
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
                        decoration: InputDecoration(hintText: "Name"),
                        onChanged: (val) {
                          name = val;
                        },
                        validator: (val) {
                          return val!.isEmpty ? "Enter name" : null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Email"),
                        onChanged: (val) {
                          email = val;
                        },
                        validator: (val) {
                          return validateEmail(email)
                              ? null
                              : "Enter correct email";
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
                          return (val!.length < 6)
                              ? "Password length must be 6 characters"
                              : null;
                        },
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                          onTap: () {
                            _signUp();
                          },
                          child: orangeButton(
                              context,
                              "Запеєструватися",
                              MediaQuery.of(context).size.width - 48,
                              Colors.blue)),
                      SizedBox(height: 14),
                      SizedBox(height: 40.0)
                    ],
                  ),
                ),
              ),
      );
    });
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern as String);
  return (!regex.hasMatch(value)) ? false : true;
}
