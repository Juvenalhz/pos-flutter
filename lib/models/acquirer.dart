class Acquirer {
  int _id;
  String _name;
  String _rif;

  Acquirer(this._id, this._name, this._rif);

  int get id => this._id;
  String get name => this._name;
  String get rif => this._rif;

  set id(int id) {
    this._id = id;
  }

  set name(String name) {
    this._name = name;
  }

  set rif(String rif) {
    this._rif = rif;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['name'] = this._name;
    map['rif'] = this._rif;

    return map;
  }

  Acquirer.fromMap(Map<String, dynamic> Acquirer) {
    this._id = Acquirer['id'];
    this._name = Acquirer['name'];
    this._rif = Acquirer['rif'];
  }
}
