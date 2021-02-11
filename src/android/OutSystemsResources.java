package outsystems.resources.plugin;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.os.Build;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import org.apache.cordova.PermissionHelper;
import org.apache.cordova.file.PendingRequests;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import io.cordova.hellocordova.MainActivity;

/**
 * This class echoes a string called from JavaScript.
 */
public class OutSystemsResources extends CordovaPlugin {

    private org.apache.cordova.file.PendingRequests pendingRequests;
    Activity activity;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        activity  = this.cordova.getActivity();
        pendingRequests = new PendingRequests();
        if (action.equals("getFile")) {
            String fileName = args.getString(0);
            this.getFile(fileName, callbackContext);
            return true;
        }
        return false;
    }

    // Function to check and request permission
    public Boolean checkPermission(String permission, int requestCode)
    {
        // Checking if permission is not granted
        if (ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_DENIED) {
            return false;
        }
        return true;
    }

    private void getWritePermission(String rawArgs, int action, CallbackContext callbackContext) {
        int requestCode = pendingRequests.createRequest(rawArgs, action, callbackContext);
        PermissionHelper.requestPermission(this, requestCode, rawArgs);
    }

    private String copyAssets(String fileToBeCopied) {
        Context context = cordova.getActivity();
        AssetManager assetManager = cordova.getContext().getAssets();
        String[] files = null;
        try {
            files = assetManager.list("www/resources/");
        } catch (IOException e) {
            Log.e("tag", "Failed to get asset file list.", e);
            String errorMessage = "Failed to copy resource file: " + fileToBeCopied + ". " + e;
            return errorMessage;
        }
        Boolean fileFound = false;
        if (files != null) for (String filename : files) {
            if (filename.equals(fileToBeCopied)){
                fileFound = true;
                InputStream in = null;
                OutputStream out = null;
                try {
                    in = assetManager.open("www/resources/" + filename);
                    String folderPath = Environment.getExternalStorageDirectory().getPath() + File.separator + "Android" + File.separator + "data" + File.separator +
                            context.getPackageName() + "/resources";
                    File outFile = new File(folderPath, filename);
                    out = new FileOutputStream(outFile);
                    copyFile(in, out);
                } catch(IOException e) {
                    Log.e("tag", "Failed to copy resource file: " + filename, e);
                    String errorMessage = "Failed to copy resource file: " + filename + ". " + e;
                    return errorMessage;
                }
                finally {
                    if (in != null) {
                        try {
                            in.close();
                        } catch (IOException e) {
                            String errorMessage = "Failed to copy resource file: " + filename + ". " + e;
                            return errorMessage;
                        }
                    }
                    if (out != null) {
                        try {
                            out.close();
                        } catch (IOException e) {
                            String errorMessage = "Failed to copy resource file: " + filename + ". " + e;
                            return errorMessage;
                        }
                    }
                }
            }
        }
        if (fileFound){
            return "Ok";
        } else {
            return "Failed to copy resource file: " + fileToBeCopied + ". File not found.";
        }

    }
    private void copyFile(InputStream in, OutputStream out) throws IOException {
        byte[] buffer = new byte[1024];
        int read;
        while((read = in.read(buffer)) != -1){
            out.write(buffer, 0, read);
        }
    }

    private void getFile(String fileName, CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();

        if (fileName != null && fileName.length() > 0) {
            if (!checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE,2)) {
                try {
                    getWritePermission(Manifest.permission.WRITE_EXTERNAL_STORAGE,2, callbackContext);
                } catch (Exception e) {
                    e.printStackTrace();
                    callbackContext.error("Error requesting Write permission." + e);
                    throw e;
                }
                callbackContext.error("External Storage Write permission was not granted");

            } else {
                String folderPath = Environment.getExternalStorageDirectory().getPath() + File.separator + "Android" + File.separator + "data" + File.separator +
                        context.getPackageName() + File.separator + "resources";
                File destDir = new File(folderPath);
                if(!destDir.exists()){
                    destDir.mkdirs();
                }

                File f=new File(folderPath,fileName);

                if (!f.exists()) {
                    String result = copyAssets(fileName);
                    if (result != "Ok" ){
                        callbackContext.error(result);
                    } else {
                        callbackContext.success(fileName + " copied successfuly");
                    }
                } else {
                    callbackContext.error("File already exists on the destination folder.");
                }
            }

        } else {
            callbackContext.error("file name cannot be null");
        }
    }
}
