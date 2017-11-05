using Toybox.Application as App;
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.FitContributor as fit;


//We must check if the system can do backgrounding:
var canDoBG = false;
//Keys to the object store data:
var OSDATA = "osdata";
var FLAG = "bgFlag";





(:background)
class glucose_datafieldApp extends App.AppBase {
	private const TAG = "datafieldApp";
    function initialize() {
    	Sys.println(TAG + "->initialize");
    	
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	Sys.println(TAG + "->onStart");
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	Sys.println(TAG + "->onStop");
    	Background.deleteTemporalEvent();
        return false;
    }

    // Return the initial view of your application here
    function getInitialView() {
    	Sys.println(TAG + "->getInitialView");
    	
    	//Register for temporal events if they are supported:
    	if(Toybox.System has :ServiceDelegate) {
    		canDoBG=true;
    		Background.registerForTemporalEvent(new Time.Duration(5*60));
    		Sys.println(TAG + "->getInitialViewSystem has bgs support.");
    	} else {
    		Sys.println("****background not available on this device****");
    	}
        return [ new glucose_datafieldView() ];
    }
    
    //Receive the data from the temporal event:
    function onBackgroundData(data){
    	Sys.println(TAG + "-> onBackgroundData: Background data received: " + data);   
    	 	
    	//Store in object store for main thread:
        App.getApp().setProperty(OSDATA,data);
        //Set flag to indicate that temporal event has occured and sgc is updated:
        App.getApp().setProperty(FLAG, true);
        Ui.requestUpdate();
    }
    
    
    //Delegate what happens when the temporal event occurs:	
    function getServiceDelegate(){
    	Sys.println(TAG + "-> getServiceDelegate");
    	return [new BgbgServiceDelegate()];
    }	
    
 }   
