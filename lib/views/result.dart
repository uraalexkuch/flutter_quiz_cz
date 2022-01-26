import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:testcz/views/home.dart';
import 'package:testcz/views/play_quiz.dart';
import 'package:testcz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final fireStore = FirebaseFirestore.instance;

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  Results(
      {required this.correct, required this.incorrect, required this.total});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late String userId;
  final _auth = FirebaseAuth.instance;
  late double summit;
  void getResult() async {
    var fireBaseUser = await _auth.currentUser!;
    int all = widget.total;
    int res = widget.correct;
    double summit = (res / all) * 100;
    userId = fireBaseUser.uid;
    print(double.parse((summit).toStringAsFixed(2)));
    // int correct = Results as int;
    await fireStore
        .collection("User")
        .doc('$userId')
        .update({'result': double.parse((summit).toStringAsFixed(2))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  void initState() {
    int all = widget.total;
    int res = widget.correct;
    double summit = (res / all) * 100;
    print(summit);
    getResult();
    super.initState();
  }

  sum() {
    int all = widget.total;
    int res = widget.correct;
    double summit = (res / all) * 100;
    return summit;
  }

  resultPhrase() {
    String resultText;
    //   final percent = resultScore / 5 * 100;
    if (sum() >= 80) {
      resultText = 'Вітаємо!\n Відмінні знання!';
    } else if (sum() < 80 && sum() >= 60) {
      resultText = "Достатній рівень";
    } else if (sum() < 60 && sum() >= 40) {
      resultText = "Задовільний рівень";
    } else {
      resultText = "Незадовільно....";
    }
    print(resultText);
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('image/logodon.webp', height: 30.h, width: 30.w),
                Text(
                  "Правильні відповіді:${widget.correct}\n Загальна чисельність питань : ${widget.total}",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  resultPhrase(),
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 100,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: orangeButton(
                        context,
                        "Повернутися на головну",
                        MediaQuery.of(context).size.width / 2,
                        Colors.blueAccent)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
