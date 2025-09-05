package Delus.app.webview;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.DownloadManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.provider.Settings;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.webkit.CookieManager;
import android.webkit.DownloadListener;
import android.webkit.GeolocationPermissions;
import android.webkit.PermissionRequest;
import android.webkit.URLUtil;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.SslErrorHandler;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.NotificationCompat;

import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;

import com.onesignal.OneSignal;
import com.onesignal.debug.LogLevel;
import com.onesignal.Continue;

public class MainActivity extends AppCompatActivity {

    //Permission variables
    static boolean DelusApp_JSCRIPT = DelusConfig.DelusApp_JSCRIPT;
    static boolean DelusApp_FUPLOAD = DelusConfig.DelusApp_FUPLOAD;
    static boolean DelusApp_CAMUPLOAD = DelusConfig.DelusApp_CAMUPLOAD;
    static boolean DelusApp_ONLYCAM = DelusConfig.DelusApp_ONLYCAM;
    static boolean DelusApp_MULFILE = DelusConfig.DelusApp_MULFILE;
    static boolean DelusApp_LOCATION = DelusConfig.DelusApp_LOCATION;
    static boolean DelusApp_RATINGS = DelusConfig.DelusApp_RATINGS;
    static boolean DelusApp_PULLFRESH = DelusConfig.DelusApp_PULLFRESH;
    static boolean DelusApp_PBAR = DelusConfig.DelusApp_PBAR;
    static boolean DelusApp_ZOOM = DelusConfig.DelusApp_ZOOM;
    static boolean DelusApp_SFORM = DelusConfig.DelusApp_SFORM;
    static boolean DelusApp_OFFLINE = DelusConfig.DelusApp_OFFLINE;
    static boolean DelusApp_EXTURL = DelusConfig.DelusApp_EXTURL;

    //Security variables
    static boolean DelusApp_CERT_VERIFICATION = DelusConfig.DelusApp_CERT_VERIFICATION;

    //Configuration variables
    private static String Delus_URL = DelusConfig.Delus_URL;
    private String CURR_URL = Delus_URL;

    private String oneSignalUserID;

    private static String Delus_F_TYPE = DelusConfig.Delus_F_TYPE;

    private static String Delus_ONESIGNAL_APP_ID = DelusConfig.Delus_ONESIGNAL_APP_ID;

    public static String ASWV_HOST = aswm_host(Delus_URL);

    //Careful with these variable names if altering
    WebView swvp_view;
    ProgressBar swvp_progress;
    TextView swvp_loading_text;
    NotificationManager swvp_notification;
    Notification swvp_notification_new;

    private String swvp_cam_message;
    private ValueCallback<Uri> swvp_file_message;
    private ValueCallback<Uri[]> swvp_file_path;
    private final static int swvp_file_req = 1;

    private final static int loc_perm = 1;
    private final static int file_perm = 2;

    private SecureRandom random = new SecureRandom();

    private static final String TAG = MainActivity.class.getSimpleName();

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (Build.VERSION.SDK_INT >= 21) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            getWindow().setStatusBarColor(getResources().getColor(R.color.colorPrimary));
            Uri[] results = null;
            if (resultCode == Activity.RESULT_OK) {
                if (requestCode == swvp_file_req) {
                    if (null == swvp_file_path) {
                        return;
                    }
                    if (intent == null || intent.getData() == null) {
                        if (swvp_cam_message != null) {
                            results = new Uri[]{Uri.parse(swvp_cam_message)};
                        }
                    } else {
                        String dataString = intent.getDataString();
                        if (dataString != null) {
                            results = new Uri[]{Uri.parse(dataString)};
                        } else {
                            if (DelusApp_MULFILE) {
                                if (intent.getClipData() != null) {
                                    final int numSelectedFiles = intent.getClipData().getItemCount();
                                    results = new Uri[numSelectedFiles];
                                    for (int i = 0; i < numSelectedFiles; i++) {
                                        results[i] = intent.getClipData().getItemAt(i).getUri();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            swvp_file_path.onReceiveValue(results);
            swvp_file_path = null;
        } else {
            if (requestCode == swvp_file_req) {
                if (null == swvp_file_message) return;
                Uri result = intent == null || resultCode != RESULT_OK ? null : intent.getData();
                swvp_file_message.onReceiveValue(result);
                swvp_file_message = null;
            }
        }
    }

    @SuppressLint({"SetJavaScriptEnabled", "WrongViewCast"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // OneSignal Initialization
        if (!Objects.equals(Delus_ONESIGNAL_APP_ID, "")) {
            OneSignal.initWithContext(this, Delus_ONESIGNAL_APP_ID);

            // requestPermission will show the native Android notification permission prompt.
            // NOTE: It's recommended to use a OneSignal In-App Message to prompt instead.
            OneSignal.getNotifications().requestPermission(false, Continue.none());

            // Get OneSignal user ID
            oneSignalUserID = OneSignal.getUser().getPushSubscription().getId();
        }

        Intent intent = getIntent();
        String action = intent.getAction();
        if (action == null) {
            //Prevent the app from being started again when it is still alive in the background
            if (!isTaskRoot()) {
                finish();
                return;
            }
        }

        setContentView(R.layout.activity_main);
        swvp_view = findViewById(R.id.msw_view);
        swvp_view.getSettings().setJavaScriptEnabled(true);

        final SwipeRefreshLayout pullfresh = findViewById(R.id.pullfresh);
        if (DelusApp_PULLFRESH) {
            pullfresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
                @Override
                public void onRefresh() {
                    pull_fresh();
                    pullfresh.setRefreshing(false);
                }
            });
            swvp_view.getViewTreeObserver().addOnScrollChangedListener(new ViewTreeObserver.OnScrollChangedListener() {
                @Override
                public void onScrollChanged() {
                    if (swvp_view.getScrollY() == 0) {
                        pullfresh.setEnabled(true);
                    } else {
                        pullfresh.setEnabled(false);
                    }
                }
            });
        } else {
            pullfresh.setRefreshing(false);
            pullfresh.setEnabled(false);
        }

        if (DelusApp_PBAR) {
            swvp_progress = findViewById(R.id.msw_progress);
        } else {
            findViewById(R.id.msw_progress).setVisibility(View.GONE);
        }
        swvp_loading_text = findViewById(R.id.msw_loading_text);
        Handler handler = new Handler();

        //Launching app rating request
        if (DelusApp_RATINGS) {
            handler.postDelayed(new Runnable() {
                public void run() {
                    get_rating();
                }
            }, 1000 * 60); //running request after few moments
        }

        //Getting basic device information
        get_info();

        //Getting GPS location of device if given permission
        get_location();

        //Webview settings; defaults are customized for best performance
        WebSettings webSettings = swvp_view.getSettings();
        swvp_view.getSettings().setUserAgentString("Delus");
        swvp_view.getSettings().setMediaPlaybackRequiresUserGesture(false);

        if (!DelusApp_OFFLINE) {
            webSettings.setJavaScriptEnabled(DelusApp_JSCRIPT);
        }
        webSettings.setSaveFormData(DelusApp_SFORM);
        webSettings.setSupportZoom(DelusApp_ZOOM);
        webSettings.setGeolocationEnabled(DelusApp_LOCATION);
        webSettings.setAllowFileAccess(true);
        webSettings.setAllowFileAccessFromFileURLs(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setDomStorageEnabled(true);

        swvp_view.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                return true;
            }
        });
        swvp_view.setHapticFeedbackEnabled(false);

        swvp_view.setDownloadListener(new DownloadListener() {
            @Override
            public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimeType, long contentLength) {
                DownloadManager.Request request = new DownloadManager.Request(Uri.parse(url));
                request.setMimeType(mimeType);
                String cookies = CookieManager.getInstance().getCookie(url);
                request.addRequestHeader("cookie", cookies);
                request.addRequestHeader("User-Agent", userAgent);
                request.setDescription(getString(R.string.dl_downloading));
                request.setTitle(URLUtil.guessFileName(url, contentDisposition, mimeType));
                request.allowScanningByMediaScanner();
                request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
                request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, URLUtil.guessFileName(url, contentDisposition, mimeType));
                DownloadManager dm = (DownloadManager) getSystemService(DOWNLOAD_SERVICE);
                assert dm != null;
                dm.enqueue(request);
                Toast.makeText(getApplicationContext(), getString(R.string.dl_downloading2), Toast.LENGTH_LONG).show();
            }
        });

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        getWindow().setStatusBarColor(getResources().getColor(R.color.colorPrimaryDark));
        webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        swvp_view.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        swvp_view.setVerticalScrollBarEnabled(false);
        swvp_view.setWebViewClient(new Callback());

        //Rendering the default URL
        aswm_view(Delus_URL, false);

        //Get Cam & Mic & location permissions
        if (!check_permission(1) || !check_permission(3) || !check_permission(4)) {
            //Cam & Mic & location permissions not granted so request them
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO}, 20);
        }

        swvp_view.setWebChromeClient(new WebChromeClient() {
            public void onPermissionRequest(final PermissionRequest request) {
                request.grant(request.getResources());
            }

            @Override
            public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback callback) {
                callback.invoke(origin, true, false);
            }

            //Handling input[type="file"]
            public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
                if (check_permission(3)) {
                    if (DelusApp_FUPLOAD) {
                        if (swvp_file_path != null) {
                            swvp_file_path.onReceiveValue(null);
                        }
                        swvp_file_path = filePathCallback;
                        Intent takePictureIntent = null;
                        if (DelusApp_CAMUPLOAD) {
                            takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                            if (takePictureIntent.resolveActivity(MainActivity.this.getPackageManager()) != null) {
                                File photoFile = null;
                                Uri photoURI = null;
                                try {
                                    photoFile = create_image();
                                    photoURI = FileProvider.getUriForFile(MainActivity.this, BuildConfig.APPLICATION_ID + ".provider", photoFile);
                                } catch (IOException ex) {
                                    Log.e(TAG, "Image file creation failed", ex);
                                }
                                if (photoURI != null) {
                                    swvp_cam_message = "file:" + photoFile.getAbsolutePath();
                                    takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                                } else {
                                    takePictureIntent = null;
                                }
                            }
                        }
                        Intent contentSelectionIntent = new Intent(Intent.ACTION_GET_CONTENT);
                        if (!DelusApp_ONLYCAM) {
                            contentSelectionIntent.addCategory(Intent.CATEGORY_OPENABLE);
                            contentSelectionIntent.setType(Delus_F_TYPE);
                            if (DelusApp_MULFILE) {
                                contentSelectionIntent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
                            }
                        }
                        Intent[] intentArray;
                        if (takePictureIntent != null) {
                            intentArray = new Intent[]{takePictureIntent};
                        } else {
                            intentArray = new Intent[0];
                        }

                        Intent chooserIntent = new Intent(Intent.ACTION_CHOOSER);
                        chooserIntent.putExtra(Intent.EXTRA_INTENT, contentSelectionIntent);
                        chooserIntent.putExtra(Intent.EXTRA_TITLE, getString(R.string.fl_chooser));
                        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, intentArray);
                        startActivityForResult(chooserIntent, swvp_file_req);
                    }
                    return true;
                } else {
                    get_file();
                    return false;
                }
            }

            //Getting webview rendering progress
            @Override
            public void onProgressChanged(WebView view, int p) {
                if (DelusApp_PBAR) {
                    swvp_progress.setProgress(p);
                    if (p == 100) {
                        swvp_progress.setProgress(0);
                    }
                }
            }
        });
        if (getIntent().getData() != null) {
            String path = getIntent().getDataString();
            if (path != null && path.startsWith("Delus://")) {
                path = path.replace("Delus://", "https://");
            }
            aswm_view(path, false);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        swvp_view.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();
        swvp_view.onResume();
        //Coloring the "recent apps" tab header; doing it onResume, as an insurance
        if (Build.VERSION.SDK_INT >= 23) {
            Bitmap bm = BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher);
            ActivityManager.TaskDescription taskDesc;
            taskDesc = new ActivityManager.TaskDescription(getString(R.string.app_name), bm, getColor(R.color.colorPrimary));
            MainActivity.this.setTaskDescription(taskDesc);
        }
        get_location();
    }

    //Setting activity layout visibility
    private class Callback extends WebViewClient {
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            get_location();
        }

        public void onPageFinished(WebView view, String url) {
            findViewById(R.id.msw_welcome).setVisibility(View.GONE);
            findViewById(R.id.msw_view).setVisibility(View.VISIBLE);

            // Disable pull-to-refresh for the reels page
            SwipeRefreshLayout pullfresh = findViewById(R.id.pullfresh);
            if (pullfresh != null) {
                pullfresh.setEnabled(!url.contains("reels"));
            }

            // Inject JavaScript to save the OneSignal user ID after the page has loaded
            if (oneSignalUserID != null) {
                swvp_view.loadUrl("javascript:saveAndroidOneSignalUserId('" + oneSignalUserID + "')");
            }
        }

        //For android below API 23
        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            Toast.makeText(getApplicationContext(), getString(R.string.went_wrong), Toast.LENGTH_SHORT).show();
            aswm_view("file:///android_asset/error.html", false);
        }

        //Overriding webview URLs
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            CURR_URL = url;
            return url_actions(view, url);
        }

        //Overriding webview URLs for API 23+ [suggested by github.com/JakePou]
        @TargetApi(Build.VERSION_CODES.N)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            CURR_URL = request.getUrl().toString();
            return url_actions(view, CURR_URL);
        }

        @Override
        public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
            if (DelusApp_CERT_VERIFICATION) {
                super.onReceivedSslError(view, handler, error);
            } else {
                handler.proceed(); // Ignore SSL certificate errors
            }
        }
    }

    //Random ID creation function to help get fresh cache every-time webview reloaded
    public String random_id() {
        return new BigInteger(130, random).toString(32);
    }

    //Opening URLs inside webview with request
    void aswm_view(String url, Boolean tab) {
        if (tab) {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse(url));
            startActivity(intent);
        } else {
            if (url.contains("?")) { // check to see whether the url already has query parameters and handle appropriately.
                url += "&";
            } else {
                url += "?";
            }
            url += "rid=" + random_id();
            swvp_view.loadUrl(url);
        }
    }

    //Actions based on shouldOverrideUrlLoading
    public boolean url_actions(WebView view, String url) {
        boolean a = true;
        //Show toast error if not connected to the network
        if (!DelusApp_OFFLINE && !DetectConnection.isInternetAvailable(MainActivity.this)) {
            Toast.makeText(getApplicationContext(), getString(R.string.check_connection), Toast.LENGTH_SHORT).show();

        } else if (url.startsWith("Delus:")) {
            // Replace custom scheme with actual URL
            String newUrl = url.replace("Delus://", "https://");
            aswm_view(newUrl, false);

            //Use this in a hyperlink to redirect back to default URL :: href="refresh:android"
        } else if (url.startsWith("refresh:")) {
            String ref_sch = (Uri.parse(url).toString()).replace("refresh:", "");
            if (ref_sch.matches("URL")) {
                CURR_URL = Delus_URL;
            }
            pull_fresh();

            //Use this in a hyperlink to launch default phone dialer for specific number :: href="tel:+919876543210"
        } else if (url.startsWith("tel:")) {
            Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse(url));
            startActivity(intent);

            //Use this to open your apps page on google play store app :: href="rate:android"
        } else if (url.startsWith("rate:")) {
            final String app_package = getPackageName(); //requesting app package name from Context or Activity object
            try {
                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + app_package)));
            } catch (ActivityNotFoundException anfe) {
                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + app_package)));
            }

            //Sharing content from your webview to external apps :: href="share:URL" and remember to place the URL you want to share after share:___
        } else if (url.startsWith("share:")) {
            Intent intent = new Intent(Intent.ACTION_SEND);
            intent.setType("text/plain");
            intent.putExtra(Intent.EXTRA_SUBJECT, view.getTitle());
            intent.putExtra(Intent.EXTRA_TEXT, view.getTitle() + "\nVisit: " + (Uri.parse(url).toString()).replace("share:", ""));
            startActivity(Intent.createChooser(intent, getString(R.string.share_w_friends)));

            //Use this in a hyperlink to exit your app :: href="exit:android"
        } else if (url.startsWith("exit:")) {
            Intent intent = new Intent(Intent.ACTION_MAIN);
            intent.addCategory(Intent.CATEGORY_HOME);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);

            //Getting location for offline files
        } else if (url.startsWith("offloc:")) {
            String offloc = Delus_URL + "?loc=" + get_location();
            aswm_view(offloc, false);
            Log.d("OFFLINE LOC REQ", offloc);

            //Opening external URLs in android default web browser
        } else if (DelusApp_EXTURL && !aswm_host(url).equals(ASWV_HOST)) {
            aswm_view(url, true);

        } else {
            a = false;
        }
        return a;
    }

    //Getting host name
    public static String aswm_host(String url) {
        if (url == null || url.length() == 0) {
            return "";
        }
        int dslash = url.indexOf("//");
        if (dslash == -1) {
            dslash = 0;
        } else {
            dslash += 2;
        }
        int end = url.indexOf('/', dslash);
        end = end >= 0 ? end : url.length();
        int port = url.indexOf(':', dslash);
        end = (port > 0 && port < end) ? port : end;
        return url.substring(dslash, end);
    }

    //Reloading current page
    public void pull_fresh() {
        aswm_view((!CURR_URL.equals("") ? CURR_URL : Delus_URL), false);
    }

    //Getting device basic information
    public void get_info() {
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        cookieManager.setCookie(Delus_URL, "DEVICE=android");
        cookieManager.setCookie(Delus_URL, "DEV_API=" + Build.VERSION.SDK_INT);
    }

    //Checking permission for storage and camera for writing and uploading images
    public void get_file() {
        String[] perms = {Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA};

        //Checking for storage permission to write images for upload
        if (DelusApp_FUPLOAD && DelusApp_CAMUPLOAD && !check_permission(2) && !check_permission(3)) {
            ActivityCompat.requestPermissions(MainActivity.this, perms, file_perm);

            //Checking for WRITE_EXTERNAL_STORAGE permission
        } else if (DelusApp_FUPLOAD && !check_permission(2)) {
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE}, file_perm);

            //Checking for CAMERA permissions
        } else if (DelusApp_CAMUPLOAD && !check_permission(3)) {
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CAMERA}, file_perm);
        }
    }

    //Using cookies to update user locations
    public String get_location() {
        String newloc = "0,0";
        //Checking for location permissions
        if (DelusApp_LOCATION && (Build.VERSION.SDK_INT < 23 || check_permission(1))) {
            GPSTrack gps;
            gps = new GPSTrack(MainActivity.this);
            double latitude = gps.getLatitude();
            double longitude = gps.getLongitude();
            if (gps.canGetLocation()) {
                if (latitude != 0 || longitude != 0) {
                    if (!DelusApp_OFFLINE) {
                        CookieManager cookieManager = CookieManager.getInstance();
                        cookieManager.setAcceptCookie(true);
                        cookieManager.setCookie(Delus_URL, "lat=" + latitude);
                        cookieManager.setCookie(Delus_URL, "long=" + longitude);
                    }
                    newloc = latitude + "," + longitude;
                } else {
                    Log.w("New Updated Location:", "NULL");
                }
            } else {
                show_notification(1, 1);
                Log.w("New Updated Location:", "FAIL");
            }
        }
        return newloc;
    }

    //Checking if particular permission is given or not
    public boolean check_permission(int permission) {
        switch (permission) {
            case 1:
                return ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;

            case 2:
                return ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;

            case 3:
                return ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED;

            case 4:
                return ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED;
        }
        return false;
    }

    //Creating image file for upload
    private File create_image() throws IOException {
        @SuppressLint("SimpleDateFormat")
        String file_name = new SimpleDateFormat("yyyy_mm_ss").format(new Date());
        String new_name = "file_" + file_name + "_";
        File storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        return File.createTempFile(new_name, ".jpg", storageDir);
    }

    //Launching app rating dialoge [developed by github.com/hotchemi]
    public void get_rating() {
        if (DetectConnection.isInternetAvailable(MainActivity.this)) {
            AppRate.with(this)
                    .setStoreType(StoreType.GOOGLEPLAY)     //default is Google Play, other option is Amazon App Store
                    .setInstallDays(DelusConfig.ASWR_DAYS)
                    .setLaunchTimes(DelusConfig.ASWR_TIMES)
                    .setRemindInterval(DelusConfig.ASWR_INTERVAL)
                    .setTitle(R.string.rate_dialog_title)
                    .setMessage(R.string.rate_dialog_message)
                    .setTextLater(R.string.rate_dialog_cancel)
                    .setTextNever(R.string.rate_dialog_no)
                    .setTextRateNow(R.string.rate_dialog_ok)
                    .monitor();
            AppRate.showRateDialogIfMeetsConditions(this);
        }
        //for more customizations, look for AppRate and DialogManager
    }

    //Creating custom notifications with IDs
    public void show_notification(int type, int id) {
        long when = System.currentTimeMillis();
        swvp_notification = (NotificationManager) MainActivity.this.getSystemService(Context.NOTIFICATION_SERVICE);
        Intent i = new Intent();
        if (type == 1) {
            i.setClass(MainActivity.this, MainActivity.class);
        } else if (type == 2) {
            i.setAction(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
        } else {
            i.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            i.addCategory(Intent.CATEGORY_DEFAULT);
            i.setData(Uri.parse("package:" + MainActivity.this.getPackageName()));
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            i.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
            i.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
        }
        i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        PendingIntent pendingIntent = PendingIntent.getActivity(MainActivity.this, 0, i, PendingIntent.FLAG_UPDATE_CURRENT);

        Uri alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(MainActivity.this, "");
        switch (type) {
            case 1:
                builder.setTicker(getString(R.string.app_name));
                builder.setContentTitle(getString(R.string.loc_fail));
                builder.setContentText(getString(R.string.loc_fail_text));
                builder.setStyle(new NotificationCompat.BigTextStyle().bigText(getString(R.string.loc_fail_more)));
                builder.setVibrate(new long[]{350, 350, 350, 350, 350});
                builder.setSmallIcon(R.mipmap.ic_launcher);
                break;

            case 2:
                builder.setTicker(getString(R.string.app_name));
                builder.setContentTitle(getString(R.string.loc_perm));
                builder.setContentText(getString(R.string.loc_perm_text));
                builder.setStyle(new NotificationCompat.BigTextStyle().bigText(getString(R.string.loc_perm_more)));
                builder.setVibrate(new long[]{350, 700, 350, 700, 350});
                builder.setSound(alarmSound);
                builder.setSmallIcon(R.mipmap.ic_launcher);
                break;
        }
        builder.setOngoing(false);
        builder.setAutoCancel(true);
        builder.setContentIntent(pendingIntent);
        builder.setWhen(when);
        builder.setContentIntent(pendingIntent);
        swvp_notification_new = builder.build();
        swvp_notification.notify(id, swvp_notification_new);
    }

    //Checking if users allowed the requested permissions or not
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                get_location();
            }
        }
    }

    //Action on back key tap/click
    @Override
    public boolean onKeyDown(int keyCode, @NonNull KeyEvent event) {
        if (event.getAction() == KeyEvent.ACTION_DOWN) {
            if (keyCode == KeyEvent.KEYCODE_BACK) {
                if (swvp_view.canGoBack()) {
                    swvp_view.goBack();
                } else {
                    finish();
                }
                return true;
            }
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        swvp_view.saveState(outState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        swvp_view.restoreState(savedInstanceState);
    }
}
