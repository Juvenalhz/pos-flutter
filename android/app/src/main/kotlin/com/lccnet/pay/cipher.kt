package com.lccnet.pay

import android.content.Context
import android.os.Build
import android.os.RemoteException
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import com.ingenico.lar.apos.DeviceHelper
import com.usdk.apiservice.aidl.pinpad.DESMode
import com.usdk.apiservice.aidl.pinpad.KeySystem
import com.usdk.apiservice.aidl.pinpad.KeyType
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class Cipher : MethodChannel.MethodCallHandler{
    var params = HashMap<String, Any>()
    private val PAN_KEY_ID = 20

    fun registerWith(@NonNull flutterEngine: FlutterEngine, context: Context){
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cipher")
        channel.setMethodCallHandler(Cipher())

        params.put("MethodChannel", channel)

        Timer().schedule(object : TimerTask() {
            override fun run() {
                try {
                    DeviceHelper.me().bindService()
                    try {
                        val pinpad = DeviceHelper.me().getPinpad(0, 0, KeySystem.KS_FIXED_KEY)
                        pinpad.open()
                        try {
                            if (!pinpad.isKeyExist(PAN_KEY_ID)) {
                                if (pinpad.loadPlainTextKey(KeyType.DEK_KEY, PAN_KEY_ID, pinpad.getRandom(24))) {
                                    Log.e("Cipher", "ramdom key created")
                                }
                            }
                        } finally {
                            pinpad.close()
                        }
                    } finally {
                        DeviceHelper.me().unbindService()
                    }
                } catch (e: RemoteException) {
                    Log.e("Cipher", "pinpad", e)
                }
            }
        }, 1000)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        if (call.method == "cipherCriticalData") {
            var data : String? = call.argument("data")
            
            if (Build.MODEL.contains("APOS")) {
                try {
                    val pinpad = DeviceHelper.me().getPinpad(0, 0, KeySystem.KS_FIXED_KEY)
                    pinpad.open()
                    try {
                        val encrypted = pinpad.calculateDes(PAN_KEY_ID, DESMode(DESMode.DM_ENC, DESMode.DM_OM_TCBC), null, data?.toByteArray(Charsets.US_ASCII))

                        if (encrypted == null) {
                            Log.d("Cipher", "pinpad.error = " + pinpad.lastError)
                        }

                        result.success(Base64.encodeToString(encrypted, Base64.URL_SAFE));
                    } finally {
                        pinpad.close()
                    }
                } catch (e: RemoteException) {
                    Log.e("Cipher", "Pinpad", e)
                }
            }
        } else if (call.method == "decipherCriticalData") {
            var dataString : String? = call.argument("data")
            var data : ByteArray? = Base64.decode(dataString, Base64.URL_SAFE)

            if (Build.MODEL.contains("APOS")) {
                try {
                    val pinpad = DeviceHelper.me().getPinpad(0, 0, KeySystem.KS_FIXED_KEY)
                    pinpad.open()
                    try {
                        val decrypted = String(pinpad.calculateDes(PAN_KEY_ID, DESMode(DESMode.DM_DEC, DESMode.DM_OM_TCBC), null, data))
                        if (decrypted == null) {
                            Log.d("Cipher", "pinpad.error = " + pinpad.lastError)
                        }
                        result.success(decrypted)
                    } finally {
                        pinpad.close()
                    }
                } catch (e: RemoteException) {
                    Log.e("Cipher", "Pinpad", e)
                }
            }
        }


    }
}