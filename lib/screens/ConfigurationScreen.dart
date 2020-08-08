import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'components/title_section_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/bloc.dart';
import 'package:pay/bloc/merchant_bloc.dart';

class ConfigurationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
        body: ListView(children: <Widget>[
          TitleSectionForm(title: 'Comercio'),
          BlocBuilder<MerchantBloc, MerchantState>(
            builder: (context, state) {
              Widget retWidget = SizedBox();
              if (state is MerchantLoaded) {
                retWidget = Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Nombre del Comercio'),
                        subtitle: Text('${state.merchant.nameL1}\n'
                            '${state.merchant.nameL2}'),
                        isThreeLine: true,
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Ciudad del Comercio'),
                        subtitle: Text(state.merchant.City),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Código de Comercio'),
                        subtitle: Text(state.merchant.MID),
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          Container(
                            width: size.width / 2.18,
                            child: ListTile(
                              title: Text('RIF del Comercio'),
                              subtitle: Text(state.merchant.TaxID),
                            ),
                          ),
                          Container(
                            width: size.width / 2.18,
                            child: ListTile(
                              title: Text('Número de Terminal'),
                              subtitle: Text(state.merchant.TID),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          Container(
                            width: size.width / 2.18,
                            child: ListTile(
                              title: Text('Código Moneda'),
                              subtitle:
                                  Text(state.merchant.CurrencyCode.toString()),
                            ),
                          ),
                          Container(
                            width: size.width / 2.18,
                            child: ListTile(
                              title: Text('Símbolo de Moneda'),
                              subtitle: Text(state.merchant.CurrencySymbol),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          Container(
                            width: size.width / 2.18,
                            child: ListTile(
                              title: Text('Código Adquiriente'),
                              subtitle: Text(state.merchant.AcquirerCode),
                            ),
                          ),
                          Container(
                            width: size.width / 2.18,
                            child: ListTile(
                              title: Text('Código de País'),
                              subtitle:
                                  Text(state.merchant.CountryCode.toString()),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Versión de la Aplicación'),
                        subtitle: Text(state.merchant.id.toString()),
                      ),
                    ],
                  ),
                );
              }
              return retWidget;
            },
          ),
          TitleSectionForm(title: 'Terminal'),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
//                        borderRadius: BorderRadius.circular(10.0),
//                        border: Border.all(color: Colors.black)
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('title'),
                      subtitle: Text('subtitle'),
                      dense: true,
                    ),
                    Divider(),
                    ListTile(
                      title: Text('title'),
                      subtitle: Text('subtitle'),
                    ),
                  ],
                ),
              )),
          TitleSectionForm(title: 'Comunicacion'),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
//                        borderRadius: BorderRadius.circular(10.0),
//                        border: Border.all(color: Colors.black)
                ),
                child: Column(
                  children: <Widget>[
                    dataTile('dataTile Title1', 'dataTile value',
                        TextInputType.text),
                    //Divider(),
                    dataTile('dataTile Title2', 'dataTile value',
                        TextInputType.number),
                    //Divider(),
                    dataTile('dataTile Title3', 'dataTile value',
                        TextInputType.text),
                    //Divider(),
                    onOffTile('on / off', 1),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}

Widget dataTile(String myTitle, String value, TextInputType type) {
  return ListTile(
    title: TextFormField(
      keyboardType: type,
      validator: (String newValue) {
        if (newValue.isEmpty) {
          return 'Este campo no puede estar vacio';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: myTitle,
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      initialValue: value,
      onSaved: (String newValue) {
        value = newValue;
      },
    ),
    //dense: true,
  );
}

Widget onOffTile(String myTitle, int value) {
  return SwitchListTile(
    title: Text(myTitle),
    value: (value == 1) ? true : false,
  );
}

bool isIP(String str) {
  RegExp _ipv4Maybe =
      new RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');

  if (!_ipv4Maybe.hasMatch(str)) {
    return false;
  }

  var parts = str.split('.');
  parts.sort((a, b) => int.parse(a) - int.parse(b));
  return int.parse(parts[3]) <= 255;
}

Widget ipAddressTile(String myTitle, String value) {
  return ListTile(
    title: TextFormField(
      keyboardType: TextInputType.number,
      validator: (String newValue) {
        if (newValue.isEmpty) {
          return 'Este campo no puede estar vacio';
        }
        if (!isIP(newValue)) return 'La direccion IP es invalida';

        return null;
      },
      decoration: InputDecoration(
        labelText: myTitle,
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      initialValue: value,
      onSaved: (String newValue) {
        value = newValue;
      },
    ),
    //dense: true,
  );
}
