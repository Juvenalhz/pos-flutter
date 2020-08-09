import 'package:flutter/material.dart';

class CommProgress extends StatelessWidget {
  String title;
  String status;

  CommProgress(this.title, {this.status});

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
                  Text(
                    this.title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
            if (this.status != null)
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.blueGrey[800]),
                  child: Text(
                    this.status,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      backgroundColor: Colors.blueGrey[800],
                      color: Colors.white,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
