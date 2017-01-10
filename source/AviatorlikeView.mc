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


    var font1;
    var fontDigital;
    var isAwake;
    var screenShape;
    //var dndIcon;
    
    var clockTime;
    
  //Variablen für die analoge Uhr   
  // the x coordinate for the center
    var center_x;
    // the y coordinate for the center
    var center_y;     

	//Variablen für die digitale Uhr
		var timeStr;		
		var Use24hFormat;
		var dualtime = false;
		var dualtimeTZ = 0;
		var dualtimeDST = 0;
		
	//variables for secondary displays	
		//altitude
		var altitudeStr;
		var altUnit; 
		//distance
		var distStr;
		var distUnit;
		//Battery
		var BatteryStr;
		//date
		//var dateStr;
		
		

    function initialize() {
        WatchFace.initialize();
        screenShape = Sys.getDeviceSettings().screenShape; 
         
        Sys.println("Screenshape = " + screenShape);
             
        
    }
   
    
    function onLayout(dc) {    
    	font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
        //font1 = Gfx.FONT_SYSTEM_NUMBER_SMALL;
        fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital);        
        
    }

   

    // Draw the hash mark symbols on the watch-------------------------------------------------------
    function drawHashMarks(dc) {
    
        var width = dc.getWidth();
        var height = dc.getHeight();
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;

       //if (Sys.SCREEN_SHAPE_ROUND == screenShape) {

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
      var width = dc.getWidth();
      var height = dc.getHeight();
       center_x = dc.getWidth() / 2;
       center_y = dc.getHeight() / 2;
      
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
  
  		var width = dc.getWidth();
        var height  = dc.getHeight();
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
			var ampmStr = "am ";
			
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
			if (!use24hclock) {
				timeStr = timeStr + ampmStr; 
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
		var width = dc.getWidth();
        var height = dc.getHeight();
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
		
		var Battery = Toybox.System.getSystemStats().battery;       
        //BatteryStr = Lang.format("$1$ % ", [ Battery.format ( "%2d" ) ] );
      	//dc.drawText(width / 2, (height / 4 * 2.9), fontDigital, BatteryStr, Gfx.TEXT_JUSTIFY_CENTER);
        
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
 		var width = dc.getWidth();
        var height  = dc.getHeight();
 		//var outerRad = width / 2;
        //var innerRad = outerRad - 15; //Länge des Step-Zeigers               
        var actsteps = 0;
        var stepGoal = 0;		
		
		stepGoal = ActMonitor.getInfo().stepGoal;
		actsteps = ActMonitor.getInfo().steps;
		var stepPercent = 100 * actsteps / stepGoal;
        
        //dc.drawText(width / 2, (height / 4 * 3), fontDigital, stepGoal, Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 2, (height / 5), fontDigital, stepPercent, Gfx.TEXT_JUSTIFY_CENTER);
       
       dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
       if (stepPercent >= 100) {
       		stepPercent = 100;
       		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
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
			r2 = r1 -lenth; ////Länge des Bat-Zeigers
										
			hand =     [[center_x+r2*Math.sin(alpha+0.1),center_y-r2*Math.cos(alpha+0.1)],
						[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
						[center_x+r2*Math.sin(alpha-0.1),center_y-r2*Math.cos(alpha-0.1)]   ];					
		
					
		dc.fillPolygon(hand);
		
		dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        var n;
		for (n=0; n<2; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
 	}


 
	function drawDistance(dc) {
	// Draw Distance------------------------------  
			
			distStr = 0;
			//var highaltide = false;			
			var unknownDistance = true;
			var actDistance = 0;
			var actInfo;
			var metric = Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC;
			distUnit = "Dist km";
			
			actInfo = ActMonitor.getInfo();
			if (actInfo != null) {
			
				if (metric) {				
				distUnit = "km";
				actDistance = actInfo.distance * 0.00001;
				} else {
				distUnit = "mi";
				actDistance = actInfo.distance * 0.00001 * 0.621371;
				}
				
				//actDistance = actDistance.format("%2d");
				if (actDistance != null) {
					unknownDistance = false;
				} 				
			}
					
			if (unknownDistance) {
				distStr = Lang.format("Dst ?");
			} else {
				distStr = Lang.format("$1$", [actDistance.format("%.2f")] );
			}	
	
	} 
 


// Handle the update event-----------------------------------------------------------------------
    function onUpdate(dc) {
    
    
    
    
    var LDInfo = (App.getApp().getProperty("LDInfo"));
   	var UDInfo = (App.getApp().getProperty("UDInfo"));
        
        var width = dc.getWidth();
        var height  = dc.getHeight();   
        //Sys.println("width = " + width);
		//Sys.println("height = " + height);     
       
        
  // Clear the screen--------------------------------------------
        //dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT));
        dc.setColor(Gfx.COLOR_TRANSPARENT, App.getApp().getProperty("BackgroundColor"));
        dc.clear();
        
        
        
   // Draw the hash marks ---------------------------------------------------------------------------
        drawHashMarks(dc);  
        drawQuarterHashmarks(dc);      
  


//Draw Digital Elements ------------------------------------------------------------------ 

         var digiFont = (App.getApp().getProperty("DigiFont")); 
          
    	//font for display
	    if ( digiFont == 1) { //digital
	    	fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital);     
	    	}
	    if ( digiFont == 2) { //digital
        	fontDigital = Ui.loadResource(Rez.Fonts.id_font_classicklein);      
	    	}
	    if ( digiFont == 3) { //simple
	    	if (screenShape == 1) {  // round 
        		fontDigital = Gfx.FONT_SYSTEM_SMALL ; 
        	}
        	if (screenShape == 2) {  // semi round 
        		fontDigital = Gfx.FONT_SYSTEM_MEDIUM ; 
        	}      	    
	    }
	    	
	    //Texthöhen	
	    var UDnorText = 0;	
	    var UDobereZeile = 0;
	    var UDuntereZeile = 0;
	    
	    var LDnorText = 0;	
	    var LDobereZeile = 0;
	    var LDuntereZeile = 0;
	    
	    if (screenShape == 1) {  // round  	
	    	UDnorText = height / 10 * 2.7;
	    	UDobereZeile = height / 10 * 2.4;
	    	UDuntereZeile = height / 10 * 3;
	    	
	    	LDnorText = height / 10 * 6.8;
	    	LDobereZeile = height / 10 * 6.5;
	    	LDuntereZeile = height / 10 * 7.1;
	    }
	   	if (screenShape == 2) {  // semi round  	
	    	UDnorText = height / 10 * 2.3;
	    	UDobereZeile = height / 10 * 1.95;
	    	UDuntereZeile = height / 10 * 2.75;
	    	
	    	LDnorText = height / 10 * 6.4;
	    	LDobereZeile = height / 10 * 6.0;
	    	LDuntereZeile = height / 10 * 6.8;
	    	
	    }
	    
  		

         
	    
	    var UpperDispEnable = (App.getApp().getProperty("UpperDispEnable"));
	    var LowerDispEnable = (App.getApp().getProperty("LowerDispEnable"));
	    
	   //upper display 	
		if (UpperDispEnable) {
		
		//background for upper display
		dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);          
         if (screenShape == 1) {  // round       
        	dc.fillRoundedRectangle(width / 2 -65 , height / 10 * 2.4 , 130 , 35, 5);
      	 }
      	 if (screenShape == 2) {  // semi round       
        	dc.fillRoundedRectangle(width / 2 -65 , height / 10 * 2 , 130 , 35, 5);
      	 }
         dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);	    	
	    	
	 		//Draw date---------------------------------
		   	if (UDInfo == 1) {
		   		date.buildDateString(dc);      
				dc.drawText(width / 2, UDnorText, fontDigital, date.dateStr, Gfx.TEXT_JUSTIFY_CENTER); 
			}	
	
	 	    //Draw Steps --------------------------------------
	      	if (UDInfo == 2) {
		        var actsteps = 0;
		        var stepGoal = 0;		
				stepGoal = ActMonitor.getInfo().stepGoal;
				actsteps = ActMonitor.getInfo().steps;
		        var stepsStr = Lang.format("$1$", [actsteps]);        	
		        dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
				dc.drawText(width / 2, UDnorText, fontDigital, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);	
				dc.drawText(width / 2 + 50, UDobereZeile, Gfx.FONT_XTINY, stepGoal, Gfx.TEXT_JUSTIFY_RIGHT);
				dc.drawText(width / 2 + 50, UDuntereZeile, Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
			
			}
			
			//Draw Steps to go --------------------------------------
	      	if (UDInfo == 3) {
	        var actsteps = 0;
	        var stepGoal = 0;
	        var stepstogo = 0;		
			stepGoal = ActMonitor.getInfo().stepGoal;
			actsteps = ActMonitor.getInfo().steps;
			dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
			
		        if (actsteps <= stepGoal) {
			        stepstogo = stepGoal - actsteps;
			        stepstogo = Lang.format("$1$", [stepstogo]);       
					dc.drawText(width / 2, UDnorText, fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
					dc.drawText(width / 2 + 50, UDobereZeile, Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
					dc.drawText(width / 2 + 50, UDuntereZeile, Gfx.FONT_XTINY, "to go", Gfx.TEXT_JUSTIFY_RIGHT);
				}
				 if (actsteps > stepGoal) {
			        stepstogo = actsteps - stepGoal;
			        stepstogo = Lang.format("$1$", [stepstogo]);       
					dc.drawText(width / 2, UDnorText, fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
					dc.drawText(width / 2 + 50, UDobereZeile, Gfx.FONT_XTINY, "since", Gfx.TEXT_JUSTIFY_RIGHT);
					dc.drawText(width / 2 + 50, UDuntereZeile, Gfx.FONT_XTINY, "goal", Gfx.TEXT_JUSTIFY_RIGHT);
				}
			}
	 		//Draw DigitalTime---------------------------------
		   	if (UDInfo == 4) {
			 drawDigitalTime(dc);
			 dc.drawText(width / 2, UDnorText, fontDigital, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
			}	         
	        
			
	    	// Draw Altitude------------------------------
			if (UDInfo == 5) {
				drawAltitude(dc);
				dc.drawText(width / 2, UDnorText, fontDigital, altitudeStr, Gfx.TEXT_JUSTIFY_CENTER);
				dc.drawText(width / 2 + 50, UDobereZeile, Gfx.FONT_XTINY, "Alt", Gfx.TEXT_JUSTIFY_RIGHT);
				dc.drawText(width / 2 + 50, UDuntereZeile, Gfx.FONT_XTINY, altUnit, Gfx.TEXT_JUSTIFY_RIGHT);
			 }	
				
			// Draw Calories------------------------------
			if (UDInfo == 6) {	
			dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
			var actInfo = ActMonitor.getInfo(); 
	        var actcals = actInfo.calories;		       
	        var calStr = Lang.format(" $1$ kCal ", [actcals]);	
			dc.drawText(width / 2, UDnorText, fontDigital, calStr, Gfx.TEXT_JUSTIFY_CENTER);	
			}
			
			//Draw distance
			if (UDInfo == 7) {
				drawDistance(dc);
				dc.drawText(width / 2 + 20 , UDnorText, fontDigital, distStr, Gfx.TEXT_JUSTIFY_RIGHT);	
		       	//draw unit-String
				dc.drawText(width / 2 + 50, UDuntereZeile, Gfx.FONT_XTINY, distUnit, Gfx.TEXT_JUSTIFY_RIGHT);
			}
			
			
			//Draw battery
			if (UDInfo == 8) {
				var Battery = Toybox.System.getSystemStats().battery;       
        	    BatteryStr = Lang.format("$1$ % ", [ Battery.format ( "%2d" ) ] );
				dc.drawText(width / 2 + 20 , UDnorText, fontDigital, BatteryStr, Gfx.TEXT_JUSTIFY_RIGHT);	
		       	dc.drawText(width / 2 + 50, UDuntereZeile, Gfx.FONT_XTINY, "Bat", Gfx.TEXT_JUSTIFY_RIGHT);
			}
			
			//Draw Day an d week of year
			if (UDInfo == 9) {
				date.builddayWeekStr();				
				dc.drawText(width / 2  , UDnorText, fontDigital, date.dayWeekStr, Gfx.TEXT_JUSTIFY_RIGHT);	
		    	dc.drawText(width / 2 + 50, UDobereZeile, Gfx.FONT_XTINY, "day /", Gfx.TEXT_JUSTIFY_RIGHT);
		    	dc.drawText(width / 2 + 50, UDuntereZeile, Gfx.FONT_XTINY, "week", Gfx.TEXT_JUSTIFY_RIGHT);
			}
			
			
			
			
		}	
	
	
			
	 //Anzeige unteres Display--------------------------  
		if (LowerDispEnable) {
		
		//background for lower display
		 dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);          
         if (screenShape == 1) {  // round       
        	dc.fillRoundedRectangle(width / 2 -65 , height / 10 * 6.5 , 130 , 35, 5);
      	 }
      	 if (screenShape == 2) {  // semi round       
        	dc.fillRoundedRectangle(width / 2 -65 , height / 10 * 6.1 , 130 , 35, 5);
      	 }
         dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
         
	
		   if (LDInfo == 1) {
			date.buildDateString(dc);        
			dc.drawText(width / 2, LDnorText, fontDigital, date.dateStr, Gfx.TEXT_JUSTIFY_CENTER); 
			}	
	
	 	    //Draw Steps --------------------------------------
	      	if (LDInfo == 2) {
	        var actsteps = 0;
	        var stepGoal = 0;		
			stepGoal = ActMonitor.getInfo().stepGoal;
			actsteps = ActMonitor.getInfo().steps;
	        var stepsStr = Lang.format("$1$", [actsteps]);        	
	        dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
			dc.drawText(width / 2, LDnorText, fontDigital, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);	
			dc.drawText(width / 2 + 50, LDobereZeile, Gfx.FONT_XTINY, stepGoal, Gfx.TEXT_JUSTIFY_RIGHT);
			dc.drawText(width / 2 + 50, LDuntereZeile, Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
			}
			
			//Draw Steps to go --------------------------------------
	      	if (LDInfo == 3) {
	        var actsteps = 0;
	        var stepGoal = 0;
	        var stepstogo = 0;		
			stepGoal = ActMonitor.getInfo().stepGoal;
			actsteps = ActMonitor.getInfo().steps;
			dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
			
		        if (actsteps <= stepGoal) {
			        stepstogo = stepGoal - actsteps;
			        stepstogo = Lang.format("$1$", [stepstogo]);       
					dc.drawText(width / 2, LDnorText, fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
					dc.drawText(width / 2 + 50, LDobereZeile, Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
					dc.drawText(width / 2 + 50, LDuntereZeile, Gfx.FONT_XTINY, "to go", Gfx.TEXT_JUSTIFY_RIGHT);
				}
				 if (actsteps > stepGoal) {
			        stepstogo = actsteps - stepGoal;
			        stepstogo = Lang.format("$1$", [stepstogo]);       
					dc.drawText(width / 2, LDnorText, fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
					dc.drawText(width / 2 + 50, LDobereZeile, Gfx.FONT_XTINY, "since", Gfx.TEXT_JUSTIFY_RIGHT);
					dc.drawText(width / 2 + 50, LDuntereZeile, Gfx.FONT_XTINY, "goal", Gfx.TEXT_JUSTIFY_RIGHT);
				}
			}
			
	 		//Draw DigitalTime---------------------------------
		   	if (LDInfo == 4) {
			 	drawDigitalTime(dc);
			 	dc.drawText(width / 2, LDnorText, fontDigital, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
			}	         
	        
			
	    	// Draw Altitude------------------------------
			if (LDInfo == 5) {
				drawAltitude(dc);
				dc.drawText(width / 2, LDnorText, fontDigital, altitudeStr, Gfx.TEXT_JUSTIFY_CENTER);
				dc.drawText(width / 2 + 50, LDobereZeile, Gfx.FONT_XTINY, "Alt", Gfx.TEXT_JUSTIFY_RIGHT);
				dc.drawText(width / 2 + 50, LDuntereZeile, Gfx.FONT_XTINY, altUnit, Gfx.TEXT_JUSTIFY_RIGHT);
			 }	
				
			// Draw Calories------------------------------
			if (LDInfo == 6) {	
				dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
				var actInfo = ActMonitor.getInfo(); 
		        var actcals = actInfo.calories;		       
		        var calStr = Lang.format(" $1$ kCal ", [actcals]);	
				dc.drawText(width / 2, LDnorText, fontDigital, calStr, Gfx.TEXT_JUSTIFY_CENTER);	
			}	
			
			//Draw distance
			if (LDInfo == 7) {
				drawDistance(dc);
				dc.drawText(width / 2 + 20 , LDnorText, fontDigital, distStr, Gfx.TEXT_JUSTIFY_RIGHT);	
		       	//draw unit-String
				dc.drawText(width / 2 + 50, LDuntereZeile, Gfx.FONT_XTINY, distUnit, Gfx.TEXT_JUSTIFY_RIGHT);
			}
			
			//Draw battery
			if (LDInfo == 8) {
				var Battery = Toybox.System.getSystemStats().battery;       
        	    BatteryStr = Lang.format("$1$ % ", [ Battery.format ( "%2d" ) ] );
				dc.drawText(width / 2 + 20 , LDnorText, fontDigital, BatteryStr, Gfx.TEXT_JUSTIFY_RIGHT);	
		       	dc.drawText(width / 2 + 50, LDuntereZeile, Gfx.FONT_XTINY, "Bat", Gfx.TEXT_JUSTIFY_RIGHT);
			}
			
			//Draw Day an d week of year
			if (LDInfo == 9) {
				date.builddayWeekStr();				
				dc.drawText(width / 2  , LDnorText, fontDigital, date.dayWeekStr, Gfx.TEXT_JUSTIFY_RIGHT);	
		    	dc.drawText(width / 2 + 50, LDobereZeile, Gfx.FONT_XTINY, "day /", Gfx.TEXT_JUSTIFY_RIGHT);
		    	dc.drawText(width / 2 + 50, LDuntereZeile, Gfx.FONT_XTINY, "week", Gfx.TEXT_JUSTIFY_RIGHT);
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

      // Draw the numbers --------------------------------------------------------------------------------------
       var NbrFont = (App.getApp().getProperty("Numbers")); 
       dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);  
       
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
		    		dc.drawText((width / 2), 9, font1, "}", Gfx.TEXT_JUSTIFY_CENTER);
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
        dc.drawText(width / 2 + 30, height / 2 -2, Gfx.FONT_XTINY, "Msg", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 3 + 7, height / 2, Gfx.FONT_XTINY, messages, Gfx.TEXT_JUSTIFY_CENTER); 
      
	  //Alarm is set 	
     	var alarm = Sys.getDeviceSettings().alarmCount;     	
     	if (alarm > 0) {
     		dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        	dc.fillCircle(width / 2 - 30, height / 2 -7, 5);
     	}
     	dc.setPenWidth(2);
        dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(width / 2 - 30, height / 2 -7, 5);
        dc.drawText(width / 2 - 30, height / 2 -2, Gfx.FONT_XTINY, "Alm", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 3 + 7, height / 2, Gfx.FONT_XTINY, messages, Gfx.TEXT_JUSTIFY_CENTER);        
    

  
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
