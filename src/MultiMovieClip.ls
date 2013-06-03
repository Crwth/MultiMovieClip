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
		public function set action(a:int):void { if (a!=_action && a<_actionNames.length) {_action=a; onActionChanged();} }

		var _actionNames:Vector.<String> =[];
		public function setActionNames(names:Vector.<String>):void {
			if (!names) return;
			_actionNames=names.slice(0,names.length);
			for (var i=0;i<names.length;i++)
				setLooping(i,defaultLoop);
		}
		public function setActionName(act:int, name:String):void {
			if (!_actionNames) _actionNames = [];
			_actionNames[act]=name;
			setLooping(act,defaultLoop);
		}
		public function getActionName(act:int):String {
			if (act<_actionNames.length) {
				return _actionNames[act];
			}
			else return "";
		}		
		public function get currentActionName():String { return getActionName(action); }
		public function get numActions():int { return _actionNames.length; }
		
		public function getActionByName(name:String):int {
			var ret=-1;
			_actionNames.forEach(
				function(v:Object,i:Number,a:Vector.<Object>) {
					if (v as String == name) {
						ret=i; 
					}
				}
			);			
			return ret;			
		}		
		public function setCurrentActionByName(name:String):Boolean {
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
		var _defaultAction:int=0;
		public function get defaultAction():int { return _defaultAction; }
		public function set defaultAction(d:int):void { _defaultAction=d; }
		public function setDefaultActionByName(name:String):void {
			var a=getActionByName(name);
			defaultAction=a;
		}
		
		public var defaultLoop:Boolean=false;
		var _loopflags:Vector.<Boolean> = [];
		public function setLoopingFlags(flags:Vector.<Boolean>):void {
			if (!flags) return;
			_loopflags=flags.slice(0,flags.length);
		}
		public function getLooping(i:int):Boolean { return _loopflags[i]; }
		public function setLooping(i:int,l:Boolean):void { _loopflags[i]=l; }
		public function get currentLooping():Boolean { return getLooping(action); }
		public function setLoopingByName(name:String,l:Boolean):Boolean {
			var act=getActionByName(name);
			if (act==-1) return false;
			setLooping(act,l);
			return true;
		}
		
		
		/* direction */	
		var _direction:int=0;
		public function get direction():int { return _direction; }
		public function set direction(d:int):void { if (d!=_direction && d<_directionNames.length) {_direction=d; onDirectionChanged(); }}
		

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
		public function get numDirections():int { return _directionNames.length; }

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
		public function set objname(on:String):void { if (on!=_objname) {_objname=on; onObjectChanged(); }} 
		
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
			
			onActionChanged+=function() { this.reset(false); };
			onDirectionChanged+=function() { this.reset(); };
			onObjectChanged+=function() { this.reset(); };
		
			addEventListener(Event.COMPLETE,function(e:Event) {
				if (!loop && action!=defaultAction) action=defaultAction;
			});
			
		
			reset();	
		}	

		private var sizeNeedsAdjusting:Boolean=true;
		private function reset(keepFrame:Boolean=true):void {
			var prefix:String="";
			var curFrame=currentFrame;
			var curTime=currentTime;
			
			//trace("object:"+objname);
			if (objname && objname!="")
				prefix+=objname+"_";
				
			//trace("action:"+currentActionName);
			if (currentActionName!="")
				prefix+=currentActionName+"_";
				
			//trace("dir:"+currentDirectionName);
			if (currentDirectionName!="")
				prefix+=currentDirectionName+"_";
				
			//trace("prefix:"+prefix);
			texvec=atlas.getTextures(prefix);
			if (texvec.length==1) { // hack for single-frame animation
			 _texvec.push(_texvec[0]);
			}
			if (texvec.length!=0) {
				//trace("texvec ("+texvec.length+"):"+texvec.toString());
				init(texvec,fps);
            	//readjustSize();
            	sizeNeedsAdjusting=true;
            	pivotX=width/2;
            	pivotY=height/2;                
				loop=currentLooping;
				if (keepFrame) currentFrame=curFrame;
				//currentTime=curTime;
			} else {
				trace("No textures found matching '"+prefix+"'");
			}		
		}

        protected override function setTexture(t:Texture):void {
        	//trace("set texture:"+t.toString());
            texture = t;            
            if (sizeNeedsAdjusting) { 
            	readjustSize(); 
            	sizeNeedsAdjusting=false; 
                pivotX=width/2;
	            pivotY=height/2;                
            }
            
        }
       
	}
}
