package com.lccnet.pay

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.ingenico.lar.apos.DeviceHelper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class Emv : MethodChannel.MethodCallHandler{

    private final var pinpad : PinpadManager? = null

    private var emv : HashMap<String, Any?>? = null
    private var aids : List<HashMap<String, Any?>>? = null
    private var pubKeys : List<HashMap<String, Any?>>? = null
    private val tables = arrayOfNulls<String>(150)
    private var context: Context? = null
    private var callbackChannel : MethodChannel? = null

    /** Plugin registration.  */
    fun registerWith(@NonNull flutterEngine: FlutterEngine, context: Context){
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pinpad")
        channel.setMethodCallHandler(Emv())

        this.pinpad = PinpadManager.init(context, channel)

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "loadTables") {
            emv = call.argument("emv")
            aids = call.argument("aids")
            pubKeys = call.argument("pubKeys")

            loadTables(emv, aids, pubKeys)

        } else if (call.method == "getCard") {
            val trans : HashMap<String, Any?>? = call.argument("trans")

            var monto : Long = (trans?.get("total").toString().toLong())
            if (trans != null) {
                result.success(getCard(monto))
            }
        } else if (call.method == "goOnChip"){
            val trans : HashMap<String, Any?>? = call.argument("trans")
            val aid : HashMap<String, Any?>? = call.argument("aid")
            val keyIndex : Int? = call.argument("keyIndex")
            var montoOriginal : Long = (trans?.get("originalTotal").toString().toLong())
            var cashback : Long = (trans?.get("cashback").toString().toLong())
            if ((trans != null) && (aid != null) && (keyIndex != null)) {
                result.success(goOnChip(montoOriginal, cashback, keyIndex, aid))
            }
        } else if (call.method == "finishChip"){
            val respCode : String? = call.argument("respCode")
            val entryMode : Int? = call.argument("entryMode")
            val respEmvTags : String? = call.argument("respEmvTags")

            if ((respCode != null) && (entryMode != null) && (respEmvTags != null) ){
                result.success(finishChip(respCode, entryMode, respEmvTags))
            }
        } else if (call.method == "askPin") {
            val keyIndex: Int? = call.argument("keyIndex")
            val pan: String? = call.argument("pan")
            val msg1: String? = call.argument("msg1")
            val msg2: String? = call.argument("msg2")
            val type: String? = call.argument("type")
            
            if ((keyIndex != null) && (pan != null) && (msg1 != null) && (msg2 != null)) {
                result.success(PinpadManager.me().askPin(keyIndex, pan, msg1, msg2, type));
            }
        } else if (call.method == "swipeCard") {
            result.success(PinpadManager.me().swipeCard());
        } else if (call.method == "removeCard"){
            PinpadManager.me().RemoveCard();
        } else if (call.method == "beep"){
            if (Build.MODEL.contains("APOS"))
                DeviceHelper.me().beeper.startBeep(200)
        }
        
        else {
            result.notImplemented()
        }
    }

    private fun loadTables(emv: HashMap<String, Any?>?, aids: List<HashMap<String, Any?>>?, pubKeys: List<HashMap<String, Any?>>?){

        var i : Int = 0

        var atc : String = "6000f0a001";

        if (aids != null) {
            for((index, aid) in aids.withIndex()){

                tables[i] = "01"    // fixed value
                tables[i] += "314"  // record size
                tables[i] += "1"    // aid table
                tables[i] += "01"   // acquirer ID - fixed to 01 as only 1 acquirer is used
                tables[i] += (index+1).toString().padStart(2, '0') // index
                tables[i] += (aid["aid"].toString().length / 2).toString().padStart(2, '0')     // lengthe of aid
                tables[i] += aid["aid"].toString().padEnd(32, '0')  // aid value
                tables[i] += "01"   // 01 credit - 02 debit (right now there is not way to know if debit)
                tables[i] += "".padEnd(16, ' ')
                tables[i] += "03"   // standar emv aid - fixed value
                tables[i] += "%04x".format(aid["version"])  // terminal application 1
                tables[i] += "0000"   // terminal application 2
                tables[i] += "0000"   // terminal application 3

                tables[i] +="862"

                tables[i] += emv?.get("currencyCode").toString().padStart(3, '0')
                tables[i] += "2"    // currency exponent
                tables[i] += "".padEnd(15, ' ')  // MID - optional
                tables[i] += "5999" // merchant category code
                tables[i] += "".padEnd(8, ' ')  // TID - optional
                tables[i] += emv?.get("terminalCapabilities").toString()


                tables[i] +=atc

                tables[i] += emv?.get("terminalType").toString()
                tables[i] += aid["tacDefault"].toString()
                tables[i] += aid["tacDenial"].toString()
                tables[i] += aid["tacOnline"].toString()
                tables[i] += aid["floorLimit"].toString().padStart(8, '0')
                tables[i] += "R"    // transaction category code
                tables[i] += "0"    // contactles support
                tables[i] += "0"    // cless type - 0 = not supported
                tables[i] += "".padEnd(8, '0')  // cless trans limit
                tables[i] += "".padEnd(8, '0')  // cless floor limit
                tables[i] += "".padEnd(8, '0')  // CVM Limit
                tables[i] += "0000"     // paypass terminal version
                tables[i] += "0"        // cless selection mode
                tables[i] += aid["tdol"].toString().padEnd(40, '0') // TDOL
                tables[i] += aid["ddol"].toString().padEnd(40, '0') // DDOL
                tables[i] += "Y1Z1Y3Z3"  // fixed value - not used with newer emv specs
                tables[i] += "".padEnd(10, '0') // cless tac default
                tables[i] += "".padEnd(10, '0') // cless tac denial
                tables[i] += "".padEnd(10, '0') // cless tac online

                i += 1
            }
        }

        if (pubKeys != null) {
            for ((index, pubKey) in pubKeys.withIndex()) {
                tables[i] = "01"    // fixed value
                tables[i] += "611"  // record size
                tables[i] += "2"    // aid table
                tables[i] += "01"   // acquirer ID - fixed to 01 as only 1 acquirer is used
                tables[i] += (index + i + 1).toString().padStart(2, '0') // index in table
                tables[i] += pubKey["rid"].toString()   // key rid
                tables[i] += "%02x".format(pubKey["keyIndex"])  // key index
                tables[i] += "00"   // RFU
                tables[i] += (pubKey["exponent"].toString().length / 2).toString() // length of exponent
                tables[i] += pubKey["exponent"].toString().padStart(6, '0')  // exponent
                tables[i] += pubKey["length"].toString().padStart(3, '0')  // length of key modulus
                tables[i] += pubKey["modulus"].toString().padEnd(496, '0')  // key modulus
                tables[i] += "0"    // checksum not supported
                tables[i] += "".padEnd(40, '0')  // checksum value
                tables[i] += "".padEnd(42, '0')  // RFU

                i += 1
            }
        }

        PinpadManager.me().updateTables(tables)
    }

    private fun getCard(amount: Long) : Long{
        var ret : Long

        Thread {
            if (Build.MODEL.contains("APOS")) {
                PinpadManager.me().open()
            }
        }.start()

        ret = PinpadManager.me().getCard(amount).toLong()
        Log.i("emv", "getCard: $ret")

        return ret
    }

    private fun goOnChip(total: Long, cashBack: Long, keyIndex: Int, aid: HashMap<String, Any?>): Int {
        return PinpadManager.me().goOnChip(total, cashBack, keyIndex, aid)
    }

    private fun finishChip(respCode: String, entryMode: Int, respEmvTags: String): Int{
        return PinpadManager.me().finishChip(respCode, entryMode, respEmvTags)
    }
}