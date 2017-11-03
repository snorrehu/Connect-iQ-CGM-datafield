using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Time.Gregorian;


(:background)
class RequestListener extends Comm.ConnectionListener {

    function initialize() {
    	Sys.println("CommListener:");
    	ConnectionListener.initialize();
    }
        
	function onComplete() {
        Sys.println( "Request sendt" );
    }

    function onError() {
        Sys.println( "Request Failed" );
    }
   
}


(:background)
class BgbgServiceDelegate extends Toybox.System.ServiceDelegate {
	function initialize(){
		ServiceDelegate.initialize();	
		Sys.println("BgbgServiceDelegate initialized.");  	
	}
	
	
	function onTemporalEvent() {
		var listener = new RequestListener();
		Comm.emptyMailbox();
		Sys.println("Setting mailboxlistener");	
    	Comm.setMailboxListener(method(:onMail));
    	Sys.println("Mailboxlistener ready");
    	Comm.transmit(0,null,listener);
        
    }
    
    function onMail(mailIter) {   
	    var mail = mailIter.next();  
		Sys.println("Mail received: " + mail);
	    Background.exit(mail);
    }
}


