import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pay/screens/components/data_tile.dart';
import 'components/checkbox_item.dart';
import 'components/item_tile_two_column.dart';
import 'components/title_section_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/bloc.dart';
import 'package:pay/bloc/merchant_bloc.dart';

class ConfigurationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String value = 'dataTile value';
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
                      ItemTileTwoColumn(
                        leftLabel: Text('RIF del Comercio'),
                        rightLabel: Text('Número de Terminal'),
                        leftItem: Text(state.merchant.TaxID),
                        rightItem: Text(state.merchant.TID),
                      ),
                      Divider(),
                      ItemTileTwoColumn(
                        leftLabel: Text('Código Moneda'),
                        rightLabel: Text('Símbolo de Moneda'),
                        leftItem: Text(state.merchant.CurrencyCode.toString()),
                        rightItem: Text(state.merchant.CurrencySymbol),
                      ),
                      Divider(),
                      ItemTileTwoColumn(
                        leftLabel: Text('Código Adquiriente'),
                        rightLabel: Text('Código de País'),
                        leftItem: Text(state.merchant.AcquirerCode),
                        rightItem: Text(state.merchant.CountryCode.toString()),
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
                    DataTile(
                      myTitle: 'Clave Sistema',
                      value: '000000',
                    ),
                    Divider(),
                    DataTile(
                      myTitle: 'Mensaje Pin Pad',
                      value: 'PLATCO',
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
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
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: DataTile(
                        myTitle: 'Min. PIN',
                        value: '4',
                      ),
                      rightLabel: DataTile(
                        myTitle: 'Máx. PIN',
                        value: '6',
                      ),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: DataTile(
                        myTitle: 'Master Key',
                        value: '0',
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Pre-discado',
                        value: false,
                        onChanged: (v) {},
                      ),
                    ),
                    Divider(color: Colors.black, thickness: 1.0),
                    ItemTileTwoColumn(
                      leftLabel: Text('Número de Lote'),
                      rightLabel: Text('Terminal ID'),
                      leftItem: Text('subtitle'),
                      rightItem: Text('00000000'),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Serial Terminal'),
                      subtitle: Text('subtitle'),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: Text('Tiempo Max. Entrada'),
                      rightLabel: Text('Porcentaje Propina'),
                      leftItem: Text('20 Seg.'),
                      rightItem: Text('20 %'),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: Text('Tipo  Soft.'),
                      rightLabel: Text('Lectura de Track'),
                      leftItem: Text('Normal'),
                      rightItem: Text('Track 1 y Track 2'),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Impresión',
                        value: true,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Cash back',
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Cuotas',
                        value: false,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Devolución',
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Cheque',
                        value: false,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Check In/\nCheckOut',
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'CVV2',
                        value: false,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: '4 últimos\ndígitos',
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Clave\nAnulación',
                        value: false,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Clave Cierre',
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Divider(),
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
                    ),
                    Divider(),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Pre-impresión',
                        value: true,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Entrada\nManual PAN',
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Divider(),
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
                    ),
                    Divider(),
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
                    DataTile(
                      myTitle: 'dataTile Title1',
                      value: value,
                      type: TextInputType.text,
                      onSaved: (String newValue) => value = newValue,
                    ),
                    //Divider(),
                    DataTile(
                      myTitle: 'dataTile Title2',
                      value: value,
                      type: TextInputType.number,
                      onSaved: (String newValue) => value = newValue,
                    ),
                    //Divider(),
                    DataTile(
                      myTitle: 'dataTile Title3',
                      value: value,
                      type: TextInputType.text,
                      onSaved: (String newValue) => value = newValue,
                    ),
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
