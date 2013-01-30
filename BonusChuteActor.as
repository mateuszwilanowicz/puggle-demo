package  
{
	import Box2D.Collision.b2Point;
	import Box2D.Collision.Shapes.b2PolygonDef;
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
	public class BonusChuteActor extends Actor
	{
		public static const BONUS_TARGET:String = "BonusTarget";
		
		private const TRAVEL_SPEED:int = 2;
		private var _bounds:Array;
		private var _yPos:int;
		private var _direction:int;
		
		public function BonusChuteActor(parent:DisplayObjectContainer, leftBounds:int, rightBounds:int, yPos:int) 
		{
			_bounds = [leftBounds, rightBounds];
			_yPos = yPos;
			_direction = 1;
			
			var chuteGraphic:Sprite = new BonusChuteGraphic();
			parent.addChild(chuteGraphic);
			
			var leftRamShapeDef:b2PolygonDef = new b2PolygonDef();
			leftRamShapeDef.vertexCount = 3;
			b2Vec2(leftRamShapeDef.vertices[0]).Set( - 83 / Const.RATIO, 12 / Const.RATIO);
			b2Vec2(leftRamShapeDef.vertices[1]).Set( - 59 / Const.RATIO, -8 / Const.RATIO);
			b2Vec2(leftRamShapeDef.vertices[2]).Set( - 59 / Const.RATIO, 12 / Const.RATIO);
			leftRamShapeDef.friction = 0.1;
			leftRamShapeDef.restitution = 0.6;
			leftRamShapeDef.density = 1;
			
			var rightRamShapeDef:b2PolygonDef = new b2PolygonDef();
			rightRamShapeDef.vertexCount = 3;
			b2Vec2(rightRamShapeDef.vertices[0]).Set( 83 / Const.RATIO, 12 / Const.RATIO);
			b2Vec2(rightRamShapeDef.vertices[1]).Set( 59 / Const.RATIO, 12 / Const.RATIO);
			b2Vec2(rightRamShapeDef.vertices[2]).Set( 59 / Const.RATIO, -8 / Const.RATIO);
			rightRamShapeDef.friction = 0.1;
			rightRamShapeDef.restitution = 0.6;
			rightRamShapeDef.density = 1;
			
			var centerRamShapeDef:b2PolygonDef = new b2PolygonDef();
			centerRamShapeDef.vertexCount = 4;
			b2Vec2(centerRamShapeDef.vertices[0]).Set( -59 / Const.RATIO, -8 / Const.RATIO);
			b2Vec2(centerRamShapeDef.vertices[1]).Set( 59 / Const.RATIO, -8 / Const.RATIO);
			b2Vec2(centerRamShapeDef.vertices[2]).Set( 59 / Const.RATIO, 12 / Const.RATIO);
			b2Vec2(centerRamShapeDef.vertices[3]).Set( -59 / Const.RATIO, 12 / Const.RATIO);
			centerRamShapeDef.friction = 0.1;
			centerRamShapeDef.restitution = 0.6;
			centerRamShapeDef.density = 1;
			centerRamShapeDef.isSensor = true;
			centerRamShapeDef.userData = BonusChuteActor.BONUS_TARGET;
			
			var chuteBodyDef:b2BodyDef = new b2BodyDef();
			chuteBodyDef.position.Set(( leftBounds + rightBounds) / 2 / Const.RATIO, yPos / Const.RATIO);
			chuteBodyDef.fixedRotation = true;
			
			var chuteBody:b2Body = Const.world.CreateBody(chuteBodyDef);
			chuteBody.CreateShape(leftRamShapeDef);
			chuteBody.CreateShape(rightRamShapeDef);
			chuteBody.CreateShape(centerRamShapeDef);
			chuteBody.SetMassFromShapes();
			
			
			super(chuteBody, chuteGraphic);
			
		}
		
		override protected function childSpecificUpdating():void 
		{
			/*
			if (_costume.x >= _bounds[1]) {
				_direction = -1;
			} else if (_costume.x <= _bounds[0]) {
				_direction = 1;
			}
			*/
				
			//var idealLocation:b2Vec2 = new b2Vec2(_costume.x + (_direction * TRAVEL_SPEED), _yPos);
			var idealLocation:b2Vec2 = new b2Vec2(_costume.x + _costume.mouseX, _yPos);
			
			idealLocation.x = Math.max(idealLocation.x , _bounds[0]);
			idealLocation.x = Math.min(idealLocation.x , _bounds[1]);
			
			
			var directionToTravel:b2Vec2 = new b2Vec2(idealLocation.x - _costume.x, idealLocation.y - _costume.y);
		
			// The distacne we want to travel by, in meters each frame
			directionToTravel.Multiply( 1 / Const.RATIO );
			
			// The distacne we want to travel by, in meters each seccond
			directionToTravel.Multiply( Const.FRAME_RATE );
			
			_body.SetLinearVelocity(directionToTravel);
			
			super.childSpecificUpdating();
		}
		
	}
	
}