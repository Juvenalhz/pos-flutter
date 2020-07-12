class Merchant {
  int _id;
  String _name;
  String _TID;
  String _MID;
  int _CurrencyCode;
  String _CurrencySymbol;
  String _Password;
  String _Header;
  int _Amount_MaxDigtis;
  int _Amount_DecimalPosition;
  int _BatchNumber;
  int _MaxTip;
  String _Address;
  String _TaxID;

  Merchant(this._name, this._TID, this._MID,
      [this._CurrencyCode,
      this._CurrencySymbol,
      this._Password,
      this._Header,
      this._Amount_MaxDigtis,
      this._Amount_DecimalPosition,
      this._BatchNumber,
      this._MaxTip,
      this._Address,
      this._TaxID]);

  int get id => _id;
  String get name => _name;
  String get TID => _TID;
  String get MID => _MID;
  int get CurrencyCode => _CurrencyCode;
  String get CurrencySymbol => _CurrencySymbol;
  String get Password => _Password;
  String get Header => _Header;
  int get Amount_MaxDigtis => _Amount_MaxDigtis;
  int get Amount_DecimalPosition => _Amount_DecimalPosition;
  int get BatchNumber => _BatchNumber;
  int get MaxTip => _MaxTip;
  String get Address => _Address;
  String get TaxID => _TaxID;

  set name(String name) {
    this._name = name;
  }

  set TID(String TID) {
    this._TID = TID;
  }

  set MID(String MID) {
    this._MID = MID;
  }

  set CurrencyCode(int CurrencyCode) {
    this._CurrencyCode = CurrencyCode;
  }

  set CurrencySymbol(String CurrencySymbol) {
    this._CurrencySymbol = CurrencySymbol;
  }

  set Password(String Password) {
    this._Password = Password;
  }

  set Header(String Header) {
    this._Header = Header;
  }

  set Amount_MaxDigtis(int Amount_MaxDigtis) {
    this._Amount_MaxDigtis = Amount_MaxDigtis;
  }

  set Amount_DecimalPosition(int Amount_DecimalPosition) {
    this._Amount_DecimalPosition = Amount_DecimalPosition;
  }

  set BatchNumber(int BatchNumber) {
    this._BatchNumber = BatchNumber;
  }

  set MaxTip(int MaxTip) {
    this._MaxTip = MaxTip;
  }

  set Address(String Address) {
    this._Address = Address;
  }

  set TaxID(String TaxID) {
    this._TaxID = TaxID;
  }

  // Convert a Merchant object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['Name'] = _name;
    map['TID'] = _TID;
    map['MID'] = _MID;
    map['CurrencyCode'] = _CurrencyCode;
    map['CurrencySymbol'] = _CurrencySymbol;
    map['Password'] = _Password;
    map['Header'] = _Header;
    map['Amount_MaxDigtis'] = _Amount_MaxDigtis;
    map['Amount_DecimalPosition'] = _Amount_DecimalPosition;
    map['BatchNumber'] = _BatchNumber;
    map['MaxTip'] = _MaxTip;
    map['Address'] = _Address;
    map['TaxID'] = _TaxID;

    return map;
  }

  // Extract a Merchant object from a Map object
  Merchant.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['Name'];
    this._TID = map['TID'];
    this._MID = map['MID'];
    this._CurrencyCode = map['CurrencyCode'];
    this._CurrencySymbol = map['CurrencySymbol'];
    this._Password = map['Password'];
    this._Header = map['Header'];
    this._Amount_MaxDigtis = map['Amount_MaxDigtis'];
    this._Amount_DecimalPosition = map['Amount_DecimalPosition'];
    this._BatchNumber = map['BatchNumber'];
    this._MaxTip = map['MaxTip'];
    this._Address = map['Address'];
    this._TaxID = map['TaxID'];
  }
}
