package com.lccnet.pay

import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*


class pinpad : MethodChannel.MethodCallHandler {

    companion object {
        /** Plugin registration.  */
        fun registerWith(@NonNull flutterEngine: FlutterEngine){
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pinpad")
            channel.setMethodCallHandler(pinpad())
        }
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "loadTables") {
            val emv : HashMap<String, Any?>? = call.argument("emv")
            val aids : List<HashMap<String, Any?>>? = call.argument("aids")
            val pubKeys : List<HashMap<String, Any?>>? = call.argument("pubKeys")

            Log.d("emv", emv.toString())

        } else {
            result.notImplemented()
        }
    }

}