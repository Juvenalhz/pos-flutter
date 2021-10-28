import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AskNumeric extends StatelessWidget {
  final String title1;
  final String title2;
  final String name;
  final int min;
  final int max;
  final Function(BuildContext, int) onClickEnter;
  final Function(BuildContext) onClickBack;
  final int separatorType;

  static const int DECIMALS = 0;
  static const int NO_DECIMALS = 1;
  static const int NO_SEPARATORS = 2;
  static const int ACCOUNT = 3;
  static const int EXP_DATE = 4;

  AskNumeric(this.title1, this.title2, this.name, this.min, this.max, this.separatorType, this.onClickEnter, this.onClickBack);

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
                  // Positioned(
                  //   left: 6,
                  //   top: 6,
                  //   child: IconButton(
                  //     color: Colors.white,
                  //     icon: Icon(Icons.arrow_back),
                  //     onPressed: () {
                  //       this.onClickBack(context);
                  //     },
                  //   ),
                  // ),
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
                child: new NumericEntry(this.name, this.min, this.max, this.separatorType, this.onClickEnter),
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
  final int separatorType;
  final Function(BuildContext, int) onClickEnter;

  NumericEntry(this.entryText, this.min, this.max, this.separatorType, this.onClickEnter);

  @override
  _NumericEntryState createState() => _NumericEntryState(this.entryText, this.min, this.max, this.separatorType, this.onClickEnter);
}

class _NumericEntryState extends State<NumericEntry> {
  String amount = '';
  final int min;
  final int max;
  final int separatorType;

  var textControllerInput = new TextEditingController(text: '');
  String entryText;
  final Function(BuildContext, int) onClickEnter;
  var _formatter;

  _NumericEntryState(this.entryText, this.min, this.max, this.separatorType, this.onClickEnter);

  @override
  Widget build(BuildContext context) {
    if (separatorType == AskNumeric.DECIMALS)
      _formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);
    else if (separatorType == AskNumeric.NO_DECIMALS) _formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 0);

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
              style: TextStyle(fontSize:(separatorType != AskNumeric.ACCOUNT) ?  33 : 27, fontFamily: 'RobotoMono', fontWeight: FontWeight.bold),
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
        ),
        child: Text(
          btntext,
          style: TextStyle(fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'),
        ),
        onPressed: () {
          setState(() {
            String formattedAmount;

            if ((separatorType == AskNumeric.NO_DECIMALS) && (amount.length == 0) && btntext == '0') {
              // in this case do nothing, leading zeros should be ignored
            } else if (amount.length < this.max) {
              amount = amount + btntext;

              if (separatorType == AskNumeric.DECIMALS) {
                if (amount.length >= 2)
                  formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
                else if (amount.length == 2)
                  formattedAmount = '0.' + amount;
                else
                  formattedAmount = '0.0' + amount;

                textControllerInput.text = _formatter.format(double.parse(formattedAmount));
              } else if (separatorType == AskNumeric.NO_DECIMALS)
                textControllerInput.text = _formatter.format(double.parse(amount + '.00'));
              else
                textControllerInput.text = amount;
            }
          });
        },
        color: btnColor,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
      ),
    );
  }

  Widget btnClear() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: FlatButton(
        child: Icon(Icons.backspace, size: 35, color: Colors.blueGrey),
        onPressed: () {
          //String formattedAmount;

          amount = (amount.length > 0) ? (amount.substring(0, amount.length - 1)) : "";

          textControllerInput.text = amount;
        },
        color: Colors.amberAccent,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
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

          if (( (this.separatorType == AskNumeric.DECIMALS) && (amount.length > 0 && amount.length >= this.min &&  int.parse(amount) > this.min)) ||
          ((this.separatorType != AskNumeric.DECIMALS) && (amount.length >= this.min && amount.length <= this.max))){
            this.onClickEnter(context, int.parse(amount));
            deactivate();
          } else {
            final snackBarAmount = SnackBar(
              content: Text('Valor Debe Ser Mayor a ' + this.min.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
              duration: Duration(seconds: 1),
            );
            final snackBarNumber = SnackBar(
              content: Text('Longitud Mínima Es ' + (this.min > 0 ? this.min : this.min + 1).toString(),
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
              duration: Duration(seconds: 1),
            );

            if (this.separatorType == AskNumeric.DECIMALS)
              Scaffold.of(context).showSnackBar(snackBarAmount);
            else
              Scaffold.of(context).showSnackBar(snackBarNumber);
          }
        },
        color: Colors.green,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class AskLast4 extends AskNumeric {
  AskLast4(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}

class AskCVV extends AskNumeric {
  AskCVV(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}

class AskID extends AskNumeric {
  AskID(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}

class AskServer extends AskNumeric {
  AskServer(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}

class AskVisitType extends AskNumeric {
  AskVisitType(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}

class AskRequirementType extends AskNumeric {
  AskRequirementType(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}

class AskAccountNumber extends AskNumeric {
  AskAccountNumber(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}

class AskExpirationDate extends AskNumeric {
  AskExpirationDate(String title1, String title2, String name, int min, int max, int separatorType, Function(BuildContext p1, int p2) onClickEnter,
      Function(BuildContext p1) onClickBack)
      : super(title1, title2, name, min, max, separatorType, onClickEnter, onClickBack);
}