class Comm {
  int _id;
  String _tpdu;
  String _nii;
  int _timeout;
  String _ip;
  int _port;

  Comm(this._id, this._tpdu, this._nii, this._timeout, this._ip, this._port);

  int get id => this._id;
  String get tpdu => this._tpdu;
  String get nii => this._nii;
  int get timeout => this._timeout;
  String get ip => this._ip;
  int get port => this._port;

  set id(int id) {
    this._id = id;
  }

  set tpdu(String tpdu) {
    this._tpdu = tpdu;
  }

  set nii(String nii) {
    this._nii = nii;
  }

  set timeout(int timeout) {
    this._timeout = timeout;
  }

  set ip(String ip) {
    this._ip = ip;
  }

  set port(int port) {
    this._port = port;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this._id;
    map['tpdu'] = this._tpdu;
    map['nii'] = this._nii;
    map['timeout'] = this._timeout;
    map['ip'] = this._ip;
    map['port'] = this._port;

    return map;
  }

  Comm.fromMap(Map<String, dynamic> comm) {
    this._id = comm['id'];
    this._tpdu = comm['tpdu'];
    this._nii = comm['nii'];
    this._timeout = comm['timeout'];
    this._ip = comm['ip'];
    this._port = comm['port'];
  }
}
