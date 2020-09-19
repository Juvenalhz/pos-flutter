package com.lccnet.pay;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import com.ingenico.lar.bc.Pinpad;
import com.ingenico.lar.bc.PinpadCallbacks;
import com.ingenico.lar.bc.PinpadOutput;
import com.ingenico.lar.bc.PinpadOutputHandler;
import com.ingenico.lar.bc.apos.PinpadProviderAPOS;

import java.util.HashMap;

/**
 * A singleton interface to BC's Pinpad API to ease state sharing between the Activities of the
 * project.
 * <p>
 * Also allows to dynamically change the callbacks that will be used by Pinpad.
 */
public class PinpadManager implements PinpadCallbacks {

    final static String TAG = "PinpadManager";

    // the singleton instance
    static private PinpadManager myself = null;

    /**
     * Initialize this {@code PinpadManager} instance.
     * @param context The <i>application context</i> that the {@code Pinpad} will be bound to.
     * @return The singleton instance (the same as will be returned by {@link #me()}.
     * @throws UnsupportedOperationException in any error creating the {@code Pinpad} instance.
     */
    public static PinpadManager init(Context context) {
        Log.d(TAG, "PinpadManager.init(" + context + ")");
        if (myself == null) myself = new PinpadManager(context);

        return myself;
    }

    /**
     * Return the <i>already initialized</i> {@code PinpadManager} instance, or {@code null} if none.
     * @return The {@code PinpadManager} instance of {@code null} if {@link #init(Context)} has not
     *  been called yet.
     */
    static PinpadManager me() {
        return myself;
    }

    /**
     * Return the message that shall be used for an {@code onShowMessage} with {@code id} and extra parameter {@code s}.
     * @return The message to show or {@code null} if no message shall be shown!
     */
    static String formatMessage(int id, final String s) {
        switch (id) {
            case PinpadCallbacks.TEXT_S:
                return s;
            case PinpadCallbacks.PROCESSING:
                return "Processing...";
            case PinpadCallbacks.INSERT_SWIPE_CARD:
                return "Insert or Swipe Card";
            case PinpadCallbacks.TAP_INSERT_SWIPE_CARD:
                return "Tap, Insert or Swipe Card";
            case PinpadCallbacks.SELECT:
                return "Select";
            case PinpadCallbacks.SELECTED_S:
                return "Selected: " + s;
            case PinpadCallbacks.INVALID_APP:
                return "Invalid Application";
            case PinpadCallbacks.WRONG_PIN_S:
                return "Wrong PIN (" + s + " left)";
            case PinpadCallbacks.PIN_LAST_TRY:
                return "PIN Last Try!";
            case PinpadCallbacks.PIN_BLOCKED:
                return "PIN Blocked!";
            case PinpadCallbacks.CARD_BLOCKED:
                return "Card Blocked!";
            case PinpadCallbacks.REMOVE_CARD:
                return "Please, Remove Card";
            case PinpadCallbacks.UPDATING_TABLES:
                return "Updating Tables...";
            case PinpadCallbacks.SECOND_TAP:
                return "Please Tap Card Again";
            case PinpadCallbacks.PIN_VERIFIED:
            case PinpadCallbacks.UPDATING_RECORD:
            case PinpadCallbacks.PIN_STARTING:
            default:
                return null;
        }
    }

    public final static String TIMESTAMP = "0000000002";

    private Pinpad pinpad;
    private PinpadCallbacks callbacks;

    private PinpadManager(Context context) {
        Log.d(TAG, "building Pinpad with " + context);
        HashMap<String, Object> params = new HashMap<>();
        params.put(Pinpad.PARAM_CONTEXT, context);

        this.pinpad = Pinpad.build(params, this);
        if (this.pinpad == null) {
            Log.e(TAG, "error building Pinpad");
            throw new UnsupportedOperationException("Pinpad construction error");
        }
        else{
            this.setCallbacks(this);
        }
    }

    /**
     * Change the callbacks that will be called by {@code Pinpad}.
     * @param callbacks New {@code PinpadCallback} instance.
     */
    public void setCallbacks(PinpadCallbacks callbacks) {
        assert callbacks != null;
        this.callbacks = callbacks;
    }

    /**
     * Update the BC tables given whatever the applicatison must be using.
     */
    public void updateTables(String[] tables) {

        PinpadManager.me().abort();

        //this.callbacks = callbacks;

        //int ret = pinpad.tableLoadInit("00" + TIMESTAMP);



        new Thread(() -> {
            pinpad.open();
            if (pinpad.tableLoadInit("00" + TIMESTAMP) == Pinpad.PP_TABEXP) {
                for (final String s : tables){
                    pinpad.tableLoadRec(s);
                }
                pinpad.tableLoadEnd();
            }
        }).start();



    }

    public void abort() {
        pinpad.abort();
    }

    public int open() {
        return pinpad.open();
    }

    public int getCard(final String input, final PinpadCallbacks callbacks, final PinpadOutputHandler handler) {
        this.callbacks = callbacks;
        return pinpad.getCard(input, handler);
    }

    public int resumeGetCard() {
        return pinpad.resumeGetCard();
    }

    public int goOnChip(final String input, final String tags, final PinpadCallbacks callbacks, final PinpadOutputHandler handler) {
        this.callbacks = callbacks;
        return pinpad.goOnChip(input, tags, null, handler);
    }

    public PinpadOutput finishChip(final String input, final String tags) {
        return pinpad.finishChip(input, tags);
    }

    public int removeCard(final String message, final PinpadCallbacks callbacks, final PinpadOutputHandler handler) {
        this.callbacks = callbacks;
        return pinpad.removeCard(message, handler );
    }

    public int checkEvent(final String input, final PinpadCallbacks callbacks, final PinpadOutputHandler handler) {
        this.callbacks = callbacks;
        return pinpad.checkEvent(input, handler);
    }

    public static class TrackData {
        String track1, track2, track3;

        public TrackData(String t1, String t2, String t3) {
            track1 = t1;
            track2 = t2;
            track3 = t3;
        }
    }

    public static TrackData extractTrack(final String output, int offset) {
        final int track1Len = Integer.parseInt(output.substring(offset, offset + 2));
        final String track1 = output.substring(offset + 2, offset + 2 + track1Len);
        Log.d(TAG, "track1 (" + track1Len + ") [" + track1 + "]");

        final int track2Len = Integer.parseInt(output.substring(offset + 78, offset + 80));
        final String track2 = output.substring(offset + 80, offset + 80 + track2Len);
        Log.d(TAG, "track2 (" + track2Len + ") [" + track2 + "]");

        final int track3Len = Integer.parseInt(output.substring(offset + 117, offset + 120));
        final String track3 = output.substring(offset + 120, offset + 120 + track3Len);
        Log.d(TAG, "track3 (" + track3Len + ") [" + track3 + "]");

        return new TrackData(track1, track2, track3);
    }

    @Override
    public int onShowMessage(int i, String s) {
        return (callbacks != null) ? callbacks.onShowMessage(i, s) : 0;
    }

    @Override
    public int onShowPinEntry(String s, long l, int i) {
        return (callbacks != null) ? callbacks.onShowPinEntry(s, l, i) : 0;
    }

    @Override
    public void onAbort() {
        if (callbacks != null) callbacks.onAbort();
    }

    @Override
    public void onShowMenu(int i, String s, String[] strings, MenuResult menuResult) {
        // if callbacks have not been set, arbitrarily select first menu entry
        if (callbacks != null) callbacks.onShowMenu(i, s, strings, menuResult);
        else menuResult.setResult(0, 0);
    }
}

