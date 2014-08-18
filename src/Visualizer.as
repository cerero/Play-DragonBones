package  
{
	import Components.InfoField;
	import Contents.DragonBonesObject;
	import Contents.PropertiesBar;
	import Contents.DBDataDriven;
	import dragonBones.textures.StarlingTextureAtlas;
	
	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.display.Quad;
	import starling.animation.Transitions;
	
	/**
	 * Main component.
	 * - Create the sidebar
	 * - Object with the project of the DragonBones
	 * - Status from the objects
	 * @author Jack Dracon
	 */
	public class Visualizer extends Sprite
	{
		private var _properties : PropertiesBar;
		private var _statusDelay : Number = .25;
		private var _busyStatus : Boolean = false;
		
		private var _dbObject : DragonBonesObject;
		
		private var _arrFields : Array = [];
		
		private var infoFieldInitPositionX : Number = 0;
		private var infoFieldInitPositionY : Number = 0;
		
		public function Visualizer() : void
		{
			_properties = new PropertiesBar();
			addChild(_properties);
		}
		
		/**
		 * Status about some info on the right bottom side.
		 * @param	_str, text to be showed.
		 */
		public function StatusInfo(_str : String = "") : void 
		{
			var _black : Quad = new Quad(100, 50);
			addChild(_black);
			
			_black.x = Starling.current.stage.stageWidth - _black.width;
			_black.y = Starling.current.stage.stageHeight - _black.height;
			_black.setVertexColor(0, 0x0);
			_black.setVertexColor(1, 0x0);
			_black.setVertexColor(2, 0x0);
			_black.setVertexColor(3, 0x0);
			_black.alpha = 0.25;
			
			var _field : TextField = new TextField(100, 50, _str, "Arial", 12, 0xffffff);
			addChild(_field);
			_field.x = _black.x;
			_field.y = _black.y;
			trace(_str );
			
			Starling.juggler.delayCall(function() : void {
			Starling.juggler.tween(_black, 1, { alpha : 0, transition: Transitions.EASE_OUT, onComplete: function complete() : void {
				Starling.juggler.purge();
				removeChild(_black);
				removeChild(_field);
				_statusDelay -= .25;
			}});
			}, _statusDelay);
			_statusDelay += .25;
		}
		
		/**
		 * Load the files and turn them able to create the DragonBones object.
		 */
		public function Load_DragonBones() : void 
		{
			if (DBDataDriven.Assets_Complete()) 
			{
				var _atlas : StarlingTextureAtlas = new StarlingTextureAtlas(DBDataDriven.Current_Texture, DBDataDriven.Current_Data);
				Create_DragonBones(_atlas, DBDataDriven.Current_Skeleton);
			} else {
				StatusInfo("LOAD ERROR");
			}
		}
		
		public function DragonBonesInfo(_str : String) : void {
			var _info : InfoField = new InfoField(_str);
			addChild(_info);
			_arrFields.push(_info);
			if (_arrFields.length > 1) 
			{
				for (var _i:int = 0; _i < _arrFields.length; _i++) {
					var _value : InfoField = _arrFields[_i];
					if (_value.x == infoFieldInitPositionX) {
						continue;
					}
					else 
					{
						_value.x = (_arrFields[(_i - 1)] as InfoField).x + (_arrFields[(_i - 1)] as InfoField).width;
						_value.y = infoFieldInitPositionY;
					}
				}
			}else {
				_info.x = infoFieldInitPositionX;
				_info.y = infoFieldInitPositionY;
			}
		}
		
		/**
		* Create the DragonBones object.
		* @param	_atlas, StarlingTextureAtlas
		* @param	_skeleton, Data(XML) with the skeleton info to combine with texture atlas of DragonBones
		*/
		public function Create_DragonBones(_atlas : StarlingTextureAtlas, _skeleton : XML) : void 
		{
			_dbObject = new DragonBonesObject(_atlas, _skeleton);
			addChild(_dbObject);
			_dbObject.pivotX = _dbObject.width * .5;
			_dbObject.pivotY = _dbObject.height * .5;
			_dbObject.x = _properties.width + _dbObject.width;// (Starling.current.stage.stageWidth - Starling.current.stage.stageWidth * .35);
			_dbObject.y = Starling.current.stage.stageHeight * .5;
		}
		
		/**
		* @return if the object still already exists.
		*/
		public function Has_DragonBonesObject() : Boolean 
		{
			return (_dbObject) ? true : false;
		}
	}
}