import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:pay/bloc/acquirer/acquirer_bloc.dart';
import 'package:pay/bloc/acquirer/acquirer_state.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_event.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/bloc/emv/emv_bloc.dart';
import 'package:pay/bloc/emv/emv_state.dart';
import 'package:pay/bloc/merchant/merchant_state.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'package:pay/bloc/terminal/terminal_bloc.dart';
import 'package:pay/bloc/terminal/terminal_event.dart';
import 'package:pay/bloc/terminal/terminal_state.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/screens/components/data_tile.dart';
import 'package:pay/utils/dropdown_items.dart';
import 'package:pay/utils/input_validation.dart';
import 'package:pay/utils/serialNumber.dart';
import 'package:pay/viewModel/config_viewmodel.dart';
import 'package:provider/provider.dart';
import 'components/checkbox_item.dart';
import 'components/item_tile_two_column.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> with TickerProviderStateMixin {
  String _serialNumber;
  TextInputType _tNumber = TextInputType.number;
  Merchant _merchant;
  Terminal _terminal;
  Comm _comm;
  Emv _emv;
  Acquirer _acquirer;
  TabController _tabController;
  int _indexTab;
  final _formKey = GlobalKey<FormState>();
  final _kTabs = <Tab>[
    Tab(icon: Icon(Icons.location_city), text: 'Comercio'),
    Tab(icon: Icon(Icons.perm_device_information), text: 'Terminal'),
    Tab(icon: Icon(Icons.network_wifi), text: 'Comunicación'),
    Tab(icon: Icon(Icons.payment), text: 'EMV'),
    Tab(icon: Icon(Icons.account_balance), text: 'Adquiriente'),
  ];
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  void submit(BuildContext context) {
    final form = _formKey.currentState;
    final terminalBloc = BlocProvider.of<TerminalBloc>(context);
    final commBloc = BlocProvider.of<CommBloc>(context);

    if (form.validate()) {
      form.save();
      Provider.of<ConfigViewModel>(context, listen: false).updateChanges(false);
      print('form save');

      switch (_indexTab) {
        case 1:
          _terminal.id = 1;
          terminalBloc.add(UpdateTerminal(_terminal));
          terminalBloc.add(GetTerminal(1));
          break;
        case 2:
          _comm.id = 1;
          commBloc.add(UpdateComm(_comm));
          commBloc.add(GetComm(1));
          break;
        default:
          break;
      }

      // Navigator.of(context).pop();
    } else {
      print('form dont save');
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Debe guardar, para cambiar de pestaña'),
        // action: SnackBarAction(label: 'DESCARTAR', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: _kTabs.length, vsync: this);
    _initPackageInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    String sn = await SerialNumber.serialNumber;
    setState(() {
      _packageInfo = info;
      _serialNumber = sn;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<ConfigViewModel>(
      create: (_) => ConfigViewModel(),
      child: SafeArea(
        child: DefaultTabController(
          length: _kTabs.length,
          child: Consumer<ConfigViewModel>(
            builder: (context, config, child) => Scaffold(
              resizeToAvoidBottomInset: false,
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
                bottom: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: _kTabs,
                  onTap: (index) {
                    if (config.changes) {
                      _tabController.index = _indexTab;
                      _showToast(context);
                    }
                  },
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: FlatButton(
                      onPressed: () => submit(context),
                      child: Icon(
                        Icons.save,
                        size: 26.0,
                        color: config.changes ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              body: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabController,
                  physics: config.changes ? NeverScrollableScrollPhysics() : ScrollPhysics(),
                  children: [
                    BlocBuilder<MerchantBloc, MerchantState>(
                      builder: (context, state) {
                        Widget retWidget = SizedBox();
                        if (state is MerchantLoaded) {
                          _merchant = state.merchant;
                          retWidget = Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView(
                              children: <Widget>[
                                ListTile(
                                  title: Text('Nombre del Comercio'),
                                  subtitle: Text('${_merchant.nameL1}\n${_merchant.nameL2}'),
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
                                  leftItem: Text(_merchant.AcquirerCode.toString()),
                                  rightItem: Text(_merchant.CountryCode.toString()),
                                  leftWidth: size.width / 2.18,
                                  rightWidth: size.width / 2.18,
                                ),
                                ListTile(
                                  title: Text('Versión de la Aplicación'),
                                  subtitle: Text(_packageInfo.version),
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
                          _indexTab = 1;
                          retWidget = BlocBuilder<AcquirerBloc, AcquirerState>(
                            builder: (context, state) {
                              Widget retWidget = SizedBox();
                              if (state is AcquirerLoaded) {
                                _acquirer = state.acquirer;
                                retWidget = ListView(
                                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  children: <Widget>[
                                    DataTile(
                                        myTitle: 'Clave Sistema',
                                        value: _terminal.password,
                                        type: _tNumber,
                                        obscureText: true,
                                        maxLength: 6,
                                        onSaved: (nValue) => _terminal.password = nValue,
                                        onChanged: (nValue) {
                                          Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                          _terminal.password = nValue;
                                        },
                                        validator: (nValue) => InputValidation.defaultPasswordValidator(nValue)),
                                    DataTile(
                                        myTitle: 'Mensaje Pin Pad',
                                        value: _terminal.industry,
                                        maxLength: 16,
                                        onSaved: (nValue) => _terminal.industry = nValue,
                                        onChanged: (nValue) {
                                          Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                          _terminal.industry = nValue;
                                        },
                                        validator: (nValue) => InputValidation.requiredField(nValue)),
                                    ItemTileTwoColumn(
                                      contentPadding: EdgeInsets.zero,
                                      leftLabel: DataTile(
                                          myTitle: 'Min. PIN',
                                          value: _terminal.minPinDigits.toString(),
                                          type: _tNumber,
                                          maxLength: 2,
                                          onSaved: (nValue) => _terminal.minPinDigits = int.parse(nValue),
                                          onChanged: (nValue) {
                                            Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                            _terminal.minPinDigits = int.parse(nValue);
                                          },
                                          validator: (nValue) => InputValidation.requiredField(nValue)),
                                      rightLabel: DataTile(
                                          myTitle: 'Máx. PIN',
                                          value: _terminal.maxPinDigits.toString(),
                                          type: _tNumber,
                                          maxLength: 2,
                                          onSaved: (nValue) => _terminal.maxPinDigits = int.parse(nValue),
                                          onChanged: (nValue) {
                                            Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                            _terminal.maxPinDigits = int.parse(nValue);
                                          },
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
                                          onSaved: (nValue) => _terminal.keyIndex = int.parse(nValue),
                                          onChanged: (nValue) {
                                            Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                            _terminal.keyIndex = int.parse(nValue);
                                          },
                                          validator: (nValue) => InputValidation.requiredField(nValue)),
                                      leftWidth: size.width / 3.0,
                                      rightWidth: size.width / 1.8,
                                    ),
                                    SizedBox(height: 10.0),
                                    Divider(color: Colors.black54, thickness: 0.6),
                                    ItemTileTwoColumn(
                                      leftLabel: Text('Número de Lote'),
                                      rightLabel: Text('Terminal ID'),
                                      leftItem: Text(_merchant.BatchNumber.toString()),
                                      //TODO: asignar campo valido
                                      rightItem: Text(_terminal.idTerminal),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: Text('Serial Terminal'),
                                      rightLabel: Text('Tipo de Pin Pad'),
                                      leftItem: Text(_serialNumber),
                                      rightItem: Text('Interno'),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: Text('Tiempo Max. Entrada'),
                                      rightLabel: Text('Porcentaje Propina'),
                                      leftItem: Text(_terminal.timeoutPrompt.toString()),
                                      rightItem: Text(_terminal.maxTipPercentage.toString()),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    /*ItemTileTwoColumn(
                                  leftLabel: Text('Tipo  Soft.'),
                                  rightLabel: Text('Lectura de Track'),
                                  leftItem: Text('Normal'),
                                  rightItem: Text('Track 1 y Track 2'),
                                  leftWidth: size.width / 2.18,
                                  rightWidth: size.width / 2.18,
                                ),*/
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(label: 'Impresión', value: _terminal.print, onChanged: null),
                                      rightLabel: CheckboxItem(label: 'Cash back', value: _terminal.cashback, onChanged: null),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(label: 'Cuotas', value: _terminal.installments, onChanged: null),
                                      rightLabel: CheckboxItem(label: 'Devolución', value: _terminal.refund, onChanged: null),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(label: 'Cheque', value: _acquirer.cheque, onChanged: null),
                                      rightLabel:
                                          CheckboxItem(label: 'Check In/\nCheckOut', value: _acquirer.checkIncheckOut, onChanged: null),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(label: 'CVV2', value: _acquirer.cvv2, onChanged: null),
                                      rightLabel: CheckboxItem(label: '4 últimos\ndígitos', value: _terminal.last4Digits, onChanged: null),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(label: 'Clave\nAnulación', value: _terminal.passwordVoid, onChanged: null),
                                      rightLabel: CheckboxItem(label: 'Clave Cierre', value: _terminal.passwordBatch, onChanged: null),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(
                                        label: 'Clave\nDevolución',
                                        value: _terminal.passwordRefund,
                                        onChanged: null,
                                      ),
                                      rightLabel: CheckboxItem(
                                        label: 'Enmascarar\nTarjeta',
                                        value: _terminal.maskPan,
                                        onChanged: null,
                                      ),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(
                                        label: 'Pre-impresión',
                                        value: _acquirer.prePrint,
                                        onChanged: null,
                                      ),
                                      rightLabel: CheckboxItem(
                                        label: 'Entrada\nManual PAN',
                                        value: _acquirer.manualEntry,
                                        onChanged: null,
                                      ),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                    ItemTileTwoColumn(
                                      leftLabel: CheckboxItem(
                                        label: 'Confirmación\nde Importe',
                                        value: _terminal.amountConfirmation,
                                        onChanged: null,
                                      ),
                                      rightLabel: CheckboxItem(
                                        label: 'Ventas Fuera\nde Línea',
                                        value: _acquirer.saleOffline,
                                        onChanged: null,
                                      ),
                                      leftWidth: size.width / 2.18,
                                      rightWidth: size.width / 2.18,
                                    ),
                                  ],
                                );
                              }
                              return retWidget;
                            },
                          );
                        }
                        return retWidget;
                      },
                    ),
                    BlocBuilder<CommBloc, CommState>(
                      builder: (context, state) {
                        Widget retWidget = SizedBox();
                        if (state is CommLoaded) {
                          if (_comm == null) _comm = state.comm;
                          _indexTab = 2;
                          retWidget = ListView(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            children: <Widget>[
                              DataTile(
                                myTitle: 'TPDU',
                                value: _comm.tpdu,
                                type: _tNumber,
                                maxLength: 10,
                                formatInput: [FilteringTextInputFormatter.digitsOnly],
                                onSaved: (nValue) => _comm.tpdu = nValue,
                                onChanged: (nValue) {
                                  Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                  _comm.tpdu = nValue;
                                },
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
                                  onSaved: (nValue) => _comm.timeout = int.parse(nValue),
                                  onChanged: (nValue) {
                                    Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                    _comm.timeout = int.parse(nValue);
                                  },
                                  validator: (nValue) => InputValidation.requiredField(nValue),
                                ),
                                rightLabel: DataTile(
                                  myTitle: 'NII',
                                  value: _comm.nii,
                                  type: _tNumber,
                                  maxLength: 3,
                                  formatInput: [FilteringTextInputFormatter.digitsOnly],
                                  onSaved: (nValue) => _comm.nii = nValue,
                                  onChanged: (nValue) {
                                    Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                    _comm.nii = nValue;
                                  },
                                  validator: (nValue) => InputValidation.requiredField(nValue),
                                ),
                                leftWidth: size.width / 2.26,
                                rightWidth: size.width / 2.8,
                              ),
                              ItemTileTwoColumn(
                                contentPadding: EdgeInsets.zero,
                                leftLabel: DataTile(
                                  myTitle: 'IP Host',
                                  value: _comm.ip,
                                  type: _tNumber,
                                  maxLength: 15,
                                  onSaved: (nValue) => _comm.ip = nValue,
                                  onChanged: (nValue) {
                                    Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                    _comm.ip = nValue;
                                  },
                                  validator: (nValue) => InputValidation.ipv4Validator(nValue),
                                ),
                                rightLabel: DataTile(
                                  myTitle: 'Puerto Host',
                                  value: _comm.port.toString(),
                                  type: _tNumber,
                                  maxLength: 5,
                                  formatInput: [FilteringTextInputFormatter.digitsOnly],
                                  onSaved: (nValue) => _comm.port = int.parse(nValue),
                                  onChanged: (nValue) {
                                    Provider.of<ConfigViewModel>(context, listen: false).updateChanges(true);
                                    _comm.port = int.parse(nValue);
                                  },
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
                      },
                    ),
                    BlocBuilder<EmvBloc, EmvState>(
                      builder: (context, state) {
                        Widget retWidget = SizedBox();
                        if (state is EmvLoaded) {
                          _emv = state.emv;
                          retWidget = ListView(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            children: <Widget>[
                              ItemTileTwoColumn(
                                leftLabel: Text('Tipo de Terminal'),
                                leftItem: Text(_emv.terminalType),
                                rightLabel: Text('Terminal Capabilities'),
                                rightItem: Text(_emv.terminalCapabilities),
                                leftWidth: size.width / 2.6,
                                rightWidth: size.width / 1.9,
                              ),
                              ListTile(
                                title: Text('Terminal Additional Capabilities'),
                                subtitle: Text(_emv.addTermCapabilities),
                              ),
                              ItemTileTwoColumn(
                                leftLabel: CheckboxItem(
                                  label: 'Fallback',
                                  value: _emv.fallback,
                                  onChanged: null,
                                ),
                                rightLabel: CheckboxItem(
                                  label: 'Forzar Online',
                                  value: _emv.forceOnline,
                                  onChanged: null,
                                  // onChanged: (v) {},
                                ),
                                leftWidth: size.width / 2.18,
                                rightWidth: size.width / 2.18,
                              ),
                              /*ItemTileTwoColumn(
                                leftLabel: CheckboxItem(
                                  label: 'Selección\nAutomatica',
                                  value: false,
                                  onChanged: (v) {},
                                ),
                                leftWidth: size.width / 2.18,
                                rightWidth: size.width / 2.18,
                              ),*/
                            ],
                          );
                        }
                        return retWidget;
                      },
                    ),
                    BlocBuilder<AcquirerBloc, AcquirerState>(
                      builder: (context, state) {
                        Widget retWidget = SizedBox();
                        if (state is AcquirerLoaded) {
                          _acquirer = state.acquirer;
                          retWidget = ListView(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            children: <Widget>[
                              ItemTileTwoColumn(
                                leftLabel: Text('Código Adquiriente'),
                                leftItem: Text(_merchant.AcquirerCode.toString()),
                                rightLabel: Text('Nombre Adquiriente'),
                                rightItem: Text(_acquirer.name),
                                leftWidth: size.width / 2.18,
                                rightWidth: size.width / 2.18,
                              ),
                              ItemTileTwoColumn(
                                leftLabel: Text('RIF Adquiriente'),
                                leftItem: Text(_acquirer.rif),
                                rightLabel: CheckboxItem(
                                  label: 'Activo',
                                  value: true,
                                  onChanged: null,
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
                  ],
                ),
              ),
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
