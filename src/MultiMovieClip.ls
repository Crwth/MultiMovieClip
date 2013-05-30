package {
	import Loom2D.Display.Image;    
    import Loom2D.Display.Loom2DGame;
	import Loom2D.Display.StageScaleMode;
	import Loom2D.Display.MovieClip;
	
	import Loom2D.Events.Event;
	    
    import Loom2D.Textures.Texture;
    import Loom2D.Textures.TextureAtlas;
        
    import System.XML.XMLNode;
	
	public delegate MovieClipChange();
	
	public class MultiMovieClip extends MovieClip {
		/* action */		
		var _action:int=0;
		public function get action():int { return _action; }
		public function set action(a:int):void { _action=a; onActionChanged(); }

		var _actionNames:Vector.<String> =[];
		public function setActionNames(names:Vector.<String>):void {
			if (!names) return;
			_actionNames=names.slice(0,names.length);
		}
		public function setActionName(act:int, name:String):void {
			if (!_actionNames) _actionNames = [];
			_actionNames[act]=name;
		}
		public function getActionName(act:int):String {
			if (act<_actionNames.length) {
				return _actionNames[act];
			}
			else return "";
		}		
		public function get currentActionName():String { return getActionName(action); }
		
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
		

		var _directionNames:Vector.<String> =[];
		public function setDirectionNames(names:Vector.<String>):void {
			if (!names) return;
			_directionNames=names.slice(0,names.length);
		}
		public function setDirectionName(dir:int, name:String):void {
			if (!_directionNames) _directionNames = [];
			_directionNames[dir]=name;
		}
		public function getDirectionName(dir:int):String {
			if (dir<_directionNames.length) {
				return _directionNames[dir];
			}
			else return "";
		}		
		public function get currentDirectionName():String { return getDirectionName(direction); }

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
		public var onObjectChanged:MovieClipChange;
		public var onTextureChanged:MovieClipChange;
		public var onStateChanged:MovieClipChange;
		
		private var _texvec:Vector.<Texture>;
		private function get texvec():Vector.<Texture> { return _texvec; }
		private function set texvec(tv:Vector.<Texture>):void { _texvec=tv; onTextureChanged(); }
		
		private var _objname:String;
		public function get objname():String { return _objname; }
		public function set objname(on:String):void { _objname=on; onObjectChanged(); } 
		
		private var atlas:TextureAtlas;
		public function MultiMovieClip(
			prefix:String,
			objectName:String,
			actions:Vector.<String>,
			directions:Vector.<String>,
			fps:int=12) 
		{
			var polyTex:Texture=Texture.fromAsset(prefix+".png");
			super([polyTex],fps);
			var xmldoc:XMLDocument=new XMLDocument();
			xmldoc.loadFile(prefix+".xml");
			var xmlroot:XMLElement=xmldoc.rootElement();

			atlas=new TextureAtlas(polyTex,xmlroot);
	
			action=0;direction=0;objname=objectName;

			setActionNames(actions);
			setDirectionNames(directions);
			trace("directions:"+_directionNames.length);

//			this.fps=fps;
			
			onActionChanged+=function() { this.reset(); };
			onDirectionChanged+=function() { this.reset(); };
			onObjectChanged+=function() { this.reset(); };
		
			reset();	
		}	

		private function reset():void {
			var prefix:String="";
			
			trace("object:"+objname);
			if (objname && objname!="")
				prefix+=objname+"_";
				
			trace("action:"+currentActionName);
			if (currentActionName!="")
				prefix+=currentActionName+"_";
				
			trace("dir:"+currentDirectionName);
			if (currentDirectionName!="")
				prefix+=currentDirectionName+"_";
				
			trace("prefix:"+prefix);
			texvec=atlas.getTextures(prefix);
			trace("texvec ("+texvec.length+"):"+texvec.toString());
			init(texvec,fps);			
		}

        protected override function setTexture(t:Texture):void {
                texture = t;
                readjustSize();
        }
	}
}
