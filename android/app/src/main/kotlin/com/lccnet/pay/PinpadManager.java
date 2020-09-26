package com.lccnet.pay;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.ingenico.lar.bc.Pinpad;
import com.ingenico.lar.bc.PinpadCallbacks;
import com.ingenico.lar.bc.PinpadOutput;
import com.ingenico.lar.bc.PinpadOutputHandler;
import com.ingenico.lar.bc.apos.PinpadProviderAPOS;

import java.util.HashMap;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

import static java.lang.Thread.sleep;

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
    HashMap<String, Object> params;

    /**
     * Initialize this {@code PinpadManager} instance.
     * @param context The <i>application context</i> that the {@code Pinpad} will be bound to.
     * @return The singleton instance (the same as will be returned by {@link #me()}.
     * @throws UnsupportedOperationException in any error creating the {@code Pinpad} instance.
     */
    public static PinpadManager init(Context context, MethodChannel channel) {
        Log.d(TAG, "PinpadManager.init(" + context + ")");
        if (myself == null) myself = new PinpadManager(context, channel);

        return myself;
    }

    private PinpadManager(Context context, MethodChannel channel) {
        Log.d(TAG, "building Pinpad with " + context);
        params = new HashMap<>();
        params.put(Pinpad.PARAM_CONTEXT, context);
        params.put("MethodChannel", channel);

        if (Build.MODEL.contains("APOS")) {
            this.pinpad = Pinpad.build(params, this);
            if (this.pinpad == null) {
                Log.e(TAG, "error building Pinpad");
                throw new UnsupportedOperationException("Pinpad construction error");
            } else {
                this.setCallbacks(this);
            }
        }
    }


    /**
     * Return the <i>already initialized</i> {@code PinpadManager} instance, or {@code null} if none.
     * @return The {@code PinpadManager} instance of {@code null} if  has not
     *  been called yet.
     */
    static PinpadManager me() {
        return myself;
    }

    public final static String TIMESTAMP = "0000000002";
    private Pinpad pinpad;
    private PinpadCallbacks callbacks;


    /**
     * Change the callbacks that will be called by {@code Pinpad}.
     * @param callbacks New {@code PinpadCallback} instance.
     */
    public void setCallbacks(PinpadCallbacks callbacks) {
        assert callbacks != null;
        this.callbacks = callbacks;
    }

    /**
     * Update the BC tables given whatever the application must be using.
     */
    public void updateTables(String[] tables) {
        MethodChannel channel = (MethodChannel) params.get("MethodChannel");
        params.put("emvTables", tables);

        if (Build.MODEL.contains("APOS")) {
            PinpadManager.me().abort();
            new Thread(() -> {
                pinpad.open();
                if (pinpad.tableLoadInit("00" + TIMESTAMP) == Pinpad.PP_TABEXP) {
                    for (final String s : tables) {
                        pinpad.tableLoadRec(s);
                    }
                    pinpad.tableLoadEnd();
                }

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("tablesLoaded", "");
                    }
                });

            }).start();
        }
        else{
            new Thread(() -> {
                try {
                    // simulate loading of the emv data
                    this.onShowMessage(PinpadCallbacks.UPDATING_TABLES, "");
                    sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("tablesLoaded", "");
                    }
                });
            }).start();
        }
    }

    public void abort() {
        pinpad.abort();
    }

    public int open() {
        return pinpad.open();
    }

    public int getCard(final String input) {
        MethodChannel channel = (MethodChannel) params.get("MethodChannel");

        if (Build.MODEL.contains("APOS")) {
            int ret = pinpad.getCard(input, output -> {
                Log.i(TAG, "getCard output: (" + output.getResultCode() + ") '" + output.getOutput() + "'");
                if (output.getResultCode() == Pinpad.PP_CANCEL) {
                    Log.i(TAG, "Pinpad.PP_CANCEL");
                } else if (output.getResultCode() == Pinpad.PP_OK) {
                    final String out = output.getOutput();
                    final int cardType = Integer.parseInt(out.substring(0, 2));
                    final int readStatus = Integer.parseInt(out.substring(2, 3));
                    final int appType = Integer.parseInt(out.substring(3, 5));
                    final int appNetID = Integer.parseInt(out.substring(5, 7));
                    final int recordID = Integer.parseInt(out.substring(7, 9));
                    final TrackData tracks = PinpadManager.extractTrack(output.getOutput(), 9);
                    final int panLen = Integer.parseInt(out.substring(233, 235));
                    final String pan = out.substring(235, 235 + panLen);
                    final int PANSequenceNumber = Integer.parseInt(out.substring(254, 256));
                    final String appLabel = out.substring(256, 272).trim();
                    final String serviceCode = out.substring(272, 275);
                    final String cardholderName = out.substring(275, 301).trim();
                    final String expiryDate = out.substring(301, 307);

                    Log.i(TAG, "Pinpad.PP_OK");
                }
            });
            if (ret == Pinpad.PP_TABEXP) {
                new Thread(() -> {
                    String[] emvTables = (String[]) params.get("emvTables");
                    updateTables(emvTables);
                    resumeGetCard();
                }).start();
            }
            return ret;
        }
        else{
            new Thread(() -> {
                try {
                    // simulate loading of the emv data
                    this.onShowMessage(PinpadCallbacks.PROCESSING, "");
                    sleep(200);
                    this.onShowMessage(PinpadCallbacks.INSERT_SWIPE_CARD, "");
                    sleep(200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("cardRead", "");
                    }
                });
            }).start();
            return 0;
        }
    }

    public int resumeGetCard() {
        return pinpad.resumeGetCard();
    }

    public int goOnChip(final String input, final String tags, final PinpadOutputHandler handler) {
        return pinpad.goOnChip(input, tags, null, handler);
    }

    public PinpadOutput finishChip(final String input, final String tags) {
        return pinpad.finishChip(input, tags);
    }

    public int removeCard(final String message, final PinpadOutputHandler handler) {
        return pinpad.removeCard(message, handler );
    }

    public int checkEvent(final String input, final PinpadOutputHandler handler) {
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
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                MethodChannel channel = (MethodChannel) params.get("MethodChannel");
                HashMap<String, Object> params = new HashMap<>();
                params.put("id", i);
                params.put("msg", s);
                channel.invokeMethod("showMessage", params);
            }
        });

        return 0;
    }

    @Override
    public int onShowPinEntry(String s, long l, int i) {
        //return (callbacks != null) ? callbacks.onShowPinEntry(s, l, i);
        return 0;
    }

    @Override
    public void onAbort() {
        //if (callbacks != null) callbacks.onAbort();
    }

    @Override
    public void onShowMenu(int i, String s, String[] strings, MenuResult menuResult) {

        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                MethodChannel channel = (MethodChannel) params.get("MethodChannel");
                channel.invokeMethod("tablesLoaded", "");
            }
        });

        menuResult.setResult(0, 0);

    }
}


