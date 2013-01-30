package  
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
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
	public class ArbStaticActor extends Actor
	{
		
		public function ArbStaticActor(parent:DisplayObjectContainer, location:Point, arrayOfCoords:Array) 
		{
			var myBody:b2Body = createBodyFromCoords(arrayOfCoords, location);
			var mySprite:Sprite = createSpriteFromCoords(arrayOfCoords, location, parent);
			
			super(myBody, mySprite);
		}
		
		private function createSpriteFromCoords(arrayOfCoords:Array, location:Point, parent:DisplayObjectContainer):Sprite
		{
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.lineStyle(2, 0x00BB00);
			for each (var listOfPoints:Array in arrayOfCoords) {
				var firstPoint:Point = listOfPoints[0];
				newSprite.graphics.moveTo(firstPoint.x , firstPoint.y);
				newSprite.graphics.beginFill(0x00BB00);
				
				for each (var newPoint:Point in listOfPoints) {
					newSprite.graphics.lineTo(newPoint.x , newPoint.y);
				}
				
				newSprite.graphics.lineTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.endFill();
			
			}
			
			newSprite.x = location.x;
			newSprite.y = location.y;
			parent.addChild(newSprite);
			
			return newSprite;
		}
		
		private function createBodyFromCoords(arrayOfCoords:Array, location:Point):b2Body
		{
			// Define shapes
			var allShapes:Array = [];
			
			for each (var listOfPoints:Array in arrayOfCoords) {
				var newShapeDef:b2PolygonDef = new b2PolygonDef();
				newShapeDef.vertexCount = listOfPoints.length;
				for (var i:int = 0; i < listOfPoints.length; i++) {
					var nextPoint:Point = listOfPoints[i];
					b2Vec2(newShapeDef.vertices[i]).Set(nextPoint.x / Const.RATIO, nextPoint.y / Const.RATIO);
				}
				newShapeDef.density = 0;
				newShapeDef.friction = 0.2;
				newShapeDef.restitution = 0.3;
				
				allShapes.push(newShapeDef);
			}
			
			// Define a body
			var arbBodyDef:b2BodyDef = new b2BodyDef();
			arbBodyDef.position.Set(location.x / Const.RATIO, location.y / Const.RATIO);
			
			// Create the body
			var arbBody:b2Body = Const.world.CreateBody(arbBodyDef);
			
			// Create the shapes
			for each (var newShapeDefToAdd:b2ShapeDef in allShapes) {
				arbBody.CreateShape(newShapeDefToAdd);
			}
			arbBody.SetMassFromShapes();
			
			return arbBody;
		}
		
	}
}
