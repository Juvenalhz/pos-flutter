package com.lccnet.pay

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class pinpad : MethodChannel.MethodCallHandler {

    companion object {
        /** Plugin registration.  */
        fun registerWith(@NonNull flutterEngine: FlutterEngine){
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pinpad")
            channel.setMethodCallHandler(SerialNumber())
        }
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "loadTables") {
            val dateTime : String? = call.argument("tables")
        } else {
            result.notImplemented()
        }
    }

}