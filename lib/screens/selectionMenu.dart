import 'package:flutter/material.dart';

class SelectionMenu extends StatelessWidget {
  final String message;

  SelectionMenu(this.message);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      this.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                    color: Colors.green,
                    padding: EdgeInsets.all(15.0),
                    splashColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      //side: BorderSide(color: Colors.blueGrey)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
