import 'package:pay/utils/dataUtils.dart';

class Bin {
  int _id;
  String _type;
  int _binLow;
  int _binHigh;
  int _cardType;
  String _brand;
  bool _cashback;
  bool _pin;
  bool _manualEntry;
  bool _fallback;

  Bin() {}

  int get id => this._id;
  String get type => this._type;
  int get binLow => this._binLow;
  int get binHigh => this._binHigh;
  int get cardType => this._cardType;
  String get brand => this._brand;
  bool get cashback => this._cashback;
  bool get pin => this._pin;
  bool get manualEntry => this._manualEntry;
  bool get fallback => this._fallback;

  set id(int id) {
    this._id = id;
  }

  set type(String type) {
    this._type = type;
  }

  set binLow(int binLow) {
    this._binLow = binLow;
  }

  set binHigh(int binHigh) {
    this._binHigh = binHigh;
  }

  set cardType(int cardType) {
    this._cardType = cardType;
  }

  set brand(String brand) {
    this._brand = brand;
  }

  set cashback(bool cashback) {
    this._cashback = cashback;
  }

  set pin(bool pin) {
    this._pin = pin;
  }

  set manualEntry(bool manualEntry) {
    this._manualEntry = manualEntry;
  }

  set fallback(bool fallback) {
    this._fallback = fallback;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['type'] = this._type;
    map['binLow'] = this._binLow;
    map['binHigh'] = this._binHigh;
    map['cardType'] = this._cardType;
    map['brand'] = this._brand;
    map['cashback'] = boolToInt(this._cashback);
    map['pin'] = boolToInt(this._pin);
    map['manualEntry'] = boolToInt(this._manualEntry);
    map['fallback'] = boolToInt(this._fallback);

    return map;
  }

  Bin.fromMap(Map<String, dynamic> bin) {
    this._id = bin['id'];
    this._type = bin['type'];
    this._binLow = bin['binLow'];
    this._binHigh = bin['binHigh'];
    this._cardType = bin['cardType'];
    this._brand = bin['brand'];
    this._cashback = intToBool(bin['cashback']);
    this._pin = intToBool(bin['pin']);
    this._manualEntry = intToBool(bin['manualEntry']);
    this._fallback = intToBool(bin['fallback']);
  }
}
