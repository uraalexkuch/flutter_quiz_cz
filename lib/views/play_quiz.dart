import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:testcz/models/question_model.dart';
import 'package:testcz/services/database.dart';
import 'package:testcz/views/result.dart';
import 'package:testcz/widgets/quiz_play_widget.dart';
import 'package:testcz/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  PlayQuiz(this.quizId);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

Stream? infoStream;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService _databaseService = new DatabaseService();
  late QuerySnapshot? querySnapshot;

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
    questionModel.question = questionSnapshot["question"];

    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];

    questionModel.correctOption = questionSnapshot["correctAnswer"];
    questionModel.correctAnswer = questionSnapshot["correctAnswer"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    _databaseService.getQuestionData(widget.quizId).then((value) {
      querySnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = querySnapshot!.docs.length;
      _isLoading = false;
      setState(() {});
    });

    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        return [_correct, _incorrect];
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: _isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Container(
                  width: 100.w,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      querySnapshot!.docs == null
                          ? Container(
                              width: 95.w,
                              child: Center(
                                child: Text("No Question Available",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.red)),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: querySnapshot!.docs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 100.w,
                                  child: QuizPlayTile(
                                    questionModel: getQuestionModelFromSnapshot(
                                        querySnapshot!.docs[index]),
                                    index: index,
                                  ),
                                );
                              })
                    ],
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done_outline_sharp),
          onPressed: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Results(
                        correct: _correct,
                        incorrect: _incorrect,
                        total: total)));
          },
        ),
      ));
    });
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel? questionModel;
  final int? index;
  QuizPlayTile({this.questionModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Q${widget.index! + 1} ${widget.questionModel!.question}",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  if (!widget.questionModel!.answered) {
                    if (widget.questionModel!.option1 ==
                        widget.questionModel!.correctOption) {
                      optionSelected = widget.questionModel!.option1;
                      widget.questionModel!.answered = true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    } else {
                      optionSelected = widget.questionModel!.option1;
                      widget.questionModel!.answered = true;
                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    }
                  }
                },
                child: OptionTile(
                    option: "A",
                    description: widget.questionModel!.option1,
                    correctAnswer: widget.questionModel!.correctAnswer,
                    optionSelected: optionSelected),
              ),
              SizedBox(
                height: 4,
              ),
              GestureDetector(
                onTap: () {
                  if (!widget.questionModel!.answered) {
                    if (widget.questionModel!.option2 ==
                        widget.questionModel!.correctOption) {
                      optionSelected = widget.questionModel!.option2;
                      widget.questionModel!.answered = true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    } else {
                      optionSelected = widget.questionModel!.option2;
                      widget.questionModel!.answered = true;
                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    }
                  }
                },
                child: Container(
                  child: OptionTile(
                      option: "B",
                      description: widget.questionModel!.option2,
                      correctAnswer: widget.questionModel!.correctAnswer,
                      optionSelected: optionSelected),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              GestureDetector(
                onTap: () {
                  if (!widget.questionModel!.answered) {
                    if (widget.questionModel!.option3 ==
                        widget.questionModel!.correctOption) {
                      optionSelected = widget.questionModel!.option3;
                      widget.questionModel!.answered = true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    } else {
                      optionSelected = widget.questionModel!.option3;
                      widget.questionModel!.answered = true;
                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    }
                  }
                },
                child: OptionTile(
                    option: "C",
                    description: widget.questionModel!.option3,
                    correctAnswer: widget.questionModel!.correctAnswer,
                    optionSelected: optionSelected),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 20,
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
