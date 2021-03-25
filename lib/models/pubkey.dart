class PubKey {
  int _id;
  int _keyIndex;
  String _rid;
  String _exponent;
  String _expDate;
  int _length;
  String _modulus;

  PubKey();

  int get id => this._id;
  int get keyIndex => this._keyIndex;
  String get rid => this._rid;
  String get exponent => this._exponent;
  String get expDate => this._expDate;
  int get length => this._length;
  String get modulus => this._modulus;

  set id(int id) {
    this._id = id;
  }

  set keyIndex(int keyIndex) {
    this._keyIndex = keyIndex;
  }

  set rid(String rid) {
    this._rid = rid;
  }

  set exponent(String exponent) {
    this._exponent = exponent;
  }

  set expDate(String expDate) {
    this._expDate = expDate;
  }

  set length(int length) {
    this._length = length;
  }

  set modulus(String modulus) {
    this._modulus = modulus;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['keyIndex'] = this._keyIndex;
    map['rid'] = this._rid;
    map['exponent'] = this._exponent;
    map['expDate'] = this._expDate;
    map['length'] = this._length;
    map['modulus'] = this._modulus;

    return map;
  }

  PubKey.fromMap(Map<String, dynamic> pubKey) {
    this._id = pubKey['id'];
    this._keyIndex = pubKey['keyIndex'];
    this._rid = pubKey['rid'];
    this._exponent = pubKey['exponent'];
    this._expDate = pubKey['expDate'];
    this._length = pubKey['length'];
    this._modulus = pubKey['modulus'];
  }
}
