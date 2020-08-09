import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'dart:io';
import 'package:pay/models/merchant.dart';
import 'package:pay/utils/testConfig.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDev = (const String.fromEnvironment('dev') == 'true');
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          ExpansionTile(title: Text("Reportes"), leading: Icon(Icons.receipt), children: <Widget>[
            _createDrawerItem(
              icon: Icons.calendar_view_day,
              text: 'Reporte Resumen',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.contacts)
            ),
            _createDrawerItem(
              icon: Icons.receipt,
              text: 'Reporte Detallado',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.contacts)
            ),
            _createDrawerItem(
              icon: Icons.room_service,
              text: 'Reporte Meseros',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.contacts)
            ),
          ]),
          Divider(),
          _createDrawerItem(
            icon: Icons.repeat,
            text: 'Reimpresion',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.notes)
          ),
          Divider(),
          _createDrawerItem(icon: Icons.account_balance, text: 'Cierre De Lote'),
          Divider(),
          ExpansionTile(title: Text("Menu Tecnico"), leading: Icon(Icons.settings), children: <Widget>[
            _createDrawerItem(text: 'Inicializacion', onTap: () => Navigator.pushNamed(context, '/initialization')),
            _createDrawerItem(text: 'Borrar Lote'),
            _createDrawerItem(text: 'Borrar Reverso'),
            _createDrawerItem(text: 'Reporte de Parametros'),
            _createDrawerItem(text: 'Configuracion', onTap: () => Navigator.pushNamed(context, '/configuration')),
          ]),
          if (isDev)
            _createDrawerItem(
              icon: Icons.bug_report,
              text: 'Inicializacion De Pruebas',
              onTap: () async {
                await testConfig().createTestConfiguration();
                merchantBloc.add(GetMerchant(1));
                Navigator.of(context).pop();
              },
            ),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);

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
            top: 10.0,
            left: 95.0,
            child: BlocBuilder<MerchantBloc, MerchantState>(builder: (context, state) {
              if (state is MerchantLoaded) {
                if ((state.merchant.Logo != null) && (state.merchant.Logo.length > 0)) {
                  return GestureDetector(
                      onTap: () {
                        selectFile(context, state.merchant);
                      },
                      child: CircleImage(state.merchant.Logo, 2));
                } else {
                  return GestureDetector(
                      onTap: () {
                        selectFile(context, state.merchant);
                      },
                      child: CircleImage('assets/images/logo.jpg', 1));
                }
              } else
                return CircleImage('assets/images/logo.jpg', 1);
            }),
          ),
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: BlocBuilder<MerchantBloc, MerchantState>(builder: (context, state) {
              if (state is MerchantLoaded) {
                return Text(state.merchant.nameL1, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500));
              } else {
                return Text(' ', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500));
              }
            }),
          )
        ]));
  }

  Widget _createDrawerItem({IconData icon, String text, GestureTapCallback onTap}) {
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

  Future<void> selectFile(BuildContext context, Merchant merchant) async {
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);

    File file = await FilePicker.getFile(type: FileType.image);
    merchant.Logo = file.path;
    merchant.id = 1;
    merchantBloc.add(UpdateMerchant(merchant));
  }
}

class CircleImage extends StatelessWidget {
  String image;
  int imageType;

  CircleImage(this.image, this.imageType);

  @override
  Widget build(BuildContext context) {
    double _size = 100.0;
    Image img;

    if (this.imageType == 1)
      img = new Image.asset(
        this.image,
        height: 70,
        width: 70,
      );
    else if (this.imageType == 2) img = new Image.file(File(this.image), height: 200, width: 200);

    return Container(
        width: _size,
        height: _size,
        decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: img.image,
            )));
  }
}
