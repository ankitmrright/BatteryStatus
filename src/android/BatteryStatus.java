package cordova.plugin.kaaryaa.batterystatus;

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
        if (action.equals("getLevel")) {
            this.getStatus(args, callbackContext);
            return true;
        } else if (action.equals("isPLugged")) {
            this.getStatus(args, callbackContext);
            return true;
        }
        return false;
    }
    
    private void getLevel(JSONArray args, CallbackContext callbackContext) {
        try {
            int level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
            int scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
            float batteryPct = level / (float)scale;
            callbackContext.success("" + batteryPct);
        } catch (Exception e) {
            callbackContext.error("something went wrong" + e);
        }
    }
    private void isPLugged(JSONArray args, CallbackContext callbackContext) {
        try {
            IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
            Intent batteryStatus = context.registerReceiver(null, ifilter);
            // Are we charging / charged?
            int status = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                                status == BatteryManager.BATTERY_STATUS_FULL;
            callbackContext.success("" + isCharging);
                                
        } catch (Exception e) {
            callbackContext.error("something went wrong" + e);
        }
    }
}
