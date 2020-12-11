import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pay/bloc/acquirerBloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_event.dart';
import 'package:pay/bloc/deleteReversal/delete_reversal_bloc.dart';
import 'package:pay/bloc/emv/emv_bloc.dart';
import 'package:pay/bloc/emv/emv_event.dart';
import 'package:pay/bloc/initialization/initialization_bloc.dart';
import 'package:pay/bloc/lastSale/last_sale_bloc.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'package:pay/bloc/terminal/terminal_bloc.dart';
import 'package:pay/bloc/terminal/terminal_event.dart';
import 'dart:io';
import 'package:pay/models/merchant.dart';
import 'package:pay/utils/testConfig.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pay/bloc/echotestBloc.dart';


class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDev = (const String.fromEnvironment('dev') == 'true');
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
    final TerminalBloc terminalBloc = BlocProvider.of<TerminalBloc>(context);
    final CommBloc commBloc = BlocProvider.of<CommBloc>(context);
    final EmvBloc emvBloc = BlocProvider.of<EmvBloc>(context);
    final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          ExpansionTile(
              title: Text("Reportes"),
              leading: Icon(Icons.receipt),
              children: <Widget>[
                _createDrawerItem(
                  //icon: Icons.calendar_view_day,
                  text: 'Reporte Resumen',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.contacts)
                ),
                _createDrawerItem(
                  //icon: Icons.receipt,
                  text: 'Reporte Detallado',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.contacts)
                ),
                _createDrawerItem(
                  //icon: Icons.room_service,
                  text: 'Reporte Meseros',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.contacts)
                ),
                _createDrawerItem(
                  //icon: Icons.repeat,
                  text: 'Reimpresión',
//              onTap: () =>
//                  Navigator.pushReplacementNamed(context, Routes.notes)
                ),
              ]),
          Divider(),
          _createDrawerItem(
              icon: Icons.sync, text: 'Prueba De Comunicación', onTap: () {
              final EchoTestBloc echoTestBloc = BlocProvider.of<EchoTestBloc>(context);

              echoTestBloc.add(EchoTestInitialEvent());
              Navigator.pushNamed(context, '/EchoTest');
          }),
          Divider(),
          ExpansionTile(title: Text("Menu De Comercio"), leading: Icon(Icons.account_balance), children: <Widget>[
            _createDrawerItem(
                text: 'Consulta Ultima Venta', onTap: () {
                final LastSaleBloc lastSaleBloc = BlocProvider.of<LastSaleBloc>(context);

                lastSaleBloc.add(LastSaleInitialEvent());
                Navigator.pushNamed(context, '/LastSale');
            }),
            _createDrawerItem(
                text: 'Cierre De Lote'),
            _createDrawerItem(text: 'Borrar Lote'),
            _createDrawerItem(
                text: 'Cambio De Adquiriente', onTap: () =>
                Navigator.pushNamed(context, '/SelectAcquirer')),

          ]),


          Divider(),
          ExpansionTile(title: Text("Menu Técnico"), leading: Icon(Icons.settings), children: <Widget>[
            _createDrawerItem(text: 'Configuracion', onTap: () {
              acquirerBloc.add(GetAllAcquirer());
              Navigator.pushNamed(context, '/configuration');
            }),
            _createDrawerItem(text: 'Reporte de Parametros'),
            _createDrawerItem(
                text: 'Inicialización',
                onTap: () {
                  final InitializationBloc initializationBloc = BlocProvider.of<InitializationBloc>(context);

                  initializationBloc.add(InitializationInitialEvent());
                  Navigator.pushNamed(context, '/initialization');
                }),
            _createDrawerItem(text: 'Borrar Reverso', onTap: () async{
              final DeleteReversalBloc deleteReversalBloc = BlocProvider.of<DeleteReversalBloc>(context);

              deleteReversalBloc.add(DeleteReversalPending());
              Navigator.pushNamed(context, '/deleteReversal');
            }),
            _createDrawerItem(
                text: 'Conformidad De Visita'),
          ]),
          if (isDev)
            _createDrawerItem(
              icon: Icons.bug_report,
              text: 'Inicializacion De Pruebas',
              onTap: () async {
                await TestConfig().createTestConfiguration();
                merchantBloc.add(GetMerchant(1));
                terminalBloc.add(GetTerminal(1));
                commBloc.add(GetComm(1));
                emvBloc.add(GetEmv(1));
                acquirerBloc.add(GetAcquirer(1));
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
            child: BlocBuilder<MerchantBloc, MerchantState>(
                builder: (context, state) {
              if (state is MerchantLoaded) {
                if ((state.merchant.logo != null) && (state.merchant.logo.length > 0)) {
                  return GestureDetector(
                      onTap: () {
                        showPicker(context, state.merchant);
                      },
                      child: CircleImage(state.merchant.logo, 2));
                } else {
                  return GestureDetector(
                      onTap: () {
                        showPicker(context, state.merchant);
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
            child: BlocBuilder<MerchantBloc, MerchantState>(
                builder: (context, state) {
              if (state is MerchantLoaded) {
                return Text(state.merchant.nameL1, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500));
              } else {
                return Text(' ', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500));
              }
            }),
          )
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

  Future<void> selectFile(BuildContext context, Merchant merchant) async {
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
    final OldPath = merchant.logo.isEmpty ? null : merchant.logo;
    File result = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: result.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Editar foto',
              cropFrameColor: Colors.blue,
              activeControlsWidgetColor: Colors.blue));
      String nameImage = (croppedFile.path.split("/")[5]);
      final folderImageLogo = new Directory('/data/data/com.lccnet.pay/Logo');
      await folderImageLogo.exists().then((isThere) {
        if (isThere) {
          croppedFile
              .copy(folderImageLogo.path + '/'+nameImage);
        } else {
          folderImageLogo.create(recursive: true).then((value) {
            croppedFile.copy(folderImageLogo.path + '/'+nameImage);
          });
        }
      });
      merchant.logo = File(folderImageLogo.path + '/'+nameImage).path;
      merchant.id = 1;
      merchantBloc.add(UpdateMerchant(merchant));
      merchantBloc.add(GetMerchant(1));
     // OldPath != null ? DeteleFile(OldPath)  ;
      if (OldPath != null ) {
        DeteleFile(OldPath);
        }
    }
  }

  void DeteleFile(dirPath) async {
    final dir = Directory(dirPath);
    dir.deleteSync(recursive: true);
  }

  Widget showPicker(context, val) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                   ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Galeria'),
                      onTap: () {
                        selectFile(context, val);
                        Navigator.pop(context);
                      }),
                   ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Cámara'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CircleImage extends StatelessWidget {
  final String image;
  final int imageType;

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
    else if (this.imageType == 2)
      img = new Image.file(File(this.image), height: 200, width: 200);

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
