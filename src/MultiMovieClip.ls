package {
	import Loom2D.Display.MovieClip;
	
	public delegate MovieClipChange();
	
	public class MultiMovieClip extends MovieClip {
		/* action */		
		var _action:int=0;
		public function get action():int { return _action; }
		public function set action(a:int):void { _action=a; onActionChanged(); }

		var _actionNames:Vector.<String>;
		public function setActionNames(names:Vector.<String>):void {
			_actionNames=names.slice();
		}
		public function setActionName(act:int, name:String):void {
			_actionNames=_actionNames || [];
			_actionNames[act]=name;
		}
		public function getActionName(act:int):String {
			if (act<_actionNames.length) {
				return _actionNames[act];
			}
			else return "";
		}		
		public function getCurrentActionName():String { getActionName(action); }
		
		public function setActionByName(name:String):Boolean {
			if (_actionNames) return false;
			
			var ret=false;
			_actionNames.forEach(
				function(v:Object,i:Number,a:Vector.<Object>) {
					if (v as String == name) {
						action=i;
						ret=true; 
					}
				}
			);			
			return ret;
		}
		
		/* direction */	
		var _direction:int=0;
		public function get direction():int { return _direction; }
		public function set direction(d:int):void { _direction=d; onDirectionChanged(); }
		

		var _directionNames:Vector.<String>;
		public function setDirectionNames(names:Vector.<String>):void {
			_directionNames=names.slice();
		}
		public function setDirectionName(dir:int, name:String):void {
			_directionNames=_directionNames || [];
			_directionNames[dir]=name;
		}
		public function getDirectionName(dir:int):String {
			if (dir<_directionNames.length) {
				return _directionNames[dir];
			}
			else return "";
		}		
		public function getCurrentDirectionName():String { getDirectionName(direction); }

		public function setDirectionByName(name:String):Boolean {
			if (_directionNames) return false;
			
			var ret=false;
			_directionNames.forEach(
				function(v:Object,i:Number,a:Vector.<Object>) {
					if (v as String == name) {
						direction=i;
						ret=true; 
					}
				}
			);			
			return ret;
		}
		
		public var onDirectionChanged:MovieClipChange;
		public var onActionChanged:MovieClipChange;
		public var onTextureChanged:MovieClipChange;
		public var onStateChanged:MovieClipChange;
		
		public function MultiMovieClip(textures:Vector.<Texture>, fps:int=12) {
			super(textures,fps);
			
		}	
		
		public static function fromTextureXML(prefix:String, fps:int=12):MultiMovieClip {		
			var polyTex:Texture=Texture.fromAsset(prefix+".png");
			var xmldoc:XMLDocument=new XMLDocument();
			xmldoc.loadFile(prefix+".xml");
			var xmlroot:XMLElement=xmldoc.rootElement();
			var ta:TextureAtlas=new TextureAtlas(polyTex,xmlroot);
			texvec=ta.getTextures("circle_");
			
//		}	
	}
}
