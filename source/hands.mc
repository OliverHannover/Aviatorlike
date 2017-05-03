using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Math as Math;
using Toybox.System as Sys;

module hands{

 // Draw hands ------------------------------------------------------------------
  function drawHands(dc) { 
      	var center_x;
   		var center_y;
   		var width = dc.getWidth();
        var height  = dc.getHeight();
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
   		        
    	var clockTime;
    	var screenShape = 1;
           
          // the length of the minute hand
   		var minute_radius = 0;
    	// the length of the hour hand
    	var hour_radius; 
    	       
        // the minute hand to be 7/8 the length of the radius
	 	screenShape = Sys.getDeviceSettings().screenShape; 
        if (screenShape == 1) {  // round 
        	minute_radius = 7/8.0 * center_x;
        }
        if (screenShape == 2) {  // semi round 
        	minute_radius = 7/8.0 * center_x -5;
        }        
        // the hour hand to be 2/3 the length of the minute hand
        hour_radius = 3/4.0 * minute_radius;
  				
		var HandsForm = (App.getApp().getProperty("HandsForm"));
		var color1 = (App.getApp().getProperty("HandsColor1"));
		var color2 = (App.getApp().getProperty("HandsColor2"));
		var outlineColor = (App.getApp().getProperty("HandsOutlineColor"));
		var outlineEnable = (App.getApp().getProperty("HandOutlinesEnable"));
		var x, n;
		var maxRad;
		var alpha, alpha2; 
		var r0, r1, r2, r3, r4, r5, r6, r7, hand, hand1;
		var deflec1, deflec2, deflec3;
		var reverseMultiplier= App.getApp().getProperty("Reverse") ? -1 : 1 ;// { reverseMultiplier=-1;}
		
		clockTime = Sys.getClockTime();
		//Sys.println("clockTime hour = " + clockTime.hour);
		//Sys.println("clockTime min = " + clockTime.min);
		
		//! only for screenshots!
		//clockTime.hour = 9;
		//clockTime.min = 00;
			
         //Race-Hands-----------------	
		if (HandsForm == 1) { 	
				// hours
				alpha = reverseMultiplier*Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
				alpha2 = alpha-.5*Math.PI;//reverseMultiplier*Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
				maxRad = hour_radius;				
				r1 = -20;
				r2 = 12;
							
			//first round houre, next round minute	
			for (x=0; x<2; x++) {	
												
					hand =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
									[center_x+maxRad*Math.sin(alpha),center_y-maxRad*Math.cos(alpha)],
									[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
									
					hand1 =        	[[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
									[center_x+maxRad*Math.sin(alpha),center_y-maxRad*Math.cos(alpha)],
									[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)]   ];
													
			        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
					dc.fillPolygon(hand);				
					dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
					dc.fillPolygon(hand1);
				
				
					if (outlineEnable) {
						hand =     [[center_x+r1*Math.sin(alpha),center_y-r1*Math.cos(alpha)],
									[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)],
									[center_x+maxRad*Math.sin(alpha),center_y-maxRad*Math.cos(alpha)],							
									[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)]   ];
				
						dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
						dc.setPenWidth(1);
						for (n=0; n<3; n++) {
							dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
						}
						dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]); 
					}			
			
					 // minutes----------------------------------------------
					alpha = reverseMultiplier*Math.PI/30.0*clockTime.min;
					alpha2 = alpha-Math.PI/2;//Math.PI/30.0*(clockTime.min-15);
					maxRad = minute_radius;
				}
			}// End of if (HandsForm == 1)		

	//Pilot-Hands----------------------------------------------------------
	if (HandsForm == 2 || HandsForm == 6) {
		alpha = reverseMultiplier*Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
		alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
		maxRad = hour_radius;
		var penWide1;
		var penWide2;
		
		//Pilot settings
		r0 = -30;
		r1 = 9; //Entfernung zum rechten winkel
		r2 = minute_radius * 2.5/10;  //Höhe Mittelbalken
		r3 = hour_radius * 5/7;
		deflec1 = 0.32; 
		deflec2 = 0.2;
		deflec3 = 0.47; //width of base
		penWide1 = 6;
		penWide2 = 4;

		if (HandsForm == 6) { //for Fenix5like
			r0 = 0;
			r1 = 6.5; //Entfernung zum rechten winkel
			r2 = minute_radius * 1/3;
			r3 = hour_radius * 11/12;
			deflec1 = 0.15; 
			deflec2 = 0.07;
			deflec3 = 0.2; //width of base
			penWide1 = 5;
			penWide2 = 3;
		}	
					
			
			//first round houre, next round minute	
			for (x=0; x<2; x++) {
				
				//Tip -------------------			
				hand =         [[center_x+r2*Math.sin(alpha-deflec1),center_y-r2*Math.cos(alpha-deflec1)],
								[center_x+r3*Math.sin(alpha-deflec2),center_y-r3*Math.cos(alpha-deflec2)],
								[center_x+maxRad*Math.sin(alpha),center_y-maxRad*Math.cos(alpha)],
								[center_x+r3*Math.sin(alpha+deflec2),center_y-r3*Math.cos(alpha+deflec2)],
								[center_x+r2*Math.sin(alpha+deflec1),center_y-r2*Math.cos(alpha+deflec1)]  ];
		
				//base -------------------
				hand1 =        	[[center_x+r2*Math.sin(alpha-deflec3),center_y-r2*Math.cos(alpha-deflec3)],
								[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
								[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
								[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
								[center_x+r2*Math.sin(alpha+deflec3),center_y-r2*Math.cos(alpha+deflec3)]  ];
				

				
				if (outlineEnable) {
				//outline tip
					dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
					dc.setPenWidth(penWide1);
					for (n=0; n<4; n++) {
						dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
					}
					dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]); 
				}
								
				// polygon base									
		        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand1);
		
				//tip
		        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		        dc.setPenWidth(penWide2);
				for (n=0; n<4; n++) {
					dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
				}
				dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);    
				
				if (outlineEnable) {
					//outline base
					dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
		        	dc.setPenWidth(1);
					for (n=0; n<4; n++) {
						dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
					}
		       	}
				//! minutes settings -------------------------------------------
				//Stand. for Pilot 
				alpha = reverseMultiplier*Math.PI/30.0*clockTime.min;
				alpha2 = Math.PI/30.0*(clockTime.min-15);
				maxRad = minute_radius;
		//		r2 = minute_radius * 2.5/10;
				r3 = minute_radius * 7.5/10;
				deflec1 = 0.35; //tip
				deflec2 = 0.15;	//Tip
		//		deflec3 = 0.47; //base
				
				if (HandsForm == 6) {  //for Fenix5like
		//			r2 = minute_radius * 1/3;
					r3 = minute_radius * 11/12;
					deflec1 = 0.15; 
					deflec2 = 0.055;
		//			deflec3 = 0.2; //width of base
				}		       	
			} //end for x 
		}
		
	
		//Diver-Hands----------------------------------------	
		if (HandsForm == 3) { 	
			//! houres------------------------------------------
			alpha = reverseMultiplier*Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
			alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
			maxRad = hour_radius;			
			r1 = hour_radius * 6/10; // höhe des Querbalkens
			deflec1 = 0.25; //wide of middle part
			r2 = 3;
	
			
			//first round houre, next round minute	
			for (x=0; x<2; x++) {			
					//rectangle on bottom 
					hand1 =        	[[center_x+r2*Math.sin(alpha2),center_y-r2*Math.cos(alpha2)],
									[center_x+r1*Math.sin(alpha-deflec1),center_y-r1*Math.cos(alpha-deflec1)],
									[center_x+r1*Math.sin(alpha+deflec1),center_y-r1*Math.cos(alpha+deflec1)],
									[center_x-r2*Math.sin(alpha2),center_y+r2*Math.cos(alpha2)]   ];
				
					//triangle at tip	 									
					hand =    		[[center_x+r1*Math.sin(alpha-deflec1),center_y-r1*Math.cos(alpha-deflec1)],
									[center_x+maxRad*Math.sin(alpha),center_y-maxRad*Math.cos(alpha)],
									[center_x+r1*Math.sin(alpha+deflec1),center_y-r1*Math.cos(alpha+deflec1)]   ];	
				
				
					//outline around at tip
					if (outlineEnable) {
						dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
						dc.setPenWidth(6);
						for (n=0; n<2; n++) {
							dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
						}
					}
		
					// outline for rectangle on bottom 						
					if (outlineEnable) {
						dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
						dc.setPenWidth(6);
						for (n=0; n<3; n++) {
							dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
						}
					}						
					//rectangle on bottom 
					dc.setColor(color2, Gfx.COLOR_TRANSPARENT);						
					dc.setPenWidth(4);
					for (n=0; n<3; n++) {
						dc.drawLine(hand1[n][0], hand1[n][1], hand1[n+1][0], hand1[n+1][1]);
					}
					dc.drawLine(hand1[n][0], hand1[n][1], hand1[0][0], hand1[0][1]);
		
			
					//tip polygon
					dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
					dc.fillPolygon(hand);
		
					//outline for tip
					dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
					dc.setPenWidth(4);	
					for (n=0; n<2; n++) {
						dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
					}
					dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
			        
				//! minutes-------------------------------------------------------
				alpha = reverseMultiplier*Math.PI/30.0*clockTime.min;
				alpha2 = Math.PI/30.0*(clockTime.min-15);
				maxRad = minute_radius;
				r1 = minute_radius * 6.5/10; // höhe des Querbalkens
				deflec1 = 0.16;					
				r2 = 4;				
			}		
	}// End of if (HandsForm Diver)		
		
	//Classic-Hands----------------------------------
		if (HandsForm == 4) {
			alpha = reverseMultiplier*Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);	
			//Tip raute	
			r0 = 20;
			r1 = 40; //Entfernung zum rechten winkel
			r2 = 55;
			deflec1 = 0.2;
			deflec2 = 0.03;
			deflec3 = 0.15; //base
					
			r4 = 22; //crossbar
			//hand base
			r5 = -30;
			r6 = 20;
			r7 = 45;
			maxRad = hour_radius;
			
			//first round houre, next round minute	
			for (x=0; x<2; x++) {		
				//tip
				hand =        	[[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
								[center_x+r1*Math.sin(alpha+deflec1),center_y-r1*Math.cos(alpha+deflec1)],						
								[center_x+r2*Math.sin(alpha+deflec2),center_y-r2*Math.cos(alpha+deflec2)],
								[center_x+maxRad*Math.sin(alpha),center_y-maxRad*Math.cos(alpha)],
								[center_x+r2*Math.sin(alpha-deflec2),center_y-r2*Math.cos(alpha-deflec2)],						
								[center_x+r1*Math.sin(alpha-deflec1),center_y-r1*Math.cos(alpha-deflec1)],
								[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];
													
		        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		        dc.setPenWidth(3);
				for (n=0; n<6; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
				}

				dc.drawLine(center_x+r4*Math.sin(alpha-0.3),center_y-r4*Math.cos(alpha-0.3),center_x+r4*Math.sin(alpha+0.3),center_y-r4*Math.cos(alpha+0.3));
		
				hand =        	[
								[center_x+r5*Math.sin(alpha),center_y-r5*Math.cos(alpha)],						
								[center_x+r6*Math.sin(alpha+deflec3),center_y-r6*Math.cos(alpha+deflec3)],
								[center_x+r7*Math.sin(alpha),center_y-r7*Math.cos(alpha)],
								[center_x+r6*Math.sin(alpha-deflec3),center_y-r6*Math.cos(alpha-deflec3)],						
								[center_x+r5*Math.sin(alpha),center_y-r5*Math.cos(alpha)]	];	
								
				dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
				dc.fillPolygon(hand);	
				
				dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		        dc.setPenWidth(1);
				for (n=0; n<4; n++) {
					dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
				}
				dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);		
		
				//! minutes
				alpha = reverseMultiplier*Math.PI/30.0*clockTime.min;
				maxRad = minute_radius;		
				r0 = 35;
				r1 = 55; //Entfernung zum rechten winkel
				r2 = 70;
				deflec1 = 0.13;
				deflec2 = 0.04;
				deflec3 = 0.14; //base
						
				r4 = 35; //crossbar
				//hand base
				r5 = -30;
				r6 = 25;
				r7 = 60;
				
			}		
		}	
		
	//Simple-Hands----------------------------------------	
		if (HandsForm == 5) { 	
			// houres
			alpha = reverseMultiplier*Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
			alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
			maxRad = hour_radius;	 													
			deflec1 = 4.5; // hour hand half width in pixels
			deflec2 = 20; //short side of hand length
			var sin=Math.sin(alpha);
			var cos=Math.cos(alpha);	
			
			
				for (x=0; x<2; x++) {
					hand =        	[[center_x+(-deflec1*cos-deflec2*sin),center_y+(-deflec1*sin+deflec2*cos)],
									[center_x+(deflec1*cos-deflec2*sin),center_y+(deflec1*sin+deflec2*cos)],
									[center_x+(deflec1*cos+maxRad*sin),center_y+(deflec1*sin-maxRad*cos)],
									[center_x+(-deflec1*cos+maxRad*sin),center_y+(-deflec1*sin-maxRad*cos)] ];
									
					if (x==0) {
						dc.setColor(color1, Gfx.COLOR_TRANSPARENT);} //minute hand color
					else {
						dc.setColor(color2, Gfx.COLOR_TRANSPARENT);} //not-minute hand (hour hand) color
					dc.fillPolygon(hand);
											
					if (outlineEnable) {
					dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
					dc.setPenWidth(2);
					for (n=0; n<3; n++) {
						dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
					}
					dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
					}		
			        
					//! minutes--------------
					alpha = reverseMultiplier*Math.PI/30.0*clockTime.min;
					sin=Math.sin(alpha);
					cos=Math.cos(alpha);
					maxRad = minute_radius;			
					deflec1 = 3.5; //minute hand half width 0.15; //0.2;
					
				}		
		}// End of if (HandsForm == 5)	
				         
  }//End of drawHands(dc)
  
	



	function drawSecondHands(dc) {        
          // the length of the minute hand
        
        var color1 = (App.getApp().getProperty("SecHandsColor"));
		var color2 = 0x555555;  
        var reverseMultiplier=App.getApp().getProperty("Reverse") ? -1: 1;
		
		
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

 	  	var width = dc.getWidth();
        var height  = dc.getHeight();
        var center_x = dc.getWidth() / 2;
        var center_y = dc.getHeight() / 2;
        
        //seconds_radius = 7/8.0 * center_x;
		var seconds_radius = height / 2 ; // wegen semiround halbe höhe
		
		var n;
	
		var clockTime = Sys.getClockTime();
       	//! only for screenshots!
       	//!clockTime.sec = 10;
        
        var r1, r2, r0, hand;
		var alpha = reverseMultiplier*Math.PI/30.0*clockTime.sec;
		
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
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x,center_y,4);
		
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x,center_y,5);
}



}