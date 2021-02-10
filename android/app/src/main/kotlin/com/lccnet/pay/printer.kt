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
    private var currentSize : Int = FONT_SIZE_NORMAL;

    fun registerWith(@NonNull flutterEngine: FlutterEngine, context: Context ){
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "printer")
        channel.setMethodCallHandler(Printer())

        params.put("MethodChannel", channel)
        currentSize = FONT_SIZE_NORMAL;

        if (Build.MODEL.contains("APOS")) {
            DeviceHelper.me().init(context)
            DeviceHelper.me().bindService()
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "addText") {
            var align : Int? = call.argument("alignMode")
            var data : String? = call.argument("data")

            if (data == null)
                return

            if (align == null)
                align = AlignMode.RIGHT

            if (Build.MODEL.contains("APOS")) {
                val printer = DeviceHelper.me().printer
                printer.addText(align, data)
            }
            else {
                printLog(align, data)
            }
        }
        else if (call.method == "setFontSize") {
            var fontSize : Int? = call.argument("fontSize")
            if (fontSize != null) {
                if (Build.MODEL.contains("APOS")) {
                    val printer = DeviceHelper.me().printer
                    setFontSpec(printer, fontSize)
                }
                currentSize = fontSize;
            }
        }
        else if (call.method == "feedLine") {
            var lines : Int? = call.argument("lines")
            if (lines != null) {
                if (Build.MODEL.contains("APOS")) {
                    val printer = DeviceHelper.me().printer
                    printer.feedLine(lines)
                }
                else{
                    var lineSize : Int
                    if (currentSize == FONT_SIZE_SMALL)
                        lineSize = 48
                    else
                        lineSize = 32
                    Log.i("printer", "|" + "".padEnd(lineSize, ' ') + "|")
                }
            }
        }
        else if (call.method == "print") {
            if (Build.MODEL.contains("APOS")) {
                val printer = DeviceHelper.me().printer
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

    private fun printLog(align : Int, data : String) {
        var line : String = ""
        var temp : String
        var lineSize : Int

        if (currentSize == FONT_SIZE_SMALL)
            lineSize = 48
        else
            lineSize = 32


        if (data.length > lineSize)
            temp = data.substring(0, lineSize)
        else
            temp = data

        line += "|"
        when (align) {
            AlignMode.RIGHT -> {
                line += temp.padStart(lineSize, ' ')
            }
            AlignMode.LEFT -> {
                line += temp.padEnd(lineSize, ' ')
            }
            AlignMode.CENTER -> {
                temp = temp.padStart( (lineSize - 1)  - (lineSize - temp.length) / 2, ' ')
                line += temp.padEnd(lineSize, ' ')
            }
        }
        line += "|"
        Log.i("printer", line)
    }
}