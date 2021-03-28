import 'package:pay/utils/cipher.dart';
import 'package:pay/utils/dataUtils.dart';

class Trans {
  int _id;
  int _number = 0;
  int _stan = 0;
  DateTime _dateTime = DateTime.now();
  String _type = '';
  bool _reverse = false;
  bool _advice = false;
  int _acquirer = 0;
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
  int _originalTotal = 0;
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
  String _authCode = '';
  String _respCode = '';
  int _batchNum = 0;
  String _respMessage = '';
  int _binType = 0;
  int _foodBalance = 0;
  bool _voided = false;
  String _issuer = '';
  int _server = 0;
  bool _tipAdjusted = false;
  bool _chipEnable = true;

  Trans();

  int get id => this._id;
  int get number => this._number;
  int get stan => this._stan;
  DateTime get dateTime => this._dateTime;
  String get type => this._type;
  bool get reverse => this._reverse;
  bool get advice => this._advice;
  int get acquirer => this._acquirer;
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
  int get originalTotal => this._originalTotal;
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
  String get authCode => this._authCode;
  String get respCode => this._respCode;
  int get batchNum => this._batchNum;
  String get respMessage => this._respMessage;
  int get binType => this._binType;
  int get foodBalance => this._foodBalance;
  bool get voided => _voided;
  String get issuer => _issuer;
  int get server => _server;
  bool get tipAdjusted => _tipAdjusted;
  bool get chipEnable => _chipEnable;

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

  set reverse(bool reverse) {
    this._reverse = reverse;
  }

  set advice(bool advice) {
    this._advice = advice;
  }

  set acquirer(int acquirer) {
    this._acquirer = acquirer;
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

  set originalTotal(int originalTotal) {
    this._originalTotal = originalTotal;
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

  set authCode(String authCode) {
    this._authCode = authCode;
  }

  set respCode(String respCode) {
    this._respCode = respCode;
  }

  set batchNum(int batchNum) {
    this._batchNum = batchNum;
  }

  set respMessage(String respMessage) {
    this._respMessage = respMessage;
  }

  set binType(int binType) {
    this._binType = binType;
  }

  set foodBalance(int foodBalance) {
    this._foodBalance = foodBalance;
  }

  set voided(bool voided) {
    this._voided = voided;
  }

  set issuer(String issuer) {
    this._issuer = issuer;
  }

  set server(int server) {
    this._server = server;
  }

  set tipAdjusted(bool tipAdjusted) {
    this._tipAdjusted = tipAdjusted;
  }

  set chipEnable(bool chipEnable) {
    this._chipEnable = chipEnable;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['number'] = this._number;
    map['stan'] = this._stan;
    map['dateTime'] = this._dateTime.toString();
    map['type'] = this._type;
    map['reverse'] = boolToInt(this._reverse);
    map['advice'] = boolToInt(this._advice);
    map['acquirer'] = this._acquirer;
    map['bin'] = this._bin;
    map['pan'] = this._pan;
    map['track1'] = this._track1;
    map['track2'] = this._track2;
    map['maskedPAN'] = this._maskedPAN;
    map['cipheredPAN'] = this._cipheredPAN;
    map['panHash'] = this._panHash;
    map['cipheredCardHolderName'] = this._cipheredCardHolderName;
    map['cipheredTrack2'] = this._cipheredTrack2;
    map['appLabel'] = this._appLabel;
    map['expDate'] = this._expDate;
    map['serviceCode'] = this._serviceCode;
    map['currency'] = this._currency;
    map['entryMode'] = this._entryMode;
    map['baseAmount'] = this._baseAmount;
    map['tip'] = this._tip;
    map['tax'] = this._tax;
    map['cashback'] = this._cashback;
    map['total'] = this._total;
    map['originalTotal'] = this._originalTotal;
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
    map['authCode'] = this._authCode;
    map['respCode'] = this._respCode;
    map['batchNum'] = this._batchNum;
    map['respMessage'] = this._respMessage;
    map['binType'] = this._binType;
    map['foodBalance'] = this._foodBalance;
    map['voided'] = this._voided;
    map['issuer'] = this._issuer;
    map['voided'] = boolToInt(this._voided);
    map['server'] = this._server;
    map['tipAdjusted'] = boolToInt(this._tipAdjusted);
    map['cardType'] = this._cardType;

    return map;
  }

  Future<Map<String, dynamic>> toDBMap() async {
    var map = Map<String, dynamic>();
    // NOTE IMPORTANT!!!!!!
    // some fields from trans should not be stored in the DB for security
    // !!!!!!!!!!!!!!!!!!!!
    var cipher = Cipher();
    this._cipheredPAN = await cipher.encryptCriticalData(this.pan);
    if (this.cardholderName.length > 0) this._cipheredCardHolderName = await cipher.encryptCriticalData(this.cardholderName);

    map['id'] = this._id;
    map['number'] = this._number;
    map['stan'] = this._stan;
    map['dateTime'] = this._dateTime.toString();
    map['type'] = this._type;
    map['reverse'] = boolToInt(this._reverse);
    map['advice'] = boolToInt(this._advice);
    map['acquirer'] = this._acquirer;
    map['bin'] = this._bin;
    map['maskedPAN'] = this._maskedPAN;
    map['cipheredPAN'] = this._cipheredPAN;
    map['panHash'] = this._panHash;
    map['cipheredCardHolderName'] = this._cipheredCardHolderName;
    map['cipheredTrack2'] = this._cipheredTrack2;
    map['appLabel'] = this._appLabel;
    map['expDate'] = this._expDate;
    map['serviceCode'] = this._serviceCode;
    map['currency'] = this._currency;
    map['entryMode'] = this._entryMode;
    map['baseAmount'] = this._baseAmount;
    map['tip'] = this._tip;
    map['tax'] = this._tax;
    map['cashback'] = this._cashback;
    map['total'] = this._total;
    map['originalTotal'] = this._originalTotal;
    map['emvTags'] = this._emvTags;
    map['aidID'] = this._aidID;
    map['responseEmvTags'] = this._responseEmvTags;
    map['cardDecision'] = this._cardDecision;
    map['finishTags'] = this._finishTags;
    map['cardholderID'] = this._cardholderID;
    map['accType'] = this._accType;
    map['signature'] = boolToInt(this._signature);
    map['offlinePIN'] = boolToInt(this._offlinePIN);
    map['blockedPIN'] = boolToInt(this._blockedPIN);
    map['onlinePIN'] = boolToInt(this._onlinePIN);
    map['referenceNumber'] = this._referenceNumber;
    map['authCode'] = this._authCode;
    map['respCode'] = this._respCode;
    map['batchNum'] = this._batchNum;
    map['binType'] = this._binType;
    map['foodBalance'] = this._foodBalance;
    map['voided'] = boolToInt(this._voided);
    map['issuer'] = this._issuer;
    map['server'] = this._server;
    map['tipAdjusted'] = boolToInt(this._tipAdjusted);
    map['cardType'] = this._cardType;

    return map;
  }

  Trans.fromMap(Map<String, dynamic> trans) {
    this._id = trans['id'];
    this._number = trans['number'];
    this._stan = trans['stan'];
    this._dateTime = DateTime.parse(trans['dateTime']);
    this._type = trans['type'];
    this._reverse = intToBool(trans['reverse']);
    this._advice = intToBool(trans['advice']);
    this._acquirer = trans['acquirer'];
    this._bin = trans['bin'];
    this._maskedPAN = trans['maskedPAN'];
    this._cipheredPAN = trans['cipheredPAN'];
    this._panHash = trans['panHash'];
    this._cipheredCardHolderName = trans['cipheredCardHolderName'];
    this._cipheredTrack2 = trans['cipheredTrack2'];
    this._appLabel = trans['appLabel'];
    this._expDate = trans['expDate'];
    this._serviceCode = trans['serviceCode'];
    this._currency = trans['currency'];
    this._entryMode = trans['entryMode'];
    this._baseAmount = trans['baseAmount'];
    this._tip = trans['tip'];
    this._tax = trans['tax'];
    this._cashback = trans['cashback'];
    this._total = trans['total'];
    this._originalTotal = trans['originalTotal'];
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
    this._authCode = trans['authCode'];
    this._respCode = trans['respCode'];
    this._batchNum = trans['batchNum'];
    this._respMessage = trans['respMessage'];
    this._binType = trans['binType'];
    this._foodBalance = trans['foodBalance'];
    this._voided = intToBool(trans['voided']);
    this._issuer = trans['issuer'];
    this._server = trans['server'];
    this._tipAdjusted = intToBool(trans['tipAdjusted']);
    this._cardType = trans['cardType'];
  }

  void clear() {
    _number = 0;
    _stan = 0;
    _dateTime = DateTime.now();
    _type = '';
    _reverse = false;
    _advice = false;
    _acquirer = 0;
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
    _originalTotal = 0;
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
    _authCode = '';
    _respCode = '';
    _batchNum = 0;
    _respMessage = '';
    _binType = 0;
    _foodBalance = 0;
    _voided = false;
    _issuer = '';
    _server = 0;
    _tipAdjusted = false;
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
    _binType = 0;
    _foodBalance = 0;
    _issuer = '';
  }

  Future<String> getClearPan() async {
    final cipher = Cipher();

    return await cipher.decryptCriticalData(cipheredPAN);
  }
}
