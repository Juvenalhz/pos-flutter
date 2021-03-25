package com.lccnet.pay

import com.ingenico.lar.apos.DeviceHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    var sn = SerialNumber
    var dt = SetDateTime
    var emv = Emv() 
    var printer = Printer()
    var cipher = Cipher()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        sn.registerWith(flutterEngine)
        dt.registerWith(flutterEngine)
        emv.registerWith(flutterEngine, this.context)
        printer.registerWith(flutterEngine, this.context)
        cipher.registerWith(flutterEngine)

    }
}
