import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:pay/utils/dataUtils.dart';

class Communication {
  SecureSocket _secureSocket;
  Socket _socket;
  String _host;
  int _port;
  bool _secure;
  Uint8List _message;
  int _size;
  int _frameSize;

  Communication(this._host, this._port, this._secure){
    _size = 0;
    _frameSize = 0;
    _message = new Uint8List(2000);
  }

  Future<bool> connect() async {
    try {
      if (_secure == true) {
        SecurityContext securityContext = SecurityContext();
        _secureSocket = await SecureSocket.connect(
          _host,
          _port,
          context: securityContext,
          onBadCertificate: _onBadCertificate,
          timeout: Duration(seconds: 10),
        );
      } else {
        _socket = await Socket.connect(_host, _port /*, timeout: Duration(seconds: 10)*/);
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
    } else {
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
    } else {
      if (_socket != null) {
        _socket.destroy();
      }
    }
  }

  Future<Uint8List> receiveMessage() async{
    bool isDone = false;
    if (_secure) {
      if (_secureSocket != null) {
        _secureSocket.listen((data) {
          print(data.toString());
          data.forEach((element) {
            _message[_size++] = element;
          });
        }, onError: (error) {
          print(error.toString());
        }, onDone: () {
          print('done');
          String temp = bcdToStr(_message.sublist(0, 2));
          _frameSize = int.parse(temp, radix: 16);
          isDone = true;
        });
      }
    } else {
      if (_socket != null) {
        _socket.listen((data) {
          print(data.toString());
          data.forEach((element) {
            _message[_size++] = element;
          });
        }, onDone: () {
          print('done');
          String temp = bcdToStr(_message.sublist(0, 2));
          _frameSize = int.parse(temp, radix: 16);
          isDone = true;
        });

      }
    }

    while (isDone == false){
      await Future.delayed(Duration(seconds: 1));
    }

    return  _message.sublist(2, _frameSize + 2);
  }

  int get rxSize => this._size;
  int get frameSize => this._frameSize;

  void sendMessage(final Uint8List bytes) {
    if (bytes != null && bytes.length > 0) {
      if (_secure) {
        if (_secureSocket != null) {
          print("send bytes len: ${bytes.length}");
          _secureSocket.add(List.from(bytes));
        }
      } else {
        if (this._socket != null) {
          print("send bytes len: ${bytes.length}");
          this._socket.add(List.from(bytes));
        }
      }
    }
  }
}
