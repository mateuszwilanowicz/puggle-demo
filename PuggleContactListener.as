package  
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2ContactListener;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class PuggleContactListener extends b2ContactListener
	{
		
		public function PuggleContactListener() 
		{
			
		}
		
		override public function Add(point:b2ContactPoint):void 
		{
			//trace("Pow!");
			
			if (point.shape1.GetBody().GetUserData() is PegActor && point.shape2.GetBody().GetUserData() is BallActor) {
			
				PegActor(point.shape1.GetBody().GetUserData()).hitBtBall();
				PegActor(point.shape1.GetBody().GetUserData()).setCollisionInfo(point.shape2.GetBody().GetLinearVelocity(), point.shape2.GetBody().GetMass(), new b2Vec2(point.normal.x * -1, point.normal.y * -1));
				
			} else if (point.shape1.GetBody().GetUserData() is BallActor && point.shape2.GetBody().GetUserData() is PegActor) {
				
				PegActor(point.shape2.GetBody().GetUserData()).hitBtBall();
				PegActor(point.shape2.GetBody().GetUserData()).setCollisionInfo(point.shape1.GetBody().GetLinearVelocity(), point.shape1.GetBody().GetMass(), point.normal);
				
			} else if (point.shape1.GetUserData() is String && String(point.shape1.GetUserData()) == BonusChuteActor.BONUS_TARGET && point.shape2.GetBody().GetUserData() is BallActor) {
				
				BallActor(point.shape2.GetBody().GetUserData()).hitBonusTarget();

			} else if (point.shape2.GetUserData() is String && String(point.shape2.GetUserData()) == BonusChuteActor.BONUS_TARGET && point.shape1.GetBody().GetUserData() is BallActor) {
				
				BallActor(point.shape1.GetBody().GetUserData()).hitBonusTarget();
				
			} 
			
			super.Add(point);
		}
		
	}
	
}