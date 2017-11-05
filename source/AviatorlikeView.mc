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
using Toybox.Sensor as Snsr;

enum
{
    LAT,
    LON
}


class AviatorlikeView extends Ui.WatchFace{
	    
	    //Positions for Displays + Text
	    var ULBGx, ULBGy, ULBGwidth;
	    var ULTEXTx, ULTEXTy;
	    var ULINFOx, ULINFOy;  
	    
	  	var LLBGx, LLBGy, LLBGwidth;
	    var LLTEXTx, LLTEXTy;
	    var LLINFOx, LLINFOy;
	    var labelText;
	  	var labelInfoText;  
	  	
	  	var infoLeft;
		var infoRight;
	    
	    var isAwake;
	    var screenShape;
	    var fontLabel;
	    
	    var clockTime;
	    
	  	var width;
	    var height;  
	  	// the x coordinate for the center
	    var center_x;
	    // the y coordinate for the center
	    var center_y;      
	    
	   
		var lastLoc;
		
	
		var moonx, moony, moonwidth;
		
		
    function initialize() {
        WatchFace.initialize();        
	    fontLabel = Ui.loadResource(Rez.Fonts.id_font_label);
        screenShape = Sys.getDeviceSettings().screenShape;                  
        Sys.println("Screenshape = " + screenShape);
     
        
        
    }
   
    
    function onLayout(dc) { 
        width = dc.getWidth();
        height = dc.getHeight();
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
        
		if (width == 218 && height == 218) {
			Sys.println("device:" + "Fenix3 218");
			ULBGx = 38;
		   	ULBGy = 50;
		   	ULBGwidth = 142;
		    
		   	ULTEXTx = 109;
		   	ULTEXTy = 52;
		    
		   	ULINFOx = 175;
		   	ULINFOy = 50;   
		    
		   	LLBGx = 38;
		   	LLBGy = 130;
		   	LLBGwidth = 142;
		    
		   	LLTEXTx = 109;
		   	LLTEXTy = 132;
		    
		   	LLINFOx = 175;
		   	LLINFOy = 130; 
		    
		   	moonx = 165;
		   	moony = 89;
		   	moonwidth = 40; 		
		}
		if (width == 240 && height == 240) {
			Sys.println("device:" + "Fenix5 240");
			ULBGx = 45;
		   	ULBGy = 57;
		   	ULBGwidth = 150;
		    
		   	ULTEXTx = 120;
		   	ULTEXTy = 59;
		    
		   	ULINFOx = 188;
		   	ULINFOy = 57;   
		    
		   	LLBGx = 45;
		   	LLBGy = 147;
		   	LLBGwidth = 150;
		    
		   	LLTEXTx = 120;
		   	LLTEXTy = 149;
		    
		   	LLINFOx = 188;
		   	LLINFOy = 148; 
		    
		   	moonx = 185;
		   	moony = 100;
		   	moonwidth = 40; 		
		}
		if (width == 215 && height == 180) {
			Sys.println("device:" + "Semiround");
			ULBGx = 35;
		   	ULBGy = 33;
		   	ULBGwidth = 145;
		    
		   	ULTEXTx = 107.5;
		   	ULTEXTy = 35;
		    
		   	ULINFOx = 174;
		   	ULINFOy = 34;   
		    
		   	LLBGx = 35;
		   	LLBGy = 110;
		   	LLBGwidth = 145;
		    
		   	LLTEXTx = 107.5;
		   	LLTEXTy = 112;
		    
		   	LLINFOx = 174;
		   	LLINFOy = 111; 
		    
		   	moonx = 165;
		   	moony = 72;
		   	moonwidth = 36; 		
		}                            
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
           	//r1 = width/2 -20; //inside
           	r1 = width/2 - (5 * App.getApp().getProperty("markslenth"));
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
      
      
      
       if ( NbrFont == 0 || NbrFont == 1) { //no number	  		
			var n;      
        	var r1, r2,  thicknes;      	
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
        	
        	//when moon then only three marks
        	var nurdrei = 0;
        	var alphaMax = 4;
        	var MoonEnable = (App.getApp().getProperty("MoonEnable"));
				if (MoonEnable && NbrFont == 0) {
        			nurdrei = (Math.PI / 2) ;
        			alphaMax = 4;
        		}
        		if (MoonEnable && NbrFont == 1) {
        			nurdrei = (Math.PI / 2) ;
        			alphaMax = 3;
        		}
        		if (MoonEnable == false && NbrFont == 0) {
        			nurdrei = 0;
        			alphaMax = 4;
        		}
        		if (MoonEnable == false && NbrFont == 1) {
        			nurdrei = 0 ;
        			alphaMax = 3;
        		}
        		      	
           	for (var alpha = (Math.PI / 2) + nurdrei ; alpha <= alphaMax * Math.PI / 2; alpha += (Math.PI / 2)) { //jede 15. Minute    
			r1 = (width/2 + 3) - outerRad; //outside
			r2 = r1 -lenth; //inside			
							
			var marks = [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha-thicknes),center_y-r2*Math.cos(alpha-thicknes)],
						[center_x+r2*Math.sin(alpha+thicknes),center_y-r2*Math.cos(alpha+thicknes)],
						[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
			
			dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);		
			dc.fillPolygon(marks);
			
			dc.setPenWidth(1);
			dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT); 
			dc.drawLine(center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha), center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha));
			
			//Sys.println(alpha + " - " + (2 * Math.PI / 2));   		
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

 

         
	function drawDigitalTime() {

  			var now = Time.now();
			var dualtime = false;
			var dualtimeTZ = (App.getApp().getProperty("DualTimeTZ"));
			var dualtimeDST = (App.getApp().getProperty("DualTimeDST"));			
			
			clockTime = Sys.getClockTime();
	 			
			var dthour;
			var dtmin;
			var dtsec;
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
			dtsec = dtinfo.sec;
			
			//var use24hclock;
			//var ampmStr = "am ";
			
			var use24hclock = Sys.getDeviceSettings().is24Hour;
			if (!use24hclock) {
				if (dthour >= 12) {
					labelInfoText = "pm";
				}
				if (dthour > 12) {
					dthour = dthour - 12;				
				} else if (dthour == 0) {
					dthour = 12;
					labelInfoText = "am";
				}
			}			
			
			if (dthour < 10) {
				labelText = Lang.format("0$1$:", [dthour]);
			} else {
				labelText = Lang.format("$1$:", [dthour]);
			}
			if (dtmin < 10) {
				labelText = labelText + Lang.format("0$1$", [dtmin]);
			} else {
				labelText = labelText + Lang.format("$1$", [dtmin]);
			}
			
			if (isAwake) {
				if (dtsec < 10) {
					labelText = labelText + Lang.format(":0$1$", [dtsec]);
				} else {
					labelText = labelText + Lang.format(":$1$", [dtsec]);
				}
			}
			
			
  
  }//End of drawDigitalTime(dc)-------


	function drawAltitude() {
			
			var unknownaltitude = true;
			var actaltitude = 0;
			var actInfo;
			var metric = Sys.getDeviceSettings().elevationUnits == Sys.UNIT_METRIC;
			labelInfoText = "m";
						
			actInfo = Act.getActivityInfo();
			if (actInfo != null) {
			
				if (metric) {				
				labelInfoText = "m";
				actaltitude = actInfo.altitude;
				} else {
				labelInfoText = "ft";
				actaltitude = actInfo.altitude  * 3.28084;
				}
			
			
				if (actaltitude != null) {
					unknownaltitude = false;
				} 				
			}			
							
			if (unknownaltitude) {
				labelText = "unknown";
			} else {
				labelText = Lang.format("$1$", [actaltitude.toLong()]);				
			}
			
			infoLeft = labelText;
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
		}
		return text;
	}
 	

    function buildSunsetStr()
    {
		var sc = new SunCalc();
		var lat;
		var lon;		
		var loc = Act.getActivityInfo().currentLocation;

		if (loc == null)
		{
			lat = App.getApp().getProperty(LAT);
			lon = App.getApp().getProperty(LON);
		} 
		else
		{
			lat = loc.toDegrees()[0] * Math.PI / 180.0;
			App.getApp().setProperty(LAT, lat);
			lon = loc.toDegrees()[1] * Math.PI / 180.0;
			App.getApp().setProperty(LON, lon);
		}


//		lat = 52.375892 * Math.PI / 180.0;
//		lon = 9.732010 * Math.PI / 180.0;

		if(lat != null && lon != null)
		{
			
			var now = new Time.Moment(Time.now().value());			
			var sunrise_moment = sc.calculate(now, lat.toDouble(), lon.toDouble(), SUNRISE);
			var sunset_moment = sc.calculate(now, lat.toDouble(), lon.toDouble(), SUNSET);
			var sunrise = momentToString(sunrise_moment);
			var sunset = momentToString(sunset_moment);		

    		labelText =  sunrise + "  " + sunset;
    		   		
    		infoLeft = sunrise;
			infoRight = sunset;	
				
		}else{
	    	labelText = Ui.loadResource(Rez.Strings.none);
	    	}
		
	}

	//draw stepHistory-Graph-----------------------------------------------------------------------------------	
	function drawStepGraph(dc,stepGraphposX, stepGraphposY, stepInfoX, stepInfoY) {
		var activityHistory = ActMonitor.getHistory();
	  	var histDays=activityHistory.size();
	  	//Sys.println("histDays: " + histDays);
	  		  	
	  	var maxheight = 26.0;	  	
	  	var stepHistory=0;
	  	var maxValue; 
	  	var graphheight; 
	  	//Sys.println("graphheight : " + graphheight);
	  	
	  	var graphposX = stepGraphposX;
	  	var graphposY = stepGraphposY + 4;
	  	
	  	dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
	  	dc.setPenWidth(1);
	  	//first draw empty graph---------------------------------------------------------
	  	for(var i=0;i<7;i++) {	 
	  		//Sys.println("i : " + i); 	
	  		//dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
	  		dc.drawRectangle(graphposX, graphposY, 9, maxheight);
	        graphposX = graphposX - 11;	        
	  	}//--------------------------------------------------------------------------
	  		  	
	  if (histDays > 0) {	  	
	  		graphposX = stepGraphposX;
		  	for(var i=0;i<histDays;i++) {
		  		maxValue=stepHistory+activityHistory[i].stepGoal;
		  		graphheight = maxheight / maxValue;		  		
		  		stepHistory=stepHistory+activityHistory[i].steps;		  		
		  		graphheight = graphheight * stepHistory;
		  		
		  		if (graphheight > maxheight) {
		  			graphheight = maxheight;
		  		}
		  		
		  		//Sys.println("graphheight " + i + ": " + graphheight);	
		  		dc.fillRectangle(graphposX, graphposY+maxheight-graphheight, 8, graphheight);		  	
		  		dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
		  		dc.drawRectangle(graphposX, graphposY, 9, maxheight);
	
		        graphposX = graphposX - 11;
		        stepHistory=0;
		        graphheight = maxheight / maxValue;
		  	}
		  	
		  	//aktual step graph--------------------------------------
		  	maxValue=ActMonitor.getInfo().stepGoal;
	  		graphheight = maxheight / maxValue;
	  		
		  	dc.drawText(stepInfoX, stepInfoY + 17, fontLabel, ActMonitor.getInfo().steps, Gfx.TEXT_JUSTIFY_RIGHT);
	  		graphheight = graphheight * ActMonitor.getInfo().steps;
	  		if (graphheight > maxheight) {
	  			graphheight = maxheight;
	  		}
	  		dc.setColor((App.getApp().getProperty("HandsColor1")), Gfx.COLOR_TRANSPARENT);
	  		dc.fillRectangle(stepGraphposX+11, graphposY+maxheight-graphheight, 9, graphheight);	 
	  		dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT); 	
		  	dc.drawRectangle(stepGraphposX+11, graphposY, 9, maxheight);
	  	}
	  }// end od draw stepHistory-Graph----------------------



	//build string for display in labels-------------------- 
	function setLabel(displayInfo) {
				
			labelText = "";
  			labelInfoText = "";	        
    		     	    	
	 		//Draw date---------------------------------
		   	if (displayInfo == 1) {
		   		date.buildDateString();
		   		labelText = date.dateStr;	  		      
			}	
	
	 	    //Draw Steps --------------------------------------
	      	if (displayInfo == 2) {				   		
		   		labelText = Lang.format("$1$", [ActMonitor.getInfo().steps]);
	  			labelInfoText = Lang.format("$1$", [ActMonitor.getInfo().stepGoal]);   						
			}
			
			//Draw Steps to go --------------------------------------
	      	if (displayInfo == 3) {
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
		   		labelText = stepstogo;				        			              
			}

	 	    //Draw StepGraph --------------------------------------
	      	if (displayInfo == 4) {				   		
		   		labelText = "";
	  			labelInfoText = Lang.format("$1$", [ActMonitor.getInfo().stepGoal]); 	  						
			}


	 		//Draw DigitalTime---------------------------------
		   	if (displayInfo == 5) {
				 drawDigitalTime(); 
			}	         
	        
	    	// Draw Altitude------------------------------
			if (displayInfo == 6) {
				drawAltitude();	
			 }	
				
			// Draw Calories------------------------------
			if (displayInfo == 7) {	
				var actInfo = ActMonitor.getInfo(); 
		        var actcals = actInfo.calories;		       
		        labelText = Lang.format("$1$", [actcals]);
		        labelInfoText = "kCal";
			}
			
			//Draw distance
			if (displayInfo == 8) {
				distance.drawDistance();
				labelText = distance.distStr;
	  			labelInfoText = distance.distUnit;
	  			//Sys.println("Distance");
			}			
			
			//Draw battery
			if (displayInfo == 9) {
				var Battery = Toybox.System.getSystemStats().battery;       
        	    labelText = Lang.format("$1$ % ", [ Battery.format ( "%2d" ) ] );
			}
			
			//Draw Day and week of year
			if (displayInfo == 10) {
				date.builddayWeekStr();
				//labelText = date.dayWeekStr;
				labelText = date.aktDay + " / " + date.week;
			}
			
			//next / over next sun event
			if (displayInfo == 11) {
				buildSunsetStr();
		    }
		    
		   	//heart rate
			if (displayInfo == 12) {
			var hasHR = (ActivityMonitor has :HeartRateIterator) ? true : false;			
				if (hasHR) {
					var HRH = ActMonitor.getHeartRateHistory(null, true);
					var hr="--";
					
					if(HRH != null) {
						var HRS=HRH.next();
						if(HRS!=null && HRS.heartRate!=null && HRS.heartRate!=ActMonitor.INVALID_HR_SAMPLE) {
							hr = HRS.heartRate.toString();
							labelText = hr;
							labelInfoText = "bpm";
							//labelText = HRH.getMax()+"/"+HRH.getMin()+" "+HRS.heartRate+" bpm";			
						}
					}	
				}
				else {
				labelText = "no sensor";
				}				
		    }
		   		    	    
		    
		    
	//Sys.println("Dispfilled");
	//Sys.println("");
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
        
        
    // Indicators, moon ---------------------------------------------------------------------------       
        //! Moon phase
		var MoonEnable = (App.getApp().getProperty("MoonEnable"));
		if (MoonEnable) {             			
	   		var now = Time.now();
			var dateinfo = Calendar.info(now, Time.FORMAT_SHORT);
	        var clockTime = Sys.getClockTime();
	        var moon = new Moon(Ui.loadResource(Rez.Drawables.moon), moonwidth, moonx, moony);
			moon.updateable_calcmoonphase(dc, dateinfo, clockTime.hour);
			dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(1);	   
	 		dc.drawCircle(moonx+moonwidth/2,moony+moonwidth/2,moonwidth/2-1);
	 		
	 		//dc.setColor((App.getApp().getProperty("NumbersColor")), Gfx.COLOR_TRANSPARENT);
	 		//dc.drawText(moonx+moonwidth/2,moony+moonwidth/2-12, fontLabel, moon.c_moon_label, Gfx.TEXT_JUSTIFY_CENTER);
			//dc.drawText(moonx+moonwidth/2,moony+moonwidth/2, fontLabel, moon.c_phase, Gfx.TEXT_JUSTIFY_CENTER);
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
		//! Alm / Msg indicators
		var AlmMsgEnable = (App.getApp().getProperty("AlmMsgEnable"));
		var AlmMsg = (App.getApp().getProperty("AlmMsg"));

		
		if (AlmMsgEnable) {
			var offcenter=35;
			var labelLeft = "";
			var labelRight = "";
			//var infoLeft = "";
			//var infoRight = "";
			infoLeft = "";
			infoRight = "";
			
			dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
			var messages = Sys.getDeviceSettings().notificationCount;
			var alarm = Sys.getDeviceSettings().alarmCount; 
			
			if (AlmMsg == 1) { // setting Alm/Msg count		     	
		     	labelLeft = "Alm";
		     	infoLeft = alarm;
		     	
	     		labelRight = "Msg";
				infoRight = messages; 
			} 	     	
	 	    
	 	    if (AlmMsg == 2) { // setting Alm/Msg only indicators 
	 	    	labelLeft = "Alm";		     	
	     		labelRight = "Msg";	
				//messages
 	     		if (messages > 0) {
 	     		    dc.fillCircle(width / 2 + offcenter, height / 2 -7, 5);
 	     		}
 	     		dc.setPenWidth(2);
 	        	dc.drawCircle(width / 2 + offcenter, height / 2 -7, 5);	
 	        		     		     	
				//Alarm		     	
 	     		if (alarm > 0) {
 	     			dc.fillCircle(width / 2 - offcenter, height / 2 -7, 5);
 	     		}
 	     		dc.setPenWidth(2);
 	        	dc.drawCircle(width / 2 - offcenter, height / 2 -7, 5);
	     	} 
	     	
	     	if (AlmMsg == 3) { 
	     		date.builddayWeekStr();    	
	     		labelLeft = "day";
	     		infoLeft = date.aktDay;
	     		labelRight = "week";				
				infoRight = date.week;     	
	     	}
	     	
	     	if (AlmMsg == 4) { 
	     		buildSunsetStr();    	
	     		labelLeft = "s.rise";
	     		labelRight = "s.set";				   	
	     	}
	     	
	     	if (AlmMsg == 5) { 
	     		drawAltitude();    	
	     		labelLeft = "elev";	     		
	     		distance.drawDistance();
	     		labelRight = "dist";				
				infoRight = distance.distStr;    	
	     	}
	     	
	     	if (AlmMsg == 6) {    	
	     		labelLeft = "goal";	     		
	     		infoLeft = ActMonitor.getInfo().stepGoal;
	     		labelRight = "steps";				
				infoRight = ActMonitor.getInfo().steps;    	
	     	}


	     		
			dc.drawText(width / 2 + offcenter, height / 2 -15, fontLabel, infoRight, Gfx.TEXT_JUSTIFY_CENTER);	     		
	 		dc.drawText(width / 2 + offcenter, height / 2 -2, fontLabel, labelRight, Gfx.TEXT_JUSTIFY_CENTER);
	 		
	 		dc.drawText(width / 2 - offcenter, height / 2 -15, fontLabel, infoLeft, Gfx.TEXT_JUSTIFY_CENTER);
	 		dc.drawText(width / 2 - offcenter, height / 2 -2, fontLabel, labelLeft, Gfx.TEXT_JUSTIFY_CENTER); 
		}       




//Draw Digital Elements ------------------------------------------------------------------ 

	    var fontDigital = 0;
	   

         var digiFont = (App.getApp().getProperty("DigiFont")); 
         //Sys.println("digiFont="+ digiFont);
         //fontDigital = null;
         
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
        		fontDigital = Gfx.FONT_SYSTEM_MEDIUM ; 
        	}
        	if (screenShape == 2) {  // semi round 
        		fontDigital = Gfx.FONT_SYSTEM_LARGE ; 
        	}      	    
	    }
	    	
	    	   
	    var UpperDispEnable = (App.getApp().getProperty("UpperDispEnable"));
	    var LowerDispEnable = (App.getApp().getProperty("LowerDispEnable"));

	  	
		//Anzeige oberes Display--------------------------  
		if (UpperDispEnable) {
			var displayInfo = (App.getApp().getProperty("UDInfo"));
		//	Sys.println("UDInfo: " + displayInfo);
			setLabel(displayInfo);
			//background for upper display
			dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);  
	       	dc.fillRoundedRectangle(ULBGx, ULBGy , ULBGwidth, 38, 5);
      	      	 
        	dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
        	dc.drawText(ULTEXTx, ULTEXTy, fontDigital, labelText, Gfx.TEXT_JUSTIFY_CENTER);	
        	//dc.drawText(ULTEXTx, ULTEXTy, fontDigital, "88:88/88:88", Gfx.TEXT_JUSTIFY_CENTER);	
			dc.drawText(ULINFOx, ULINFOy, fontLabel, labelInfoText, Gfx.TEXT_JUSTIFY_RIGHT);
			
			if (displayInfo == 4) {
			drawStepGraph(dc, ULTEXTx, ULTEXTy, ULINFOx, ULINFOy);
			}	    				
		}	
		
			
	 //Anzeige unteres Display--------------------------  
		if (LowerDispEnable) {
			var displayInfo = (App.getApp().getProperty("LDInfo"));
		//	Sys.println("LDInfo: " + displayInfo);
			setLabel(displayInfo);
			//background for upper display
			dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);  
	       	dc.fillRoundedRectangle(LLBGx, LLBGy , LLBGwidth, 38, 5);
	       	
	      // 	dc.setColor((App.getApp().getProperty("NumbersColor")), Gfx.COLOR_TRANSPARENT);
	      // 	dc.drawRoundedRectangle(LLBGx, LLBGy , LLBGwidth, 38, 5);
	       	      	      	 
        	dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
        	dc.drawText(LLTEXTx, LLTEXTy, fontDigital, labelText, Gfx.TEXT_JUSTIFY_CENTER);
       // 	dc.drawText(LLTEXTx-25, LLTEXTy, fontDigital, "88888", Gfx.TEXT_JUSTIFY_CENTER);		
			dc.drawText(LLINFOx, LLINFOy, fontLabel, labelInfoText, Gfx.TEXT_JUSTIFY_RIGHT);
			
			if (displayInfo == 4) {
			drawStepGraph(dc, LLTEXTx, LLTEXTy, LLINFOx, LLINFOy);
			}	    				
		}

//Fadenkreuz-------------------------------------
	  	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
//	  	dc.setPenWidth(1);  	
//		dc.drawLine(ULBGx, 0, ULBGx , height);
//		dc.drawLine(ULBGx + ULBGwidth, 0, ULBGx + ULBGwidth , height);	
//		dc.drawLine(width/2, 0, width/2 , height);		
//		dc.drawLine(0, height/2, width , height/2);

	
//draw move bar (inactivity alarm)----------------------
Sys.println("moveBarLevel "+ ActMonitor.getInfo().moveBarLevel);
var showMoveBar = (App.getApp().getProperty("MoveBarEnable"));

var setY = ULBGy + 40 ;
var setX = center_x;

	if (showMoveBar) {
	dc.setPenWidth(3);
	
		dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
		if (ActMonitor.getInfo().moveBarLevel >= 1) {
			dc.drawLine(setX - 7 , setY, setX  - 58, setY);		
		//	dc.fillRoundedRectangle(ULBGx , setY, ULBGwidth/2 - 2 , 3, 3);
		}
		
		
		if (ActMonitor.getInfo().moveBarLevel >= 2) {
			dc.drawLine(setX , setY, setX + 10, setY);
			setX = setX +  16;
		//	dc.fillRoundedRectangle(ULBGx + ULBGwidth/2, setY, ULBGwidth/8 - 2 , 3, 3);
		}
		if (ActMonitor.getInfo().moveBarLevel >= 3) {
			dc.drawLine(setX , setY, setX + 10, setY);
			setX = setX +  16;
		//	dc.fillRoundedRectangle(ULBGx  + ULBGwidth/2 + ULBGwidth/8, setY, ULBGwidth/8 - 2 , 3, 3);
		}
		if (ActMonitor.getInfo().moveBarLevel >= 4) {
			dc.drawLine(setX , setY, setX + 10, setY);
			setX = setX +  16;
		//	dc.fillRoundedRectangle(ULBGx  + ULBGwidth/2 + ULBGwidth/8 * 2, setY, ULBGwidth/8 - 2 , 3, 3);
		}
		if (ActMonitor.getInfo().moveBarLevel == 5) {
			dc.drawLine(setX , setY, setX + 10, setY);
		//	dc.fillRoundedRectangle(ULBGx  + ULBGwidth/2 + ULBGwidth/8 * 3, setY, ULBGwidth/8 + 2 , 3, 3);
		}
	}	  	
	 
	  	
	  	





	        

      // Draw the numbers --------------------------------------------------------------------------------------
       var NbrFont = (App.getApp().getProperty("Numbers")); 
       dc.setColor((App.getApp().getProperty("NumbersColor")), Gfx.COLOR_TRANSPARENT);
       var font1 = 0;  
       
       if (screenShape == 1) {  // round
   		    if ( NbrFont == 1) { //fat
	    		font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
	    		dc.drawText((width / 2), 5, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
	    	}            
		    if ( NbrFont == 2) { //fat
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
		    		dc.drawText((width / 2), 5, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {
		    			dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 54, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		    if ( NbrFont == 3) { //race
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_race);
		    		dc.drawText((width / 2), 5, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {	
		    			dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 52, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		    if ( NbrFont == 4) { //classic
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_classic);
		    		dc.drawText((width / 2), 15, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {	
		    			dc.drawText(width - 16, (height / 2) - 18, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 48, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 18, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		   if ( NbrFont == 5) {  //roman
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_roman);
		    		dc.drawText((width / 2), 11, font1, "}", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {	
		    			dc.drawText(width - 16, (height / 2) - 22, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 50, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 22, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
		   	if ( NbrFont == 6) {  //simple
		    		dc.drawText((width / 2), 10, Gfx.FONT_SYSTEM_LARGE   , "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {
		    			dc.drawText(width - 16, (height / 2) - 22, Gfx.FONT_SYSTEM_LARGE  , "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 45, Gfx.FONT_SYSTEM_LARGE   , "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 22, Gfx.FONT_SYSTEM_LARGE   , "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
	   	}
       
       
       if (screenShape == 2) {  //semi round
   		    if ( NbrFont == 1) { //fat
	    		font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
	    		dc.drawText((width / 2), -12, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    }
                  
		    if ( NbrFont == 2) { //fat
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
		    		dc.drawText((width / 2), -12, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {	
		    			dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 41, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    }
		    if ( NbrFont == 3) { //race
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_race);
		    		dc.drawText((width / 2), -12, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {		
		    			dc.drawText(width - 16, (height / 2) - 26, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 39, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 26, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		    if ( NbrFont == 4) { //classic
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_classic);
		    		dc.drawText((width / 2), 0, font1, "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {		
		    			dc.drawText(width - 16, (height / 2) - 18, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 33, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 18, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		    	}
		   if ( NbrFont == 5) {  //roman
		    		font1 = Ui.loadResource(Rez.Fonts.id_font_roman);
		    		dc.drawText((width / 2), -4, font1, "}", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {		
		    			dc.drawText(width - 16, (height / 2) - 20, font1, "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 35, font1, "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 20, font1, "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
		   	if ( NbrFont == 6) {  //simple
		    		dc.drawText((width / 2), -3, Gfx.FONT_SYSTEM_LARGE   , "12", Gfx.TEXT_JUSTIFY_CENTER);
		    		if (! MoonEnable) {		
		    			dc.drawText(width - 16, (height / 2) - 17, Gfx.FONT_SYSTEM_LARGE  , "3", Gfx.TEXT_JUSTIFY_RIGHT);
	        		}
	        		dc.drawText(width / 2, height - 30, Gfx.FONT_SYSTEM_LARGE   , "6", Gfx.TEXT_JUSTIFY_CENTER);
	        		dc.drawText(16, (height / 2) - 17, Gfx.FONT_SYSTEM_LARGE   , "9", Gfx.TEXT_JUSTIFY_LEFT);
		   		}
	   	} 
       

  // Draw hands ------------------------------------------------------------------         
    	hands.drawHands(dc); 
     	
     	
  // Center Point with Bluetooth connection
  	var CenterDotEnable = (App.getApp().getProperty("CenterDotEnable"));
  	if (CenterDotEnable) {
  	
  		if (Sys.getDeviceSettings().phoneConnected) {
  			dc.setColor((App.getApp().getProperty("HandsColor1")), Gfx.COLOR_TRANSPARENT);
	   	} else {
  			dc.setColor((App.getApp().getProperty("BackgroundColor")), Gfx.COLOR_TRANSPARENT);
	   	} 
	
	} else {
  			dc.setColor((App.getApp().getProperty("HandsColor1")), Gfx.COLOR_TRANSPARENT);
	   	} 

	    
	    dc.fillCircle(width / 2, height / 2, 5);
	    dc.setPenWidth(2);
     	dc.setColor((App.getApp().getProperty("HandsColor2")), Gfx.COLOR_TRANSPARENT);
	    dc.drawCircle(width / 2, height / 2 , 5);
 	
 	
 
 
 	
 	
    //draw second hand  
       if (isAwake) {
       var SecHandEnable = (App.getApp().getProperty("SecHandEnable"));
       if (SecHandEnable) {
     		hands.drawSecondHands(dc);
     	}
      }
 
//Sys.println("used: " + System.getSystemStats().usedMemory);
//Sys.println("free: " + System.getSystemStats().freeMemory);
//Sys.println("total: " + System.getSystemStats().totalMemory);
//Sys.println("");
          
}
    
   

    function onEnterSleep() {
        isAwake = false;
        Ui.requestUpdate();
    }

    function onExitSleep() {
        isAwake = true;
    }
}
