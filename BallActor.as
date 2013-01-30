package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class BallActor extends Actor
	{
		private static const BALL_DIAMETER:int = 12;
		
		public function BallActor(parent:DisplayObjectContainer, location:Point, initVel:Point)
		{
			// First create the costume
			var ballSprite:Sprite = new BallSprite();
			ballSprite.scaleX = BALL_DIAMETER / ballSprite.width;
			ballSprite.scaleY = BALL_DIAMETER / ballSprite.height;
			parent.addChild(ballSprite);
			
			// Create the shape definition
			var ballShapeDef:b2CircleDef = new b2CircleDef();
			ballShapeDef.radius = BALL_DIAMETER / 2 / Const.RATIO;
			ballShapeDef.density = 1.5;
			ballShapeDef.friction = 0.0;
			ballShapeDef.restitution = 0.45;
						
			// Create the body definition (specify the location here)
			var ballBodyDef:b2BodyDef = new b2BodyDef();
			ballBodyDef.position.Set(location.x / Const.RATIO, location.y / Const.RATIO);
			ballBodyDef.isBullet = true;			
			
			
			// Create the body
			var ballBody:b2Body = Const.world.CreateBody(ballBodyDef);
						
			// Create the shape
			ballBody.CreateShape(ballShapeDef);
			ballBody.SetMassFromShapes();
			
			// Set the velocity to match the parameter
			var velocityVector:b2Vec2 = new b2Vec2( initVel.x / Const.RATIO, initVel.y / Const.RATIO);
			ballBody.SetLinearVelocity(velocityVector);
			
			super(ballBody, ballSprite);
		
			
			
		}
		
		public function hitBonusTarget():void
		{
			dispatchEvent(new BallEvent(BallEvent.BALL_HIT_BONUS));
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (_costume.y > _costume.stage.stageHeight) {
				dispatchEvent(new BallEvent(BallEvent.BALL_OFF_SCREEN));
			}
			
			super.childSpecificUpdating();
		}
		
	}
	
}