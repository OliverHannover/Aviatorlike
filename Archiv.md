//Fenix 5-Hands----------------------------------------------------------
	if (HandsForm == 6) {
	//! hours---------
		alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
		alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
		r1 = 6; //Entfernung zum rechten winkel
		r2 = hour_radius * 1/3;
		r3 = hour_radius * 11/12;	
		
		
		//hour Tip			
		hand =         [[center_x+r2*Math.sin(alpha-0.18),center_y-r2*Math.cos(alpha-0.18)],
						[center_x+r3*Math.sin(alpha-0.065),center_y-r3*Math.cos(alpha-0.065)],
						[center_x+hour_radius*Math.sin(alpha),center_y-hour_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.065),center_y-r3*Math.cos(alpha+0.065)],
						[center_x+r2*Math.sin(alpha+0.18),center_y-r2*Math.cos(alpha+0.18)]  ];
						
		if (outlineEnable) {
		//outline hour tip
			dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(5);
			for (n=0; n<4; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]); 
		}
		
		//hour tip
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
									  
		//hour base
		hand =        			[[center_x+r2*Math.sin(alpha-0.22),center_y-r2*Math.cos(alpha-0.22)],
								[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
								[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
								[center_x+r2*Math.sin(alpha+0.22),center_y-r2*Math.cos(alpha+0.22)]  ];	
								
		if (outlineEnable) {
		//outline hour tip
			dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(3);
			for (n=0; n<3; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
		}
			
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand); 


		 //! minutes -------------------------------------------
		alpha = Math.PI/30.0*clockTime.min;
		alpha2 = Math.PI/30.0*(clockTime.min-15);
		r1 = 6; //Entfernung zum rechten winkel
		r2 = minute_radius * 1/3;
		r3 = minute_radius * 11/12;
		
		//minutes Tip
		hand =         [[center_x+r2*Math.sin(alpha-0.15),center_y-r2*Math.cos(alpha-0.15)],
						[center_x+r3*Math.sin(alpha-0.05),center_y-r3*Math.cos(alpha-0.05)],
						[center_x+minute_radius*Math.sin(alpha),center_y-minute_radius*Math.cos(alpha)],
						[center_x+r3*Math.sin(alpha+0.05),center_y-r3*Math.cos(alpha+0.05)],
						[center_x+r2*Math.sin(alpha+0.15),center_y-r2*Math.cos(alpha+0.15)]  ];
						
		if (outlineEnable) {
		//outline hour tip
			dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(5);
			for (n=0; n<4; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]); 
		}
		
		//minute tip
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
		for (n=0; n<4; n++) {
			dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
		}
		dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);
									  
		//minutes base
		
		hand =        			[[center_x+r2*Math.sin(alpha-0.2),center_y-r2*Math.cos(alpha-0.2)],
								[center_x+r1*Math.sin(alpha2),center_y-r1*Math.cos(alpha2)],
								[center_x-r1*Math.sin(alpha2),center_y+r1*Math.cos(alpha2)],
								[center_x+r2*Math.sin(alpha+0.2),center_y-r2*Math.cos(alpha+0.2)]  ];
		if (outlineEnable) {
		//outline hour tip
			dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(3);
			for (n=0; n<3; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
		}
										
		dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(hand);


		
		// Draw the CenterPoint
        dc.setPenWidth(2);
        dc.setColor(color1, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(width / 2, height / 2, 5);
        
        dc.setColor(color2, Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(width / 2, height / 2, 6);
		}