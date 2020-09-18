package com.lccnet.pay

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

    class MainActivity: FlutterActivity() {
    var sn = SerialNumber
    var dt = SetDateTime
    var emv = Emv

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        sn.registerWith(flutterEngine)
        dt.registerWith(flutterEngine)
        emv.registerWith(flutterEngine, this.context)

    }
}
