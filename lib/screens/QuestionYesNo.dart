import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionYesNo extends StatelessWidget {
  final String title;
  final String message;
  final Function(BuildContext) onClickEnter;
  final Function(BuildContext) onClickCancel;

  QuestionYesNo(this.title, this.message, this.onClickEnter, this.onClickCancel);

  @override
  Widget build(BuildContext context) {
    //final trans = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
          body: Column(
              children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    gradient: LinearGradient(
                      begin: Alignment(0.0, 0.6),
                      end: Alignment(0.0, 0.0),
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Colors.blue,
                      ],
                    ),
                  ),
                  child: Stack(children: <Widget>[
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  this.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                ),
                              ],
                            ),
                          )
                        )
                      )
                    ],
                  ),
                ),
                ]),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                      color: Color(0xFF0D47A1),
                    ),
                    Container(
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(flex: 1),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                this.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                            Spacer(flex: 1),

                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btnCancel(context), btnEnter(context)]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ]
                  )
                ),
              ],
            ),

        ),
      );

    }

  Widget btnCancel(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.cancel, size: 35, color: Colors.white),
        onPressed: () {
          this.onClickCancel(context);
        },
        color: Colors.red,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  Widget btnEnter(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {
          this.onClickEnter(context);
        },
        color: Colors.green,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }
}

