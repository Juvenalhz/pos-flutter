package com.lccnet.pay

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.time.LocalDateTime
import java.time.Month
import java.util.*


class SetDateTime : MethodChannel.MethodCallHandler {

    companion object {
        /** Plugin registration.  */
        fun registerWith(@NonNull flutterEngine: FlutterEngine){
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "Date_Time")
            channel.setMethodCallHandler(SetDateTime())
        }
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "setDateTime") {
            val dateTime : String? = call.argument("datetime")
            val year = ("20" + dateTime?.substring(0, 2)).toInt()
            val month = dateTime?.substring(2, 4)?.toInt()
            val day = dateTime?.substring(4, 6)?.toInt()
            val hour = dateTime?.substring(6, 8)?.toInt()
            val min = dateTime?.substring(8, 10)?.toInt()
            val seg = dateTime?.substring(10, 12)?.toInt()

            val calendar: Calendar = Calendar.getInstance()

            if ((month != null) && (day != null) && (hour != null) && (min != null) && (seg != null))  {
                calendar.set( year, month, day, hour, min, seg)
            }

        } else {
            result.notImplemented()
        }
    }

}

