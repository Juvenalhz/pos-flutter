import 'package:pay/utils/dataUtils.dart';

class Terminal {
  int _id;
  String _password = '';
  String _techPassword = '';
  String _idTerminal = '';

  int _minPinDigits = 0;
  int _maxPinDigits = 0;
  int _timeoutPrompt = 0;
  int _maxTipPercentage = 0;
  int _keyIndex = 0;
  String _industry = '';
  bool _print = false;
  bool _cashback = false;
  bool _installments = false;
  bool _refund = false;
  bool _last4Digits = false;
  bool _passwordVoid = false;
  bool _passwordBatch = false;
  bool _passwordRefund = false;
  bool _maskPan = false;
  bool _amountConfirmation = false;
  bool _debitPrint = false;
  bool _creditPrint = false;
  int _numPrint = 0;

  Terminal(this._id, this._idTerminal,
      [this._password,
      this._techPassword,
      this._minPinDigits,
      this._maxPinDigits,
      this._timeoutPrompt,
      this._maxTipPercentage,
      this._keyIndex,
      this._industry,
      this._print,
      this._cashback,
      this._installments,
      this._refund,
      this._last4Digits,
      this._passwordVoid,
      this._passwordBatch,
      this._passwordRefund,
      this._maskPan,
      this._amountConfirmation,
      this._debitPrint,
      this._creditPrint,
      this._numPrint]);

  int get id => _id;

  String get password => _password;

  String get techPassword => _techPassword;

  String get idTerminal => _idTerminal;
  int get minPinDigits => _minPinDigits;

  int get maxPinDigits => _maxPinDigits;

  int get timeoutPrompt => _timeoutPrompt;

  int get maxTipPercentage => _maxTipPercentage;

  int get keyIndex => _keyIndex;

  String get industry => _industry;

  bool get print => _print;

  bool get cashback => _cashback;

  bool get installments => _installments;

  bool get refund => _refund;

  bool get last4Digits => _last4Digits;

  bool get passwordVoid => _passwordVoid;

  bool get passwordBatch => _passwordBatch;

  bool get passwordRefund => _passwordRefund;

  bool get maskPan => _maskPan;

  bool get amountConfirmation => _amountConfirmation;

  bool get debitPrint => _debitPrint;

  bool get creditPrint => _creditPrint;

  int get numPrint => _numPrint;

  set id(int id) {
    this._id = id;
  }

  set password(String password) {
    this._password = password;
  }

  set techPassword(String techPassword) {
    this._techPassword = techPassword;
  }

  set idTerminal(String idTerminal) {
    this._idTerminal = idTerminal;
  }

  set minPinDigits(int minPinDigits) {
    this._minPinDigits = minPinDigits;
  }

  set maxPinDigits(int maxPinDigits) {
    this._maxPinDigits = maxPinDigits;
  }

  set timeoutPrompt(int timeoutPrompt) {
    this._timeoutPrompt = timeoutPrompt;
  }

  set maxTipPercentage(int maxTipPercentage) {
    this._maxTipPercentage = maxTipPercentage;
  }

  set keyIndex(int keyIndex) {
    this._keyIndex = keyIndex;
  }

  set industry(String industry) {
    this._industry = industry;
  }

  set print(bool print) {
    this._print = print;
  }

  set cashback(bool cashback) {
    this._cashback = cashback;
  }

  set installments(bool installments) {
    this._installments = installments;
  }

  set refund(bool refund) {
    this._refund = refund;
  }

  set last4Digits(bool last4Digits) {
    this._last4Digits = last4Digits;
  }

  set passwordVoid(bool passwordVoid) {
    this._passwordVoid = passwordVoid;
  }

  set passwordBatch(bool passwordBatch) {
    this._passwordBatch = passwordBatch;
  }

  set passwordRefund(bool passwordRefund) {
    this._passwordRefund = passwordRefund;
  }

  set maskPan(bool maskPan) {
    this._maskPan = maskPan;
  }

  set amountConfirmation(bool amountConfirmation) {
    this._amountConfirmation = amountConfirmation;
  }

  set debitPrint(bool debitPrint) {
    this._debitPrint = debitPrint;
  }

  set creditPrint(bool creditPrint) {
    this._creditPrint = creditPrint;
  }
  set numPrint(int numPrint) {
    this._numPrint = numPrint;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['password'] = this._password;
    map['techPassword'] = this._techPassword;
    map['idTerminal'] = this._idTerminal;
    map['minPinDigits'] = this._minPinDigits;
    map['maxPinDigits'] = this._maxPinDigits;
    map['timeoutPrompt'] = this._timeoutPrompt;
    map['maxTipPercentage'] = this._maxTipPercentage;
    map['keyIndex'] = this._keyIndex;
    map['industry'] = this._industry;
    map['print'] = boolToInt(this._print);
    map['cashback'] = boolToInt(this._cashback);
    map['installments'] = boolToInt(this._installments);
    map['refund'] = boolToInt(this._refund);
    map['last4Digits'] = boolToInt(this._last4Digits);
    map['passwordVoid'] = boolToInt(this._passwordVoid);
    map['passwordBatch'] = boolToInt(this._passwordBatch);
    map['passwordRefund'] = boolToInt(this._passwordRefund);
    map['maskPan'] = boolToInt(this._maskPan);
    map['amountConfirmation'] = boolToInt(this._amountConfirmation);
    map['debitPrint'] = boolToString(this._debitPrint);
    map['creditPrint'] = boolToString(this._creditPrint);
    map['numPrint'] = this._numPrint;

    return map;
  }

  Terminal.fromMap(Map<String, dynamic> terminal) {
    this._id = terminal['id'];
    this._password = terminal['password'];
    this._techPassword = terminal['techPassword'];
    this._idTerminal = terminal['idTerminal'];
    this._minPinDigits = terminal['minPinDigits'];
    this._maxPinDigits = terminal['maxPinDigits'];
    this._timeoutPrompt = terminal['timeoutPrompt'];
    this._maxTipPercentage = terminal['maxTipPercentage'];
    this._keyIndex = terminal['keyIndex'];
    this._industry = terminal['industry'];
    this._print = intToBool(terminal['print']);
    this._cashback = intToBool(terminal['cashback']);
    this._installments = intToBool(terminal['installments']);
    this._refund = intToBool(terminal['refund']);
    this._last4Digits = intToBool(terminal['last4Digits']);
    this._passwordVoid = intToBool(terminal['passwordVoid']);
    this._passwordBatch = intToBool(terminal['passwordBatch']);
    this._passwordRefund = intToBool(terminal['passwordRefund']);
    this._maskPan = intToBool(terminal['maskPan']);
    this._amountConfirmation = intToBool(terminal['amountConfirmation']);
    this._debitPrint = intToBool(terminal['debitPrint']);
    this._creditPrint = intToBool(terminal['creditPrint']);
    this._numPrint = terminal['numPrint'];
  }
}
