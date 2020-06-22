import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _hight;
  bool test = true;
  String amount = '0';
  var textControllerInput =  TextEditingController(text: '0,00');
  var formatter = new NumberFormat.currency(locale: 'eu', symbol:' ', decimalDigits: 2);


  @override
  Widget build(BuildContext context) {
    if (test)
      _hight = 100.0;
    else
      _hight = 200.0;


    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: 12),
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  print('menu selected');
                },
              ),
            ),
            stretch: true,
            onStretchTrigger: () {
              // Function callback for stretch
              return;
            },
            expandedHeight: _hight,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: true,
              title: const Text('Store Name'),
              background: Stack(
                fit: StackFit.expand,
                children: [
//                  Image.network(
//                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
//                    fit: BoxFit.cover,
//                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.5),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Text(
                          "Monto:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'RobotoMono',
                          ),
                        )
                      ],
                    ),
                    new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: new TextField(
                          decoration: new InputDecoration.collapsed(
                              hintText: "0",
                              hintStyle: TextStyle(
                                fontSize: 40,
                                fontFamily: 'RobotoMono',
                              )),
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'RobotoMono',
                          ),
                          textAlign: TextAlign.right,
                          controller: textControllerInput,
                          onTap: () => FocusScope.of(context)
                              .requestFocus(new FocusNode()),
                        )),
                    SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        btn('7', Colors.white),
                        btn('8', Colors.white),
                        btn('9', Colors.white),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        btn('4', Colors.white),
                        btn('5', Colors.white),
                        btn('6', Colors.white),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        btn('1', Colors.white),
                        btn('2', Colors.white),
                        btn('3', Colors.white),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(height: 20.0, width: 90.0,),
                        //btn000(Colors.white),
                        btn('0', Colors.white),
                        btn00(Colors.white),
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
                      height: 10.0,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget btn(btntext, Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(
          btntext,
          style: TextStyle(
              fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'),
        ),
        onPressed: () {
          setState(() {
            String formattedAmount;

            if (amount.length < 15) {
              amount = amount + btntext;

              if (amount.length >= 2)
                formattedAmount = amount.substring(0, amount.length - 2) + '.' +
                    amount.substring(amount.length - 2);
              else if (amount.length == 2)
                formattedAmount = '0.' + amount;
              else
                formattedAmount = '0.0' + amount;

              textControllerInput.text =
                  formatter.format(double.parse(formattedAmount));
            }
          });
        },
        color: btnColor,
        padding: EdgeInsets.all(18.0),
        splashColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }


  Widget btn00(Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(
          "00",
          style: TextStyle(
              fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'),
        ),
        onPressed: () {
          setState(() {
            String formattedAmount;

            if (amount.length <= 13) {
              amount = amount + '00';

              if (amount.length >= 2)
                formattedAmount = amount.substring(0, amount.length - 2) + '.' +
                    amount.substring(amount.length - 2);
              else if (amount.length == 2)
                formattedAmount = '0.' + amount;
              else
                formattedAmount = '0.0' + amount;

              textControllerInput.text =
                  formatter.format(double.parse(formattedAmount));
            }
          });
        },
        color: btnColor,
        padding: EdgeInsets.all(18.0),
        splashColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }

  Widget btn000(Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Text(
          "000",
          style: TextStyle(
              fontSize: 28.0, color: Colors.black, fontFamily: 'RobotoMono'),
        ),
        onPressed: () {
          setState(() {
            String formattedAmount;

            if (amount.length <= 12) {
              amount = amount + '000';

              if (amount.length >= 2)
                formattedAmount = amount.substring(0, amount.length - 2) + '.' +
                    amount.substring(amount.length - 2);
              else if (amount.length == 2)
                formattedAmount = '0.' + amount;
              else
                formattedAmount = '0.0' + amount;

              textControllerInput.text =
                  formatter.format(double.parse(formattedAmount));
            }
          });
        },
        color: btnColor,
        padding: EdgeInsets.all(18.0),
        splashColor: Colors.black,
        shape: CircleBorder(),
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

          amount = (amount.length > 0)
              ? (amount.substring(0, amount.length - 1))
              : "";

          if (amount.length >= 2)
            formattedAmount = amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
          else if (amount.length == 2)
            formattedAmount = '0.' + amount;
          else
            formattedAmount = '0.0' + amount;

          textControllerInput.text = formatter.format( double.parse(formattedAmount));
        },
        color: Colors.amberAccent,
        padding: EdgeInsets.all(18.0),
        splashColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }

  Widget btnEnter() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {},
        color: Colors.green,
        padding: EdgeInsets.all(18.0),
        splashColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}
