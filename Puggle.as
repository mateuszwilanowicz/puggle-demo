package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Mateusz Wilanowicz
	 */
	public class Puggle extends Sprite
	{
		var _allActors:Array;
		var _actorsToRemove:Array
		var _pegsLitUp:Array
		var _camera:Camera;
		var _currentBall:BallActor;
		var _timeMaster:TimeMaster;
		var _director:Director;
		var _amingLine:AimingLine;
		var _shooter:Shooter;
		
		var _goalPegs:Array;
		
		private const SHOOTER_POINT:Point = new Point(323, 10);
		private const LUNCH_VELOCITY:Number = 470.0;
		private const GOAL_PEG_NUM:int = 22;
		
		public function Puggle() 
		{
			// Camera initiation
			_camera = new Camera();
			addChild(_camera);
			
			// Initiate shooter
			_shooter = new Shooter();
			_shooter.x = SHOOTER_POINT.x;
			_shooter.y = SHOOTER_POINT.y;
			_camera.addChild(_shooter);			
			
			// Variable initiation
			_allActors = [];
			_actorsToRemove = [];
			_pegsLitUp = [];
			_goalPegs = [];
			_currentBall = null;
			_timeMaster = new TimeMaster();
			_director = new Director(_camera, _timeMaster);
			_amingLine = new AimingLine(Const.GRAVITY);
			_camera.addChild(_amingLine);
						
			// Startup functions
			setupPhysicsWorld();
			createLevel();
			
			// Basic listeners
			addEventListener(Event.ENTER_FRAME, newFrameListener);
			stage.addEventListener(MouseEvent.CLICK, lunchBall);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, showAimLine);
		}
		
		
		
		private function createLevel():void
		{
			var horizSpacing:int = 46;
			var vertSpacing:int = 46;
			var pegBounds:Rectangle = new Rectangle(114, 226, 418, 255);
			var flipRow:Boolean = false;
			var allPegs:Array = [];
			
			
			// Creating all of out pegs
			for ( var pegY:int = pegBounds.top; pegY < pegBounds.bottom; pegY += vertSpacing) {
				var startX:int = pegBounds.left + ((flipRow) ? 0 : (horizSpacing / 2));
				flipRow = !flipRow;
				for ( var pegX = startX; pegX < pegBounds.right; pegX += horizSpacing) {
					var newPeg:PegActor = new PegActor(_camera , new Point(pegX, pegY), PegActor.NORMAL);
					newPeg.addEventListener(PegEvent.PEG_LIT_UP, handlePegLitUp);
					newPeg.addEventListener(PegEvent.DONE_FADING_OUT, destroyPegNow);
					_allActors.push(newPeg);
					allPegs.push(newPeg);
				}
			}
			
			// Turning pegs in to goal pegs and removing them from the allPegs array
			if (allPegs.length < GOAL_PEG_NUM) {
				throw (new Error("Not enough pegs to set up a level!"));
			} else {
				for (var i:int = 0; i < GOAL_PEG_NUM; i++) {
					// Turn some of these pegs into Goal page;
					var randomPegNum = Math.floor(Math.random() * allPegs.length);
					
					PegActor(allPegs[randomPegNum]).setType(PegActor.GOAL);
					
					// Keep track of which pegs these are;
					_goalPegs.push(allPegs[randomPegNum]);
					allPegs.splice(randomPegNum, 1);
				}
			}
			
			
			// Add the side walls
			var wallShapes:Array = [[new Point(0, 0), new Point(10, 0), new Point(10, 603), new Point(0, 603)]];
			
			var leftWall:ArbStaticActor = new ArbStaticActor(_camera, new Point(-9, 0), wallShapes);
			_allActors.push(leftWall);
	
			var rightWall:ArbStaticActor = new ArbStaticActor(_camera, new Point(640, 0), wallShapes);
			_allActors.push(rightWall);
			
			var leftRamCoords:Array = [[new Point(0, 0), new Point(79, 27), new Point(79, 30), new Point(0, 3)]];
			
			var leftRam1:ArbStaticActor = new ArbStaticActor(_camera, new Point(0, 265), leftRamCoords);
			_allActors.push(leftRam1);
			
			var leftRam2:ArbStaticActor = new ArbStaticActor(_camera, new Point(0, 336), leftRamCoords);
			_allActors.push(leftRam2);
			
			var leftRam3:ArbStaticActor = new ArbStaticActor(_camera, new Point(0, 415), leftRamCoords);
			_allActors.push(leftRam3);

			var rightRamCoords:Array = [[new Point(0, 0), new Point(0, 3), new Point( -85, 32), new Point( -85, 29)]];
			
			var rightRam1:ArbStaticActor = new ArbStaticActor(_camera, new Point(646, 232), rightRamCoords);
			_allActors.push(rightRam1);
			
			var rightRam2:ArbStaticActor = new ArbStaticActor(_camera, new Point(646, 308), rightRamCoords);
			_allActors.push(rightRam2);
			
			var rightRam3:ArbStaticActor = new ArbStaticActor(_camera, new Point(646, 388), rightRamCoords);
			_allActors.push(rightRam3);
			
			var bonusChute:BonusChuteActor = new BonusChuteActor(_camera, 90, 550, 585);
			_allActors.push(bonusChute);
			
		}
		
		private function destroyPegNow(e:PegEvent):void 
		{
			safeRemoveActor(PegActor(e.currentTarget));
			PegActor(e.currentTarget).removeEventListener(PegEvent.DONE_FADING_OUT, destroyPegNow);
		}

		private function newFrameListener(e:Event):void 
		{
			Const.world.Step( _timeMaster.getTimeStep() , 10);
			
			for each (var actor:Actor in _allActors) {
				actor.updateNow();
			}
			
			checkForZoomIn();
			
			reallyRemoveActors();
			
		}
		
		private function checkForZoomIn():void
		{
			if (_goalPegs.length == 1 && _currentBall != null) {
				var finalPeg:PegActor = _goalPegs[0];
				var p1:Point = finalPeg.getSpriteLoc();
				var p2:Point = _currentBall.getSpriteLoc();
			
				if (getDistSquared(p1, p2) < 40 * 40) {
					_director.zoomIn(p1);
				} else {
					_director.backToNormal();
				}
			} else if (_goalPegs.length == 0 ) {
				_director.backToNormal();
			}
		}
		
		private function getDistSquared(p1:Point, p2:Point):int
		{
			return ((p2.x - p1.x) * (p2.x - p1.x)) + ((p2.y - p1.y) * (p2.y - p1.y));
		}
		
		// Mark and actor to be removed, at the same time
		// It wont actualy remove anything
		public function safeRemoveActor(actorToRemove:Actor):void 
		{
			if (_actorsToRemove.indexOf(actorToRemove) < 0) {
				_actorsToRemove.push(actorToRemove);
			}
		}
		
		// Actualy remove the actors that have been marked for delation
		// in my removeActor function
		private function reallyRemoveActors():void
		{
			for each (var removeMe:Actor in _actorsToRemove) {
				removeMe.destroy();
				
				// Remove it from our main list of actors
				var actorIndex:int = _allActors.indexOf(removeMe);
				if (actorIndex > -1) {
					_allActors.splice(actorIndex, 1);
				}
			}
			
			_actorsToRemove = [];
			
		}
		
		
		private function lunchBall(e:MouseEvent):void 
		{
			if (_currentBall == null) {
				var lunchPoint:Point = _shooter.getLunchPosition();
				
				var direction:Point = new Point(mouseX, mouseY).subtract(lunchPoint);
				direction.normalize(LUNCH_VELOCITY);
				
				var newBall:BallActor = new BallActor(_camera, lunchPoint, direction);
				newBall.addEventListener(BallEvent.BALL_OFF_SCREEN, handleBallOffScrteen);
				newBall.addEventListener(BallEvent.BALL_HIT_BONUS, handleBallHitBonus);
				_allActors.push(newBall);
				_currentBall = newBall;
				_amingLine.hide();
			}
		}
		
		
		private function showAimLine(e:MouseEvent):void 
		{
			if (_currentBall == null) {
				var lunchPoint:Point = _shooter.getLunchPosition();
				var direction:Point = new Point( mouseX, mouseY).subtract(lunchPoint);
				_amingLine.showLine(lunchPoint, direction, LUNCH_VELOCITY);
			}
			
			_shooter.alignToMouse(null);
			
		}	
			
		
		private function handleBallHitBonus(e:BallEvent):void 
		{
			handleBallOffScrteen(e);
		}
			
		
		private function handleBallOffScrteen(e:BallEvent):void 
		{
			//trace("Ball is off screen");
			var ballToRemove:BallActor = BallActor(e.currentTarget);
			ballToRemove.removeEventListener(BallEvent.BALL_OFF_SCREEN, handleBallOffScrteen);
			ballToRemove.removeEventListener(BallEvent.BALL_HIT_BONUS, handleBallHitBonus);
						
			_currentBall = null;
			
			safeRemoveActor(ballToRemove);
			
			// Remove the pegs that have been lit up at this point
			for (var i:int = 0; i < _pegsLitUp.length; i++ ) {
				var pegToRemove:PegActor = PegActor(_pegsLitUp[i]);
				pegToRemove.fadeOut(i);
			}
			
			_pegsLitUp = [];
			
			showAimLine(null);
			
		}
				
		private function handlePegLitUp(e:PegEvent):void 
		{
			// Record the fact the peg hes been lit, so I can remove it later
			var pegActor:PegActor = PegActor(e.currentTarget);
			pegActor.removeEventListener(PegEvent.PEG_LIT_UP, handlePegLitUp);
			if (_pegsLitUp.indexOf(pegActor) < 0 ) {
				_pegsLitUp.push(pegActor);	
			}
			
			var goalPegIndex:int = _goalPegs.indexOf(pegActor);
			if (goalPegIndex > -1 ) {
				_goalPegs.splice(goalPegIndex, 1);
			}
		}
		
		private function setupPhysicsWorld():void
		{
			var worldBounds:b2AABB = new b2AABB();
			worldBounds.lowerBound.Set ( -5000 / Const.RATIO, -5000 / Const.RATIO);
			worldBounds.upperBound.Set ( 5000 / Const.RATIO, 5000 / Const.RATIO);
			
			var gravity:b2Vec2 = new b2Vec2(0, Const.GRAVITY);
			var allowSleep:Boolean = true;
			
			Const.world = new b2World( worldBounds, gravity, allowSleep);
			Const.world.SetContactListener(new PuggleContactListener);
			
			
		}
		
	}
	
}