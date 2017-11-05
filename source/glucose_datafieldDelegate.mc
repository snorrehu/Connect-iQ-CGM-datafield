using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Time.Gregorian;


(:background)
class RequestListener extends Comm.ConnectionListener {
	private const TAG = "RequestListener";
	
    function initialize() {
    	Sys.println(TAG + "->initialize");
    	
    	Sys.println("CommListener:");
    	ConnectionListener.initialize();
    }
        
	function onComplete() {
		Sys.println(TAG + "->onComplete");
        Sys.println( "Request sendt" );
    }

    function onError() {
    	Sys.println(TAG + "->onError");
        Sys.println( "Request Failed" );
    }
   
}


(:background)
class BgbgServiceDelegate extends Toybox.System.ServiceDelegate {
	private const TAG = "BgbgServiceDelegate";
	
	function initialize(){
		Sys.println(TAG + "->initialize");
		
		ServiceDelegate.initialize();	
		Sys.println("BgbgServiceDelegate initialized.");  	
	}
	
	
	function onTemporalEvent() {
		Sys.println(TAG + "-> onTemporalEvent");
		var listener = new RequestListener();
		Comm.emptyMailbox();
		Sys.println("Setting mailboxlistener");	
    	Comm.setMailboxListener(method(:onMail));
    	Sys.println("Mailboxlistener ready");
    	Comm.transmit(0,null,listener);
        
    }
    
    function onMail(mailIter) {   
	    var mail = mailIter.next();  
		Sys.println(TAG + "-> onMail: Mail received: " + mail);
	    Background.exit(mail);
    }
}


