package cordova-plugin-kaaryaa-batterystatus;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class BatteryStatus extends CordovaPlugin {

    private class BatteryStatusInformation {
        boolean isPlugged;
        int level;
        float percentage;
        boolean usbCharging;
        boolean acCharging;
        public void setParams(boolean isPlugged, int level, float percentage, boolean usbCharging, boolean acCharging){
         this.isPlugged = isPlugged;
         this.level = level;
         }
     }
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("getStatus")) {
            this.getStatus(args, callbackContext);
            return true;
        }
        return false;
    }

    private void coolMethod(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
    private void getStatus(JSONArray args, CallbackContext callbackContext) {
      try {
        IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent batteryStatus = context.registerReceiver(null, ifilter);
        // Are we charging / charged?
        int status = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
        boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                            status == BatteryManager.BATTERY_STATUS_FULL;

        // How are we charging?
        int chargePlug = batteryStatus.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1);
        boolean usbCharge = chargePlug == BatteryManager.BATTERY_PLUGGED_USB;
        boolean acCharge = chargePlug == BatteryManager.BATTERY_PLUGGED_AC;


        int level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
        int scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        float batteryPct = level / (float)scale;

        BatteryStatusInformation batteryInfo = new BatteryStatusInformation();
        batteryInfo.setParams(isCharging, level, batteryPct, usbCharge, acCharge);
        callbackContext.success(batteryInfo);
      } catch (Exception e) {
          callbackContext.error("something went wrong" + e);
      }
    }
}
