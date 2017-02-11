using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as ActMonitor;

module distance{
		
		var distStr;
		var distUnit;

	function drawDistance() {
	// Draw Distance------------------------------  
			
			distStr = 0;
			//var highaltide = false;			
			var unknownDistance = true;
			var actDistance = 0;
			var actInfo;
			var metric = Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC;
			distUnit = "km";
			
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
			
			//Sys.println("Distance-Function" + distStr + " " + distUnit);
	
	
	}

}