using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.FitContributor as Fit;

const CURRENT_SGV_FIELD_ID = 0;
const LAP_SGV_FIELD_ID = 1;
const AVG_SGV_FIELD_ID = 2;


class SGVFitContributor {

	// Variables for computing averages
    hidden var mSgvLapAverage = 0.0;
    hidden var mSgvSessionAverage = 0.0;
   
    hidden var mLapRecordCount = 0;
    hidden var mSessionRecordCount = 0;
    hidden var mTimerRunning = false;
    
    // FIT Contributions variables
    hidden var mCurrentSgvField = null;			//Instantaneous values
    hidden var mLapAverageSgvField = null;		//Lap average
    hidden var mSessionAverageSgvField = null;	//Session average

    // Constructor
    function initialize(dataField) {
    	
        mCurrentSgvField = dataField.createField("Current_SGV", CURRENT_SGV_FIELD_ID, Fit.DATA_TYPE_FLOAT, { :nativeNum=>54, :mesgType=>Fit.MESG_TYPE_RECORD, :units=>"mmol/l" });
        mLapAverageSgvField = dataField.createField("Lap_average_SGV", LAP_SGV_FIELD_ID, Fit.DATA_TYPE_FLOAT, { :nativeNum=>84, :mesgType=>Fit.MESG_TYPE_LAP, :units=>"mmol/l"});
        mSessionAverageSgvField = dataField.createField("Session_average_SGV", AVG_SGV_FIELD_ID, Fit.DATA_TYPE_FLOAT, { :nativeNum=>95, :mesgType=>Fit.MESG_TYPE_SESSION, :units=>"mmol/l"});

        mCurrentSgvField.setData(0.0);
        mLapAverageSgvField.setData(0.0);
        mSessionAverageSgvField.setData(0.0);
        
        Sys.println("FIT field initialized.");
	
		
    }

    function compute(sensor) {
        if( sgvData != null ) {
        	var sgv = sgvData.toFloat();
            mCurrentSgvField.setData(sgv);  
        	
            if( mTimerRunning ) {
                // Update lap/session data and record counts
                mLapRecordCount++;
                mSessionRecordCount++;
                mSgvLapAverage += sgv;
                mSgvSessionAverage += sgv;
                // Update lap/session FIT Contributions
                
                mLapAverageSgvField.setData(mSgvLapAverage/mLapRecordCount);
                mSessionAverageSgvField.setData(mSgvSessionAverage/mSessionRecordCount);
                
                Sys.println("FIT data recorded. SGV = "+sgv);
                Sys.println("Lap record count = "+mLapRecordCount);
                Sys.println("Sgv lap average= "+mSgvLapAverage/mLapRecordCount);
                Sys.println("Sgv session average = "+mSgvSessionAverage/mSessionRecordCount);
                
            }
        }
    }

   
    function setTimerRunning(state) {
        mTimerRunning = state;
    }

    function onTimerLap() {
        mLapRecordCount = 0;
        mSgvLapAverage = 0.0;
    }

    function onTimerReset() {
        mSessionRecordCount = 0;
        mSgvSessionAverage = 0.0;
    }

}