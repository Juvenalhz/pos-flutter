class Acquirer {
  int _id;
  String _name;
  String _rif;
  int _industryType;
  int _cashback;
  int _installmets;
  int _refund;
  int _provimillas;
  int _cheque;
  int _checkIncheckOut;
  int _saleOffline;
  int _cvv2;
  int _last4Digits;
  int _passwordVoid;
  int _passwordSettlement;
  int _passwordRefund;
  int _maskPan;
  int _prePrint;
  int _manualEntry;

  Acquirer(this._id, this._name, this._rif) {
    _industryType = 0;
    _cashback = 0;
    _installmets = 0;
    _refund = 0;
    _provimillas = 0;
    _cheque = 0;
    _checkIncheckOut = 0;
    _saleOffline = 0;
    _cvv2 = 0;
    _last4Digits = 0;
    _passwordVoid = 0;
    _passwordSettlement = 0;
    _passwordRefund = 0;
    _maskPan = 0;
    _prePrint = 0;
    _manualEntry = 0;
  }

  int get id => this._id;
  String get name => this._name;
  String get rif => this._rif;
  int get industryType => _industryType;
  int get cashback => _cashback;
  int get installmets => _installmets;
  int get refund => _refund;
  int get provimillas => _provimillas;
  int get cheque => _cheque;
  int get checkIncheckOut => _checkIncheckOut;
  int get saleOffline => _saleOffline;
  int get cvv2 => _cvv2;
  int get last4Digits => _last4Digits;
  int get passwordVoid => _passwordVoid;
  int get passwordSettlement => _passwordSettlement;
  int get passwordRefund => _passwordRefund;
  int get maskPan => _maskPan;
  int get prePrint => _prePrint;
  int get manualEntry => _manualEntry;

  set id(int id) {
    this._id = id;
  }

  set name(String name) {
    this._name = name;
  }

  set rif(String rif) {
    this._rif = rif;
  }

  set industryType(int i) {
    this._industryType = i;
  }

  set cashback(int i) {
    this._cashback = i;
  }

  set installmets(int i) {
    this._installmets = i;
  }

  set refund(int i) {
    this._refund = i;
  }

  set provimillas(int i) {
    this._provimillas = i;
  }

  set cheque(int i) {
    this._cheque = i;
  }

  set checkIncheckOut(int i) {
    this._checkIncheckOut = i;
  }

  set saleOffline(int i) {
    this._saleOffline = i;
  }

  set cvv2(int i) {
    this._cvv2 = i;
  }

  set last4Digits(int i) {
    this._last4Digits = i;
  }

  set passwordVoid(int i) {
    this._passwordVoid = i;
  }

  set passwordSettlement(int i) {
    this._passwordSettlement = i;
  }

  set passwordRefund(int i) {
    this._passwordRefund = i;
  }

  set maskPan(int i) {
    this._maskPan = i;
  }

  set prePrint(int i) {
    this._prePrint = i;
  }

  set manualEntry(int i) {
    this._manualEntry = i;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['name'] = this._name;
    map['rif'] = this._rif;
    map['industryType'] = this._industryType;
    map['cashback'] = this._cashback;
    map['installmets'] = this._installmets;
    map['refund'] = this._refund;
    map['rif'] = this._provimillas;
    map['cheque'] = this._cheque;
    map['checkIncheckOut'] = this._checkIncheckOut;
    map['saleOffline'] = this._saleOffline;
    map['cvv2'] = this._cvv2;
    map['last4Digits'] = this._last4Digits;
    map['passwordVoid'] = this._passwordVoid;
    map['passwordSettlement'] = this._passwordSettlement;
    map['maskPan'] = this._maskPan;
    map['prePrint'] = this._prePrint;
    map['manualEntry'] = this._manualEntry;

    return map;
  }

  Acquirer.fromMap(Map<String, dynamic> Acquirer) {
    this._id = Acquirer['id'];
    this._name = Acquirer['name'];
    this._rif = Acquirer['rif'];
    this._industryType = Acquirer['industryType'];
    this._cashback = Acquirer['cashback'];
    this._installmets = Acquirer['installmets'];
    this._refund = Acquirer['refund'];
    this._provimillas = Acquirer['rif'];
    this._cheque = Acquirer['cheque'];
    this._checkIncheckOut = Acquirer['checkIncheckOut'];
    this._saleOffline = Acquirer['saleOffline'];
    this._cvv2 = Acquirer['cvv2'];
    this._last4Digits = Acquirer['last4Digits'];
    this._passwordVoid = Acquirer['passwordVoid'];
    this._passwordSettlement = Acquirer['passwordSettlement'];
    this._maskPan = Acquirer['maskPan'];
    this._prePrint = Acquirer['prePrint'];
    this._manualEntry = Acquirer['manualEntry'];
  }

  setIndicators(String indicator) {
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x01) != 0) this._industryType = 1;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x02) != 0) this._cashback = 1;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x04) != 0) this._installmets = 1;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x08) != 0) this._refund = 1;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x10) != 0) this._provimillas = 1;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x20) != 0) this._cheque = 1;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x40) != 0) this._checkIncheckOut = 1;
    if ((int.parse(indicator.substring(0, 2), radix: 16) & 0x80) != 0) this._saleOffline = 1;

    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x01) != 0) this._cvv2 = 1;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x02) != 0) this._last4Digits = 1;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x04) != 0) this._passwordVoid = 1;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x08) != 0) this._passwordSettlement = 1;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x10) != 0) this._passwordRefund = 1;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x20) != 0) this._maskPan = 1;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x40) != 0) this._prePrint = 1;
    if ((int.parse(indicator.substring(2, 4), radix: 16) & 0x80) != 0) this._manualEntry = 1;
  }
}
