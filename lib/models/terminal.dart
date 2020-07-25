class Terminal{
  int _id;
  String _password;
  String _techPassword;
  String _idTerminal;
  int _kin;
  int _minPinDigits;
  int _maxPinDigits;
  int _timeoutPrompt;
  int _maxTipPercentage;
  int _keyIndex;
  String _industry;
  String _print;
  int _cashback;
  int _installments;
  int _refund;
  int _last4Digits;
  int _passwordVoid;
  int _passwordBatch;
  int _passwordRefund;
  int _maskPan;
  int _amountConfirmation;

  Terminal(this._id, this._idTerminal,
    [this._password,
    this._techPassword,
    this._kin,
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
    this._amountConfirmation]);

  int get id => _id;
  String get password => _password;
  String get techPassword => _techPassword;
  String get idTerminal => _idTerminal;
  int get kin => _kin;
  int get minPinDigits => _minPinDigits;
  int get maxPinDigits => _maxPinDigits;
  int get timeoutPrompt => _timeoutPrompt;
  int get maxTipPercentage => _maxTipPercentage;
  int get keyIndex => _keyIndex;
  String get industry => _industry;
  String get print => _print;
  int get cashback => _cashback;
  int get installments => _installments;
  int get refund => _refund;
  int get last4Digits => _last4Digits;
  int get passwordVoid => _passwordVoid;
  int get passwordBatch => _passwordBatch;
  int get passwordRefund => _passwordRefund;
  int get maskPan => _maskPan;
  int get amountConfirmation => _amountConfirmation;

  set id(int id) {
    this._id = id;
  }

  set password(String password){
    this._password = password;
  }

  set techPassword(String techPassword){
    this._techPassword = techPassword;
  }

  set idTerminal(String idTerminal){
    this._idTerminal = idTerminal;
  }

  set kin(int kin){
    this._kin = kin;
  }

  set minPinDigits(int minPinDigits) {
    this._minPinDigits = minPinDigits;
  }

  set maxPinDigits(int maxPinDigits){
    this._maxPinDigits = maxPinDigits;
  }

  set timeoutPrompt(int timeoutPrompt){
    this._timeoutPrompt = timeoutPrompt;
  }

  set maxTipPercentage(int maxTipPercentage){
    this._maxTipPercentage = maxTipPercentage;
  }

  set keyIndex(int keyIndex){
    this._keyIndex = keyIndex;
  }

  set industry(String industry){
    this._industry = industry;
  }

  set print(String print){
    this._print = print;
  }

  set cashback(int cashback){
    this._cashback = cashback;
  }

  set installments(int installments){
    this._installments = installments;
  }

  set refund(int refund){
    this._refund = refund;
  }

  set last4Digits(int last4Digits){
    this._last4Digits = last4Digits;
  }

  set passwordVoid(int passwordVoid){
    this._passwordVoid = passwordVoid;
  }

  set passwordBatch(int passwordBatch){
    this._passwordBatch = passwordBatch;
  }

  set passwordRefund(int passwordRefund){
    this._passwordRefund = passwordRefund;
  }

  set maskPan(int maskPan){
    this._maskPan = maskPan;
  }

  set amountConfirmation(int amountConfirmation){
    this._amountConfirmation = amountConfirmation;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['password'] = this._password;
    map['techPassword'] = this._techPassword;
    map['idTerminal'] = this._idTerminal;
    map['kin'] = this._kin;
    map['minPinDigits'] = this._minPinDigits;
    map['maxPinDigits'] = this._maxPinDigits;
    map['timeoutPrompt'] = this._timeoutPrompt;
    map['maxTipPercentage'] = this._maxTipPercentage;
    map['keyIndex'] = this._keyIndex;
    map['industry'] = this._industry;
    map['print'] = this._print;
    map['cashback'] = this._cashback;
    map['installments'] = this._installments;
    map['refund'] = this._refund;
    map['last4Digits'] = this._last4Digits;
    map['passwordVoid'] = this._passwordVoid;
    map['passwordBatch'] = this._passwordBatch;
    map['passwordRefund'] = this._passwordRefund;
    map['maskPan'] = this._maskPan;
    map['amountConfirmation'] = this._amountConfirmation;

    return map;
  }

  Terminal.fromMap(Map<String, dynamic> terminal) {
    this._id = terminal['id'];
    this._password = terminal['password'];
    this._techPassword = terminal['techPassword'];
    this._idTerminal = terminal['idTerminal'];
    this._kin = terminal['kin'];
    this._minPinDigits = terminal['minPinDigits'];
    this._maxPinDigits = terminal['maxPinDigits'];
    this._timeoutPrompt = terminal['timeoutPrompt'];
    this._maxTipPercentage = terminal['maxTipPercentage'];
    this._keyIndex = terminal['keyIndex'];
    this._industry = terminal['industry'];
    this._print = terminal['print'];
    this._cashback = terminal['cashback'];
    this._installments = terminal['installments'];
    this._refund = terminal['refund'];
    this._last4Digits = terminal['last4Digits'];
    this._passwordVoid = terminal['passwordVoid'];
    this._passwordBatch = terminal['passwordBatch'];
    this._passwordBatch = terminal['passwordRefund'];
    this._maskPan = terminal['maskPan'];
    this._amountConfirmation = terminal['amountConfirmation'];
  }

}

