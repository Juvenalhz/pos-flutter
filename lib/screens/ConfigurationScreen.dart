import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigurationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuracion"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
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
        ),
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.black)),
              child: Column(
                children: <Widget>[
                  Text(
                    'Comercio',
                    textAlign: TextAlign.left,
                  ),
                  ListTile(
                    title: Text('title'),
                    subtitle: Text('subtitle'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('title'),
                    subtitle: Text('subtitle'),
                  ),
                ],
              ),
            )),
      ]),
    );
  }
}
