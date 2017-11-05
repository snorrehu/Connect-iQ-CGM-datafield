using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.FitContributor as fit;


var mFitContributor;

var sgvString;

class glucose_datafieldView extends Ui.SimpleDataField {
	private const TAG = "glucose_datafieldView";
    // Set the label of the data field here.
    function initialize() {
    	Sys.println(TAG + "->initialize");
        SimpleDataField.initialize();
        
        //------------------------FIT-----------------------
        
        mFitContributor = new SGVFitContributor(self);
        //--------------------------------------------------
        Sys.println("FIT contributor initialized");
        label = "Blood glucose";
        App.getApp().setProperty(OSDATA, null);
    }
    
   
    function compute(info) {
    	Sys.println(TAG + "-> compute");
    
        //Returns the value to be displayed in the datafield
    	//Check the flag:
    	var tempFlag = App.getApp().getProperty(FLAG);
    	Sys.println("-> compute: tempFlag = " + tempFlag);
    	//Read object store:
    	var tempSgv = App.getApp().getProperty(OSDATA);
        Sys.println("-> compute: tempSgv = " + tempSgv);
        mFitContributor.compute("6.54");
        if(tempFlag){
        	sgvString = tempSgv + "mmol/l";
        	
        	//Reset the flag:
        	App.getApp().setProperty(FLAG,false);
        }
     	
        return sgvString;
    }
    
    function onTimerStart() {
		Sys.println(TAG + "-> onTimerStart.");
        mFitContributor.setTimerRunning( true );
    }

    function onTimerStop() {
    	Sys.println(TAG + "-> onTimerStop.");
        mFitContributor.setTimerRunning( false );
    }

    function onTimerPause() {
    	Sys.println(TAG + "-> onTimerPause.");
        mFitContributor.setTimerRunning( false );
    }

    function onTimerResume() {
    	Sys.println(TAG + "-> onTimerResume.");
        mFitContributor.setTimerRunning( true );
    }

    function onTimerLap() {
    	Sys.println(TAG + "-> onTimerLap.");
        mFitContributor.onTimerLap();
    }

    function onTimerReset() {
    	Sys.println(TAG + "-> onTimerReset.");
        mFitContributor.onTimerReset();
    }
    
}