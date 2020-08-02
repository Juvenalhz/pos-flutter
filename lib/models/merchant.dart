class Merchant {
  int _id;
  String _name;
  String _TID;
  String _MID;
  int _CurrencyCode;
  String _CurrencySymbol;
  String _CountryCode;
  String _Password;
  String _Header;
  int _Amount_MaxDigtis;
  int _Amount_DecimalPosition;
  int _BatchNumber;
  int _MaxTip;
  String _Address;
  String _TaxID;
  String _Logo;
  String _AcquirerCode;


  Merchant(this._name, this._TID, this._MID,
      [this._CurrencyCode,
      this._CurrencySymbol,
      this._CountryCode,
      this._Password,
      this._Header,
      this._Amount_MaxDigtis,
      this._Amount_DecimalPosition,
      this._BatchNumber,
      this._MaxTip,
      this._Address,
      this._TaxID,
      this._Logo,
      this._AcquirerCode]);

  int get id => _id;
  String get name => _name;
  String get TID => _TID;
  String get MID => _MID;
  int get CurrencyCode => _CurrencyCode;
  String get CurrencySymbol => _CurrencySymbol;
  String get CountryCode => _CountryCode;
  String get Password => _Password;
  String get Header => _Header;
  int get Amount_MaxDigtis => _Amount_MaxDigtis;
  int get Amount_DecimalPosition => _Amount_DecimalPosition;
  int get BatchNumber => _BatchNumber;
  int get MaxTip => _MaxTip;
  String get Address => _Address;
  String get TaxID => _TaxID;
  String get Logo => _Logo;
  String get AcquirerCode => _AcquirerCode;

  set id(int id) {
    this._id = id;
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

  set CountryCode(String CountryCode) {
    this._CountryCode = CountryCode;
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

  set Logo(String Logo) {
    this._Logo = Logo;
  }

  set AcquirerCode(String AcquirerCode){
    this._AcquirerCode = AcquirerCode;
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
    map['CountryCode'] = _CountryCode;
    map['Password'] = _Password;
    map['Header'] = _Header;
    map['Amount_MaxDigtis'] = _Amount_MaxDigtis;
    map['Amount_DecimalPosition'] = _Amount_DecimalPosition;
    map['BatchNumber'] = _BatchNumber;
    map['MaxTip'] = _MaxTip;
    map['Address'] = _Address;
    map['TaxID'] = _TaxID;
    map['Logo'] = _Logo;
    map['AcquirerCode'] = _AcquirerCode;

    return map;
  }

  // Extract a Merchant object from a Map object
  Merchant.fromMap(Map<String, dynamic> merchant) {
    this._id = merchant['id'];
    this._name = merchant['Name'];
    this._TID = merchant['TID'];
    this._MID = merchant['MID'];
    this._CurrencyCode = merchant['CurrencyCode'];
    this._CurrencySymbol = merchant['CurrencySymbol'];
    this._CountryCode = merchant['CountryCode'];
    this._Password = merchant['Password'];
    this._Header = merchant['Header'];
    this._Amount_MaxDigtis = merchant['Amount_MaxDigtis'];
    this._Amount_DecimalPosition = merchant['Amount_DecimalPosition'];
    this._BatchNumber = merchant['BatchNumber'];
    this._MaxTip = merchant['MaxTip'];
    this._Address = merchant['Address'];
    this._TaxID = merchant['TaxID'];
    this._Logo = merchant['Logo'];
    this._AcquirerCode = merchant['AcquirerCode'];
  }
}
