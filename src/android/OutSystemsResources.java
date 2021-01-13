package outsystems-resources-plugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class OutSystemsResources extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("getFile")) {
            String fileName = args.getString(0);
            this.getFile(fileName, callbackContext);
            return true;
        }
        return false;
    }

    private void getFile(String fileName, CallbackContext callbackContext) {
        if (fileName != null && fileName.length() > 0) {

            //Creates the destination dir if it does not exists
            String folderPath=Environment.getExternalStorageDirectory().getAbsolutePath()+"/Documents/";
            File destDir=new File(folderPath);
            if(!destDir.exists()){
             destDir.mkdirs();
            }

            File f=new File(Environment.getExternalStorageDirectory(), "Documents/" + fileName);
            if (!f.exists()) {
                try {
                    InputStream ins = getApplicationContext().getAssets().open("www/" + fileName);
                    FileOutputStream out=new FileOutputStream(f);
                    byte[] buf=new byte[1024];
                    int len;
                    while ((len=ins.read(buf)) > 0) {
                        out.write(buf, 0, len);
                    }
                    ins.close();
                    out.close();
                }
                catch (IOException e) {
                    Log.e("FileProvider", "Exception copying from assets", e);
                }
            }

            callbackContext.success(fileName);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
}
