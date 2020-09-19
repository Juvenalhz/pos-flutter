package com.lccnet.pay

import android.content.Context
import android.util.Log
import com.ingenico.lar.bc.Pinpad
import com.ingenico.lar.bc.PinpadCallbacks
import com.ingenico.lar.bc.PinpadCallbacks.MenuResult
import com.ingenico.lar.bc.PinpadOutput
import com.ingenico.lar.bc.PinpadOutputHandler
import java.util.*


/**
 * A singleton interface to BC's Pinpad API to ease state sharing between the Activities of the
 * project.
 *
 *
 * Also allows to dynamically change the callbacks that will be used by Pinpad.
 */
class PinpadManagerKT(context: Context) : PinpadCallbacks {
    private var pinpad: Pinpad
    private var callbacks: PinpadCallbacks? = null

    /**
     * Change the callbacks that will be called by `Pinpad`.
     * @param callbacks New `PinpadCallback` instance.
     */
    fun setCallbacks(callbacks: PinpadCallbacks?) {
        assert(callbacks != null)
        this.callbacks = callbacks
    }

    /**
     * Update the BC tables given whatever the application must be using.
     */
    fun updateTables(tables: Array<String?>) {

        //this.callbacks = callbacks
        if (pinpad!!.tableLoadInit("00" + TIMESTAMP) == Pinpad.PP_TABEXP) {
            for (s in tables) pinpad!!.tableLoadRec(s)
            pinpad!!.tableLoadEnd()
        }
    }

    fun abort() {
        pinpad!!.abort()
    }

    fun open(): Int {
        return pinpad!!.open()
    }

    fun getCard(input: String?, callbacks: PinpadCallbacks?, handler: PinpadOutputHandler?): Int {
        this.callbacks = callbacks
        return pinpad!!.getCard(input, handler)
    }

    fun resumeGetCard(): Int {
        return pinpad!!.resumeGetCard()
    }

    fun goOnChip(input: String?, tags: String?, callbacks: PinpadCallbacks?, handler: PinpadOutputHandler?): Int {
        this.callbacks = callbacks
        return pinpad!!.goOnChip(input, tags, null, handler)
    }

    fun finishChip(input: String?, tags: String?): PinpadOutput {
        return pinpad!!.finishChip(input, tags)
    }

    fun removeCard(message: String?, callbacks: PinpadCallbacks?, handler: PinpadOutputHandler?): Int {
        this.callbacks = callbacks
        return pinpad!!.removeCard(message, handler)
    }

    fun checkEvent(input: String?, callbacks: PinpadCallbacks?, handler: PinpadOutputHandler?): Int {
        this.callbacks = callbacks
        return pinpad!!.checkEvent(input, handler)
    }

    class TrackData(var track1: String, var track2: String, var track3: String)

    override fun onShowMessage(i: Int, s: String): Int {
        return if (callbacks != null) callbacks!!.onShowMessage(i, s) else 0
    }

    override fun onShowPinEntry(s: String, l: Long, i: Int): Int {
        return if (callbacks != null) callbacks!!.onShowPinEntry(s, l, i) else 0
    }

    override fun onAbort() {
        if (callbacks != null) callbacks!!.onAbort()
    }

    override fun onShowMenu(i: Int, s: String, strings: Array<String>, menuResult: MenuResult) {
        // if callbacks have not been set, arbitrarily select first menu entry
        if (callbacks != null) callbacks!!.onShowMenu(i, s, strings, menuResult) else menuResult.setResult(0, 0)
    }

    companion object {
        const val TAG = "PinpadManager"

        // the singleton instance
        private var myself: PinpadManagerKT? = null

        /**
         * Initialize this `PinpadManager` instance.
         * @param context The *application context* that the `Pinpad` will be bound to.
         * @return The singleton instance (the same as will be returned by [.me].
         * @throws UnsupportedOperationException in any error creating the `Pinpad` instance.
         */
        fun init(context: Context): PinpadManagerKT? {
            Log.d(TAG, "PinpadManager.init($context)")
            if (myself == null) myself = PinpadManagerKT(context)
            return myself
        }

        /**
         * Return the *already initialized* `PinpadManager` instance, or `null` if none.
         * @return The `PinpadManager` instance of `null` if [.init] has not
         * been called yet.
         */
        fun me(): PinpadManagerKT? {
            return myself
        }

        /**
         * Return the message that shall be used for an `onShowMessage` with `id` and extra parameter `s`.
         * @return The message to show or `null` if no message shall be shown!
         */
        fun formatMessage(id: Int, s: String): String? {
            return when (id) {
                PinpadCallbacks.TEXT_S -> s
                PinpadCallbacks.PROCESSING -> "Processing..."
                PinpadCallbacks.INSERT_SWIPE_CARD -> "Insert or Swipe Card"
                PinpadCallbacks.TAP_INSERT_SWIPE_CARD -> "Tap, Insert or Swipe Card"
                PinpadCallbacks.SELECT -> "Select"
                PinpadCallbacks.SELECTED_S -> "Selected: $s"
                PinpadCallbacks.INVALID_APP -> "Invalid Application"
                PinpadCallbacks.WRONG_PIN_S -> "Wrong PIN ($s left)"
                PinpadCallbacks.PIN_LAST_TRY -> "PIN Last Try!"
                PinpadCallbacks.PIN_BLOCKED -> "PIN Blocked!"
                PinpadCallbacks.CARD_BLOCKED -> "Card Blocked!"
                PinpadCallbacks.REMOVE_CARD -> "Please, Remove Card"
                PinpadCallbacks.UPDATING_TABLES -> "Updating Tables..."
                PinpadCallbacks.SECOND_TAP -> "Please Tap Card Again"
                PinpadCallbacks.PIN_VERIFIED, PinpadCallbacks.UPDATING_RECORD, PinpadCallbacks.PIN_STARTING -> null
                else -> null
            }
        }

        const val TIMESTAMP = "0000000002"
        fun extractTrack(output: String, offset: Int): TrackData {
            val track1Len = output.substring(offset, offset + 2).toInt()
            val track1 = output.substring(offset + 2, offset + 2 + track1Len)
            Log.d(TAG, "track1 ($track1Len) [$track1]")
            val track2Len = output.substring(offset + 78, offset + 80).toInt()
            val track2 = output.substring(offset + 80, offset + 80 + track2Len)
            Log.d(TAG, "track2 ($track2Len) [$track2]")
            val track3Len = output.substring(offset + 117, offset + 120).toInt()
            val track3 = output.substring(offset + 120, offset + 120 + track3Len)
            Log.d(TAG, "track3 ($track3Len) [$track3]")
            return TrackData(track1, track2, track3)
        }
    }

    init {
        Log.d(TAG, "building Pinpad with $context")
        val params = HashMap<String, Any>()
        params[Pinpad.PARAM_CONTEXT] = context
        pinpad = Pinpad.build(params, this)
        if (pinpad == null) {
            Log.e(TAG, "error building Pinpad")
            throw UnsupportedOperationException("Pinpad construction error")
        }
    }
}