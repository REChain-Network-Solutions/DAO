package Delus.app.webview;

class DelusConfig {

    /* -- CONFIG VARIABLES -- */

    //complete URL of your Delus website
    static String Delus_URL = "https://demo.Delus.com/";

    // OneSignal APP Id
    static String Delus_ONESIGNAL_APP_ID = "";


    /* -- PERMISSION VARIABLES -- */

    // enable JavaScript for webview
    static boolean DelusApp_JSCRIPT = true;

    // upload file from webview
    static boolean DelusApp_FUPLOAD = true;

    // enable upload from camera for photos
    static boolean DelusApp_CAMUPLOAD = true;

    // incase you want only camera files to upload
    static boolean DelusApp_ONLYCAM = false;

    // upload multiple files in webview
    static boolean DelusApp_MULFILE = true;

    // track GPS locations
    static boolean DelusApp_LOCATION = true;

    // show ratings dialog; auto configured
    // edit method get_rating() for customizations
    static boolean DelusApp_RATINGS = true;

    // pull refresh current url
    static boolean DelusApp_PULLFRESH = true;

    // show progress bar in app
    static boolean DelusApp_PBAR = true;

    // zoom control for webpages view
    static boolean DelusApp_ZOOM = false;

    // save form cache and auto-fill information
    static boolean DelusApp_SFORM = false;

    // whether the loading webpages are offline or online
    static boolean DelusApp_OFFLINE = false;

    // open external url with default browser instead of app webview
    static boolean DelusApp_EXTURL = false;


    /* -- SECURITY VARIABLES -- */

    // verify whether HTTPS port needs certificate verification
    static boolean DelusApp_CERT_VERIFICATION = true;

    //to upload any file type using "*/*"; check file type references for more
    static String Delus_F_TYPE = "*/*";


    /* -- RATING SYSTEM VARIABLES -- */

    static int ASWR_DAYS = 3;    // after how many days of usage would you like to show the dialoge
    static int ASWR_TIMES = 10;  // overall request launch times being ignored
    static int ASWR_INTERVAL = 2;   // reminding users to rate after days interval
}
