using Toybox.Time as Time;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
//using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.Math as Math;
using Toybox.Graphics as Gfx;
//using Toybox.System as Sys;


module extras{

	var lastLoc;
		
     function getMoment(now,what) {
		return SunCalc.calculate(now, lastLoc[0], lastLoc[1], what);
	}		

 function drawSunMarkers(dc) {
	// Draw Sunset / sunrise markers -------------------------------------------------------------------------
        
        var alphaSunrise = 0;
        var alphaSunset = 0;
        var hand; 
        
		var moment = Time.now();
	    var info_date = Calendar.info(moment, Time.FORMAT_LONG);
     	var actInfo = Act.getActivityInfo(); 
     	//var alms = new AviatorlikeView();   
     	var reverseMultiplier= App.getApp().getProperty("Reverse") ? -1 : 1 ;   
	        
      
		if(actInfo.currentLocation!=null){
    		lastLoc = actInfo.currentLocation.toRadians();
    		var sunrise_moment = getMoment(moment,SUNRISE);
    		var sunset_moment = getMoment(moment,SUNSET);
			
			var sunriseTinfo = Time.Gregorian.info(new Time.Moment(sunrise_moment.value() + 30), Time.FORMAT_SHORT);
			var sunsetTinfo = Time.Gregorian.info(new Time.Moment(sunset_moment.value() + 30), Time.FORMAT_SHORT);
   	       
    		alphaSunrise = Math.PI/6*(1.0*sunriseTinfo.hour+sunriseTinfo.min/60.0)*reverseMultiplier;
    		alphaSunset = Math.PI/6*(1.0*sunsetTinfo.hour+sunsetTinfo.min/60.0)*reverseMultiplier;
      
        	var r1, r2;      	
        	var outerRad = 0;
        	var lenth = 10;
        	var center_x = dc.getWidth() / 2;
        	var center_y = dc.getHeight() / 2;
     
			r1 = dc.getWidth()/2 - outerRad; //outside
			r2 = r1 -lenth; ////Länge des Bat-Zeigers
     
			dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);		
			dc.drawLine(center_x+r1*Math.sin(alphaSunrise),center_y-r1*Math.cos(alphaSunrise), center_x+r2*Math.sin(alphaSunrise),center_y-r2*Math.cos(alphaSunrise));		
			dc.drawLine(center_x+r1*Math.sin(alphaSunset),center_y-r1*Math.cos(alphaSunset), center_x+(r2-10)*Math.sin(alphaSunset),center_y-(r2-10)*Math.cos(alphaSunset));		
			
			dc.setPenWidth(1);
			dc.drawCircle(center_x+(r1-15)*Math.sin(alphaSunrise),center_y-(r1-15)*Math.cos(alphaSunrise),6);			
			dc.drawCircle(center_x+(r1-5)*Math.sin(alphaSunset),center_y-(r1-5)*Math.cos(alphaSunset),6);
			
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);	
			dc.fillCircle(center_x+(r1-15)*Math.sin(alphaSunrise),center_y-(r1-15)*Math.cos(alphaSunrise),5);	
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
			dc.fillCircle(center_x+(r1-5)*Math.sin(alphaSunset),center_y-(r1-5)*Math.cos(alphaSunset),5); 			      
		}			
	}
	




}