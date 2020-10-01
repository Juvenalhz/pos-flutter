package com.lccnet.pay;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.RemoteException;
import android.util.Log;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import static java.lang.Thread.sleep;
import io.flutter.plugin.common.MethodChannel;

import com.ingenico.lar.apos.DeviceHelper;
import com.ingenico.lar.bc.Pinpad;
import com.ingenico.lar.bc.PinpadCallbacks;
import com.ingenico.lar.bc.PinpadOutput;
import com.ingenico.lar.bc.PinpadOutputHandler;
import com.ingenico.lar.bc.apos.PinpadProviderAPOS;



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

    private static int entryMode(int cardType) {
        final int MODE_MAG = 21;
        final int MODE_CHIP = 51;
        final int MODE_CTLS = 3;
        final int MODE_CTLS_MS = 4;

        switch (cardType) {
            case 0: return MODE_MAG;
            case 3: return MODE_CHIP;
            case 5: return MODE_CTLS_MS;
            case 6: return MODE_CTLS;
            default: return -1;
        }
    }
    public int getCard(final String input) {
        MethodChannel channel = (MethodChannel) params.get("MethodChannel");
        HashMap<String, Object> card = new HashMap<>();

        if (Build.MODEL.contains("APOS")) {
            int ret = pinpad.getCard(input, output -> {
                Log.i(TAG, "getCard output: (" + output.getResultCode() + ") '" + output.getOutput() + "'");
                if (output.getResultCode() == Pinpad.PP_CANCEL) {
                    Log.i(TAG, "Pinpad.PP_CANCEL");
                } else if (output.getResultCode() == Pinpad.PP_OK) {
                    final String out = output.getOutput();

                    int cardType = Integer.parseInt(out.substring(0, 2));
                    card.put("cardType", cardType);
                    card.put("entryMode", entryMode(cardType));
                    card.put("readStatus", Integer.parseInt(out.substring(2, 3)));
                    card.put("readStatus", Integer.parseInt(out.substring(2, 3)));
                    card.put("appType", Integer.parseInt(out.substring(3, 5)));
                    card.put("appNetID", Integer.parseInt(out.substring(5, 7)));
                    card.put("recordID", Integer.parseInt(out.substring(7, 9)));
                    final PinpadManager.TrackData tracks = PinpadManager.extractTrack(output.getOutput(), 9);
                    card.put("track1", tracks.track1);
                    card.put("track2", tracks.track2);
                    final int panLen = Integer.parseInt(out.substring(233, 235));
                    card.put("pan", out.substring(235, 235 + panLen));
                    card.put("PANSequenceNumber", Integer.parseInt(out.substring(254, 256)));
                    card.put("appLabel", out.substring(256, 272).trim());
                    card.put("serviceCode", out.substring(272, 275));
                    card.put("cardholderName", out.substring(275, 301).trim());
                    card.put("expDate", out.substring(301, 307));

                    Log.i(TAG, "Pinpad.PP_OK");

                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("cardRead", card);
                        }
                    });
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

                    // test menu selection
//                    new Handler(Looper.getMainLooper()).post(new Runnable() {
//                        @Override
//                        public void run() {
//                            HashMap<Integer, String> menu = new HashMap<>();
//                            menu.put(0, "Credito");
//                            menu.put(1, "Debito");
//
//                            channel.invokeMethod("showMenu", menu);
//                        }
//                    });
//
//                    sleep(10000);

                    // test data for swipe card
//                    card.put("track2", "4034467912409037=230112100000105000");
//                    card.put("track1", "B4034467912409037^07675009725$10000$^2301121000000000000000105000000");
//                    card.put("expDate", "2301");
//                    card.put("pan", "4034467912409037");

                    // test data for chip card
                    card.put("appNetID", 1);
                    card.put("serviceCode", "201");
                    card.put("appType", 1);
                    card.put("cardType", 3);
                    card.put("PANSequenceNumber", 1);
                    card.put("cardholderName", "UAT USA/Test Card 01");
                    card.put("pan", "4761739001010119");
                    card.put("track2", "4761739001010119=22122011143804400000");
                    card.put("appLabel", "VISA CREDIT");
                    card.put("recordID", 3);
                    card.put("expDate", "221231");
                    card.put("track1", "");
                    card.put("readStatus", 0);

                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("cardRead", card);
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
                HashMap<String, Object> methodParams = new HashMap<>();
                methodParams.put("id", i);
                methodParams.put("msg", s);
                channel.invokeMethod("showMessage", methodParams);
            }
        });

        return 0;
    }

    @Override
    public void onAbort() {
        //if (callbacks != null) callbacks.onAbort();
    }

    @Override
    public void onShowMenu(int i, String s, String[] strings, MenuResult menuResult) {

        if (strings.length == 1) {
            menuResult.setResult(Pinpad.PP_OK, 0);
            return;
        }

        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                MethodChannel channel = (MethodChannel) params.get("MethodChannel");
                HashMap<String, Object> methodParams = new HashMap<>();

                HashMap<Integer, String> menuItems = new HashMap<>();
                int i;
                for(i=0; i<strings.length; i++){
                    menuItems.put(i, strings[i]);
                }

                channel.invokeMethod("showMenu", menuItems, new MethodChannel.Result() {

                    @Override
                    public void success(Object o) {
                        if ((int)o >= 0) {
                            menuResult.setResult(Pinpad.PP_OK, (int) o);
                        }
                        else
                            menuResult.setResult(Pinpad.PP_CANCEL, 0);
                    }

                    @Override
                    public void error(String s, String s1, Object o) {}

                    @Override
                    public void notImplemented() {}
                });
            }
        });

    }

    public int goOnChip(int amount, int cashBack) {
        MethodChannel channel = (MethodChannel) params.get("MethodChannel");
        HashMap<String, Object> onChipData = new HashMap<>();

        //TODO: need to pass inforamtion about the keys, and other emv params
        // input parameters to GoOnChip
        final String goOnChipInput = String.format(Locale.US, "%012d%012d%d%d%d%d%02d%-32s%d%s%02d%s%02d000",
                amount,     // Transaction amount
                cashBack,        // Transaction cashback amount
                0,                                                     // Is PAN black-listed? (0/1)
                1,                                                     // Must go online? (0/1)
                0,                                                     // Unused (was used for TIBC Easy-Entry, not supported)
                3,                                                     // Crypto mode for online PIN (1 for MK 3DES, 3 for DUKPT 3DES)
                2,                                                     // Key index for online PIN
                "00000000000000000000000000000000",                    // WK for PIN capture (if mode == 1) (hex, 32 digits)
                1,                                                     // Enable EMV risk management? (0/1)
                "00000000",                                            // Terminal Floor Limit (hex, 8 digits)
                25,                                                    // Target Percentage to be used for Biased Random Selection
                "00000000",                                            // Threshold Value for Biased Random Selection (hex, 8 digits)
                25                                                     // Maximum Target Percentage to be used for Biased Random Selection
        );

        // list of tags that GoOnChip should return
        final String goOnChipTagList = "828E959B9F109F179F269F279F349F369F37";
        final String goOnChipTags = String.format(Locale.US, "%03d%s",
                goOnChipTagList.length() / 2,       // Length of tag list *in bytes*
                goOnChipTagList                        // List of tags, hex-coded
        );

        final int ret = pinpad.goOnChip(goOnChipInput, goOnChipTags, null, output -> {

            Log.i(TAG, "goOnChip output: (" + output.getResultCode() + ") '" + output.getOutput() + "'");

            if (output.getResultCode() != Pinpad.PP_OK) {
                // error
                Log.i(TAG, "goOnChip error");
            }
            else {
                // parse response
                final String out = output.getOutput();
                onChipData.put("decision", Integer.parseInt(out.substring(0, 1)));
                onChipData.put("signature", Integer.parseInt(out.substring(1, 2)));
                onChipData.put("didOfflinePIN", Integer.parseInt(out.substring(2, 3)));
                onChipData.put("triesLeft", Integer.parseInt(out.substring(3, 4)));
                onChipData.put("isBlockedPIN", Integer.parseInt(out.substring(4, 5)));
                onChipData.put("didOnlinePIN", Integer.parseInt(out.substring(5, 6)));
                onChipData.put("onlinePINBlock", out.substring(6, 22));
                onChipData.put("PINKSN", out.substring(22, 42));
                final int emvTagsLength = Integer.parseInt(out.substring(42, 45));
                onChipData.put("emvTags", out.substring(45, 45 + emvTagsLength * 2));

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onChipDone", onChipData);
                    }
                });
            }
        });

        Log.i(TAG, "goOnChip: " + ret);

        return ret;
    }

    @Override
    public int onShowPinEntry(final String message, final long amount, final int digits) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    DeviceHelper.me().getBeeper().startBeep(200);
                } catch (RemoteException e) {
                    Log.e(TAG, "startBeep", e);
                }
                final StringBuilder sb = new StringBuilder();
                if (message != null) sb.append(message).append('\n');
                if (amount != 0)
                    sb.append("$ ").append(amount / 100).append('.').append(String.format(Locale.US, "%02d", amount % 100)).append('\n');
                for (int i = 0; i < digits; i++) sb.append('\u25CF');
                //textView.setText(sb.toString());
            }
        });
        return Pinpad.PP_OK;
    }
}


