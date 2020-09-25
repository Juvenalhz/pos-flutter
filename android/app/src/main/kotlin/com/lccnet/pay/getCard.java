package com.lccnet.pay;

import android.util.Log;
import com.ingenico.lar.bc.Pinpad;
import com.ingenico.lar.bc.PinpadCallbacks;
import java.util.Calendar;
import java.util.Locale;

import io.flutter.plugin.common.MethodChannel;

public class getCard implements PinpadCallbacks {

    public final static String TAG = "GetCard";

    private static int entryMode(int cardType) {
        switch (cardType) {
//            case 0: return Transaction.MODE_MAG;
//            case 3: return Transaction.MODE_CHIP;
//            case 5: return Transaction.MODE_CTLS_MS;
//            case 6: return Transaction.MODE_CTLS;
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

    public void getCardData(int amount) {


        final String getCardInput = String.format(Locale.US, "%02d%02d%012d%s%s%s00%d",
                0,                                              // Network ID filter (inconsequential outside BR and for POS)
                99,                                                    // Application type filter (credit, debit, "99" for all)
                amount,          // Transaction amount with 1/100 cents ("100" = 1.00)
                currentDate(),                                         // Transaction date (YYMMDD)
                currentTime(),                                         // Transaction time (HHMMSS)
                PinpadManager.TIMESTAMP,                               // 10-digit table timestamp
                0                                                      // 1 to allow CTLS, 0 to force disable
        );

        int ret = PinpadManager.me().getCard(getCardInput, this, output -> {
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
                final PinpadManager.TrackData tracks = PinpadManager.extractTrack(output.getOutput(), 9);
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

        Log.i(TAG, "getCard: " + ret);

        if (ret == Pinpad.PP_TABEXP) {
            new Thread(() -> {
                //PinpadManager.me().updateTables();
                //PinpadManager.me().resumeGetCard();
            }).start();
        }
    }

    @Override
    public int onShowMessage(int i, String s) {
        if (i == PinpadCallbacks.UPDATING_TABLES || i == PinpadCallbacks.UPDATING_RECORD) {
             Log.i(TAG, "onShowMessage1");

        } else {
            Log.i(TAG, "onShowMessage2");
        }

        final String message = PinpadManager.formatMessage(i, s);
        if (message != null) {
            Log.i(TAG, "onShowMessage3");
        }
        return Pinpad.PP_OK;
    }

    @Override
    public int onShowPinEntry(String s, long l, int i) {
        Log.i(TAG, "onShowPinEntry");
        return 0;
    }

    @Override
    public void onAbort() {
        Log.i(TAG, "onAbort");
    }

    @Override
    public void onShowMenu(final int i, final String s, final String[] strings, final MenuResult menuResult) {
        Log.i(TAG, "onShowMenu");
    }
}

