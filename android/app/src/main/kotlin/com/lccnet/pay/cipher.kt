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
import com.usdk.apiservice.aidl.pinpad.UPinpad
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*
import java.nio.charset.StandardCharsets;

class Cipher : MethodChannel.MethodCallHandler{
    companion object {
    var params = HashMap<String, Any>()
    }
    private val PAN_KEY_ID = 0

    fun registerWith(@NonNull flutterEngine: FlutterEngine){
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cipher")
        channel.setMethodCallHandler(Cipher())

        params.put("MethodChannel", channel)

        if (Build.MODEL.contains("APOS")) {
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
            } else if (PinpadManager.isEmulator()){
                result.success(Base64.encodeToString(data?.toByteArray(Charsets.US_ASCII), Base64.URL_SAFE));
            }

        } else if (call.method == "decipherCriticalData") {
            var dataString : String? = call.argument("data")
            var data : ByteArray? = Base64.decode(dataString, Base64.URL_SAFE)

            if (Build.MODEL.contains("APOS")) {
                try {
                    val pinpad = DeviceHelper.me().getPinpad(0, 0, KeySystem.KS_FIXED_KEY)
                    pinpad.open()
                    try {
                        var decrypted = String(pinpad.calculateDes(PAN_KEY_ID, DESMode(DESMode.DM_DEC, DESMode.DM_OM_TCBC), null, data), StandardCharsets.UTF_8);
                        if (decrypted.isEmpty()) {
                            Log.d("Cipher", "pinpad.error = " + pinpad.lastError)
                        }
                        val re = Regex("[^0-9 ]")
                        decrypted = re.replace(decrypted, "")
                        result.success(decrypted)
                    } finally {
                        pinpad.close()
                    }
                } catch (e: RemoteException) {
                    Log.e("Cipher", "Pinpad", e)
                }
            }
            else if (PinpadManager.isEmulator()){
                result.success(data?.let { String(it) });
            }
        }
        else if (call.method == "cipherMessage") {
            var data: ByteArray? = call.argument("data")
            var wk: String? = call.argument("wk")
            var keyId: Int? = call.argument("keyId")
            var encrypted: ByteArray = byteArrayOf()

            if (Build.MODEL.contains("APOS") == true)
            {
                DeviceHelper.me().bindService()
                try {
                    try {
                    val pinpad: UPinpad
                    if (wk == null) {
                        pinpad = DeviceHelper.me().getPinpad(0, 0, KeySystem.KS_FIXED_KEY)
                        pinpad.open()
                    } else {
                        pinpad = DeviceHelper.me().getPinpad(0, 0, KeySystem.KS_MKSK)
                        pinpad.open()
                        //load ciphered key
                        //pinpad.loadEncKey(int keyType, int mainKeyId, int keyId, byte[] encKey, byte[] checkValue)
                    }

                    try {

                        if (pinpad.isKeyExist(keyId!!)) {
                                val iv = byteArrayOf(0x00.toByte(), 0x00.toByte(), 0x00.toByte(), 0x00.toByte(), 0x00.toByte(), 0x00.toByte(), 0x00.toByte(), 0x00.toByte())
                                encrypted = pinpad.calculateDes(keyId!!, DESMode(DESMode.DM_ENC, DESMode.DM_OM_TCBC), iv, data)

                            if (encrypted == null) {
                                Log.d("Cipher", "pinpad.error = " + pinpad.lastError)
                            }
                        }

                    } finally {
                        pinpad.close()
                    }
                } catch (e: RemoteException) {
                    Log.e("Cipher", "Pinpad", e)
                }
                } finally {
                    DeviceHelper.me().unbindService()
                }

                result.success(encrypted)
            }
            else {
                result.success(data)
            }
        }


    }
}
