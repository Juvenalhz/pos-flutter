package com.lccnet.pay

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.ingenico.lar.bc.Pinpad
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

//        if (Build.MODEL.contains("APOS")) {
            this.pinpad = PinpadManager.init(context, channel)
//        }

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "loadTables") {
            emv = call.argument("emv")
            aids = call.argument("aids")
            pubKeys = call.argument("pubKeys")

            loadTables(emv, aids, pubKeys)

        } else if (call.method == "getCard") {
            val trans : HashMap<String, Any?>? = call.argument("trans")

            if (trans != null) {
                getCard(trans["total"] as Int)
            }
        }
        else {
            result.notImplemented()
        }
    }

    private fun loadTables(emv: HashMap<String, Any?>?, aids: List<HashMap<String, Any?>>?, pubKeys: List<HashMap<String, Any?>>?){

        var i : Int = 0

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
                tables[i] += emv?.get("countryCode").toString().padStart(3, '0')
                tables[i] += emv?.get("currencyCode").toString().padStart(3, '0')
                tables[i] += "2"    // currency exponent
                tables[i] += "".padEnd(15, ' ')  // MID - optional
                tables[i] += "5999" // merchant category code
                tables[i] += "".padEnd(8, ' ')  // TID - optional
                tables[i] += emv?.get("terminalCapabilities").toString()
                tables[i] += emv?.get("addTermCapabilities").toString().subSequence(0, 10).toString()
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

        //if (Build.MODEL.contains("APOS")) {
            PinpadManager.me().updateTables(tables)
        //}


    }

    private fun currentDate(): String? {
        val now = Calendar.getInstance()
        return String.format(Locale.US, "%02d%02d%02d",
                now[Calendar.YEAR] % 100,
                now[Calendar.MONTH],
                now[Calendar.DAY_OF_MONTH])
    }

    private fun currentTime(): String? {
        val now = Calendar.getInstance()
        return String.format(Locale.US, "%02d%02d%02d",
                now[Calendar.HOUR],
                now[Calendar.MINUTE],
                now[Calendar.SECOND])
    }

    private fun getCard(amount: Int){


        var getCardInput = "00"            // Network ID filter - allways 0
            getCardInput += "99"                // Application type filter (credit, debit, "99" for all)
            getCardInput += amount.toString().padStart(12, '0') // Transaction amount with 1/100 cents ("100" = 1.00)
            getCardInput += currentDate()       // Transaction date (YYMMDD)
            getCardInput += currentTime()       // Transaction time (HHMMSS)
            getCardInput += PinpadManager.TIMESTAMP  // 10-digit table timestamp
            getCardInput += "00"                // filling digits
            getCardInput += "0"                // 1 to allow CTLS, 0 to force disable


//            val readCard = getCard()
//
//            readCard.getCardData(amount)

        Thread {
            if (Build.MODEL.contains("APOS")) {
                PinpadManager.me().open()
            }

            var ret = PinpadManager.me().getCard(getCardInput)
            Log.i("emv", "getCard: $ret")

            if (ret == Pinpad.PP_TABEXP) {
                Thread {
                    PinpadManager.me().updateTables(this.tables)
                    PinpadManager.me().resumeGetCard()
                }.start()
            }

            Log.i("emv", "getCard: $ret")
        }.start()


        Log.i("emv", "getCard -- out")


    }
}