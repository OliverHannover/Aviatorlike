using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as ActMonitor;

//develop
class AviatorlikeView extends Ui.WatchFace{


		hidden var font1;
	    hidden var fontDigital;
	    hidden var fontLabel;
	    
	    var isAwake;
	    var screenShape;
	    
	    hidden var clockTime;
	    
	  	hidden var width;
	    hidden var height;  
	  	// the x coordinate for the center
	    hidden var center_x;
	    // the y coordinate for the center
	    hidden var center_y;     

		//Variablen für die digitale Uhr
		var ampmStr = "am";
		var timeStr;		
		var Use24hFormat;
		var dualtime = false;
		var dualtimeTZ = 0;
		var dualtimeDST = 0;
		
		//variables for secondary displays	
		//altitude
		var altitudeStr;
		var altUnit; 

		//Battery
		var BatteryStr;
	
		//sunset sunrise	
		hidden var sunset_sunrise;
		//hidden var sunrise;
		//hidden var sunset;
		hidden var lastLoc;
		hidden var sunsetStr;
	
	//var moon;

	var upperDisplay, lowerDisplay;	
		

    function initialize() {
        WatchFace.initialize();
        screenShape = Sys.getDeviceSettings().screenShape;
                  
        Sys.println("Screenshape = " + screenShape);
             
        
    }
   
    
    function onLayout(dc) { 
    	setLayout(Rez.Layouts.WatchFace(dc));
    
    	width = dc.getWidth();
        height = dc.getHeight();
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2; 
          
    	font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
        //font1 = Gfx.FONT_SYSTEM_NUMBER_SMALL;
        fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital);
        fontLabel = Ui.loadResource(Rez.Fonts.id_font_label);        
        
    }

   

    // Draw the hash mark symbols on the watch-------------------------------------------------------
    function drawHashMarks(dc) {

            var n;      
        	var alpha, r1, r2;

        	//alle 5 minutes
            dc.setPenWidth(3);
            dc.setColor(App.getApp().getProperty("MinutesColor"), Gfx.COLOR_TRANSPARENT);
           	r1 = width/2 -5; //inside
			r2 = width/2 ; //outside
           	for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute 			
				dc.drawLine(center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha), center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)); 

     		}
        
        	//alle 5 minutes
            dc.setPenWidth(3);
            dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
           	r1 = width/2 -20; //inside
			r2 = width/2 ; //outside
           	//for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
         	for (var alpha = Math.PI / 6; alpha <= 11 * Math.PI / 6; alpha += (Math.PI / 3)) { //jede 5. Minute  			
				dc.drawLine(center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha), center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)); 
				alpha += Math.PI / 6;  
				dc.drawLine(center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha), center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha));    	
     		}      
 
    }
 
 
    
    function drawQuarterHashmarks(dc){          
      //12, 3, 6, 9
      var NbrFont = (App.getApp().getProperty("Numbers"));
      
       if ( NbrFont == 0) { //no number	  		
			var n;      
        	var r1, r2, marks, thicknes;      	
        	var outerRad = 0;
        	var lenth=20;
        	if (screenShape == 1) {  //semi round 
        		lenth = 20;
        	}
        	if (screenShape == 2) {  //semi round 
        		lenth = 30;
        	}	
        	
        	var thick = 5;
        	thicknes = thick * 0.02;
           	for (var alpha = Math.PI / 2; alpha <= 13 * Math.PI / 2; alpha += (Math.PI / 2)) { //jede 15. Minute    
			r1 = (width/2 + 3) - outerRad; //outside
			r2 = r1 -lenth; //inside			
							
			marks =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha-thicknes),center_y-r2*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha+thicknes),center_y-r2*Math.cos(alpha+thicknes)],
						[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
			
			dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);		
			dc.fillPolygon(marks);
			
			dc.setPenWidth(1);
			dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT); 
			dc.drawLine(center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha), center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha));
			    		
			}
		}	
		else {	
	        var r1 = width/2 -5; //inside
			var r2 = width/2 ; //outside
		   	dc.setPenWidth(8);       
            dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
            for (var alpha = Math.PI / 2; alpha <= 13 * Math.PI / 2; alpha += (Math.PI / 2)) {
				dc.drawLine(center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha), center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha));                
             }
         }
    } 

 

         
  
  function drawDigitalTime(dc) {

  		var now = Time.now();
  
 	  		
			dualtimeTZ = (App.getApp().getProperty("DualTimeTZ"));
			dualtimeDST = (App.getApp().getProperty("DualTimeDST"));
			
			clockTime = Sys.getClockTime();
	 
			
			var dthour;
			var dtmin;
			var dtnow = now;
			// adjust to UTC/GMT
			dtnow = dtnow.add(new Time.Duration(-clockTime.timeZoneOffset));
			// adjust to time zone
			dtnow = dtnow.add(new Time.Duration(dualtimeTZ));
			
			
			
			if (dualtimeDST != 0) {
				// calculate Daylight Savings Time (DST)
				var dtDST;
				if (dualtimeDST == -1) {
					// Use the current dst value
					dtDST = clockTime.dst;
				} else {
					// Use the configured DST value
					dtDST = dualtimeDST; 
				}
				// adjust DST
				dtnow = dtnow.add(new Time.Duration(dtDST));
			}

			// create a time info object
			var dtinfo = Calendar.info(dtnow, Time.FORMAT_LONG);
			
			dthour = dtinfo.hour;
			dtmin = dtinfo.min;
			
			var use24hclock;
			//var ampmStr = "am ";
			
			use24hclock = Sys.getDeviceSettings().is24Hour;
			if (!use24hclock) {
				if (dthour >= 12) {
					ampmStr = "pm ";
				}
				if (dthour > 12) {
					dthour = dthour - 12;				
				} else if (dthour == 0) {
					dthour = 12;
					ampmStr = "am ";
				}
			}			
			
			if (dthour < 10) {
				timeStr = Lang.format(" 0$1$:", [dthour]);
			} else {
				timeStr = Lang.format(" $1$:", [dthour]);
			}
			if (dtmin < 10) {
				timeStr = timeStr + Lang.format("0$1$ ", [dtmin]);
			} else {
				timeStr = timeStr + Lang.format("$1$ ", [dtmin]);
			}
  	
 	    		 
  
  
  }//End of drawDigitalTime(dc)-------


	function drawAltitude(dc) {
			
			var unknownaltitude = true;
			var actaltitude = 0;
			var actInfo;
			var metric = Sys.getDeviceSettings().elevationUnits == Sys.UNIT_METRIC;
			altUnit = "Alt m";
						
			actInfo = Act.getActivityInfo();
			if (actInfo != null) {
			
				if (metric) {				
				altUnit = "m";
				actaltitude = actInfo.altitude;
				} else {
				altUnit = "ft";
				actaltitude = actInfo.altitude  * 3.28084;
				}
			
			
				if (actaltitude != null) {
					unknownaltitude = false;
				} 				
			}			
							
			if (unknownaltitude) {
				altitudeStr = Lang.format("unknown");
			} else {
				altitudeStr = Lang.format("$1$", [actaltitude.toLong()]);
			}
			
       		//dc.drawText(width / 2, (height / 10 * 6.9), fontDigital, altitudeStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
	
	
function drawBattery(dc) {
	// Draw battery -------------------------------------------------------------------------
		
		var Battery = Toybox.System.getSystemStats().battery;       
        
        var alpha, hand;
        alpha = 0; 
        
        if (screenShape == 1) {  //round 
        alpha = 2*Math.PI/100*(Battery); 
		}		
		if (screenShape == 2) {  //semi round
        alpha = (Math.PI-1)/100*(Battery)+Math.PI+0.5;
		}
						
			var r1, r2;      	
        	var outerRad = 0;
        	var lenth = 15;
     
			r1 = width/2 - outerRad; //outside
			r2 = r1 -lenth; ////Länge des Bat-Zeigers
										
			hand =     [[center_x+r1*Math.sin(alpha+0.1),center_y-r1*Math.cos(alpha+0.1)],
						[center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha-0.1),center_y-r1*Math.cos(alpha-0.1)]   ];				
						
											
						

        if (Battery >= 25) {
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        }
        if (Battery < 25) {
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        }
		if (Battery >= 50) {
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        }
		dc.fillPolygon(hand);
		
		dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        var n;
		for (n=0; n<2; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);		
	}
	
	
	//StepGoal progress-------------------------------
 	function drawStepGoal(dc) {
              
        var actsteps = 0;
        var stepGoal = 0;		
		
		stepGoal = ActMonitor.getInfo().stepGoal;
		actsteps = ActMonitor.getInfo().steps;
		var stepPercent = 100 * actsteps / stepGoal;
        
        //dc.drawText(width / 2, (height / 4 * 3), fontDigital, stepGoal, Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 2, (height / 5), fontDigital, stepPercent, Gfx.TEXT_JUSTIFY_CENTER);
       
       	if (stepPercent >= 100) {
       		stepPercent = 100;
       	} 
       	
       	if (stepPercent > 95) {
       		dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_TRANSPARENT);
       	}
       	if (stepPercent <= 95) {
       		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
       	}
       	if (stepPercent < 70 ) {
       		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
       	}
       	if (stepPercent < 29) {
       		dc.setColor(Gfx.COLOR_ORANGE , Gfx.COLOR_TRANSPARENT);
       	}
       	if (stepPercent < 5) {
       		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
       	}
       	
       	    
              
        var alpha, hand;
        alpha = 0; 
        
        if (screenShape == 1) {  //1=round 
        alpha = 2*Math.PI/100*(stepPercent);
		}		
		if (screenShape == 2) {  //2=semi round
        //alpha = (Math.PI-1)/100*(Battery)+Math.PI+0.5;
        alpha = (Math.PI-0.5)-(Math.PI-1)/100*(stepPercent);
		}
         
	
			var r1, r2;      	
        	var outerRad = 0;
        	var lenth = 15;
     
			r1 = width/2 - outerRad; //outside
			r2 = r1 -lenth; ////Länge des Step-Zeigers
										
			hand =     [[center_x+r2*Math.sin(alpha+0.1),center_y-r2*Math.cos(alpha+0.1)],
						[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
						[center_x+r2*Math.sin(alpha-0.1),center_y-r2*Math.cos(alpha-0.1)]   ];					
		
       if (stepPercent < 100) {       
					
			dc.fillPolygon(hand);			
			dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
	        dc.setPenWidth(1);
	        var n;
			for (n=0; n<2; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
		}
		
 	}


     function getMoment(now,what) {
		return SunCalc.calculate(now, lastLoc[0], lastLoc[1], what);
	}

	function momentToString(moment) {

		if (moment == null) {
			return "--:--";
		}

   		var tinfo = Time.Gregorian.info(new Time.Moment(moment.value() + 30), Time.FORMAT_SHORT);
		var text;
		if (Sys.getDeviceSettings().is24Hour) {
			text = tinfo.hour.format("%02d") + ":" + tinfo.min.format("%02d");
		} else {
			var hour = tinfo.hour % 12;
			if (hour == 0) {
				hour = 12;
			}
			text = hour.format("%02d") + ":" + tinfo.min.format("%02d");
			
		//	if (tinfo.hour < 12 || tinfo.hour == 24) {
		//		text = text + " AM";
		//	} else {
		//		text = text + " PM";
		//	}
		}

		return text;
	}
 
 
 
	function builSunsetStr(dc) {

			var moment = Time.now();
	        var info_date = Calendar.info(moment, Time.FORMAT_LONG);
	        var actInfo = Act.getActivityInfo();       
	        
	        //sunset or sunrise       
	        if(actInfo.currentLocation!=null){
	    		lastLoc = actInfo.currentLocation.toRadians();
	    		var sunrise_moment = getMoment(moment,SUNRISE);
	    		var sunset_moment = getMoment(moment,SUNSET);
				var sunrise = momentToString(sunrise_moment);
				var sunset = momentToString(sunset_moment);
				
				if(moment.greaterThan(sunset_moment) || moment.lessThan(sunrise_moment)){
    				sunsetStr =  sunrise + "/" + sunset;
    			}else{
    				sunsetStr =  sunset + "/" + sunrise;
    			}				
	    	}else{
	    		sunsetStr = Ui.loadResource(Rez.Strings.none);
	    	}
	    	
	    	//sunsetStr =  sunrise + "/" + sunset;
	    	//dc.drawText(width/2, height / 10 * 6, Gfx.FONT_SMALL, sunrise + " / " + sunset, Gfx.TEXT_JUSTIFY_CENTER);	
	
	}	

	

// Handle the update event-----------------------------------------------------------------------
    function onUpdate(dc) {
    
   	//Sys.println("width = " + width);
	//Sys.println("height = " + height); 
          
        
  // Clear the screen--------------------------------------------
        //dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT));
        dc.setColor(Gfx.COLOR_TRANSPARENT, App.getApp().getProperty("BackgroundColor"));
        dc.clear();
                
        
   // Draw the hash marks ---------------------------------------------------------------------------
        drawHashMarks(dc);  
        drawQuarterHashmarks(dc);  
    
//    if (screenShape == 1) {           
//   		extras.drawMoon(dc);
//		}

//Draw Digital Elements ------------------------------------------------------------------ 

         var digiFont = (App.getApp().getProperty("DigiFont")); 
         //Sys.println("digiFont="+ digiFont);
         fontDigital = null;
         
    	//font for display
	    if ( digiFont == 1) { //!digital
	    	fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital); 
	    	//fontDigital = Gfx.FONT_SYSTEM_MEDIUM ;
	    	//Sys.println("set digital");    
	    	}
	    if ( digiFont == 2) { //!classik
        	fontDigital = Ui.loadResource(Rez.Fonts.id_font_classicklein); 
        	//fontDigital = Gfx.FONT_SYSTEM_MEDIUM ;
        	//Sys.println("set classic");     
	    	}
	    if ( digiFont == 3) { //!simple
	    	if (screenShape == 1) {  // round 
        		fontDigital = Gfx.FONT_SYSTEM_SMALL ; 
        	}
        	if (screenShape == 2) {  // semi round 
        		fontDigital = Gfx.FONT_SYSTEM_MEDIUM ; 
        	}      	    
	    }



   		
   	
	    var UpperDispEnable = (App.getApp().getProperty("UpperDispEnable"));
	    var LowerDispEnable = (App.getApp().getProperty("LowerDispEnable"));
	    
	   //upper display 	
		if (UpperDispEnable) {
			upperDisplay = new Rez.Drawables.upperDisplay();
			var UDInfo = (App.getApp().getProperty("UDInfo"));
			
			//background for upper display
			dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);
			upperDisplay.draw(dc);		
	      	      	 
	        dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
	        var UpperLabel = View.findDrawableById("UpperLabel");
	        UpperLabel.setFont(fontDigital);
	        UpperLabel.setColor(App.getApp().getProperty("ForegroundColor"));
	        
	        var UpperLabelobereZeile = View.findDrawableById("UpperLabelobereZeile");
	        UpperLabelobereZeile.setFont(fontLabel);
	        UpperLabelobereZeile.setColor(App.getApp().getProperty("ForegroundColor"));
	        
	    //    var UpperLabeluntereZeile = View.findDrawableById("UpperLabeluntereZeile");
	    //    UpperLabeluntereZeile.setFont(fontLabel);
	    //    UpperLabeluntereZeile.setColor(App.getApp().getProperty("ForegroundColor"));
        	    	
	 		//Draw date---------------------------------
		   	if (UDInfo == 1) {
		   		date.buildDateString(dc);
		   		UpperLabel.setText(date.dateStr); 
		   		UpperLabel.draw( dc );		   		      
			}	
	
	 	    //Draw Steps --------------------------------------
	      	if (UDInfo == 2) {		
				var stepGoal =  Lang.format("$1$", [ActMonitor.getInfo().stepGoal]);
		        var stepsStr = Lang.format("$1$", [ActMonitor.getInfo().steps]); 		   		
		        UpperLabel.setText(stepsStr);
		        //UpperLabel.setJustification(Gfx.TEXT_JUSTIFY_RIGHT);
		   		UpperLabel.draw( dc ); 
		   		UpperLabelobereZeile.setText(stepGoal); 
		   		UpperLabelobereZeile.draw( dc );
		   		//UpperLabeluntereZeile.setText("steps"); 
		   		//UpperLabeluntereZeile.draw( dc ); 			
			}
			
			//Draw Steps to go --------------------------------------
	      	if (UDInfo == 3) {
	        var actsteps = 0;
	        var stepGoal = 0;
	        var stepstogo = 0;		
			stepGoal = ActMonitor.getInfo().stepGoal;
			actsteps = ActMonitor.getInfo().steps;
			
		        if (actsteps <= stepGoal) {
			        stepstogo = "- " + (stepGoal - actsteps);
			    }
			    if (actsteps > stepGoal) {
			        stepstogo = "+ " + (actsteps - stepGoal);
			    }    			        
			        stepstogo = Lang.format("$1$", [stepstogo]); 			        
				    UpperLabel.setText(stepstogo);
			   		UpperLabel.draw( dc ); 				        			              
			}
				 

	 		//Draw DigitalTime---------------------------------
		   	if (UDInfo == 4) {
			 drawDigitalTime(dc);
			 UpperLabel.setText(timeStr);
			 UpperLabel.draw( dc );

				 if (!Sys.getDeviceSettings().is24Hour) {
				 	UpperLabelobereZeile.setText(ampmStr); 
				   	UpperLabelobereZeile.draw( dc );
				} 
			}	         
	        
	    	// Draw Altitude------------------------------
			if (UDInfo == 5) {
				drawAltitude(dc);
				UpperLabel.setText(altitudeStr);
		   		UpperLabel.draw( dc ); 
		   		UpperLabelobereZeile.setText(altUnit); 
		   		UpperLabelobereZeile.draw( dc );
		   		//UpperLabeluntereZeile.setText("Alt"); 
		   		//UpperLabeluntereZeile.draw( dc );
			 }	
				
			// Draw Calories------------------------------
			if (UDInfo == 6) {	
			var actInfo = ActMonitor.getInfo(); 
	        var actcals = actInfo.calories;		       
	        var calStr = Lang.format(" $1$ kCal ", [actcals]);
	        UpperLabel.setText(calStr);
		   	UpperLabel.draw( dc );	
			}
			
			//Draw distance
			if (UDInfo == 7) {
				distance.drawDistance(dc);
				UpperLabel.setText(distance.distStr);
		   		UpperLabel.draw( dc ); 
		   		UpperLabelobereZeile.setText(distance.distUnit); 
		   		UpperLabelobereZeile.draw( dc );
		   		//UpperLabeluntereZeile.setText("Dist"); 
		   		//UpperLabeluntereZeile.draw( dc );
			}			
			
			//Draw battery
			if (UDInfo == 8) {
				var Battery = Toybox.System.getSystemStats().battery;       
        	    BatteryStr = Lang.format("$1$ % ", [ Battery.format ( "%2d" ) ] );
        	    UpperLabel.setText(BatteryStr);
		   		UpperLabel.draw( dc );
		   		//UpperLabeluntereZeile.setText("Bat"); 
		   		//UpperLabeluntereZeile.draw( dc );
			}
			
			//Draw Day an d week of year
			if (UDInfo == 9) {
				date.builddayWeekStr();	
				UpperLabel.setText(date.dayWeekStr);
		   		UpperLabel.draw( dc ); 

			}
			
			//next / over next sun event
			if (UDInfo == 10) {
				builSunsetStr(dc);				
				UpperLabel.setText(sunsetStr);
		   		UpperLabel.draw( dc );		
		    }
			
			
			
		}	
	
	
			
	 //Anzeige unteres Display--------------------------  
		if (LowerDispEnable) {
			lowerDisplay = new Rez.Drawables.lowerDisplay();
			var LDInfo = (App.getApp().getProperty("LDInfo"));
			
			//background for lower display
			dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);
			lowerDisplay.draw(dc);		
	      	      	 
	        dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
	        var LowerLabel = View.findDrawableById("LowerLabel");
	        LowerLabel.setFont(fontDigital);
	        LowerLabel.setColor(App.getApp().getProperty("ForegroundColor"));
	        
	        var LowerLabelobereZeile = View.findDrawableById("LowerLabelobereZeile");
	        LowerLabelobereZeile.setFont(fontLabel);
	        LowerLabelobereZeile.setColor(App.getApp().getProperty("ForegroundColor"));
	        
	  //      var LowerLabeluntereZeile = View.findDrawableById("LowerLabeluntereZeile");
	  //      LowerLabeluntereZeile.setFont(fontLabel);
	  //      LowerLabeluntereZeile.setColor(App.getApp().getProperty("ForegroundColor"));
	  
	  
	  	   if (LDInfo == 1) {
				date.buildDateString(dc);        
				LowerLabel.setText(date.dateStr); 
		   		LowerLabel.draw( dc );	 
			}	
	
	 	    //Draw Steps --------------------------------------
	      	if (LDInfo == 2) {
				var stepGoal =  Lang.format("$1$", [ActMonitor.getInfo().stepGoal]);
		        var stepsStr = Lang.format("$1$", [ActMonitor.getInfo().steps]); 
	        	LowerLabel.setText(stepsStr);
	        	//UpperLabel.setJustification(Gfx.TEXT_JUSTIFY_RIGHT);
	   			LowerLabel.draw( dc ); 
	   			LowerLabelobereZeile.setText(stepGoal); 
	   			LowerLabelobereZeile.draw( dc );
	   			//UpperLabeluntereZeile.setText("steps"); 
	   			//UpperLabeluntereZeile.draw( dc );
			}
			
			//Draw Steps to go --------------------------------------
	      	if (LDInfo == 3) {
	        var actsteps = 0;
	        var stepGoal = 0;
	        var stepstogo = 0;		
			stepGoal = ActMonitor.getInfo().stepGoal;
			actsteps = ActMonitor.getInfo().steps;
			
		        if (actsteps <= stepGoal) {
			        stepstogo = "- " + (stepGoal - actsteps);
			    }
			    if (actsteps > stepGoal) {
			        stepstogo = "+ " + (actsteps - stepGoal);
			    }    			        
			        stepstogo = Lang.format("$1$", [stepstogo]); 			        
				    LowerLabel.setText(stepstogo);
			   		LowerLabel.draw( dc ); 				        			              
			}
			
	 		//Draw DigitalTime---------------------------------
		   	if (LDInfo == 4) {
			 	drawDigitalTime(dc);
			 	LowerLabel.setText(timeStr);
			 	LowerLabel.draw( dc );

				 if (!Sys.getDeviceSettings().is24Hour) {
				 	LowerLabelobereZeile.setText(ampmStr); 
				   	LowerLabelobereZeile.draw( dc );
				} 
			}
			
						// Draw Altitude------------------------------
			if (LDInfo == 5) {
				drawAltitude(dc);
				LowerLabel.setText(altitudeStr);
		   		LowerLabel.draw( dc ); 
		   		LowerLabelobereZeile.setText(altUnit); 
		   		LowerLabelobereZeile.draw( dc );
		   		//LowerLabeluntereZeile.setText("Alt"); 
		   		//LowerLabeluntereZeile.draw( dc );
			 }	
				
			// Draw Calories------------------------------
			if (LDInfo == 6) {	
				var actInfo = ActMonitor.getInfo(); 
		        var actcals = actInfo.calories;		       
		        var calStr = Lang.format(" $1$ kCal ", [actcals]);
		        LowerLabel.setText(calStr);
			   	LowerLabel.draw( dc );		
			}
			
						//Draw distance
			if (LDInfo == 7) {
				distance.drawDistance(dc);
				LowerLabel.setText(distance.distStr);
		   		LowerLabel.draw( dc ); 
		   		LowerLabelobereZeile.setText(distance.distUnit); 
		   		LowerLabelobereZeile.draw( dc );
		   		//LowerLabeluntereZeile.setText("Dist"); 
		   		//LowerLabeluntereZeile.draw( dc );
			}
			
			//Draw battery
			if (LDInfo == 8) {
				var Battery = Toybox.System.getSystemStats().battery;       
        	    BatteryStr = Lang.format("$1$ % ", [ Battery.format ( "%2d" ) ] );
        	    LowerLabel.setText(BatteryStr);
		   		LowerLabel.draw( dc );
		   		//LowerLabeluntereZeile.setText("Bat"); 
		   		//LowerLabeluntereZeile.draw( dc );
			}

		    //Draw Day an d week of year
			if (LDInfo == 9) {
				date.builddayWeekStr();	
				LowerLabel.setText(date.dayWeekStr);
		   		LowerLabel.draw( dc ); 
		    }
			
			//Draw Day an d week of year
			if (LDInfo == 10) {
				builSunsetStr(dc);				
				LowerLabel.setText(sunsetStr);
		   		LowerLabel.draw( dc );
		    }
			
	  
	  }
		
			
		//!progress battery------------
		var BatProgressEnable = (App.getApp().getProperty("BatProgressEnable"));
       	if (BatProgressEnable) {
			drawBattery(dc);
		}
		//!progress steps--------------
		var StepProgressEnable = (App.getApp().getProperty("StepProgressEnable"));
       	if (StepProgressEnable) {
			drawStepGoal(dc);
		}
		//! Markers for sunrire and sunset
		var SunmarkersEnable = (App.getApp().getProperty("SunMarkersEnable"));		
       	if (SunmarkersEnable && screenShape == 1) {
       		//Sys.println("sunmarkers "+ SunmarkersEnable);
			extras.drawSunMarkers(dc);
		}
		
		

      // Draw the numbers --------------------------------------------------------------------------------------
       var NbrFont = (App.getApp().getProperty("Numbers")); 
       dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
       font1 = null;  
       
       if (screenShape == 1) {  // round     
		    if ( NbrFont == 1) { //fat
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
		    		dc.drawText((width / 2), 5, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 54, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		    if ( NbrFont == 2) { //race
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_race);
		    		dc.drawText((width / 2), 5, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 52, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		    if ( NbrFont == 3) { //classic
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_classic);
		    		dc.drawText((width / 2), 15, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 18, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 48, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 18, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		   if ( NbrFont == 4) {  //roman
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_roman);
		    		dc.drawText((width / 2), 7, font1, "}", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 22, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 50, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 22, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
		   	if ( NbrFont == 5) {  //simple
		    		dc.drawText((width / 2), 10, Gfx.FONT_SYSTEM_LARGE   , "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 22, Gfx.FONT_SYSTEM_LARGE  , "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 45, Gfx.FONT_SYSTEM_LARGE   , "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 22, Gfx.FONT_SYSTEM_LARGE   , "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
	   	}
       
       
       if (screenShape == 2) {  //semi round     
		    if ( NbrFont == 1) { //fat
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
		    		dc.drawText((width / 2), -12, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 41, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		    if ( NbrFont == 2) { //race
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_race);
		    		dc.drawText((width / 2), -12, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 39, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		    if ( NbrFont == 3) { //classic
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_classic);
		    		dc.drawText((width / 2), 0, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 18, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 33, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 18, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		   if ( NbrFont == 4) {  //roman
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_roman);
		    		dc.drawText((width / 2), -4, font1, "}", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 22, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 40, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 22, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
		   	if ( NbrFont == 5) {  //simple
		    		dc.drawText((width / 2), -3, Gfx.FONT_SYSTEM_LARGE   , "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		dc.drawText(width - 16, (height / 2) - 17, Gfx.FONT_SYSTEM_LARGE  , "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		dc.drawText(width / 2, height - 30, Gfx.FONT_SYSTEM_LARGE   , "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 17, Gfx.FONT_SYSTEM_LARGE   , "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
	   	}
	   		
	   	
//Indicators-------------------------------------------------------------	
	  //messages 	
     	var messages = Sys.getDeviceSettings().notificationCount;     	
     	if (messages > 0) {
     		dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        	dc.fillCircle(width / 2 + 30, height / 2 -7, 5);
     	}
     	dc.setPenWidth(2);
        dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(width / 2 + 30, height / 2 -7, 5);
        dc.drawText(width / 2 + 30, height / 2 -2, fontLabel, "Msg", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 3 + 7, height / 2, fontLabel, messages, Gfx.TEXT_JUSTIFY_CENTER); 
      
	  //Alarm is set 	
     	var alarm = Sys.getDeviceSettings().alarmCount;     	
     	if (alarm > 0) {
     		dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        	dc.fillCircle(width / 2 - 30, height / 2 -7, 5);
     	}
     	dc.setPenWidth(2);
        dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(width / 2 - 30, height / 2 -7, 5);
        dc.drawText(width / 2 - 30, height / 2 -2, fontLabel, "Alm", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 3 + 7, height / 2, fontLabel, messages, Gfx.TEXT_JUSTIFY_CENTER); 
       

  // Draw hands ------------------------------------------------------------------         
     	hands.drawHands(dc); 
      
       if (isAwake) {
       var SecHandEnable = (App.getApp().getProperty("SecHandEnable"));
       if (SecHandEnable) {
     		hands.drawSecondHands(dc);
     	}
      }
          
}
    
   

    function onEnterSleep() {
        isAwake = false;
        Ui.requestUpdate();
    }

    function onExitSleep() {
        isAwake = true;
    }
}
