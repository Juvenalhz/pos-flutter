import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';

class AskNumeric extends StatelessWidget {
  final String title1;
  final String title2;
  final String name;
  final int min;
  final int max;
  Function(BuildContext, int) onClickEnter;
  Function(BuildContext) onClickBack;

  AskNumeric(this.title1, this.title2, this.name, this.min, this.max, this.onClickEnter, this.onClickBack);

  @override
  Widget build(BuildContext context) {
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
                  Positioned(
                    left: 6,
                    top: 6,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        this.onClickBack(context);
                      },
                    ),
                  ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  this.title1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                ),
                                Text(
                                  this.title2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                ),
                              ],
                            ),
                          ))),
                ]),
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
                child: NumericEntry(this.name, min, max, onClickEnter),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}

class NumericEntry extends StatefulWidget {
  final String entryText;
  final int min;
  final int max;
  Function(BuildContext, int) onClickEnter;

  NumericEntry(this.entryText, this.min, this.max, this.onClickEnter);

  @override
  _NumericEntryState createState() => _NumericEntryState(entryText, min, max, onClickEnter);
}

class _NumericEntryState extends State<NumericEntry> {
  String amount = '';
  final int min;
  final int max;

  var textControllerInput = new TextEditingController(text: '');
  //var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);
  String entryText;
  Function(BuildContext, int) onClickEnter;

  _NumericEntryState(this.entryText, this.min, this.max, this.onClickEnter);

  @override
  Widget build(BuildContext context) {
    textControllerInput.text = amount;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 17.0),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
              child: Text(
                entryText,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'RobotoMono',
                ),
              ),
            )
          ],
        ),
        new Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30.0, 0),
            child: new TextField(
              decoration: new InputDecoration.collapsed(
                  hintText: '',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'RobotoMono',
                  )),
              style: TextStyle(fontSize: 33, fontFamily: 'RobotoMono', fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              controller: textControllerInput,
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            )),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            btn('7', Colors.grey[200]),
            btn('8', Colors.grey[200]),
            btn('9', Colors.grey[200]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            btn('4', Colors.grey[200]),
            btn('5', Colors.grey[200]),
            btn('6', Colors.grey[200]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            btn('1', Colors.grey[200]),
            btn('2', Colors.grey[200]),
            btn('3', Colors.grey[200]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            btn('0', Colors.grey[200]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            btnClear(),
            btnEnter(),
          ],
        ),
        SizedBox(
          height: 5.0,
        )
      ],
    );
  }

  Widget btn(btntext, Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: btnColor)
        ),
        child: Text(
          btntext,
          style: TextStyle(fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'),
        ),
        onPressed: () {
          setState(() {
            String formattedAmount;

            if (amount.length < this.max) {
              amount = amount + btntext;

              // if (amount.length >= 2)
              //   formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
              // else if (amount.length == 2)
              //   formattedAmount = '0.' + amount;
              // else
              //   formattedAmount = '0.0' + amount;
              //
              // textControllerInput.text = formatter.format(double.parse(formattedAmount));
              textControllerInput.text = amount;
            }
          });
        },
        color: btnColor,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        //shape: CircleBorder(),
      ),
    );
  }

  Widget btnClear() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: FlatButton(
        child: Icon(Icons.backspace, size: 35, color: Colors.blueGrey),
        onPressed: () {
          String formattedAmount;

          amount = (amount.length > 0) ? (amount.substring(0, amount.length - 1)) : "";

          // if (amount.length >= 2)
          //   formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
          // else if (amount.length == 2)
          //   formattedAmount = '0.' + amount;
          // else
          //   formattedAmount = '0.0' + amount;
          //
          // textControllerInput.text = formatter.format(double.parse(formattedAmount));
          textControllerInput.text = amount;
        },
        color: Colors.amberAccent,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  Widget btnEnter() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {
          if ((amount.length > 0) && (amount.length >= this.min)) {
            this.onClickEnter(context, int.parse(amount));
            amount = '';
          }
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
