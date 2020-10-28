import 'package:pay/utils/dataUtils.dart';

class Trans {
  int _id;
  int _number = 0;
  int _stan = 0;
  DateTime _dateTime = DateTime.parse('');
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
  int _appType = 0;
  int _cardType = 0;
  int _panSequenceNumber = 0;
  String _cardholderName = '';
  String _pan = '';
  String _track1 = '';
  String _track2 = '';
  String _appLabel = '';
  int _aidID = 0;
  String _responseEmvTags = '';
  int _cardDecision = 0;
  String _finishTags = '';
  String _cvv = '';
  String _cardholderID = '';
  int _accType = 0;
  bool _signature = false;
  bool _offlinePIN = false;
  int _triesLeft = 0;
  bool _blockedPIN = false;
  bool _onlinePIN = false;
  String _pinBlock = '';
  String _pinKSN = '';
  String _referenceNumber = '';

  Trans();

  int get id => this._id;
  int get number => this._number;
  int get stan => this._stan;
  DateTime get dateTime => this._dateTime;
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
  int get appType => this._appType;
  int get cardType => this._cardType;
  int get panSequenceNumber => this._panSequenceNumber;
  String get cardholderName => this._cardholderName;
  String get pan => this._pan;
  String get track1 => this._track1;
  String get track2 => this._track2;
  String get appLabel => this._appLabel;
  int get aidID => this._aidID;
  String get responseEmvTags => this._responseEmvTags;
  int get cardDecision => this._cardDecision;
  String get finishTags => this._finishTags;
  String get cvv => this._cvv;
  String get cardholderID => this._cardholderID;
  int get accType => this._accType;
  bool get signature => this._signature;
  bool get offlinePIN => this._offlinePIN;
  int get triesLeft => this._triesLeft;
  bool get blockedPIN => this._blockedPIN;
  bool get onlinePIN => this._onlinePIN;
  String get pinBlock => this._pinBlock;
  String get pinKSN => this._pinKSN;
  String get referenceNumber => this._referenceNumber;

  set id(int id) {
    this._id = id;
  }

  set number(int number) {
    this._number = number;
  }

  set stan(int stan) {
    this._stan = stan;
  }

  set dateTime(DateTime dateTime) {
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

  set appType(int appType) {
    this._appType = appType;
  }

  set cardType(int cardType) {
    this._cardType = cardType;
  }

  set panSequenceNumber(int panSequenceNumber) {
    this._panSequenceNumber = panSequenceNumber;
  }

  set cardholderName(String cardholderName) {
    this._cardholderName = cardholderName;
  }

  set pan(String pan) {
    this._pan = pan;
  }

  set track1(String track1) {
    this._track1 = track1;
  }

  set track2(String track2) {
    this._track2 = track2;
  }

  set appLabel(String appLabel) {
    this._appLabel = appLabel;
  }

  set aidID(int aidID) {
    this._aidID = aidID;
  }

  set responseEmvTags(String responseEmvTags) {
    this._responseEmvTags = responseEmvTags;
  }

  set cardDecision(int cardDecision) {
    this._cardDecision = cardDecision;
  }

  set finishTags(String finishTags) {
    this._finishTags = finishTags;
  }

  set cvv(String cvv) {
    this._cvv = cvv;
  }

  set cardholderID(String cardholderID) {
    this._cardholderID = cardholderID;
  }

  set accType(int accType) {
    this._accType = accType;
  }

  set signature(bool signature) {
    this._signature = signature;
  }

  set offlinePIN(bool offlinePIN) {
    this._offlinePIN = offlinePIN;
  }

  set triesLeft(int triesLeft) {
    this._triesLeft = triesLeft;
  }

  set blockedPIN(bool blockedPIN) {
    this._blockedPIN = blockedPIN;
  }

  set onlinePIN(bool onlinePIN) {
    this._onlinePIN = onlinePIN;
  }

  set pinBlock(String pinBlock) {
    this._pinBlock = pinBlock;
  }

  set pinKSN(String pinKSN) {
    this._pinKSN = pinKSN;
  }

  set referenceNumber(String referenceNumber) {
    this._referenceNumber = referenceNumber;
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
    map['pan'] = this._pan;
    map['track1'] = this._track1;
    map['track2'] = this._track2;
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
    map['aidID'] = this._aidID;
    map['responseEmvTags'] = this._responseEmvTags;
    map['cardDecision'] = this._cardDecision;
    map['finishTags'] = this._finishTags;
    map['cvv'] = this._cvv;
    map['cardholderID'] = this._cardholderID;
    map['accType'] = this._accType;
    map['signature'] = boolToInt(this._signature);
    map['offlinePIN'] = boolToInt(this._offlinePIN);
    map['triesLeft'] = this._triesLeft;
    map['blockedPIN'] = boolToInt(this._blockedPIN);
    map['onlinePIN'] = boolToInt(this._onlinePIN);
    map['pinBlock'] = this._pinBlock;
    map['pinKSN'] = this._pinKSN;
    map['referenceNumber'] = this._referenceNumber;

    return map;
  }

  Map<String, dynamic> toDBMap() {
    var map = Map<String, dynamic>();

    // some fields from trans should not be stored in the DB for security

    map['id'] = this._id;
    map['number'] = this._number;
    map['stan'] = this._stan;
    map['dateTime'] = this._dateTime.toString();
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
    map['aidID'] = this._aidID;
    map['responseEmvTags'] = this._responseEmvTags;
    map['cardDecision'] = this._cardDecision;
    map['finishTags'] = this._finishTags;
    map['cvv'] = this._cvv;
    map['cardholderID'] = this._cardholderID;
    map['accType'] = this._accType;
    map['signature'] = boolToInt(this._signature);
    map['offlinePIN'] = boolToInt(this._offlinePIN);
    map['blockedPIN'] = boolToInt(this._blockedPIN);
    map['onlinePIN'] = boolToInt(this._onlinePIN);
    map['referenceNumber'] = this._referenceNumber;

    return map;
  }

  Trans.fromMap(Map<String, dynamic> trans) {
    this._id = trans['id'];
    this._number = trans['number'];
    this._stan = trans['stan'];
    this._dateTime = DateTime.parse(trans['dateTime']);
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
    this._aidID = trans['aidID'];
    this._responseEmvTags = trans['responseEmvTags'];
    this._cardDecision = trans['cardDecision'];
    this._finishTags = trans['finishTags'];
    this._cvv = trans['cvv'];
    this._cardholderID = trans['cardholderID'];
    this._accType = trans['accType'];
    this._signature = intToBool(trans['signature']);
    this._offlinePIN = intToBool(trans['offlinePIN']);
    this._triesLeft = trans['triesLeft'];
    this._blockedPIN = intToBool(trans['blockedPIN']);
    this._onlinePIN = intToBool(trans['onlinePIN']);
    this._pinBlock = trans['pinBlock'];
    this._pinKSN = trans['pinKSN'];
    this._referenceNumber = trans['referenceNumber'];
  }

  void clear() {
    _number = 0;
    _stan = 0;
    _dateTime = DateTime.parse('');
    _type = '';
    _reverse = 0;
    _advice = 0;
    _aquirer = 0;
    _bin = 0;
    _maskedPAN = '';
    _cipheredPAN = '';
    _panHash = '';
    _cipheredCardHolderName = '';
    _cipheredTrack2 = '';
    _expDate = '';
    _serviceCode = '';
    _currency = 0;
    _entryMode = 0;
    _baseAmount = 0;
    _tip = 0;
    _tax = 0;
    _cashback = 0;
    _total = 0;
    _origialTotal = 0;
    _responseCode = '';
    _authNumber = '';
    _hostRRN = '';
    _emvTags = '';
    _appType = 0;
    _cardType = 0;
    _panSequenceNumber = 0;
    _cardholderName = '';
    _pan = '';
    _track1 = '';
    _track2 = '';
    _appLabel = '';
    _aidID = 0;
    _responseEmvTags = '';
    _cardDecision = 0;
    _finishTags = '';
    _cvv = '';
    _cardholderID = '';
    _accType = 0;
    _signature = false;
    _offlinePIN = false;
    _triesLeft = 0;
    _blockedPIN = false;
    _onlinePIN = false;
    _pinBlock = '';
    _pinKSN = '';
    _referenceNumber = '';
  }

  void clearCardData() {
    _bin = 0;
    _maskedPAN = '';
    _cipheredPAN = '';
    _panHash = '';
    _cipheredCardHolderName = '';
    _cipheredTrack2 = '';
    _expDate = '';
    _serviceCode = '';
    _entryMode = 0;
    _emvTags = '';
    _appType = 0;
    _cardType = 0;
    _panSequenceNumber = 0;
    _cardholderName = '';
    _pan = '';
    _track1 = '';
    _track2 = '';
    _appLabel = '';
    _aidID = 0;
    _cardDecision = 0;
    _cvv = '';
    _accType = 0;
    _signature = false;
    _offlinePIN = false;
    _triesLeft = 0;
    _blockedPIN = false;
    _onlinePIN = false;
    _pinBlock = '';
    _pinKSN = '';
  }
}
