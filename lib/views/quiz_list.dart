import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:testcz/services/database.dart';
import 'package:testcz/views/edit_quiz.dart';
import 'package:testcz/widgets/widgets.dart';

class QuizList extends StatefulWidget {
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  late Stream<QuerySnapshot<Object?>>? quizStream;

  DatabaseService _databaseService = new DatabaseService();

  bool _isLoading = true;

  Widget quizList() {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
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
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return QuizEditTile(
                          imageUrl:
                              snapshot.data.docs[index].data()["quizImgUrl"],
                          title: snapshot.data.docs[index].data()["quizTitle"],
                          description: snapshot.data.docs[index]
                              .data()["quizDescription"],
                          quizId: snapshot.data.docs[index].data()["quizId"]);
                    });
          },
        ),
      );
    });
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: appBar(context),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 10.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : quizList(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQuiz()));
      //   },
      // ),
    ));
  }
}

class QuizEditTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizEditTile(
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
          return EditQuiz(quizId);
        }));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Expanded(
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(imageUrl,
                      width: MediaQuery.of(context).size.width - 48,
                      fit: BoxFit.cover)),
              Container(
                width: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(description,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        softWrap: true),
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
