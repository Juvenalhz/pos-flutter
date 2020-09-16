class Trans {
  int _id;
  int _number = 0;
  int _stan = 0;
  String _dateTime = '';
  String _type = '';
  int _reverse = 0;
  int _advice = 0;
  int _aquirer = 0;
  int _bin = 0;
  String _maskedPAN = '';
  String _cipheredPAN = '';
  String _panHash = '';
  String _cipheredCardHolderName = '';
  String _cipheredTrack2 = '';
  String _expDate = '';
  String _serviceCode = '';
  int _currency = 0;
  int _entryMode = 0;
  int _baseAmount = 0;
  int _tip = 0;
  int _tax = 0;
  int _cashback = 0;
  int _total = 0;
  int _origialTotal = 0;
  String _responseCode = '';
  String _authNumber = '';
  String _hostRRN = '';
  String _emvTags = '';

  Trans();

  int get id => this._id;
  int get number => this._number;
  int get stan => this._stan;
  String get dateTime => this._dateTime;
  String get type => this._type;
  int get reverse => this._reverse;
  int get advice => this._advice;
  int get aquirer => this._aquirer;
  int get bin => this._bin;
  String get maskedPAN => this._maskedPAN;
  String get cipheredPAN => this._cipheredPAN;
  String get panHash => this._panHash;
  String get cipheredCardHolderName => this._cipheredCardHolderName;
  String get cipheredTrack2 => this._cipheredTrack2;
  String get expDate => this._expDate;
  String get serviceCode => this._serviceCode;
  int get currency => this._currency;
  int get entryMode => this._entryMode;
  int get baseAmount => this._baseAmount;
  int get tip => this._tip;
  int get tax => this._tax;
  int get cashback => this._cashback;
  int get total => this._total;
  int get origialTotal => this._origialTotal;
  String get responseCode => this._responseCode;
  String get authNumber => this._authNumber;
  String get hostRRN => this._hostRRN;
  String get emvTags => this._emvTags;

  set id(int id) {
    this._id = id;
  }

  set number(int number) {
    this._number = number;
  }

  set stan(int stan) {
    this._stan = stan;
  }

  set dateTime(String dateTime) {
    this._dateTime = dateTime;
  }

  set type(String type) {
    this._type = type;
  }

  set reverse(int reverse) {
    this._reverse = reverse;
  }

  set advice(int advice) {
    this._advice = advice;
  }

  set aquirer(int aquirer) {
    this._aquirer = aquirer;
  }

  set bin(int bin) {
    this._bin = bin;
  }

  set maskedPAN(String maskedPAN) {
    this._maskedPAN = maskedPAN;
  }

  set cipheredPAN(String cipheredPAN) {
    this._cipheredPAN = cipheredPAN;
  }

  set panHash(String panHash) {
    this._panHash = panHash;
  }

  set cipheredCardHolderName(String cipheredCardHolderName) {
    this._cipheredCardHolderName = cipheredCardHolderName;
  }

  set cipheredTrack2(String cipheredTrack2) {
    this._cipheredTrack2 = cipheredTrack2;
  }

  set expDate(String expDate) {
    this._expDate = expDate;
  }

  set serviceCode(String serviceCode) {
    this._serviceCode = serviceCode;
  }

  set currency(int currency) {
    this._currency = currency;
  }

  set entryMode(int entryMode) {
    this._entryMode = entryMode;
  }

  set baseAmount(int baseAmount) {
    this._baseAmount = baseAmount;
  }

  set tip(int tip) {
    this._tip = tip;
  }

  set tax(int tax) {
    this._tax = tax;
  }

  set cashback(int cashback) {
    this._cashback = cashback;
  }

  set total(int total) {
    this._total = total;
  }

  set origialTotal(int origialTotal) {
    this._origialTotal = origialTotal;
  }

  set responseCode(String responseCode) {
    this._responseCode = responseCode;
  }

  set authNumber(String authNumber) {
    this._authNumber = authNumber;
  }

  set hostRRN(String hostRRN) {
    this._hostRRN = hostRRN;
  }

  set emvTags(String emvTags) {
    this._emvTags = emvTags;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['number'] = this._number;
    map['stan'] = this._stan;
    map['dateTime'] = this._dateTime;
    map['type'] = this._type;
    map['reverse'] = this._reverse;
    map['advice'] = this._advice;
    map['aquirer'] = this._aquirer;
    map['bin'] = this._bin;
    map['maskedPAN'] = this._maskedPAN;
    map['cipheredPAN'] = this._cipheredPAN;
    map['panHash'] = this._panHash;
    map['cipheredCardHolderName'] = this._cipheredCardHolderName;
    map['cipheredTrack2'] = this._cipheredTrack2;
    map['expDate'] = this._expDate;
    map['serviceCode'] = this._serviceCode;
    map['currency'] = this._currency;
    map['entryMode'] = this._entryMode;
    map['baseAmount'] = this._baseAmount;
    map['tip'] = this._tip;
    map['tax'] = this._tax;
    map['cashback'] = this._cashback;
    map['total'] = this._total;
    map['origialTotal'] = this._origialTotal;
    map['responseCode'] = this._responseCode;
    map['authNumber'] = this._authNumber;
    map['hostRRN'] = this._hostRRN;
    map['emvTags'] = this._emvTags;

    return map;
  }

  Trans.fromMap(Map<String, dynamic> trans) {
    this._id = trans['id'];
    this._number = trans['number'];
    this._stan = trans['stan'];
    this._dateTime = trans['dateTime'];
    this._type = trans['type'];
    this._reverse = trans['reverse'];
    this._advice = trans['advice'];
    this._aquirer = trans['aquirer'];
    this._bin = trans['bin'];
    this._maskedPAN = trans['maskedPAN'];
    this._cipheredPAN = trans['cipheredPAN'];
    this._panHash = trans['panHash'];
    this._cipheredCardHolderName = trans['cipheredCardHolderName'];
    this._cipheredTrack2 = trans['cipheredTrack2'];
    this._expDate = trans['expDate'];
    this._serviceCode = trans['serviceCode'];
    this._currency = trans['currency'];
    this._entryMode = trans['entryMode'];
    this._baseAmount = trans['baseAmount'];
    this._tip = trans['tip'];
    this._tax = trans['tax'];
    this._cashback = trans['cashback'];
    this._total = trans['total'];
    this._origialTotal = trans['origialTotal'];
    this._responseCode = trans['responseCode'];
    this._authNumber = trans['authNumber'];
    this._hostRRN = trans['hostRRN'];
    this._emvTags = trans['emvTags'];
  }
}
