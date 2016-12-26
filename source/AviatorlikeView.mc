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

// This implements an analog watch face
// Original design by Austen Harbour
class AviatorlikeView extends Ui.WatchFace{


    var font1;
    var fontDigital;
    var isAwake;
    var screenShape;
    var dndIcon;
    
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
		
		var altitudeStr; 
		var distStr;
		var distUnit;

    function initialize() {
        WatchFace.initialize();
        screenShape = Sys.getDeviceSettings().screenShape;
    }
   
    
    function onLayout(dc) {
    	font1 = Ui.loadResource(Rez.Fonts.id_font_fat);
    	//font1 = Ui.loadResource(Rez.Fonts.id_font_digital);
        //font1 = Gfx.FONT_SYSTEM_NUMBER_SMALL;
        fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital);
        //fontDigital = Ui.loadResource(Rez.Fonts.id_font_classicklein);          
        
    }

   

    // Draw the hash mark symbols on the watch-------------------------------------------------------
    // @param dc Device context
    function drawHashMarks(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        // Draw hashmarks differently depending on screen geometry
        //if (Sys.SCREEN_SHAPE_ROUND == screenShape) {

            var sX, sY;
            var eX, eY;
            var outerRad = width / 2;
            var innerRad = outerRad - 5; //Länge der Tickmarks
            
            dc.setPenWidth(3);         
            dc.setColor(App.getApp().getProperty("MinutesColor"), Gfx.COLOR_TRANSPARENT);
            //all minutes
            for (var i = Math.PI / 6; i <= 13 * Math.PI / 6; i += (Math.PI / 30)) {
            
            //dc.drawText(center_x, center_y+20, Gfx.FONT_MEDIUM, i, Gfx.TEXT_JUSTIFY_CENTER);
                // Partially unrolled loop to draw two tickmarks in 15 minute block
                sY = outerRad + innerRad * Math.sin(i);
                sX = outerRad + innerRad * Math.cos(i);
                
                eY = outerRad + outerRad * Math.sin(i);               
                eX = outerRad + outerRad * Math.cos(i);
                
                dc.drawLine(sX, sY, eX, eY);               
               }
        
        
        	outerRad = width / 2;
            innerRad = outerRad - 20;
            dc.setPenWidth(3);
            dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
            //all 5 minutes
            for (var i = Math.PI / 6; i <= 11 * Math.PI / 6; i += (Math.PI / 3)) {
            
            //dc.drawText(center_x, center_y+20, Gfx.FONT_MEDIUM, i, Gfx.TEXT_JUSTIFY_CENTER);
               // Partially unrolled loop to draw two tickmarks in 15 minute block
                sY = outerRad + innerRad * Math.sin(i);
                sX = outerRad + innerRad * Math.cos(i);
                
                eY = outerRad + outerRad * Math.sin(i);               
                eX = outerRad + outerRad * Math.cos(i);
                
                dc.drawLine(sX, sY, eX, eY);
                
                i += Math.PI / 6;
                sY = outerRad + innerRad * Math.sin(i);
                eY = outerRad + outerRad * Math.sin(i);
                sX = outerRad + innerRad * Math.cos(i);
                eX = outerRad + outerRad * Math.cos(i);
                dc.drawLine(sX, sY, eX, eY);  
     		} 
    }
    
    function drawQuarterHashmarks(dc){          
      //12, 3, 6, 9
      var NbrFont = (App.getApp().getProperty("Numbers"));
      
       if ( NbrFont == 0) { //no number
	  		var width = dc.getWidth();
        	var height = dc.getHeight();
			var n;      
        	var r1, r2, marks, thicknes;
        	
        	var outerRad = 0;
        	var lenth = 20;
        	var thick = 5;
        	thicknes = thick * 0.02;
           
           // for (var alpha = Math.PI / 6; alpha <= 13 * Math.PI / 6; alpha += (Math.PI / 30)) { //jede Minute
           	for (var alpha = Math.PI / 2; alpha <= 13 * Math.PI / 2; alpha += (Math.PI / 2)) { //jede 15. Minute
     
			r1 = (width/2 + 3) - outerRad; //outside
			r2 = r1 -lenth; //inside
			//thicknes = 0.01;
			
							
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
			var width = dc.getWidth();
        	var height = dc.getHeight();
        	var sX, sY;
            var eX, eY;
		   	dc.setPenWidth(8);
		   	var outerRad = width / 2;
            var innerRad = outerRad - 5;        
            dc.setColor(App.getApp().getProperty("QuarterNumbersColor"), Gfx.COLOR_TRANSPARENT);
            for (var i = Math.PI / 2; i <= 13 * Math.PI / 2; i += (Math.PI / 2)) {
            
            //dc.drawText(center_x, center_y+20, Gfx.FONT_MEDIUM, i, Gfx.TEXT_JUSTIFY_CENTER);
                // Partially unrolled loop to draw two tickmarks in 15 minute block
                sY = outerRad + innerRad * Math.sin(i);
                sX = outerRad + innerRad * Math.cos(i);
                
                eY = outerRad + outerRad * Math.sin(i);               
                eX = outerRad + outerRad * Math.cos(i);
                
                dc.drawLine(sX, sY, eX, eY);
                
             }
         }
    } 

  // Draw hands ------------------------------------------------------------------
  function drawHands(dc) {        
          // the length of the minute hand
   		var minute_radius;
    	// the length of the hour hand
    	var hour_radius; 
    	
    	var width = dc.getWidth();
        var height  = dc.getHeight();
        
        // i've arbitrarily decided that i want
        // the minute hand to be 7/8 the length of the radius
        minute_radius = 7/8.0 * center_x;
        // i've also arbitrarily decided that i want
        // the hour hand to be 2/3 the length of the minute hand
        hour_radius = 3/4.0 * minute_radius;
  				
		var HandsForm = (App.getApp().getProperty("HandsForm"));
		var color1 = (App.getApp().getProperty("HandsColor"));
		var color2 = 0x555555;
		var n;
		
		clockTime = Sys.getClockTime();
        var hours = clockTime.hour;        
        var minute = clockTime.min;
        
        var alpha, alpha2, alpha3,r0, r1, r2, r3, hand, hand1;

		
		//!Schwarz + DK-Grau
		if (color1 == 0x000000) {
			color2 = 0x555555;
			}
		//!weiß + LT-Grau
		if (color1 == 0xFFFFFF) {
			color2 = 0xAAAAAA;
			}
		//!Rot + DK-Rot
		if (color1 == 0xFF0000) {
			color2 = 0xAA0000;
			}
		//!Grün + DK-Grün
		if (color1 == 0x00FF00) {
			color2 = 0x00AA00;
			}			
		//!Blau + DK-Blau
		if (color1 == 0x00AAFF) {
			color2 = 0x0000FF;
			}		
		//!Orange + Gelb
		if (color1 == 0xFF5500) {
			color2 = 0xFFAA00;
			}	
			
			
         //Driver-Hands-----------------	
		if (HandsForm == 1) { 	
				// hours
				alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
				alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
				r1 = -20;
				r2 = 12;
				
								
				hand =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
								[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
								
				hand1 =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
								[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)]   ];
								
				dc.setPenWidth(1);				
		        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand);
				dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand1);
		            
		
		
				 // minutes
				alpha = Math.PI/30.0*clockTime.min;
				alpha2 = Math.PI/30.0*(clockTime.min-15);
				r1 = -25;
				r2 = 12;
				hand =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
								[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
								
				hand1 =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
								[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
								[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)]   ];
								
								
		        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand);
				dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand1);
				
				//Draw Center Point
				dc.setPenWidth(1);   
        		dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        		dc.drawCircle(width / 2, height / 2, 2);
		        
			}// End of if (HandsForm == 1)		

	//Pilot-Hands----------------------------------
	if (HandsForm == 2) {
	// hours
		alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
		alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
		r0 = -30;
		r1 = 9; //Entfernung zum rechten winkel
		r2 = 25;
		r3 = 50;

			
		hand =        			[[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
								[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
								[center_x+r2*Math.sin(alpha+0.4),center_y-r2*Math.cos(alpha+0.4)],
								[center_x+r2*Math.sin(alpha-0.4),center_y-r2*Math.cos(alpha-0.4)], 
								[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)]	  ];
											
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);
	
						
		hand1 =         [[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
						[center_x+r2*Math.sin(alpha-0.35),center_y-r2*Math.cos(alpha-0.35)],
						[center_x+r3*Math.sin(alpha-0.2),center_y-r3*Math.cos(alpha-0.2)],
						[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.2),center_y-r3*Math.cos(alpha+0.2)],
						[center_x+r2*Math.sin(alpha+0.35),center_y-r2*Math.cos(alpha+0.35)],
						[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]			   ];
		
		
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
		for (n=0; n<8; n++) {
			dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
		}
		//dc.drawLine(hand1[n][0], hand1[n][1], hand1[0][0], hand1[0][1]);
            


		 // minutes
		alpha = Math.PI/30.0*clockTime.min;
		alpha2 = Math.PI/30.0*(clockTime.min-15);
		r0 = -30;
		r1 = 9; //Entfernung zum rechten winkel
		r2 = 25;
		r3 = 70;
		
		hand =        			[[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
								[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
								[center_x+r2*Math.sin(alpha+0.4),center_y-r2*Math.cos(alpha+0.4)],
								[center_x+r2*Math.sin(alpha-0.4),center_y-r2*Math.cos(alpha-0.4)], 
								[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)]	  ];
											
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);
		
		hand1 =         [[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
						[center_x+r2*Math.sin(alpha-0.35),center_y-r2*Math.cos(alpha-0.35)],
						[center_x+r3*Math.sin(alpha-0.15),center_y-r3*Math.cos(alpha-0.15)],
						[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.15),center_y-r3*Math.cos(alpha+0.15)],
						[center_x+r2*Math.sin(alpha+0.35),center_y-r2*Math.cos(alpha+0.35)],
						[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]			   ];					
						
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);
		
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
		for (n=0; n<8; n++) {
			dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
		}
		dc.drawLine(hand1[n][0], hand1[n][1], hand1[0][0], hand1[0][1]);
		
		
		// Draw the CenterPoint
        dc.setPenWidth(1);
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        dc.fillCircle(width / 2, height / 2, 3);
        
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.drawCircle(width / 2, height / 2, 3);
		}
		
		//Diver-Hands----------------------------------------	
		if (HandsForm == 3) { 	
			// houres
			alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
			alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
			
			//dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);
				
			//draw the target			
			r1 = width/2 - 70; //inside
			var thicknes = 0.25;
	 									
				hand =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
							[center_x+(hour_radius)*Math.sin(alpha),center_y-(hour_radius)*Math.cos(alpha)],
							[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
																	
			dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);	
			dc.fillPolygon(hand);
			
			dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(4);
			var n;		
			for (n=0; n<2; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
			
			//Sys.println("%%.2f='" + alpha.format("%.2f") + "'");
			
			//rectangle 
			r2 = 5;
				
				hand =        	[[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)],
								[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
								[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)],
								[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
								
		dc.setPenWidth(4);
		for (n=0; n<3; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]); 		
			        
		// minutes--------------
			alpha = Math.PI/30.0*clockTime.min;
			alpha2 = Math.PI/30.0*(clockTime.min-15);
			
			//dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);
				
			//draw the target			
			r1 = width/2 - 50; //inside
			thicknes = 0.16;
	 									
				hand =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
							[center_x+(minute_radius)*Math.sin(alpha),center_y-(minute_radius)*Math.cos(alpha)],
							[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
																	
			dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);	
			dc.fillPolygon(hand);
			
			dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(4);		
			for (n=0; n<2; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
			
			//Sys.println("%%.2f='" + alpha.format("%.2f") + "'");
			
			//rectangle 
			r2 = 5;

				hand =        	[[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)],
								[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
								[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)],
								[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
								
		dc.setPenWidth(4);
		for (n=0; n<3; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
		
		
		//Centerpoint
		dc.setPenWidth(2);
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x,center_y,7);
		
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x,center_y,7);
		
	}// End of if (HandsForm Diver)		
		
	//Classic-Hands----------------------------------
		if (HandsForm == 4) {
		// houres
		alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
		r0 = 20;
		r1 = 40; //Entfernung zum rechten winkel
		r2 = 55;
		
		hand =        	[
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha+0.2),center_y-r1*Math.cos(alpha+0.2)],						
						[center_x+r2*Math.sin(alpha+0.03),center_y-r2*Math.cos(alpha+0.03)],
						[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
						[center_x+r2*Math.sin(alpha-0.03),center_y-r2*Math.cos(alpha-0.03)],						
						[center_x+r1*Math.sin(alpha-0.2),center_y-r1*Math.cos(alpha-0.2)],
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];
											
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
		for (n=0; n<6; n++) {
		dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		
		r0 = 0;
		r1 = 20;
		r2 = 45;
		
		dc.drawLine(center_x+22*Math.sin(alpha-0.3),center_y-22*Math.cos(alpha-0.3),center_x+22*Math.sin(alpha+0.3),center_y-22*Math.cos(alpha+0.3));
				
		hand =        	[
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],						
						[center_x+r1*Math.sin(alpha+0.2),center_y-r1*Math.cos(alpha+0.2)],
						[center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha-0.2),center_y-r1*Math.cos(alpha-0.2)],						
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];	
						
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);	
		
		
		// minutes
		alpha = Math.PI/30.0*clockTime.min;
		r0 = 35;
		r1 = 55; //Entfernung zum rechten winkel
		r2 = 70;
		
		//obere raute
		hand =        	[
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha+0.13),center_y-r1*Math.cos(alpha+0.13)],						
						[center_x+r2*Math.sin(alpha+0.04),center_y-r2*Math.cos(alpha+0.04)],
						[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
						[center_x+r2*Math.sin(alpha-0.04),center_y-r2*Math.cos(alpha-0.04)],						
						[center_x+r1*Math.sin(alpha-0.13),center_y-r1*Math.cos(alpha-0.13)],
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];
											
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
		for (n=0; n<6; n++) {
		dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		
		r0 = 0;
		r1 = 25;
		r2 = 65;
		
		dc.drawLine(center_x+35*Math.sin(alpha-0.2),center_y-35*Math.cos(alpha-0.2),center_x+35*Math.sin(alpha+0.2),center_y-35*Math.cos(alpha+0.2));
		
		
		//untere Raute		
		hand =        	[
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],						
						[center_x+r1*Math.sin(alpha+0.18),center_y-r1*Math.cos(alpha+0.18)],
						[center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha-0.18),center_y-r1*Math.cos(alpha-0.18)],						
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];	
						
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);			
	
		// Draw the CenterPoint
        dc.setPenWidth(1);
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(width / 2, height / 2, 7);
        
       	dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        dc.drawCircle(width / 2, height / 2, 7);		
		
		}	
		
	//Simple-Hands----------------------------------------	
		if (HandsForm == 5) { 	
			// houres
			alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
			alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
	 													
			//rectangle 
			r2 = 5; //Breite im Zentrum
			var thicknes = 0.07; //Breite oben

			hand =        	[[center_x-20*Math.sin(alpha-0.25),center_y+20*Math.cos(alpha-0.25)],
							[center_x-20*Math.sin(alpha+0.25),center_y+20*Math.cos(alpha+0.25)],
							[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)],
							[center_x+hour_radius*Math.sin(alpha-thicknes),center_y-hour_radius*Math.cos(alpha-thicknes)],
							[center_x+hour_radius*Math.sin(alpha+thicknes),center_y-hour_radius*Math.cos(alpha+thicknes)],
							[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
							
			dc.setColor(color2, Gfx.COLOR_TRANSPARENT);	
			dc.fillPolygon(hand);						
			dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);
			for (n=0; n<5; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);		
			        
		// minutes--------------
			alpha = Math.PI/30.0*clockTime.min;
			alpha2 = Math.PI/30.0*(clockTime.min-15);
			//Sys.println("%%.2f='" + alpha.format("%.2f") + "'");
		
			//rectangle 
			r2 = 3; //Breite im Zentrum
			thicknes = 0.029; //Breite oben

			hand =        	[[center_x-20*Math.sin(alpha-0.15),center_y+20*Math.cos(alpha-0.15)],
							[center_x-20*Math.sin(alpha+0.15),center_y+20*Math.cos(alpha+0.15)],
							[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)],
							[center_x+minute_radius*Math.sin(alpha-thicknes),center_y-minute_radius*Math.cos(alpha-thicknes)],
							[center_x+minute_radius*Math.sin(alpha+thicknes),center_y-minute_radius*Math.cos(alpha+thicknes)],
							[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
							
			dc.setColor(color2, Gfx.COLOR_TRANSPARENT);	
			dc.fillPolygon(hand);						
			dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);
			for (n=0; n<5; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
		
		
		//Centerpoint
		dc.setPenWidth(2);
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x,center_y,7);
		
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x,center_y,7);
		
	}// End of if (HandsForm == 4)	
		
		
			
         
  }//End of drawHands(dc)

	function drawSecondHands(dc) {        
          // the length of the minute hand
        
        var color1 = (App.getApp().getProperty("SecHandsColor"));
		var color2 = 0x555555;  
          
          //!Schwarz + DK-Grau
		if (color1 == 0x000000) {
			color2 = 0x555555;
			}
		//!weiß + LT-Grau
		if (color1 == 0xFFFFFF) {
			color2 = 0xAAAAAA;
			}
		//!Rot + DK-Rot
		if (color1 == 0xFF0000) {
			color2 = 0xAA0000;
			}
		//!Grün + DK-Grün
		if (color1 == 0x00FF00) {
			color2 = 0x00AA00;
			}			
		//!Blau + DK-Blau
		if (color1 == 0x00AAFF) {
			color2 = 0x0000FF;
			}		
		//!Orange + Gelb
		if (color1 == 0xFF5500) {
			color2 = 0xFFAA00;
			}	
   		var seconds_radius;
 	  	var width = dc.getWidth();
        var height  = dc.getHeight();
        
        //seconds_radius = 7/8.0 * center_x;
		seconds_radius = width / 2 ;
		
		var n;
	
		clockTime = Sys.getClockTime();
        var seconds = clockTime.sec;        
        
        var r1, r2, r0, hand;
		var alpha = Math.PI/30.0*clockTime.sec;
		
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);		
		dc.setPenWidth(2);

		r0 = -35;
		r1 = 35;
		r2 = seconds_radius;
		
		//untere Raute		
		hand =        	[
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],						
						[center_x+r1*Math.sin(alpha+0.08),center_y-r1*Math.cos(alpha+0.08)],
						[center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha-0.08),center_y-r1*Math.cos(alpha-0.08)],						
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];	
						
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);		

		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
		for (n=0; n<4; n++) {
		dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		
		
		//little circle
		dc.setPenWidth(2);
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x+(seconds_radius-30)*Math.sin(alpha),center_y-(seconds_radius-30)*Math.cos(alpha),6);		
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x+(seconds_radius-30)*Math.sin(alpha),center_y-(seconds_radius-30)*Math.cos(alpha),6);
	
		//Centerpoint
		dc.setPenWidth(2);
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x,center_y,4);
		
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x,center_y,4);
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
	
		var width = dc.getWidth();
        var height  = dc.getHeight();
	
		
			var actInfo;
			//var altitudeStr;
			var highaltide = false;			
			var unknownaltitude = true;
			var actaltitude = 0;
			
			actInfo = Act.getActivityInfo();
			if (actInfo != null) {
				actaltitude = actInfo.altitude;
				if (actaltitude != null) {
					unknownaltitude = false;
					if (actaltitude > 4000) {
						highaltide = true;
					}
				} 				
			}
			var metric = Sys.getDeviceSettings().elevationUnits == Sys.UNIT_METRIC;
							
			if (unknownaltitude) {
				altitudeStr = Lang.format(" Alt unknown");
			} else {
				altitudeStr = Lang.format(" Alt $1$", [actaltitude.toLong()]);
			}
			if (metric) {
				altitudeStr = altitudeStr + " m ";
			} else {
				altitudeStr = altitudeStr + " ft ";
			}
			
       		//dc.drawText(width / 2, (height / 10 * 6.9), fontDigital, altitudeStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
	
	
	function drawBattery(dc) {
	// Draw battery -------------------------------------------------------------------------
		var width = dc.getWidth();
        var height  = dc.getHeight();
		
		var Battery = Toybox.System.getSystemStats().battery;       
        var BatteryStr = Lang.format(" $1$ % ", [Battery.toLong()]);
        var outerRad = width / 2;
        var innerRad = outerRad - 15; //Länge des Bat-Zeigers        
        var alpha, alpha2, alpha3, hand;
        
        //dc.drawText(width / 2, (height / 4 * 2.9), fontDigital, BatteryStr, Gfx.TEXT_JUSTIFY_CENTER);
       
        alpha = -2*Math.PI/100*(Battery)+Math.PI; 
        alpha2 = -2*Math.PI/100*(Battery+1.3)+Math.PI;
        alpha3 = -2*Math.PI/100*(Battery-1.3)+Math.PI;
	
		hand =        	[[outerRad + outerRad*Math.sin(alpha3), outerRad + outerRad*Math.cos(alpha3)],
						[outerRad + innerRad*Math.sin(alpha), outerRad + innerRad*Math.cos(alpha)],
						[outerRad  + outerRad*Math.sin(alpha2), outerRad + outerRad*Math.cos(alpha2)]   ];						
						

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
 		var outerRad = width / 2;
        var innerRad = outerRad - 15; //Länge des Bat-Zeigers        
        var alpha, alpha2, alpha3, hand;
        
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
       
        alpha = -2*Math.PI/100*(stepPercent)+Math.PI; 
        alpha2 = -2*Math.PI/100*(stepPercent+1.3)+Math.PI;
        alpha3 = -2*Math.PI/100*(stepPercent-1.3)+Math.PI;
	
		hand =        	[[outerRad + innerRad*Math.sin(alpha3), outerRad + innerRad*Math.cos(alpha3)],
						[outerRad + outerRad*Math.sin(alpha), outerRad + outerRad*Math.cos(alpha)],
						[outerRad + innerRad*Math.sin(alpha2), outerRad + innerRad*Math.cos(alpha2)]   ];						
		
					
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
				//distStr = distStr * 0.621371;			
			//	if (actDistance > 10) {
			//	distStr = Lang.format("$1$", [actDistance.format("%.2f")] );
			//	}
			//	if (actDistance >= 10) {
			//	distStr = Lang.format("$1$", [actDistance.format("%.1f")] );
			//	}
			//	if (actDistance >= 100) {
			//	distStr = Lang.format("$1$", [actDistance.format("%.0f")] );
			//	}
			}	
	
	} 
  

// Handle the update event-----------------------------------------------------------------------
    function onUpdate(dc) {
    
    var LDInfo = (App.getApp().getProperty("LDInfo"));
   	var LUpperInfo = (App.getApp().getProperty("LUpperInfo"));
        
        var width = dc.getWidth();
        var height  = dc.getHeight();
        var screenWidth = dc.getWidth();
        
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
        
        
        
        var timeFormat = "$1$:$2$";       
       	var now = Time.now();
        
  // Clear the screen--------------------------------------------
        //dc.setColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_TRANSPARENT));
        dc.setColor(Gfx.COLOR_TRANSPARENT, App.getApp().getProperty("BackgroundColor"));
        dc.clear();
        
        
        
   // Draw the hash marks ---------------------------------------------------------------------------
        drawHashMarks(dc);  
        
        drawQuarterHashmarks(dc);      
  
  //Draw Digital Elements ------------------------------------------------------------------
   
        dc.setColor(App.getApp().getProperty("DigitalBackgroundColor"), Gfx.COLOR_TRANSPARENT);         
        dc.fillRoundedRectangle(width / 2 -65 , height / 10 * 2.4 , 130 , 35, 5);
        dc.fillRoundedRectangle(width / 2 -65 , height / 10 * 6.5 , 130 , 35, 5);
        

 //Anzeige oberess Display--------------------------  
         dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
         var digiFont = (App.getApp().getProperty("DigiFont")); 
          
    
	    if ( digiFont == 1) { //digital
	    	fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital);
        	//fontDigital = Ui.loadResource(Rez.Fonts.id_font_classicklein);      
	    	}
	    if ( digiFont == 2) { //digital
    		//fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital);
        	fontDigital = Ui.loadResource(Rez.Fonts.id_font_classicklein);      
	    	}
	    if ( digiFont == 3) { //simple
    		//fontDigital = Ui.loadResource(Rez.Fonts.id_font_digital);
        	fontDigital = Gfx.FONT_SYSTEM_SMALL ; 
        	    
	    	}
	    	
 	//Draw DigitalTime---------------------------------
	   if (LUpperInfo == 1) {
			var info = Calendar.info(now, Time.FORMAT_LONG);
	        //var dateStr = Lang.format("$1$ $2$ $3 $4$", [info.day_of_week, info.day, ".", info.month ]);
	        var dateStr =  Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);        
			dc.drawText(width / 2, (height / 10 * 2.7 ), fontDigital, dateStr, Gfx.TEXT_JUSTIFY_CENTER); 
		}	

 	    //Draw Steps --------------------------------------
      	if (LUpperInfo == 2) {
	        var actsteps = 0;
	        var stepGoal = 0;		
			stepGoal = ActMonitor.getInfo().stepGoal;
			actsteps = ActMonitor.getInfo().steps;
	        var stepsStr = Lang.format("$1$", [actsteps]);        	
	        dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
			dc.drawText(width / 2, (height / 10 * 2.7 ), fontDigital, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);	
			dc.drawText(width / 2 + 50, (height / 10 * 2.4), Gfx.FONT_XTINY, stepGoal, Gfx.TEXT_JUSTIFY_RIGHT);
			dc.drawText(width / 2 + 50, (height / 10 * 3), Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
		
		}
		
		//Draw Steps to go --------------------------------------
      	if (LUpperInfo == 3) {
        var actsteps = 0;
        var stepGoal = 0;
        var stepstogo = 0;		
		stepGoal = ActMonitor.getInfo().stepGoal;
		actsteps = ActMonitor.getInfo().steps;
		dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
		
	        if (actsteps <= stepGoal) {
		        stepstogo = stepGoal - actsteps;
		        stepstogo = Lang.format("$1$", [stepstogo]);       
				dc.drawText(width / 2, (height / 10 * 2.7), fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
				dc.drawText(width / 2 + 50, (height / 10 * 2.4), Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
				dc.drawText(width / 2 + 50, (height / 10 * 3), Gfx.FONT_XTINY, "to go", Gfx.TEXT_JUSTIFY_RIGHT);
			}
			 if (actsteps > stepGoal) {
		        stepstogo = actsteps - stepGoal;
		        stepstogo = Lang.format("$1$", [stepstogo]);       
				dc.drawText(width / 2, (height / 10 * 2.7), fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
				dc.drawText(width / 2 + 50, (height / 10 * 2.4), Gfx.FONT_XTINY, "since", Gfx.TEXT_JUSTIFY_RIGHT);
				dc.drawText(width / 2 + 50, (height / 10 * 3), Gfx.FONT_XTINY, "goal", Gfx.TEXT_JUSTIFY_RIGHT);
			}
		}
 	//Draw DigitalTime---------------------------------
	   if (LUpperInfo == 4) {
		 drawDigitalTime(dc);
		 dc.drawText(width / 2, (height / 10 * 2.7  ), fontDigital, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
		}	         
        
		
    	// Draw Altitude------------------------------
		if (LUpperInfo == 5) {
			drawAltitude(dc);
			dc.drawText(width / 2, (height / 10 * 2.7), fontDigital, altitudeStr, Gfx.TEXT_JUSTIFY_CENTER);
		 }	
			
		// Draw Calories------------------------------
		if (LUpperInfo == 6) {	
		dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
		var actInfo = ActMonitor.getInfo(); 
        var actcals = actInfo.calories;		       
        var calStr = Lang.format(" $1$ kCal ", [actcals]);	
		dc.drawText(width / 2, (height / 10 * 2.7), fontDigital, calStr, Gfx.TEXT_JUSTIFY_CENTER);	
		}
		
		//Draw distance
		if (LUpperInfo == 7) {
			drawDistance(dc);
			dc.drawText(width / 2 + 20 , (height / 10 * 2.7), fontDigital, distStr, Gfx.TEXT_JUSTIFY_RIGHT);	
	       	//draw unit-String
			dc.drawText(width / 2 + 50, (height / 10 * 2.9), Gfx.FONT_XTINY, distUnit, Gfx.TEXT_JUSTIFY_RIGHT);
		}


 //Anzeige unteres Display--------------------------  
	   if (LDInfo == 1) {
		 var info = Calendar.info(now, Time.FORMAT_LONG);
        //var dateStr = Lang.format("$1$ $2$ $3 $4$", [info.day_of_week, info.day, ".", info.month ]);
        var dateStr =  Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);        
		dc.drawText(width / 2, (height / 10 * 6.8 ), fontDigital, dateStr, Gfx.TEXT_JUSTIFY_CENTER); 
		}	

 	    //Draw Steps --------------------------------------
      	if (LDInfo == 2) {
        var actsteps = 0;
        var stepGoal = 0;		
		stepGoal = ActMonitor.getInfo().stepGoal;
		actsteps = ActMonitor.getInfo().steps;
        var stepsStr = Lang.format("$1$", [actsteps]);        	
        dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
		dc.drawText(width / 2, (height / 10 * 6.8), fontDigital, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);	
		dc.drawText(width / 2 + 50, (height / 10 * 7.1), Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(width / 2 + 50, (height / 10 * 6.5), Gfx.FONT_XTINY, stepGoal, Gfx.TEXT_JUSTIFY_RIGHT);
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
				dc.drawText(width / 2, (height / 10 * 6.8), fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
				dc.drawText(width / 2 + 50, (height / 10 * 6.5), Gfx.FONT_XTINY, "steps", Gfx.TEXT_JUSTIFY_RIGHT);
				dc.drawText(width / 2 + 50, (height / 10 * 7.1), Gfx.FONT_XTINY, "to go", Gfx.TEXT_JUSTIFY_RIGHT);
			}
			 if (actsteps > stepGoal) {
		        stepstogo = actsteps - stepGoal;
		        stepstogo = Lang.format("$1$", [stepstogo]);       
				dc.drawText(width / 2, (height / 10 * 6.8), fontDigital, stepstogo, Gfx.TEXT_JUSTIFY_RIGHT);	
				dc.drawText(width / 2 + 50, (height / 10 * 6.5), Gfx.FONT_XTINY, "since", Gfx.TEXT_JUSTIFY_RIGHT);
				dc.drawText(width / 2 + 50, (height / 10 * 7.1), Gfx.FONT_XTINY, "goal", Gfx.TEXT_JUSTIFY_RIGHT);
			}
		
 	//Draw DigitalTime---------------------------------
	   if (LDInfo == 4) {
		 drawDigitalTime(dc);
		 dc.drawText(width / 2, (height / 10 * 6.8  ), fontDigital, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
		}	         
        
		
    	// Draw Altitude------------------------------
		if (LDInfo == 5) {
			drawAltitude(dc);
			dc.drawText(width / 2, (height / 10 * 6.8), fontDigital, altitudeStr, Gfx.TEXT_JUSTIFY_CENTER);
		 }	
			
		// Draw Calories------------------------------
		if (LDInfo == 6) {	
			dc.setColor((App.getApp().getProperty("ForegroundColor")), Gfx.COLOR_TRANSPARENT);
			var actInfo = ActMonitor.getInfo(); 
	        var actcals = actInfo.calories;		       
	        var calStr = Lang.format(" $1$ kCal ", [actcals]);	
			dc.drawText(width / 2, (height / 10 * 6.8), fontDigital, calStr, Gfx.TEXT_JUSTIFY_CENTER);	
		}	
		
		//Draw distance
		if (LDInfo == 7) {
			drawDistance(dc);
			dc.drawText(width / 2 + 20 , (height / 10 * 6.8), fontDigital, distStr, Gfx.TEXT_JUSTIFY_RIGHT);	
	       	//draw unit-String
			dc.drawText(width / 2 + 50, (height / 10 * 7), Gfx.FONT_XTINY, distUnit, Gfx.TEXT_JUSTIFY_RIGHT);
		}
		
		
		}
		
		
		
		
			
		
		drawBattery(dc);
		
		drawStepGoal(dc);

      // Draw the numbers --------------------------------------------------------------------------------------
       var NbrFont = (App.getApp().getProperty("Numbers")); 
       dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);    
    
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
	   		
	   		
	   	
//Indicators-------------------------------------------------------------	
	  //messages 	
     	var messages = Sys.getDeviceSettings().notificationCount;     	
     	if (messages > 0) {
     		dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        	dc.fillCircle(width / 2 + 30, height / 2 -5, 5);
     	}
     	dc.setPenWidth(2);
        dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(width / 2 + 30, height / 2 -5, 5);
        dc.drawText(width / 2 + 30, height / 2, Gfx.FONT_XTINY, "Msg", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 3 + 7, height / 2, Gfx.FONT_XTINY, messages, Gfx.TEXT_JUSTIFY_CENTER); 
      
	  //Alarm is set 	
     	var alarm = Sys.getDeviceSettings().alarmCount;     	
     	if (alarm > 0) {
     		dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        	dc.fillCircle(width / 2 - 30, height / 2 -5, 5);
     	}
     	dc.setPenWidth(2);
        dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(width / 2 - 30, height / 2 -5, 5);
        dc.drawText(width / 2 - 30, height / 2, Gfx.FONT_XTINY, "Alm", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(width / 3 + 7, height / 2, Gfx.FONT_XTINY, messages, Gfx.TEXT_JUSTIFY_CENTER);        
    
      
  
  
  
  
  // Draw hands ------------------------------------------------------------------         
      drawHands(dc); 
      
       if (isAwake) {
     	drawSecondHands(dc);
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
