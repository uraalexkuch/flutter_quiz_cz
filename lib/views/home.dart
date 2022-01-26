import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:testcz/helper/functions.dart';
import 'package:testcz/services/auth.dart';
import 'package:testcz/services/database.dart';
import 'package:testcz/views/play_quiz.dart';
import 'package:testcz/views/signin.dart';
import 'package:testcz/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot<Object?>>? quizStream;

  AuthService _authService = new AuthService();

  DatabaseService _databaseService = new DatabaseService();

  bool _isLoading = true;

  _signOut() async {
    await _authService.signOut().then((value) {
      HelperFunctions.saveUserTypeDetails(userType: "");
      HelperFunctions.saveUserLoggedInDetails(isLoggedIn: false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    });
  }

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<QuerySnapshot>(
        stream: quizStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot == null
              ? Container(
                  child: Center(
                      child: Text(
                    "No Quiz Available",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  )),
                )
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                        imageUrl:
                            snapshot.data.docs[index].data()["quizImgUrl"],
                        title: snapshot.data.docs[index].data()["quizTitle"],
                        description:
                            snapshot.data.docs[index].data()["quizDescription"],
                        quizId: snapshot.data.docs[index].data()["quizId"]);
                  });
        },
      ),
    );
  }

  @override
  void initState() {
    _databaseService.getQuizData().then((value) {
      setState(() {
        quizStream = value;
        _isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          actions: [
            IconButton(
                onPressed: () {
                  _signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.black87,
                ))
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: _isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : quizList(),
        /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),*/
      );
    });
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizTile(
      {required this.imageUrl,
      required this.title,
      required this.description,
      required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return PlayQuiz(quizId);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 8),
          height: 25.h,
          width: 25.w,
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: MediaQuery.of(context).size.width - 48,
                    fit: BoxFit.fill,
                  )),
              Container(
                width: 95.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black26),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(description,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400)),
                      Divider()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
