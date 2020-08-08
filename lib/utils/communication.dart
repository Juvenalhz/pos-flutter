import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

class Communication {
  SecureSocket _secureSocket;
  Socket _socket;
  String _host;
  int _port;
  bool _secure;

  Communication(this._host, this._port, this._secure);

  Future<bool> connect() async {
    try {
      if (_secure == true) {
        SecurityContext securityContext = SecurityContext();
        _secureSocket = await SecureSocket.connect(_host, _port, context: securityContext,
          onBadCertificate: _onBadCertificate, timeout: Duration(seconds: 10),
        );
      }
      else {
        _socket = await Socket.connect(_host, _port/*, timeout: Duration(seconds: 10)*/);
      }
    } on SocketException catch (e) {
      print(e.toString());
      return false;
    } on HandshakeException catch (e) {
      print(e.toString());
      return false;
    }

    if (_secure == true) {
      _secureSocket.setOption(SocketOption.tcpNoDelay, true);
    }
    else{
      _socket.setOption(SocketOption.tcpNoDelay, true);
    }
    return true;
  }

  bool _onBadCertificate(X509Certificate certificate) {
    return true;
  }

  void disconnect() {
    if (_secure) {
      if (_secureSocket != null) {
        _secureSocket.destroy();
      }
    }
    else{
      if (_socket != null) {
        _socket.destroy();
      }
    }
  }

  Uint8List receiveMessage() {
    Uint8List message;
    if (_secure) {
      if (_secureSocket != null) {
        _secureSocket.listen(_receiveFromSecureSocket, onError: (error) {
          print(error.toString());
        });
      }
    }
    else{
      if (_socket != null) {
        _socket.listen((List<int> event) {
          print(utf8.decode(event));
          message = Uint8List.fromList(event);
        });
      }
    }
  }

  void _receiveFromSecureSocket(data) {
    print(data);
  }

  void sendMessage(final Uint8List bytes) {
    if (bytes != null && bytes.length > 0) {
      if (_secure) {
        if (_secureSocket != null) {
          print("send bytes len: ${bytes.length}");
          _secureSocket.add(List.from(bytes));
        }
      }
      else{
        if (this._socket != null) {
          print("send bytes len: ${bytes.length}");
          this._socket.add(List.from(bytes));
        }
      }
    }
  }
}