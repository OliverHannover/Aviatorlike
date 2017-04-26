using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

// By using updateable_calcmoonphase, the moon phase picture will be drawn, 
// but it will be only recomputed once a day.
class Moon {
	var moon_width;
	var moon_bitmap;
	var moonx, moony;
	
	var c_phase, t_phase; // day of month when last updated
	var c_moon_label, c_moon_y; // y1, y2, y1, y2, ... for the moon shadow

    function initialize(bitmap, width, x, y) {
		moon_bitmap = bitmap; // Ui.loadResource(Rez.Drawables.moon);
		moon_width = width;
		moonx = x;
		moony = y;
		t_phase = -1;
	}	
		
	
    function calcmoonphase(day, month, year) {
	    var r = (year % 100);
		r = (r % 19);
	    if (r>9) { 
	        r = r - 19;
	    }
		r = ((r * 11) % 30) + month + day;
	    if (month<3) {
	        r = r + 2;
	    }
	    r = 1.0*r - 8.3 + 0.5;
		r = (r.toNumber() % 30);
	    if (r < 0) {
	        r = r + 30;
	    }
	    return r;
    }
    function updateable_calcmoonphase(dc, dateinfo, hour) {
    	if (t_phase != dateinfo.day) {
    		t_phase = dateinfo.day;

    		c_phase = calcmoonphase(dateinfo.day , dateinfo.month, dateinfo.year);
			if (hour > 12) { // change it at noon
				c_phase = (c_phase + 1) % 30;
			}

			calc_drawmoon(c_phase);// updates c_moon_label and c_moon_y

    	}
    	
    	drawmoon(dc, moonx, moony); // uses c_moon_y
    	
   		return c_phase;
    }

	function drawmoon(dc, moonx, moony) {
        dc.drawBitmap(moonx, moony, moon_bitmap);
		var x, xby2;
		var BGColor=0xffffff;
        	
        BGColor=App.getApp().getProperty("BackgroundColor");
        if (BGColor==0x000001) {
        		BGColor=App.getApp().getProperty("BackgroundColorR")+App.getApp().getProperty("BackgroundColorG")+App.getApp().getProperty("BackgroundColorB");
        	}
		dc.setColor(BGColor, Gfx.COLOR_TRANSPARENT);
        //dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);
        dc.setPenWidth(1);
		for (x=1; x<moon_width; x++) {
			xby2 = x*2;
			if (c_moon_y[xby2] >= 0) {
				dc.drawLine(moonx+x, moony+c_moon_y[xby2], moonx+x, moony+c_moon_y[xby2+1]);
			} else {
				dc.drawLine(moonx+x, moony+1, moonx+x, moony-c_moon_y[xby2]);
				dc.drawLine(moonx+x, moony-c_moon_y[xby2+1], moonx+x, moony+moon_width);
			}
		}
		//Sys.println(" Ende-------" + c_moon_y);
	}

	function calc_drawmoon(moonphase) {
		var mw = moon_width; // image width
		var c = mw/2; // image center
		var intc = c.toNumber();
		var r = (mw-2)*0.5-0.5; // radius depends on image
		c_moon_label = "";
		var step = 1;
		var r1edge= -1;
		var rSedge= 0;
		var r1rest= -1;
		var rSrest= 0; 
		var edgelight = false;
		if (moonphase <= 8) {
      		c_moon_label = "wax.";
			r1edge = intc; rSedge = step;
			r1rest = intc; rSrest = -step;
			edgelight = true;
			if (moonphase == 8) {
				r1edge = -1; rSedge = 0;
			} else {
				if (moonphase == 0) {
					c_moon_label = "new";
				}
			}
		} else {
			if (moonphase <=16) {
	      		c_moon_label = "wax.";
				r1rest = -1; rSrest = 0;
				r1edge = intc; rSedge = -step;
				edgelight = false;
				if (moonphase == 16) {
		      		c_moon_label = "full";
					r1edge = -1; rSedge = 0;
				}
			} else {
	      		c_moon_label = "wan.";
				if (moonphase <=23) {
					r1rest = -1; rSrest = 0;
					r1edge = intc; rSedge = step;
					edgelight = false;
					if (moonphase == 23) {
						r1edge = -1; rSedge = 0;
						r1rest = intc; rSrest = step;
					}
				} else {
					r1edge = intc; rSedge = -step;
					r1rest = intc; rSrest = step;
					edgelight = true;
				}
			}
		} 	
		
		var a;
		if (moonphase > 16) {
			a = 1.0 - (moonphase - 16.0) / 7.0;
		} else {
			a = 1.0 - moonphase/8.0;
		}
		
		
		c_moon_y = new [mw*2+2];
		var i;
		for (i = 0; i<mw*2; i++) {
			c_moon_y[i] = 0;
		}
		
		var x, xx, ra, sq, y1, y2, xby2;
		for (x=r1rest; x<=mw && x>=1; x+=rSrest) {
			//dc.drawLine(moonx+x, moony+1, moonx+x, moony+mw);
			xby2 = 2*x;
			c_moon_y[xby2] = 1; 
			c_moon_y[xby2+1] = mw; 
		}
		for (x=r1edge; x<=mw && x>=1; x+=rSedge) {
			xx = (x-c)/a;
			ra = r*r - xx*xx;
			xby2 = 2*x;
			
			if (ra > 0) {
				sq = Math.sqrt(ra);
				y1 = c - sq + 0.5;
				y1 = y1.toNumber();
				y2 = c + sq + 0.5;
				y2 = y2.toNumber();
				if (edgelight) {
//					dc.drawLine(moonx+x, moony+y1, moonx+x, moony+y2);
					c_moon_y[xby2] = y1; 
					c_moon_y[xby2+1] = y2; 
				} else {
					//dc.drawLine(moonx+x, moony+1, moonx+x, moony+y1);
					//dc.drawLine(moonx+x, moony+y2, moonx+x, moony+mw);
					c_moon_y[xby2] = -y1; 
					c_moon_y[xby2+1] = -y2; 
				}
			} else {
				if (!edgelight) {
//					dc.drawLine(moonx+x, moony+1, moonx+x, moony+mw);
					c_moon_y[xby2] = 1; 
					c_moon_y[xby2+1] = mw; 
				}
			}
		}
		
		return c_moon_label;
	}


}
