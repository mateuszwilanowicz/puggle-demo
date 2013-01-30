package  
{
	import Box2D.Dynamics.b2World;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class Const 
	{ 
		
		public static const RATIO:Number = 45;
		public static const FRAME_RATE:Number = 60;
		public static const GRAVITY:Number = 7.8;
		private static var _world:b2World;
		
		public function Const() 
		{
			
		}
		
		static public function get world():b2World { return _world; }
		
		static public function set world(value:b2World):void 
		{
			_world = value;
		}
		
		static public function toMeters(val:Number):Number 
		{
			return ( val / RATIO );
		}
		
		static public function toPixels(val:Number):Number
		{
			return ( val * RATIO );
		}
		
	}
	
}