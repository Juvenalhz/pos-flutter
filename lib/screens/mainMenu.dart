import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDev = (const String.fromEnvironment("dev").contains('true') );
    isDev = true;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          _createHeader(),

          _createDrawerItem(
              icon: Icons.receipt,
              text: 'Reportes Detallado',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.contacts)
          ),
          _createDrawerItem(
              icon: Icons.calendar_view_day,
              text: 'Reporte Resumen',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.events)
          ),
          _createDrawerItem(
              icon: Icons.repeat,
              text: 'Reimpresion',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.notes)
          ),
          Divider(),
          _createDrawerItem(icon: Icons.account_balance, text: 'Cierre De Lote'),
          Divider(),
          _createDrawerItem(icon: Icons.settings, text: 'Menu Tecnico'),
          if(isDev) _createDrawerItem(icon: Icons.bug_report, text: 'Inicializacion Manual'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
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
              bottom: 12.0,
              left: 16.0,
              child: Text("Flutter Step-by-Step",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}