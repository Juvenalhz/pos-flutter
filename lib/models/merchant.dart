class Merchant {
  int _id;
  String _nameL1 = '';
  String _nameL2 = '';
  String _tid = '';
  String _mid = '';
  int _currencyCode = 0;
  String _currencySymbol = '';
  int _countryCode = 0;
  String _password = '';
  String _header = '';
  int _amountMaxDigits = 0;
  int _amountDecimalPosition = 0;
  int _batchNumber = 0;
  int _maxTip = 0;
  String _city = '';
  String _taxID = '';
  String _logo = '';
  int _acquirerCode = 0;

  Merchant(this._nameL1, this._tid, this._mid,
      [this._nameL2,
      this._currencyCode,
      this._currencySymbol,
      this._countryCode,
      this._password,
      this._header,
      this._amountMaxDigits,
      this._amountDecimalPosition,
      this._batchNumber,
      this._maxTip,
      this._city,
      this._taxID,
      this._logo,
      this._acquirerCode]);

  int get id => _id;
  String get nameL1 => _nameL1;
  String get nameL2 => _nameL2;
  String get tid => _tid;
  String get mid => _mid;
  int get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbol;
  int get countryCode => _countryCode;
  String get password => _password;
  String get header => _header;
  int get amountMaxDigits => _amountMaxDigits;
  int get amountDecimalPosition => _amountDecimalPosition;
  int get batchNumber => _batchNumber;
  int get maxTip => _maxTip;
  String get city => _city;
  String get taxID => _taxID;
  String get logo => _logo;
  int get acquirerCode => _acquirerCode;

  set id(int id) {
    this._id = id;
  }

  set nameL1(String nameL1) {
    this._nameL1 = nameL1;
  }

  set nameL2(String nameL2) {
    this._nameL2 = nameL2;
  }

  set tid(String tid) {
    this._tid = tid;
  }

  set mid(String mid) {
    this._mid = mid;
  }

  set currencyCode(int currencyCode) {
    this._currencyCode = currencyCode;
  }

  set currencySymbol(String currencySymbol) {
    this._currencySymbol = currencySymbol;
  }

  set countryCode(int countryCode) {
    this._countryCode = countryCode;
  }

  set password(String password) {
    this._password = password;
  }

  set header(String header) {
    this._header = header;
  }

  set amountMaxDigits(int amountMaxDigits) {
    this._amountMaxDigits = amountMaxDigits;
  }

  set amountDecimalPosition(int amountDecimalPosition) {
    this._amountDecimalPosition = amountDecimalPosition;
  }

  set batchNumber(int batchNumber) {
    this._batchNumber = batchNumber;
  }

  set maxTip(int maxTip) {
    this._maxTip = maxTip;
  }

  set city(String city) {
    this._city = city;
  }

  set taxID(String taxID) {
    this._taxID = taxID;
  }

  set logo(String logo) {
    this._logo = logo;
  }

  set acquirerCode(int acquirerCode) {
    this._acquirerCode = acquirerCode;
  }

  // Convert a Merchant object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['nameL1'] = _nameL1;
    map['nameL2'] = _nameL2;
    map['tid'] = _tid;
    map['mid'] = _mid;
    map['currencyCode'] = _currencyCode;
    map['currencySymbol'] = _currencySymbol;
    map['countryCode'] = _countryCode;
    map['password'] = _password;
    map['header'] = _header;
    map['amountMaxDigits'] = _amountMaxDigits;
    map['amountDecimalPosition'] = _amountDecimalPosition;
    map['batchNumber'] = _batchNumber;
    map['maxTip'] = _maxTip;
    map['city'] = _city;
    map['taxID'] = _taxID;
    map['logo'] = _logo;
    map['acquirerCode'] = _acquirerCode;

    return map;
  }

  // Extract a Merchant object from a Map object
  Merchant.fromMap(Map<String, dynamic> merchant) {
    this._id = merchant['id'];
    this._nameL1 = merchant['nameL1'];
    this._nameL2 = merchant['nameL2'];
    this._tid = merchant['tid'];
    this._mid = merchant['mid'];
    this._currencyCode = merchant['currencyCode'];
    this._currencySymbol = merchant['currencySymbol'];
    this._countryCode = merchant['countryCode'];
    this._password = merchant['password'];
    this._header = merchant['header'];
    this._amountMaxDigits = merchant['amountMaxDigits'];
    this._amountDecimalPosition = merchant['amountDecimalPosition'];
    this._batchNumber = merchant['batchNumber'];
    this._maxTip = merchant['maxTip'];
    this._city = merchant['city'];
    this._taxID = merchant['taxID'];
    this._logo = merchant['logo'];
    this._acquirerCode = merchant['acquirerCode'];
  }
}
