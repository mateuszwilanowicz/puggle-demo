package  
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class Director 
	{
		
		private var _camera:Camera;
		private var _timeMaster:TimeMaster;
		
		private var _zoomedIn:Boolean;
		private var _minimumTimeToZoomOut:int;
		
		
		
		public function Director(camera:Camera, timeMaster:TimeMaster) 
		{
			_camera = camera;
			_timeMaster = timeMaster;
		}
		
		public function zoomIn(zoomInPoint:Point):void
		{
			if(!_zoomedIn) {
				_zoomedIn = true;
				_camera.zoomTo(zoomInPoint);
				_timeMaster.slowDown();
				_minimumTimeToZoomOut = getTimer() + 1000;
			}
		}
		
		public function backToNormal():void 
		{
			if (_zoomedIn) {
				if(getTimer() >= _minimumTimeToZoomOut) {
					_zoomedIn = false;
					_camera.zoomOut();
					_timeMaster.backToNormal();
				}
			}
		}
		
	}
	
}