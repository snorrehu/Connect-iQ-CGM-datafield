using Toybox.Application as App;
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.FitContributor as fit;

//Our viewed sensor glucose value:
var sgvData = null;

//We must check if the system can do backgrounding:
var canDoBG = false;
//Keys to the object store data:
var OSDATA = "osdata";



(:background)
class glucose_datafieldApp extends App.AppBase {
	

    function initialize() {
        AppBase.initialize();
      
        Sys.println("AppBase initialized");
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        Background.deleteTemporalEvent();
        return false;
    }

    // Return the initial view of your application here
    function getInitialView() {
    	//Register for temporal events if they are supported:
    	if(Toybox.System has :ServiceDelegate) {
    		canDoBG=true;
    		Background.registerForTemporalEvent(new Time.Duration(5*60));
    		Sys.println("System has bgs support. Registered for events every 5 minutes. This is maximum period.");
    	} else {
    		Sys.println("****background not available on this device****");
    	}
        return [ new glucose_datafieldView() ];
    }
    
    //Receive the data from the temporal event:
    function onBackgroundData(data){
    	sgvData=data;
    	mFitContributor.compute(sgvData);
    	Sys.println("onBackgroundData: Background data received: " + data);
        App.getApp().setProperty(OSDATA,sgvData);
        Ui.requestUpdate();
    }
    
    
    //Delegate what happens when the temporal event occurs:	
    function getServiceDelegate(){
    	Sys.println("getServiceDelegate");
    	return [new BgbgServiceDelegate()];
    }	
    
 }   
