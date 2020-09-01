import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/bloc/merchant/merchant_state.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'package:pay/bloc/terminal/terminal_bloc.dart';
import 'package:pay/bloc/terminal/terminal_state.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/screens/components/data_tile.dart';
import 'package:pay/utils/dropdown_items.dart';
import 'package:pay/utils/input_validation.dart';
import 'components/checkbox_item.dart';
import 'components/item_tile_two_column.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  TextInputType _tNumber = TextInputType.number;
  Merchant _merchant;
  Terminal _terminal;
  Comm _comm;
  String pinPadType = DropDownItems.typePinpadList[1];
  final _formKey = GlobalKey<FormState>();
  final _kTabs = <Tab>[
    Tab(icon: Icon(Icons.location_city), text: 'Comercio'),
    Tab(icon: Icon(Icons.perm_device_info), text: 'Terminal'),
    Tab(icon: Icon(Icons.network_wifi), text: 'Comunicación'),
    Tab(icon: Icon(Icons.payment), text: 'EMV'),
  ];

  void submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print('form save');
    } else {
      print('form dont save');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: DefaultTabController(
        length: _kTabs.length,
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
            bottom: TabBar(tabs: _kTabs),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: FlatButton(
                    onPressed: submit,
                    child: Icon(
                      Icons.save,
                      size: 26.0,
                      color: Colors.black54,
                    ),
                  )),
            ],
          ),
          body: Form(
            key: _formKey,
            child: TabBarView(
              children: [
                BlocBuilder<MerchantBloc, MerchantState>(
                  builder: (context, state) {
                    Widget retWidget = SizedBox();
                    if (state is MerchantLoaded) {
                      _merchant = state.merchant;
                      retWidget = Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('Nombre del Comercio'),
                              subtitle: Text('${_merchant.nameL1}\n ${_merchant.nameL2}'),
                              isThreeLine: true,
                            ),
                            ListTile(
                              title: Text('Ciudad del Comercio'),
                              subtitle: Text(_merchant.City),
                            ),
                            ListTile(
                              title: Text('Código de Comercio'),
                              subtitle: Text(_merchant.MID),
                            ),
                            ItemTileTwoColumn(
                              leftLabel: Text('RIF del Comercio'),
                              rightLabel: Text('Número de Terminal'),
                              leftItem: Text(_merchant.TaxID),
                              rightItem: Text(_merchant.TID),
                              leftWidth: size.width / 2.18,
                              rightWidth: size.width / 2.18,
                            ),
                            ItemTileTwoColumn(
                              leftLabel: Text('Código Moneda'),
                              rightLabel: Text('Símbolo de Moneda'),
                              leftItem: Text(_merchant.CurrencyCode.toString()),
                              rightItem: Text(_merchant.CurrencySymbol),
                              leftWidth: size.width / 2.18,
                              rightWidth: size.width / 2.18,
                            ),
                            ItemTileTwoColumn(
                              leftLabel: Text('Código Adquiriente'),
                              rightLabel: Text('Código de País'),
                              leftItem: Text(_merchant.AcquirerCode),
                              rightItem: Text(_merchant.CountryCode.toString()),
                              leftWidth: size.width / 2.18,
                              rightWidth: size.width / 2.18,
                            ),
                            ListTile(
                              title: Text('Versión de la Aplicación'),
                              subtitle: Text(_merchant.id.toString()),
                            ),
                          ],
                        ),
                      );
                    }
                    return retWidget;
                  },
                ),
                BlocBuilder<TerminalBloc, TerminalState>(
                  builder: (context, state) {
                    Widget retWidget = SizedBox();
                    if (state is TerminalLoaded) {
                      if (_terminal == null) _terminal = state.terminal;
                      retWidget = ListView(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        children: <Widget>[
                          DataTile(
                            myTitle: 'Clave Sistema',
                            value: _terminal.password,
                            type: _tNumber,
                            maxLength: 6,
                            onSaved: (nValue) => _terminal.password = nValue,
                            onChanged: (nValue) => _terminal.password = nValue,
                            validator: (nValue) => InputValidation.defaultPasswordValidator(nValue),
                          ),
                          DataTile(
                              myTitle: 'Mensaje Pin Pad',
                              value: _terminal.industry,
                              maxLength: 16,
                              validator: (nValue) => InputValidation.requiredField(nValue)),
                          ItemTileTwoColumn(
                            contentPadding: EdgeInsets.zero,
                            leftLabel: DataTile(
                                myTitle: 'Min. PIN',
                                value: _terminal.minPinDigits.toString(),
                                type: _tNumber,
                                maxLength: 2,
                                validator: (nValue) => InputValidation.requiredField(nValue)),
                            rightLabel: DataTile(
                                myTitle: 'Máx. PIN',
                                value: _terminal.maxPinDigits.toString(),
                                type: _tNumber,
                                maxLength: 2,
                                validator: (nValue) => InputValidation.requiredField(nValue)),
                            leftWidth: size.width / 2.5,
                            rightWidth: size.width / 2.5,
                          ),
                          ItemTileTwoColumn(
                            contentPadding: EdgeInsets.only(right: 16.0),
                            leftLabel: DataTile(
                                myTitle: 'Master Key',
                                value: _terminal.keyIndex.toString(),
                                type: _tNumber,
                                maxLength: 1,
                                validator: (nValue) => InputValidation.requiredField(nValue)),
                            rightLabel: Text('Tipo de Pin Pad'),
                            rightTrailing: DropdownButton(
                              onChanged: (value) {
                                pinPadType = value;
                              },
                              value: pinPadType,
                              items: DropDownItems.dropDownTypePinpad,
                            ),
                            leftWidth: size.width / 3.0,
                            rightWidth: size.width / 1.8,
                          ),
                          SizedBox(height: 10.0),
                          Divider(color: Colors.black54, thickness: 0.6),
                          ItemTileTwoColumn(
                            leftLabel: Text('Número de Lote'),
                            rightLabel: Text('Terminal ID'),
                            leftItem: Text('subtitle'),
                            rightItem: Text(_terminal.idTerminal),
                            leftWidth: size.width / 2.18,
                            rightWidth: size.width / 2.18,
                          ),
                          ListTile(title: Text('Serial Terminal'), subtitle: Text('subtitle')),
                          ItemTileTwoColumn(
                            leftLabel: Text('Tiempo Max. Entrada'),
                            rightLabel: Text('Porcentaje Propina'),
                            leftItem: Text(_terminal.timeoutPrompt.toString()),
                            rightItem: Text(_terminal.maxTipPercentage.toString()),
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
                            leftLabel:
                                CheckboxItem(label: 'Impresión', value: true, onChanged: null),
                            rightLabel:
                                CheckboxItem(label: 'Cash back', value: false, onChanged: null),
                            leftWidth: size.width / 2.18,
                            rightWidth: size.width / 2.18,
                          ),
                          ItemTileTwoColumn(
                            leftLabel: CheckboxItem(label: 'Cuotas', value: false, onChanged: null),
                            rightLabel:
                                CheckboxItem(label: 'Devolución', value: false, onChanged: null),
                            leftWidth: size.width / 2.18,
                            rightWidth: size.width / 2.18,
                          ),
                          ItemTileTwoColumn(
                            leftLabel: CheckboxItem(label: 'Cheque', value: false, onChanged: null),
                            rightLabel: CheckboxItem(
                                label: 'Check In/\nCheckOut', value: false, onChanged: null),
                            leftWidth: size.width / 2.18,
                            rightWidth: size.width / 2.18,
                          ),
                          ItemTileTwoColumn(
                            leftLabel: CheckboxItem(label: 'CVV2', value: false, onChanged: null),
                            rightLabel: CheckboxItem(
                                label: '4 últimos\ndígitos', value: false, onChanged: null),
                            leftWidth: size.width / 2.18,
                            rightWidth: size.width / 2.18,
                          ),
                          ItemTileTwoColumn(
                            leftLabel: CheckboxItem(
                                label: 'Clave\nAnulación', value: false, onChanged: null),
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
                            leftLabel:
                                CheckboxItem(label: 'Pre-impresión', value: true, onChanged: null),
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
                        ],
                      );
                    }
                    return retWidget;
                  },
                ),
                BlocBuilder<CommBloc, CommState>(builder: (context, state) {
                  Widget retWidget = SizedBox();
                  if (state is CommLoaded) {
                    _comm = state.comm;
                    retWidget = ListView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      children: <Widget>[
                        DataTile(
                          myTitle: 'TPDU',
                          value: _comm.tpdu,
                          type: _tNumber,
                          maxLength: 10,
                          formatInput: [FilteringTextInputFormatter.digitsOnly],
                          validator: (nValue) => InputValidation.tpduValidator(nValue),
                        ),
                        ItemTileTwoColumn(
                          contentPadding: EdgeInsets.zero,
                          leftLabel: DataTile(
                            myTitle: 'Tiempo de Respuesta',
                            value: _comm.timeout.toString(),
                            type: _tNumber,
                            maxLength: 3,
                            formatInput: [FilteringTextInputFormatter.digitsOnly],
                            validator: (nValue) => InputValidation.requiredField(nValue),
                          ),
                          rightLabel: DataTile(
                            myTitle: 'NII',
                            value: _comm.nii,
                            type: _tNumber,
                            maxLength: 3,
                            formatInput: [FilteringTextInputFormatter.digitsOnly],
                            validator: (nValue) => InputValidation.requiredField(nValue),
                          ),
                          leftWidth: size.width / 2.26,
                          rightWidth: size.width / 2.8,
                        ),
                        ItemTileTwoColumn(
                          contentPadding: EdgeInsets.zero,
                          leftLabel: DataTile(
                            myTitle: 'IP POS',
                            value: _comm.ip,
                            type: _tNumber,
                            maxLength: 15,
                            validator: (nValue) => InputValidation.ipv4Validator(nValue),
                          ),
                          rightLabel: DataTile(
                            myTitle: 'Puerto Host',
                            value: _comm.port.toString(),
                            type: _tNumber,
                            maxLength: 5,
                            formatInput: [FilteringTextInputFormatter.digitsOnly],
                            validator: (nValue) => InputValidation.requiredField(nValue),
                          ),
                          leftWidth: size.width / 2.26,
                          rightWidth: size.width / 2.8,
                        ),
                        ListTile(title: Text('Tipo de Comunicación'), subtitle: Text('LAN')),
                      ],
                    );
                  }
                  return retWidget;
                }),
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  children: <Widget>[
                    ItemTileTwoColumn(
                      leftLabel: Text('Tipo de Terminal'),
                      leftItem: Text('22'),
                      rightLabel: Text('Terminal Capabilities'),
                      rightItem: Text('E0F8C8'),
                      leftWidth: size.width / 2.6,
                      rightWidth: size.width / 1.9,
                    ),
                    ListTile(
                      title: Text('Terminal Additional Capabilities'),
                      subtitle: Text('F0000F0F001'),
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Fallback',
                        value: true,
                        onChanged: null,
                      ),
                      rightLabel: CheckboxItem(
                        label: 'Forzar Online',
                        value: false,
                        onChanged: (v) {},
                      ),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                    ItemTileTwoColumn(
                      leftLabel: CheckboxItem(
                        label: 'Selección\nAutomatica',
                        value: false,
                        onChanged: (v) {},
                      ),
                      leftWidth: size.width / 2.18,
                      rightWidth: size.width / 2.18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
