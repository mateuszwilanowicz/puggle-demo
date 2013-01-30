package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class PegActor extends Actor
	{
		public static const NORMAL:int = 1;
		public static const GOAL:int = 2;
		
		
		//	The diamter of all the pegs, in pixels
		private static const PEG_DIAMETER:int = 22;
		
		private var _beenHit:Boolean;
		private var _pegType:int;
		private var _turnNormalWhenSafe:Boolean;
		
		private var _ballForceToApply:b2Vec2;
		
		public function PegActor(parent:DisplayObjectContainer, location:Point, type:int) 
		{
			_beenHit = false;
			_pegType = type;
			_turnNormalWhenSafe = false;
			
			// Create the costume
			var pegMovie:MovieClip = new PegMovie();
			pegMovie.scaleX = PEG_DIAMETER / 26;
			pegMovie.scaleY = PEG_DIAMETER / 26;
			parent.addChild(pegMovie);
			
			// Create the shape definition
			var pegShapeDef:b2CircleDef = new b2CircleDef();
			pegShapeDef.radius = PEG_DIAMETER / 2 / Const.RATIO;
			pegShapeDef.density = 0.0;
			pegShapeDef.friction = 0.0;
			pegShapeDef.restitution = 0.45;
			
			// Create the body definition (specify the location here)
			var pegBodyDef:b2BodyDef = new b2BodyDef();
			pegBodyDef.position.Set(location.x / Const.RATIO, location.y / Const.RATIO);
			// One other thing I'm gonna do here... byt not now
			
			// Create the body
			var pegBody:b2Body = Const.world.CreateBody(pegBodyDef);
						
			// Create the shape
			pegBody.CreateShape(pegShapeDef);
			pegBody.SetMassFromShapes();
			
			super(pegBody, pegMovie);
			
			// Set what frame the movie is going to be at
			setMyMovieFrame();
			
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (_turnNormalWhenSafe == true) {
				turnNormal();
				_turnNormalWhenSafe = false;
			}
			
			super.childSpecificUpdating();
		}
		
		public function setCollisionInfo(ballVel:b2Vec2, ballMass:Number, collisionNormal:b2Vec2):void
		{
			_ballForceToApply = collisionNormal.Copy();
			_ballForceToApply.Multiply(ballMass);
			_ballForceToApply.Multiply(ballVel.Length());
		}
		
		private function turnNormal():void 
		{
			// Iterate through all the shapes in our body
			for (var shape:b2Shape = _body.GetShapeList(); shape != null; shape = shape.GetNext()) {
				shape.m_density = 1.0;
			}
			
			_body.SetMassFromShapes();
			_body.WakeUp();
			
			_body.ApplyImpulse(_ballForceToApply, _body.GetWorldCenter());
		}
		
		public function hitBtBall():void
		{
			if (! _beenHit) {
				_beenHit = true;
				setMyMovieFrame();
				dispatchEvent(new PegEvent(PegEvent.PEG_LIT_UP));
				_turnNormalWhenSafe = true;				
			}
			
		}
		
		public function fadeOut(pegNumber:int):void 
		{
			TweenLite.to(_costume, 0.3, { alpha: 0, delay: 0.08 * pegNumber, onComplete: sendFadeOutDone} );
		}
		
		private function sendFadeOutDone():void
		{
			dispatchEvent(new PegEvent(PegEvent.DONE_FADING_OUT));
		}
		
		public function setType(newType:int):void
		{
			_pegType = newType;
			setMyMovieFrame();
		}
		
		private function setMyMovieFrame():void
		{
			if (_pegType == NORMAL) {
				if (_beenHit) {
					MovieClip(_costume).gotoAndPlay("normalLit");
				} else {
					MovieClip(_costume).gotoAndStop("normal");
				}
			} else if (_pegType == GOAL) {
				if(_beenHit) {
					MovieClip(_costume).gotoAndPlay("goalLit");
				} else {
					MovieClip(_costume).gotoAndStop("goal");
				}
			} else {
				throw(new Error("Hey! My peg type isn't anything I recognize!"));
			}
				
		}
		
	}
	
}