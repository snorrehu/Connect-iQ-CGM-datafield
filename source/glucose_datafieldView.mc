using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.FitContributor as fit;


var mFitContributor;

var sgvString = null;

class glucose_datafieldView extends Ui.SimpleDataField {
	

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        
        //------------------------FIT-----------------------
        
        mFitContributor = new SGVFitContributor(self);
        //--------------------------------------------------
        Sys.println("FIT contributor initialized");
        label = "Blood glucose";
        Sys.println("label initialized.");
    }
    
    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
    	
        // See Activity.Info in the documentation for available information.
        //Returns the value to be displayed in the datafield
        if(sgvData != null){
        	sgvString = sgvData + "mmol/l";
        }
        return sgvString;
    }
    
    function onTimerStart() {
		Sys.println("Activity started.");
        mFitContributor.setTimerRunning( true );
    }

    function onTimerStop() {
    	Sys.println("Activity stopped.");
        mFitContributor.setTimerRunning( false );
    }

    function onTimerPause() {
    	Sys.println("Activity paused.");
        mFitContributor.setTimerRunning( false );
    }

    function onTimerResume() {
    	Sys.println("Activity resumed.");
        mFitContributor.setTimerRunning( true );
    }

    function onTimerLap() {
    	Sys.println("Activity lap.");
        mFitContributor.onTimerLap();
    }

    function onTimerReset() {
    	Sys.println("Activity reset.");
        mFitContributor.onTimerReset();
    }
    
}