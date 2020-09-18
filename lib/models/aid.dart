class AID {
  int _id;
  String _aid;
  int _floorLimit;
  int _version;
  String _tacDenial;
  String _tacOnline;
  String _tacDefault;
  int _exactMatch;
  int _thresholdAmount;
  int _targetPercentage;
  int _maxTargetPercentage;
  String _tdol;
  String _ddol;

  AID();

  int get id => this._id;
  String get aid => this._aid;
  int get floorLimit => this._floorLimit;
  int get version => this._version;
  String get tacDenial => this._tacDenial;
  String get tacOnline => this._tacOnline;
  String get tacDefault => this._tacDefault;
  int get exactMatch => this._exactMatch;
  int get thresholdAmount => this._thresholdAmount;
  int get targetPercentage => this._targetPercentage;
  int get maxTargetPercentage => this._maxTargetPercentage;
  String get tdol => this._tdol;
  String get ddol => this._ddol;

  set id(int id) {
    this._id = id;
  }

  set aid(String aid) {
    this._aid = aid;
  }

  set floorLimit(int floorLimit) {
    this._floorLimit = floorLimit;
  }

  set version(int version) {
    this._version = version;
  }

  set tacDenial(String TACDenial) {
    this._tacDenial = TACDenial;
  }

  set tacOnline(String TACOnline) {
    this._tacOnline = TACOnline;
  }

  set tacDefault(String _tacDefault) {
    this._tacDefault = _tacDefault;
  }

  set exactMatch(int exactMatch) {
    this._exactMatch = exactMatch;
  }

  set thresholdAmount(int thresholdAmount) {
    this._thresholdAmount = thresholdAmount;
  }

  set targetPercentage(int targetPercentage) {
    this._targetPercentage = targetPercentage;
  }

  set maxTargetPercentage(int maxTargetPercentage) {
    this._maxTargetPercentage = maxTargetPercentage;
  }

  set tdol(String tdol) {
    this._tdol = tdol;
  }

  set ddol(String ddol) {
    this._ddol = ddol;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['aid'] = this._aid;
    map['floorLimit'] = this._floorLimit;
    map['version'] = this._version;
    map['tacDenial'] = this._tacDenial;
    map['tacOnline'] = this._tacOnline;
    map['tacDefault'] = this._tacDefault;
    map['exactMatch'] = this._exactMatch;
    map['thresholdAmount'] = this._thresholdAmount;
    map['targetPercentage'] = this._targetPercentage;
    map['maxTargetPercentage'] = this._maxTargetPercentage;
    map['tdol'] = this._tdol;
    map['ddol'] = this._ddol;

    return map;
  }

  AID.fromMap(Map<String, dynamic> aid) {
    this._id = aid['id'];
    this._aid = aid['aid'];
    this._floorLimit = aid['floorLimit'];
    this._version = aid['version'];
    this._tacDenial = aid['tacDenial'];
    this._tacOnline = aid['tacOnline'];
    this._tacDefault = aid['tacDefault'];
    this._exactMatch = aid['exactMatch'];
    this._thresholdAmount = aid['thresholdAmount'];
    this._targetPercentage = aid['targetPercentage'];
    this._maxTargetPercentage = aid['maxTargetPercentage'];
    this._tdol = aid['tdol'];
    this._ddol = aid['ddol'];
  }
}
