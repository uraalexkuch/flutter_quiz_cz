import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  OptionTile(
      {required this.option,
      required this.description,
      required this.correctAnswer,
      required this.optionSelected});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.description == widget.optionSelected
                        ? widget.optionSelected == widget.correctAnswer
                            ? Colors.green.withOpacity(0.7)
                            : Colors.red.withOpacity(0.7)
                        : Colors.grey,
                    width: 1.5),
                color: widget.description == widget.optionSelected
                    ? widget.optionSelected == widget.correctAnswer
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                "${widget.option}",
                style: TextStyle(
                    color: widget.optionSelected == widget.description
                        ? widget.optionSelected == widget.correctAnswer
                            ? Colors.white
                            : Colors.white
                        : Colors.grey),
                softWrap: true,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 85.w,
              child: Text(
                "${widget.description}",
                style: TextStyle(fontSize: 20, color: Colors.black),
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class NumberOfQuestionTile extends StatefulWidget {
  final String text;
  final int number;

  NumberOfQuestionTile({required this.text, required this.number});

  @override
  _NumberOfQuestionTileState createState() => _NumberOfQuestionTileState();
}

class _NumberOfQuestionTileState extends State<NumberOfQuestionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                color: Colors.black54),
            child: Text(
              widget.text,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
