import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/bloc/merchant/merchant_state.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'package:pay/screens/components/data_tile.dart';
import 'components/checkbox_item.dart';
import 'components/item_tile_two_column.dart';
import 'components/title_section_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String value = 'dataTile value';
    TextInputType tNumber = TextInputType.number;
    TextInputType tText = TextInputType.text;

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
                // crear merchantmap local y le asigno la data del bloc
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
                      ListTile(
                        title: Text('Ciudad del Comercio'),
                        subtitle: Text(state.merchant.City),
                      ),
                      ListTile(
                        title: Text('Código de Comercio'),
                        subtitle: Text(state.merchant.MID),
                      ),
                      ItemTileTwoColumn(
                        leftLabel: Text('RIF del Comercio'),
                        rightLabel: Text('Número de Terminal'),
                        leftItem: Text(state.merchant.TaxID),
                        rightItem: Text(state.merchant.TID),
                        leftWidth: size.width / 2.18,
                        rightWidth: size.width / 2.18,
                      ),
                      ItemTileTwoColumn(
                        leftLabel: Text('Código Moneda'),
                        rightLabel: Text('Símbolo de Moneda'),
                        leftItem: Text(state.merchant.CurrencyCode.toString()),
                        rightItem: Text(state.merchant.CurrencySymbol),
                        leftWidth: size.width / 2.18,
                        rightWidth: size.width / 2.18,
                      ),
                      ItemTileTwoColumn(
                        leftLabel: Text('Código Adquiriente'),
                        rightLabel: Text('Código de País'),
                        leftItem: Text(state.merchant.AcquirerCode),
                        rightItem: Text(state.merchant.CountryCode.toString()),
                        leftWidth: size.width / 2.18,
                        rightWidth: size.width / 2.18,
                      ),
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
                child: Column(
                  children: <Widget>[
                    DataTile(myTitle: 'Clave Sistema', value: '000000', type: tNumber),
                    DataTile(myTitle: 'Mensaje Pin Pad', value: 'PLATCO'),
                    ItemTileTwoColumn(
                      contentPadding: EdgeInsets.zero,
                      leftLabel: DataTile(myTitle: 'Min. PIN', value: '4', type: tNumber),
                      rightLabel: DataTile(myTitle: 'Máx. PIN', value: '6', type: tNumber),
                      leftWidth: size.width / 2.5,
                      rightWidth: size.width / 2.5,
                    ),
                    ItemTileTwoColumn(
                      contentPadding: EdgeInsets.zero,
                      leftLabel: DataTile(myTitle: 'Master Key', value: '0', type: tNumber),
                      rightLabel: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tipo de Pin Pad'),
                            DropdownButton(
                              onChanged: (value) {},
                              items: <DropdownMenuItem<dynamic>>[],
                            ),
                          ],
                        ),
                      ),
                      leftWidth: size.width / 3.5,
                      rightWidth: size.width / 1.8,
                    ),
                    SizedBox(height: 10.0),
                    Divider(color: Colors.black54, thickness: 0.6),
                    ItemTileTwoColumn(
                      leftLabel: Text('Número de Lote'),
                      rightLabel: Text('Terminal ID'),
                      leftItem: Text('subtitle'),
                      rightItem: Text('00000000'),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ListTile(title: Text('Serial Terminal'), subtitle: Text('subtitle')),
                    ItemTileTwoColumn(
                      leftLabel: Text('Tiempo Max. Entrada'),
                      rightLabel: Text('Porcentaje Propina'),
                      leftItem: Text('20 Seg.'),
                      rightItem: Text('20 %'),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: Text('Tipo  Soft.'),
                      rightLabel: Text('Lectura de Track'),
                      leftItem: Text('Normal'),
                      rightItem: Text('Track 1 y Track 2'),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(label: 'Impresión', value: true, onChanged: null),
                      rightLabel: CheckboxItem(label: 'Cash back', value: false, onChanged: null),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(label: 'Cuotas', value: false, onChanged: null),
                      rightLabel: CheckboxItem(label: 'Devolución', value: false, onChanged: null),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(label: 'Cheque', value: false, onChanged: null),
                      rightLabel:
                          CheckboxItem(label: 'Check In/\nCheckOut', value: false, onChanged: null),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(label: 'CVV2', value: false, onChanged: null),
                      rightLabel:
                          CheckboxItem(label: '4 últimos\ndígitos', value: false, onChanged: null),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel:
                          CheckboxItem(label: 'Clave\nAnulación', value: false, onChanged: null),
                      rightLabel:
                          CheckboxItem(label: 'Clave Cierre', value: false, onChanged: null),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Clave\nDevolución',
                        value: true,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Enmascarar\nTarjeta',
                        value: true,
                        onChanged: null,
                      ),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(label: 'Pre-impresión', value: true, onChanged: null),
                      rightLabel: CheckboxItem(
                        label: 'Entrada\nManual PAN',
                        value: false,
                        onChanged: null,
                      ),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Confirmación\nde Importe',
                        value: true,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Ventas Fuera\nde Línea',
                        value: false,
                        onChanged: (v) {},
                      ),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    SizedBox(height: 18.0),
                  ],
                ),
              )),
          TitleSectionForm(title: 'Comunicacion'),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: BlocBuilder<CommBloc, CommState>(
                builder: (context, state) {
                  Widget retWidget = SizedBox();
                  if (state is CommLoaded) {
                    retWidget = Container(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          DataTile(myTitle: 'TPDU', value: state.comm.tpdu, type: tNumber),
                          ItemTileTwoColumn(
                            contentPadding: EdgeInsets.zero,
                            leftLabel: DataTile(
                              myTitle: 'Tiempo de Respuesta',
                              value: state.comm.timeout.toString(),
                              type: tNumber,
                            ),
                            rightLabel: DataTile(
                              myTitle: 'NII',
                              value: state.comm.nii,
                              type: tNumber,
                            ),
                            leftWidth: size.width / 2.26,
                            rightWidth: size.width / 2.8,
                          ),
                          ItemTileTwoColumn(
                            contentPadding: EdgeInsets.zero,
                            leftLabel:
                                DataTile(myTitle: 'IP POS', value: '192.168.1.1', type: tNumber),
                            rightLabel:
                                DataTile(myTitle: 'Puerto Host', value: '1500', type: tNumber),
                            leftWidth: size.width / 2.26,
                            rightWidth: size.width / 2.8,
                          ),
                          ListTile(title: Text('Tipo de Comunicación'), subtitle: Text('LAN')),
                        ],
                      ),
                    );
                  }
                  return retWidget;
                },
              )),
        ]),
      ),
    );
  }
}

Widget onOffTile(String myTitle, int value) {
  return SwitchListTile(
    title: Text(myTitle),
    value: (value == 1) ? true : false,
  );
}

bool isIP(String str) {
  RegExp _ipv4Maybe = new RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');

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
