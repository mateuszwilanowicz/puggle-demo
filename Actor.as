package  
{
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class Actor extends EventDispatcher
	{
		
		protected var _body:b2Body;
		protected var _costume:DisplayObject;
		
		public function Actor(myBody:b2Body, myCostume:DisplayObject) 
		{
			_body = myBody;
			_body.SetUserData(this);
			_costume = myCostume;
			
			updateMyLook();
		}
		
		public function updateNow():void
		{
			if (!_body.IsStatic()) {
				updateMyLook();
			}
			childSpecificUpdating();
			
		}
		
		protected function childSpecificUpdating():void
		{
			// This function does nothinf
			// I expect it to be called by my children
			
		}
		
		public function destroy():void
		{
			// Remove event litenters, misc cleanup
			cleanUpBeforeRemoving();
			
			// Remove the costume sprite from display
			_costume.parent.removeChild(_costume);
			
			//	Destroy body
			Const.world.DestroyBody(_body);
		}
		
		public function getSpriteLoc():Point 
		{
			return new Point(_costume.x, _costume.y);
		}
		
		private function cleanUpBeforeRemoving():void
		{
			// This function doses nothing
			// Overwirtten by my children
		}
		
		private function updateMyLook():void
		{
			_costume.x = _body.GetPosition().x * Const.RATIO;
			_costume.y = _body.GetPosition().y * Const.RATIO;
			_costume.rotation = _body.GetAngle() * 180 / Math.PI;
		}
		
	}
	
}