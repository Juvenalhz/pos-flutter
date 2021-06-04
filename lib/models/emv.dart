import 'package:pay/utils/dataUtils.dart';

class Emv {
  int _id;
  String _terminalType;
  String _terminalCapabilities;
  String _addTermCapabilities;
  bool _fallback;
  bool _forceOnline;
  int _currencyCode;
  int _countryCode;

  Emv(this._id, this._terminalType, this._terminalCapabilities, this._addTermCapabilities, this._fallback, this._forceOnline);

  int get id => this._id;
  String get terminalType => this._terminalType;
  String get terminalCapabilities => this._terminalCapabilities;
  String get addTermCapabilities => this._addTermCapabilities;
  bool get fallback => this._fallback;
  bool get forceOnline => this._forceOnline;
  int get currencyCode => this._currencyCode;
  int get countryCode => this._countryCode;

  set id(int id) {
    this._id = id;
  }

  set terminalType(String terminalType) {
    this._terminalType = terminalType;
  }

  set terminalCapabilities(String terminalCapabilities) {
    this._terminalCapabilities = terminalCapabilities;
  }

  set addTermCapabilities(String addTermCapabilities) {
    this._addTermCapabilities = addTermCapabilities;
  }

  set fallback(bool fallback) {
    this._fallback = fallback;
  }

  set forceOnline(bool forceOnline) {
    this._forceOnline = forceOnline;
  }

  set currencyCode(int currencyCode) {
    this._currencyCode = currencyCode;
  }

  set countryCode(int countryCode) {
    this._countryCode = countryCode;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['terminalType'] = this._terminalType;
    map['terminalCapabilities'] = this._terminalCapabilities;
    map['addTermCapabilities'] = this._addTermCapabilities;
    map['fallback'] = boolToInt(this._fallback);
    map['forceOnline'] = boolToInt(this._forceOnline);
    map['currencyCode'] = this._currencyCode;

    map['countryCode'] = "862";


    return map;
  }

  Emv.fromMap(Map<String, dynamic> emv) {
    this._id = emv['id'];
    this._terminalType = emv['terminalType'];
    this._terminalCapabilities = emv['terminalCapabilities'];
    this._addTermCapabilities = emv['addTermCapabilities'];
    this._fallback = intToBool(emv['fallback']);
    this._forceOnline = intToBool(emv['forceOnline']);
    this._currencyCode = emv['currencyCode'];
    this._countryCode = emv['countryCode'];
  }
}
