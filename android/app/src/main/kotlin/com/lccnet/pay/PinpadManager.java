package com.lccnet.pay;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.RemoteException;
import android.util.Log;

import java.util.Calendar;
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
    final int MODE_MAG = 21;
    final int MODE_CHIP = 51;
    final int MODE_CTLS = 3;
    final int MODE_CTLS_MS = 4;

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

    private int entryMode(int cardType) {
        switch (cardType) {
            case 0: return this.MODE_MAG;
            case 3: return this.MODE_CHIP;
            case 5: return this.MODE_CTLS_MS;
            case 6: return this.MODE_CTLS;
            default: return -1;
        }
    }

    private String currentDate() {
        Calendar now = Calendar.getInstance();
        return String.format(Locale.US, "%02d%02d%02d",
                now.get(Calendar.YEAR) % 100,
                now.get(Calendar.MONTH),
                now.get(Calendar.DAY_OF_MONTH));
    }

    private String currentTime() {
        Calendar now = Calendar.getInstance();
        return String.format(Locale.US, "%02d%02d%02d",
                now.get(Calendar.HOUR),
                now.get(Calendar.MINUTE),
                now.get(Calendar.SECOND));
    }

    public int getCard(final int amount) {
        MethodChannel channel = (MethodChannel) params.get("MethodChannel");
        HashMap<String, Object> card = new HashMap<>();
        int ret = 0;

        if (Build.MODEL.contains("APOS")) {
            final String input = String.format(Locale.US, "%02d%02d%012d%s%s%s00%d",
                    0,         // Network ID filter (inconsequential outside BR and for POS)
                    99,              // Application type filter (credit, debit, "99" for all)
                    amount,          // Transaction amount with 1/100 cents ("100" = 1.00)
                    currentDate(),   // Transaction date (YYMMDD)
                    currentTime(),   // Transaction time (HHMMSS)
                    PinpadManager.TIMESTAMP, // 10-digit table timestamp
                    1                // 1 to allow CTLS, 0 to force disable
            );

            ret = pinpad.getCard(input, output -> {
                Log.i(TAG, "getCard output: (" + output.getResultCode() + ") '" + output.getOutput() + "'");
                if (output.getResultCode() != Pinpad.PP_OK) {
                    Log.i(TAG, "Pinpad result code error");
                } else if (output.getResultCode() == Pinpad.PP_OK) {
                    final String out = output.getOutput();

                    int cardType = Integer.parseInt(out.substring(0, 2));
                    card.put("cardType", cardType);
                    card.put("entryMode", entryMode(cardType));
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
                }

                card.put("resultCode", output.getResultCode());

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("cardRead", card);
                    }
                });
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
        else if (isEmulator()){
            new Thread(() -> {
                try {
                    // flag to simulate mag stripe, should be true if the amount ends with 83 cents
                    Boolean simulateMagStripe = ((amount % 100) == 83);
                    // simulate loading of the emv data
                    this.onShowMessage(PinpadCallbacks.PROCESSING, "");
                    sleep(200);
                    this.onShowMessage(PinpadCallbacks.INSERT_SWIPE_CARD, "");
                    sleep(200);

                    // test menu selection
                    // this section is to simulate app. selection menu
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
                    // this is to test mag stripe card
                    if (simulateMagStripe) {
                        card.put("cardType", 0);
                        card.put("entryMode", 21);
                        card.put("track2", "4034467912409037=230112100000105000");
                        card.put("track1", "B4034467912409037^07675009725$10000$^2301121000000000000000105000000");
                        card.put("expDate", "2301");
                        card.put("pan", "4034467912409037");
                    }
                    else {
                        // test data for chip card
                        card.put("appNetID", 1);
                        card.put("serviceCode", "201");
                        card.put("appType", 1);
                        card.put("cardType", 3);
                        card.put("entryMode", 51);
                        card.put("PANSequenceNumber", 1);
                        card.put("cardholderName", "UAT USA/Test Card 01");
                        card.put("pan", "4761739001010119");
                        card.put("track2", "4761739001010119=22122011143804400000");
                        card.put("appLabel", "VISA CREDIT");
                        card.put("recordID", 3);
                        card.put("expDate", "221231");
                        card.put("track1", "");
                        card.put("readStatus", 0);
                        card.put("resultCode", 0);
                    }

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
            return ret;
        }
        else
            return Pinpad.PP_CANCEL;
    }

    public int resumeGetCard() {
        return pinpad.resumeGetCard();
    }

    public int goOnChip(int amount, int cashBack, int keyIndex, HashMap<String, Object> aid) {
        MethodChannel channel = (MethodChannel) params.get("MethodChannel");
        HashMap<String, Object> onChipData = new HashMap<>();
        int ret = Pinpad.PP_ERRCARD;

        if (Build.MODEL.contains("APOS")) {
            // input parameters to GoOnChip
            final String goOnChipInput = String.format(Locale.US, "%012d%012d%d%d%d%d%02d%-32s%d%08x%02d%08X%02d000",
                    amount,     // Transaction amount
                    cashBack,        // Transaction cashback amount
                    0,                                    // Is PAN black-listed? (0/1)
                    1,                                    // Must go online? (0/1)
                    0,                                    // Unused (was used for TIBC Easy-Entry, not supported)
                    keyIndex,                                    // Crypto mode for online PIN (1 for MK 3DES, 3 for DUKPT 3DES)
                    2,                                    // Key index for online PIN
                    "00000000000000000000000000000000",   // WK for PIN capture (if mode == 1) (hex, 32 digits)
                    1,                                    // Enable EMV risk management? (0/1)
                    aid.get("floorLimit"),                // Terminal Floor Limit (hex, 8 digits)
                    aid.get("targetPercentage"),          // Target Percentage to be used for Biased Random Selection
                    aid.get("thresholdAmount"),           // Threshold Value for Biased Random Selection (hex, 8 digits)
                    aid.get("maxTargetPercentage")        // Maximum Target Percentage to be used for Biased Random Selection
            );

            // list of tags that GoOnChip should return
            final String goOnChipTagList = "828E959B9F109F179F269F279F349F369F37";
            final String goOnChipTags = String.format(Locale.US, "%03d%s",
                    goOnChipTagList.length() / 2,       // Length of tag list *in bytes*
                    goOnChipTagList                        // List of tags, hex-coded
            );

            ret = pinpad.goOnChip(goOnChipInput, goOnChipTags, null, output -> {

                Log.i(TAG, "goOnChip output: (" + output.getResultCode() + ") '" + output.getOutput() + "'");

                if (output.getResultCode() != Pinpad.PP_OK) {
                    // error
                    Log.i(TAG, "goOnChip error");
                } else {
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
                }

                onChipData.put("resultCode", output.getResultCode());

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onChipDone", onChipData);
                    }
                });
            });

            Log.i(TAG, "goOnChip: " + ret);
        }
        else if (isEmulator()){
            new Thread(() -> {
                onChipData.put("onlinePINBlock", "F52B3F2AAB59202D");
                onChipData.put("signature", 0);
                onChipData.put("PINKSN", "FFFF0000000000000036");
                onChipData.put("didOnlinePIN", 1);
                onChipData.put("didOfflinePIN", 0);
                onChipData.put("decision", 2);
                onChipData.put("emvTags", "82021C008E0E000000000000000042035E031F00950580800480009B0268009F100706010A03A0B8009F2608418EEF3143FF86479F2701809F34034203009F3602014B9F3704906DBDE1");
                onChipData.put("isBlockedPIN", 1);
                onChipData.put("triesLeft", 0);
                onChipData.put("resultCode", 0);

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onChipDone", onChipData);
                    }
                });
            }).start();
            return 0;
        }
        return ret;
    }

    public int finishChip(final String hostResponse, final int entryMode, final String responseTags) {
        MethodChannel channel = (MethodChannel) params.get("MethodChannel");
        HashMap<String, Object> finishChipData = new HashMap<>();

        if (Build.MODEL.contains("APOS")) {
            final int failedOnline = (hostResponse.length() != 0) ? 0 : 1;
            final String arc = (hostResponse.length() != 0) ? hostResponse : "Z3";
            final String finishChipInput = String.format(Locale.US, "%d%d%s%03d%s000",
                    failedOnline,                    // Error communicating with host? (0/1) -- note the negative! ("1" means communication OK)
                    0,                                      // EMV full grade (0) or partial grade (1)
                    arc,                                    // Authorization Response Code from host
                    responseTags.length() / 2,       // Length of tags returned from host (bit 55) *in bytes*
                    responseTags                     // Hex of tags returned from host
            );

            final String finishChipTagList = "9F269F27";
            final String finishChipTags = String.format(Locale.US, "%03d%s", finishChipTagList.length() / 2, finishChipTagList);

            final PinpadOutput output = pinpad.finishChip(finishChipInput, finishChipTags);

            finishChipData.put("resultCode", output.getResultCode());
            if (output.getResultCode() != Pinpad.PP_OK) {
                // TODO: processing error
                Log.i(TAG, "finishChip error");
            } else {
                final String out = output.getOutput();

                finishChipData.put("decision", Integer.parseInt(out.substring(0, 1)));
                final int tagsLen = Integer.parseInt(out.substring(1, 4));
                finishChipData.put("tags", out.substring(4, 4 + tagsLen * 2));
            }

            // if chip, ask user to remove card
            if (entryMode == MODE_CHIP) {
                pinpad.removeCard("Retire Tarjeta", removeOutput -> {
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("cardRemoved", finishChipData);
                        }
                    });

                });
            } else {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("cardRemoved", finishChipData);
                    }
                });
            }
            return output.getResultCode();
        }
        else if (isEmulator()){

            finishChipData.put("decision", 0);
            finishChipData.put("tags", "9F260820C42A2070F6B4F89F270140");
            finishChipData.put("resultCode", 0);

            new Thread(() -> {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Object> methodParams = new HashMap<>();
                        methodParams.put("id", 0);
                        methodParams.put("msg", "Retire Tarjeta");
                        channel.invokeMethod("showMessage", methodParams);
                        try {
                            sleep(1500);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }

                        channel.invokeMethod("cardRemoved", finishChipData);
                    }
                });
            }).start();

            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {

                }
            });

            return 0;
        }
        else
            return Pinpad.PP_CANCEL;
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

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        MethodChannel channel = (MethodChannel) params.get("MethodChannel");
                        channel.invokeMethod("showPinAmount", null);
                    }
                });
            }
        });
        return Pinpad.PP_OK;
    }

    public boolean isEmulator(){
        StringBuilder deviceInfo = new StringBuilder();
        deviceInfo.append("Build.PRODUCT " +Build.PRODUCT +"\n");
        deviceInfo.append("Build.FINGERPRINT " +Build.FINGERPRINT+"\n");
        deviceInfo.append("Build.MANUFACTURER " +Build.MANUFACTURER+"\n");
        deviceInfo.append("Build.MODEL " +Build.MODEL+"\n");
        deviceInfo.append("Build.BRAND " +Build.BRAND+"\n");
        deviceInfo.append("Build.DEVICE " +Build.DEVICE+"\n");
        String info = deviceInfo.toString();

        Boolean isvm = false;
        if( "google_sdk".equals(Build.PRODUCT) ||
            "sdk_google_phone_x86".equals(Build.PRODUCT) ||
            "sdk".equals(Build.PRODUCT) ||
            "sdk_x86".equals(Build.PRODUCT) ||
            "vbox86p".equals(Build.PRODUCT) ||
            Build.FINGERPRINT.contains("generic") ||
            Build.MANUFACTURER.contains("Genymotion") ||
            Build.MODEL.contains("Emulator") ||
            Build.MODEL.contains("Android SDK built for x86")
        ){
            isvm =  true;
        }

        if(Build.BRAND.contains("generic")&&Build.DEVICE.contains("generic")){
            isvm =  true;
        }

        return isvm;
    }
}


