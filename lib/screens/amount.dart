import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmountEntry extends StatefulWidget {
  final String entryText;
  Map<String, dynamic> trans;

  AmountEntry(this.entryText, this.trans);

  @override
  _AmountEntryState createState() => _AmountEntryState(entryText, trans);
}

class _AmountEntryState extends State<AmountEntry> {
  String amount = '0';
  var textControllerInput = TextEditingController(text: '0,00');
  var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);
  String entryText;
  Map<String, dynamic> trans;

  _AmountEntryState(this.entryText, this.trans);

  @override
  Widget build(BuildContext context) {
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
                  hintText: "0",
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'RobotoMono',
                  )),
              style: TextStyle(fontSize: 33, fontFamily: 'RobotoMono', fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              controller: textControllerInput,
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            )),
        SizedBox(height: 5.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 20.0,
              width: 90.0,
            ),
            //btn000(Colors.white),
            btn('0', Colors.grey[200]),
            btn00(Colors.grey[200]),
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
      padding: EdgeInsets.only(bottom: 10.0),
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

            if (amount.length < 15) {
              amount = amount + btntext;

              if (amount.length >= 2)
                formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
              else if (amount.length == 2)
                formattedAmount = '0.' + amount;
              else
                formattedAmount = '0.0' + amount;

              textControllerInput.text = formatter.format(double.parse(formattedAmount));
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

  Widget btn00(Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(
          "00",
          style: TextStyle(fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'),
        ),
        onPressed: () {
          setState(() {
            String formattedAmount;

            if (amount.length <= 13) {
              amount = amount + '00';

              if (amount.length >= 2)
                formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
              else if (amount.length == 2)
                formattedAmount = '0.' + amount;
              else
                formattedAmount = '0.0' + amount;

              textControllerInput.text = formatter.format(double.parse(formattedAmount));
            }
          });
        },
        color: btnColor,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  Widget btn000(Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(
          "000",
          style: TextStyle(fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'),
        ),
        onPressed: () {
          setState(() {
            String formattedAmount;

            if (amount.length <= 12) {
              amount = amount + '000';

              if (amount.length >= 2)
                formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
              else if (amount.length == 2)
                formattedAmount = '0.' + amount;
              else
                formattedAmount = '0.0' + amount;

              textControllerInput.text = formatter.format(double.parse(formattedAmount));
            }
          });
        },
        color: btnColor,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  Widget btnClear() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.backspace, size: 35, color: Colors.blueGrey),
        onPressed: () {
          String formattedAmount;

          amount = (amount.length > 0) ? (amount.substring(0, amount.length - 1)) : "";

          if (amount.length >= 2)
            formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
          else if (amount.length == 2)
            formattedAmount = '0.' + amount;
          else
            formattedAmount = '0.0' + amount;

          textControllerInput.text = formatter.format(double.parse(formattedAmount));
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
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {
          if (this.entryText.contains('Monto')) {
            this.trans.putIfAbsent('amount', () => int.parse(amount));
            Navigator.pushNamed(context, '/tip', arguments: trans);
          } else if (this.entryText.contains('Propina')) {
            this.trans.putIfAbsent('tip', () => int.parse(amount));
            Navigator.pushNamed(context, '/confirmation', arguments: trans);
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
