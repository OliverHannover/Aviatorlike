using Toybox.System as Sys;
//using Toybox.Graphics as Gfx;
using Toybox.Application as App;
//using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;

module date{
		//date
		var dateStr;
		var dayWeekStr;
		var now = Time.now();
		var info = Calendar.info(now, Time.FORMAT_LONG);
		var infoShort = Calendar.info(now, Time.FORMAT_SHORT);
		//Sys.println("dateFormat = " + dateFormat); 

 	//DateString -----------------------------------------------------------------------
	function buildDateString(dc) {
	
		var dateFormat = (App.getApp().getProperty("DateFormat"));			
    
		
		if (dateFormat == 1) {
        dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.day, info.month ]);
        }        
        if (dateFormat == 2) {
        dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);  
 		}
 		if (dateFormat == 3) {
 		info = Calendar.info(now, Time.FORMAT_SHORT);
        dateStr = Lang.format("$1$.$2$.$3$", [info.day, info.month, info.year]);  
 		}
 		if (dateFormat == 4) {
 		info = Calendar.info(now, Time.FORMAT_SHORT);
         dateStr = Lang.format("$1$-$2$-$3$", [info.year, info.month, info.day]);  
 		}
 		if (dateFormat == 5) {
 		info = Calendar.info(now, Time.FORMAT_SHORT);
        dateStr = Lang.format("$1$/$2$/$3$", [info.day, info.month, info.year]);  
 		}
 		if (dateFormat == 6) {
 		info = Calendar.info(now, Time.FORMAT_SHORT);
        dateStr = Lang.format("$1$/$2$/$3$", [info.month, info.day, info.year]); 
 		}
 
  	}
  	
  	
  	//Converts a calendar date to a Julian Day.------------------------
  	function julian_day(year, month, day)		
	{
		var a = (14 - month) / 12;
		var y = (year + 4800 - a);
		var m = (month + 12 * a - 3);
		return day + ((153 * m + 2) / 5) + (365 * y) + (y / 4) - (y / 100) + (y / 400) - 32045;
	}
	
	
	//check if its leap year -------------------------------------		
	function is_leap_year(year)		
		{
		if (year % 4 != 0) {
			return false;
		}
		else if (year % 100 != 0) {
			return true;
		}
		else if (year % 400 == 0) {
			return true;
		}
		return false;
	}

	//calcultae the ISO-Week number ------------------------------
	function iso_week_number(year, month, day)
	{
		var first_day_of_year = julian_day(year, 1, 1);
		var given_day_of_year = julian_day(year, month, day);
		
		var day_of_week = (first_day_of_year + 3) % 7; // days past thursday
		var week_of_year = (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;
		
		// week is at end of this year or the beginning of next year
		if (week_of_year == 53) {
		
			if (day_of_week == 6) {
				return week_of_year;
				}
				else if (day_of_week == 5 && is_leap_year(year)) {
				return week_of_year;
				}
				else {
				return 1;
			}
		}

		// week is in previous year, then try again under last year (-!)
		else if (week_of_year == 0) {
		first_day_of_year = julian_day(year - 1, 1, 1);		
		day_of_week = (first_day_of_year + 3) % 7;
		return (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;
		}
		
		// any old week of the year
		else {
		return week_of_year;
		}
	}

	function builddayWeekStr() {
	
		var dayNow = julian_day(infoShort.year, infoShort.month, infoShort.day);
		var firstDay = julian_day(infoShort.year, 1, 1);
		var aktDay = dayNow - firstDay + 1;	//day of year (julianisch)
		var week = date.iso_week_number(infoShort.year, infoShort.month, infoShort.day);	//week of year	
		dayWeekStr = aktDay + " / " + week;
		
	
	}


}