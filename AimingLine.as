package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class AimingLine extends Sprite
	{
		private var _gravityInMeters:Number;
		
		public function AimingLine(gravityInMeters:Number) 
		{
			_gravityInMeters = gravityInMeters;
		}
		
		public function showLine(startPoint:Point, direction:Point, velocityInPixels:Number):void
		{
			// This is going to be the vertor that our ball will be traveling, in pixels
			var velocityVect:Point = direction.clone();
			
			// Our velocity is the correct length, in pixels per second
			velocityVect.normalize(velocityInPixels);
			
			var gravityInPixels:Number = Const.toPixels(_gravityInMeters);
			
			var stepPoint:Point = startPoint.clone();
			
			this.graphics.clear();
			this.graphics.lineStyle(11, 0x669966, .4);
			this.graphics.moveTo(stepPoint.x, stepPoint.y);
			
			// The setps per second that we're going to draw
			var granularity:Number = 20;
			for (var i:int = 0; i < granularity; i++) {
				velocityVect.y += gravityInPixels / granularity;
				stepPoint.x += velocityVect.x / granularity;
				stepPoint.y += velocityVect.y / granularity;
				
				this.graphics.lineTo(stepPoint.x, stepPoint.y);
			}
		}
		
		public function hide():void 
		{
			this.graphics.clear();
		}
	}
	
}