using Toybox.Graphics as Gfx;
using Toybox.Application as App;

using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;


module extrasMoon{
	var moon;

	function drawMoon(dc,moonx, moony, moonwidth) {
	// Draw moon ------------------------------------------------------------------------------
		moon = new Moon(Ui.loadResource(Rez.Drawables.moon), moonwidth, moonx, moony);
		
		var time_sec = Time.now();
		var dateinfo = Calendar.info(time_sec, Time.FORMAT_SHORT);
       	var clockTime = Sys.getClockTime();
		moon.updateable_calcmoonphase(dc, dateinfo, clockTime.hour);
		
		
  		dc.setColor((App.getApp().getProperty("QuarterNumbersColor")), Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(1);	   
 		dc.drawCircle(moonx+moonwidth/2,moony+moonwidth/2,moonwidth/2-1);
		//Sys.println("MoonCircle"); 
		
		//dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		//dc.drawText(180,125, Ui.loadResource(Rez.Fonts.id_font_label), moon.c_moon_label, Gfx.TEXT_JUSTIFY_CENTER);
		//dc.drawText(180,135, Ui.loadResource(Rez.Fonts.id_font_label), moon.c_phase, Gfx.TEXT_JUSTIFY_LEFT);
	}
}