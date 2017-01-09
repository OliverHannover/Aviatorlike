using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Math as Math;

module hands{
  //Variablen für die analoge Uhr   
  // the x coordinate for the center
    var center_x;
    // the y coordinate for the center
    var center_y;    
    
    var clockTime;

 // Draw hands ------------------------------------------------------------------
  function drawHands(dc) {        
          // the length of the minute hand
   		var minute_radius;
    	// the length of the hour hand
    	var hour_radius; 
    	
    	var width = dc.getWidth();
        var height  = dc.getHeight();
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
        
        // the minute hand to be 7/8 the length of the radius
        minute_radius = 7/8.0 * center_x;
        // the hour hand to be 2/3 the length of the minute hand
        hour_radius = 3/4.0 * minute_radius;
  				
		var HandsForm = (App.getApp().getProperty("HandsForm"));
		var color1 = (App.getApp().getProperty("HandsColor1"));
		var color2 = (App.getApp().getProperty("HandsColor2"));
		var n;
		
		clockTime = Sys.getClockTime();
		//Sys.println("clockTime hour = " + clockTime.hour);
		//Sys.println("clockTime min = " + clockTime.min);
       
        
        var alpha, alpha2, r0, r1, r2, r3, hand, hand1;	
			
			
         //Race-Hands-----------------	
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

	//Pilot-Hands----------------------------------------------------------
	if (HandsForm == 2) {
	//! hours---------
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
		
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
	
						
		hand =         [//[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
						//[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
						[center_x+r2*Math.sin(alpha-0.32),center_y-r2*Math.cos(alpha-0.32)],
						[center_x+r3*Math.sin(alpha-0.2),center_y-r3*Math.cos(alpha-0.2)],
						[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.2),center_y-r3*Math.cos(alpha+0.2)],
						[center_x+r2*Math.sin(alpha+0.32),center_y-r2*Math.cos(alpha+0.32)]  ];
						//[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
						//[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]			 
		
		
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
            


		 //! minutes --------------------------
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
		
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);

		
		hand =         [//[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],
						//[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
						[center_x+r2*Math.sin(alpha-0.35),center_y-r2*Math.cos(alpha-0.35)],
						[center_x+r3*Math.sin(alpha-0.15),center_y-r3*Math.cos(alpha-0.15)],
						[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.15),center_y-r3*Math.cos(alpha+0.15)],
						[center_x+r2*Math.sin(alpha+0.35),center_y-r2*Math.cos(alpha+0.35)]  ];
						//[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)]
						//[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]			   					
						
        //dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		//dc.fillPolygon(hand);
		
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
		
		
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
				
			//draw the filled target on top			
			r1 = width/2 - 70; //inside
			var thicknes = 0.25;
	 									
				hand =     [[center_x+r1*Math.sin(alpha-thicknes),center_y-r1*Math.cos(alpha-thicknes)],
							[center_x+(hour_radius)*Math.sin(alpha),center_y-(hour_radius)*Math.cos(alpha)],
							[center_x+r1*Math.sin(alpha+thicknes),center_y-r1*Math.cos(alpha+thicknes)]   ];
																	
			dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
			dc.fillPolygon(hand);

			//outline for target
			dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(4);
			var n;		
			for (n=0; n<2; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
			
			//Sys.println("%%.2f='" + alpha.format("%.2f") + "'");
			
			//rectangle on bottom 
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
		dc.setPenWidth(1);
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(center_x,center_y,7);
		
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		dc.drawCircle(center_x,center_y,6);
		
	}// End of if (HandsForm Diver)		
		
	//Classic-Hands----------------------------------
		if (HandsForm == 4) {
		// houres
		alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
		
//!nur zum Test----------------
//alpha = Math.PI/6*(1.0*20);
//alpha2 = Math.PI/6*(1.0*20-3);
//!-----------------------------
		
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
		
		r0 = -30;
		r1 = 20;
		r2 = 45;
		
		dc.drawLine(center_x+22*Math.sin(alpha-0.3),center_y-22*Math.cos(alpha-0.3),center_x+22*Math.sin(alpha+0.3),center_y-22*Math.cos(alpha+0.3));
				
		hand =        	[
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],						
						[center_x+r1*Math.sin(alpha+0.15),center_y-r1*Math.cos(alpha+0.15)],
						[center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha-0.15),center_y-r1*Math.cos(alpha-0.15)],						
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];	
						
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);	
		
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
		
		
		
		// minutes
		alpha = Math.PI/30.0*clockTime.min;
		
//!nur zum Test MINUTEN--------
//alpha = Math.PI/30.0*05;
//alpha2 = Math.PI/30.0*(05-15);
//!-----------------------------
		
		r0 = 35;
		r1 = 55; //Entfernung zum rechten winkel
		r2 = 70;
		
		//outer raute
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
		
		r0 = -30;
		r1 = 25;
		r2 = 60;
		
		dc.drawLine(center_x+35*Math.sin(alpha-0.2),center_y-35*Math.cos(alpha-0.2),center_x+35*Math.sin(alpha+0.2),center_y-35*Math.cos(alpha+0.2));
		
		
		//inner Raute		
		hand =        	[
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)],						
						[center_x+r1*Math.sin(alpha+0.14),center_y-r1*Math.cos(alpha+0.14)],
						[center_x+r2*Math.sin(alpha),center_y-r2*Math.cos(alpha)],
						[center_x+r1*Math.sin(alpha-0.14),center_y-r1*Math.cos(alpha-0.14)],						
						[center_x+r0*Math.sin(alpha),center_y-r0*Math.cos(alpha)]	];	
						
		dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);
			
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);		
	
		// Draw the CenterPoint
        dc.setPenWidth(1);
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(width / 2, height / 2, 7);
        
       	dc.setColor(color1, Gfx.COLOR_BLACK);
        dc.drawCircle(width / 2, height / 2, 7);		
		
		}	
		
	//Simple-Hands----------------------------------------	
		if (HandsForm == 5) { 	
			// houres
			alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
			alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
	 													
			//rectangle 
			r2 = 3; //Breite im Zentrum
			var thicknes = 0.04; //Breite oben

			hand =        	[[center_x-20*Math.sin(alpha-0.2),center_y+20*Math.cos(alpha-0.2)],
							[center_x-20*Math.sin(alpha+0.2),center_y+20*Math.cos(alpha+0.2)],
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
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
        
        //seconds_radius = 7/8.0 * center_x;
		seconds_radius = height / 2 ; // wegen semiround halbe höhe
		
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



}