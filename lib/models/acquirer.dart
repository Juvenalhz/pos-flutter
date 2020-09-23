import 'package:pay/utils/dataUtils.dart';

class Acquirer {
  int _id;
  String _name;
  String _rif;
  bool _industryType;
  bool _cashback;
  bool _installmets;
  bool _refund;
  bool _provimillas;
  bool _cheque;
  bool _checkIncheckOut;
  bool _saleOffline;
  bool _cvv2;
  bool _last4Digits;
  bool _passwordVoid;
  bool _passwordSettlement;
  bool _passwordRefund;
  bool _maskPan;
  bool _prePrint;
  bool _manualEntry;

  Acquirer(this._id, this._name, this._rif) {
    _industryType = false;
    _cashback = false;
    _installmets = false;
    _refund = false;
    _provimillas = false;
    _cheque = false;
    _checkIncheckOut = false;
    _saleOffline = false;
    _cvv2 = false;
    _last4Digits = false;
    _passwordVoid = false;
    _passwordSettlement = false;
    _passwordRefund = false;
    _maskPan = false;
    _prePrint = false;
    _manualEntry = false;
  }

  int get id => this._id;
  String get name => this._name;
  String get rif => this._rif;
  bool get industryType => _industryType;
  bool get cashback => _cashback;
  bool get installmets => _installmets;
  bool get refund => _refund;
  bool get provimillas => _provimillas;
  bool get cheque => _cheque;
  bool get checkIncheckOut => _checkIncheckOut;
  bool get saleOffline => _saleOffline;
  bool get cvv2 => _cvv2;
  bool get last4Digits => _last4Digits;
  bool get passwordVoid => _passwordVoid;
  bool get passwordSettlement => _passwordSettlement;
  bool get passwordRefund => _passwordRefund;
  bool get maskPan => _maskPan;
  bool get prePrint => _prePrint;
  bool get manualEntry => _manualEntry;

  set id(int id) {
    this._id = id;
  }

  set name(String name) {
    this._name = name;
  }

  set rif(String rif) {
    this._rif = rif;
  }

  set industryType(bool i) {
    this._industryType = i;
  }

  set cashback(bool i) {
    this._cashback = i;
  }

  set installmets(bool i) {
    this._installmets = i;
  }

  set refund(bool i) {
    this._refund = i;
  }

  set provimillas(bool i) {
    this._provimillas = i;
  }

  set cheque(bool i) {
    this._cheque = i;
  }

  set checkIncheckOut(bool i) {
    this._checkIncheckOut = i;
  }

  set saleOffline(bool i) {
    this._saleOffline = i;
  }

  set cvv2(bool i) {
    this._cvv2 = i;
  }

  set last4Digits(bool i) {
    this._last4Digits = i;
  }

  set passwordVoid(bool i) {
    this._passwordVoid = i;
  }

  set passwordSettlement(bool i) {
    this._passwordSettlement = i;
  }

  set passwordRefund(bool i) {
    this._passwordRefund = i;
  }

  set maskPan(bool i) {
    this._maskPan = i;
  }

  set prePrint(bool i) {
    this._prePrint = i;
  }

  set manualEntry(bool i) {
    this._manualEntry = i;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['name'] = this._name;
    map['rif'] = this._rif;
    map['industryType'] = boolToInt(this._industryType);
    map['cashback'] = boolToInt(this._cashback);
    map['installmets'] = boolToInt(this._installmets);
    map['refund'] = boolToInt(this._refund);
    map['rif'] = boolToInt(this._provimillas);
    map['cheque'] = boolToInt(this._cheque);
    map['checkIncheckOut'] = boolToInt(this._checkIncheckOut);
    map['saleOffline'] = boolToInt(this._saleOffline);
    map['cvv2'] = boolToInt(this._cvv2);
    map['last4Digits'] = boolToInt(this._last4Digits);
    map['passwordVoid'] = boolToInt(this._passwordVoid);
    map['passwordSettlement'] = boolToInt(this._passwordSettlement);
    map['maskPan'] = boolToInt(this._maskPan);
    map['prePrint'] = boolToInt(this._prePrint);
    map['manualEntry'] = boolToInt(this._manualEntry);

    return map;
  }

  Acquirer.fromMap(Map<String, dynamic> acquirer) {
    this._id = acquirer['id'];
    this._name = acquirer['name'];
    this._rif = acquirer['rif'];
    this._industryType = intToBool(acquirer['industryType']);
    this._cashback = intToBool(acquirer['cashback']);
    this._installmets = intToBool(acquirer['installmets']);
    this._refund = intToBool(acquirer['refund']);
    this._provimillas = intToBool(acquirer['provimillas']);
    this._cheque = intToBool(acquirer['cheque']);
    this._checkIncheckOut = intToBool(acquirer['checkIncheckOut']);
    this._saleOffline = intToBool(acquirer['saleOffline']);
    this._cvv2 = intToBool(acquirer['cvv2']);
    this._last4Digits = intToBool(acquirer['last4Digits']);
    this._passwordVoid = intToBool(acquirer['passwordVoid']);
    this._passwordSettlement = intToBool(acquirer['passwordSettlement']);
    this._maskPan = intToBool(acquirer['maskPan']);
    this._prePrint = intToBool(acquirer['prePrint']);
    this._manualEntry = intToBool(acquirer['manualEntry']);
  }

  setIndicators(String indicator) {
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x01) != 0) this._industryType = true;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x02) != 0) this._cashback = true;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x04) != 0) this._installmets = true;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x08) != 0) this._refund = true;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x10) != 0) this._provimillas = true;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x20) != 0) this._cheque = true;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x40) != 0) this._checkIncheckOut = true;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x80) != 0) this._saleOffline = true;

    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x01) != 0) this._cvv2 = true;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x02) != 0) this._last4Digits = true;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x04) != 0) this._passwordVoid = true;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x08) != 0)
      this._passwordSettlement = true;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x10) != 0) this._passwordRefund = true;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x20) != 0) this._maskPan = true;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x40) != 0) this._prePrint = true;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x80) != 0) this._manualEntry = true;
  }
}
