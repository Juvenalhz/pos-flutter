package com.lccnet.pay

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.ingenico.lar.apos.DeviceHelper
import com.usdk.apiservice.aidl.printer.*
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class Printer : MethodChannel.MethodCallHandler{
    var params = HashMap<String, Any>()
    private val FONT_SIZE_SMALL = 0
    private val FONT_SIZE_NORMAL = 1
    private val FONT_SIZE_LARGE = 2

    fun registerWith(@NonNull flutterEngine: FlutterEngine, context: Context){
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "printer")
        channel.setMethodCallHandler(Printer())

        params.put("MethodChannel", channel)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val printer = DeviceHelper.me().printer

        if (call.method == "addText") {
            var align : Int? = call.argument("alignMode")
            var data : String? = call.argument("data")

            if (data == null)
                return

            if (align == null)
                align = AlignMode.RIGHT

            if (Build.MODEL.contains("APOS")) {
                printer.addText(align, data)
            }
            else {
                print(data)
            }
        }
        else if (call.method == "setFontSize") {
            var fontSize : Int? = call.argument("fontSize")
            if (fontSize != null) {
                if (Build.MODEL.contains("APOS"))
                    setFontSpec(printer, fontSize)
            }
        }
        else if (call.method == "feedLine") {
            var lines : Int? = call.argument("lines")
            if (lines != null) {
                if (Build.MODEL.contains("APOS"))
                    printer.feedLine(lines)
            }
        }
        else if (call.method == "print") {
            printer.startPrint(object : OnPrintListener.Stub() {
                override fun onFinish() {
                    Thread {
                        val channel = params["MethodChannel"] as MethodChannel?
                        Handler(Looper.getMainLooper()).post {
                            if (channel != null) {
                                channel.invokeMethod("printDone", null)
                            }
                        }
                    }.start()
                }

                override fun onError(i: Int) {
                    Log.e("Printer", "startPrint.onError $i")
                    Thread {
                        val channel = params["MethodChannel"] as MethodChannel?
                        val error = HashMap<String, Any>()

                        error["error"] = i

                        Handler(Looper.getMainLooper()).post {
                            if (channel != null) {
                                channel.invokeMethod("printError", { error })
                            }
                        }
                    }.start()
                }
            })
        }
    }

    private fun setFontSpec(printer: UPrinter, fontSpec: Int) {
        when (fontSpec) {
            this.FONT_SIZE_SMALL -> {
                printer.setHzSize(HZSize.DOT16x16)
                printer.setHzScale(HZScale.SC1x1)
                printer.setAscSize(ASCSize.DOT16x8)
                printer.setAscScale(ASCScale.SC1x1)
            }
            this.FONT_SIZE_NORMAL -> {
                printer.setHzSize(HZSize.DOT24x24)
                printer.setHzScale(HZScale.SC1x1)
                printer.setAscSize(ASCSize.DOT24x12)
                printer.setAscScale(ASCScale.SC1x1)
            }
            this.FONT_SIZE_LARGE -> {
                printer.setHzSize(HZSize.DOT24x24)
                printer.setHzScale(HZScale.SC1x2)
                printer.setAscSize(ASCSize.DOT24x12)
                printer.setAscScale(ASCScale.SC1x2)
            }
        }
    }
}