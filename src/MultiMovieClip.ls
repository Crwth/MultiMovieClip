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
	
	public class AnimInfo {
		public var reset:Boolean;
		public var loop:Boolean;
		
		public function AnimInfo(r:Boolean=true, l:Boolean=false) {
			reset=r;
			loop=l;
		}
	}
	
	public class MultiMovieClip extends MovieClip {
	
		/* AnimInfo */
		var _animinfo:Dictionary.<String,AnimInfo> ={};		
		public function setAnimInfos(ai:Dictionary.<String,AnimInfo>) { _animinfo=ai; }
		public function setAnimInfo(a:String,ai:AnimInfo):void { _animinfo[a]=ai; }
		public function getAnimInfo(a:String):AnimInfo { return _animinfo[a]; }
		public function get currentAnimInfo():AnimInfo { return getAnimInfo(action); }
		public function set currentAnimInfo(ai:AnimInfo):void { setAnimInfo(action,ai); }
		public function get numActions():int { return _animinfo.length; }

		/* action */			
		var _action:String;
		public function get action():String { return _action; }
		public function set action(a:String):void { 
			if (a!=_action) {
				_action=a; 
				onActionChanged();
			} 
		}
		var defaultAction:String;

				
		/* Direction */	
		var _direction:String;
		public function get direction():String { return _direction; }
		public function set direction(d:String):void { 
			if (d!=_direction) {
				_direction=d; 
				onDirectionChanged(); 
			}
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
		
		private var atlasses:Vector.<TextureAtlas> = [];
		public function MultiMovieClip(
			prefixes:Vector.<String>,
			objectName:String,
			animinfo:Dictionary.<String,AnimInfo>,
			startingAction:String,
			directions:Vector.<String>,
			startingDirection:String,
			fps:int=12) 
		{
			trace("prefixes.length:"+prefixes.length);
			var first:Texture;
			prefixes.forEach(function(p:Object) {
				var prefix=p as String;
				trace("Loading "+prefix);
				var polyTex:Texture=Texture.fromAsset(prefix+".png");
				if (!first) first=polyTex;
				var xmldoc:XMLDocument=new XMLDocument();
				xmldoc.loadFile(prefix+".xml");
				var xmlroot:XMLElement=xmldoc.rootElement();
	
				atlasses.push(new TextureAtlas(polyTex,xmlroot));
			});
			trace("atlasses.length:"+atlasses.length);
			super([first],fps);
			trace("initialized.");
			setAnimInfos(animinfo);
	
			objname=objectName;
			action=defaultAction=startingAction;
			direction=startingDirection;
			
//			this.fps=fps;
			
			onActionChanged+=function() { this.reset(false); };
			onDirectionChanged+=function() { this.reset(); };
			onObjectChanged+=function() { this.reset(); };
		
			addEventListener(Event.COMPLETE,function(e:Event) {
				if (!loop) {
					
				}
				if (!loop && action!=defaultAction && currentAnimInfo.reset) 
				action=defaultAction;
			});
					
			reset();	
			reset(); // hack for initial sprite display (fps?)
		}	

		private var sizeNeedsAdjusting:Boolean=true;
		private function reset(keepFrame:Boolean=true):void {
			var prefix:String="";
			var curFrame=currentFrame;
			var curTime=currentTime;
			
			//trace("object:"+objname);
			if (objname && objname!="")
				prefix+=objname+"_";
				
			//trace("action:"+action);
			if (action)
				prefix+=action+"_";
				
			//trace("dir:"+direction);
			if (direction)
				prefix+=direction+"_";
				
			trace("prefix:"+prefix);
			texvec=findTextures(prefix);
			
			if (texvec.length==1) { // hack for single-frame animation
				_texvec.push(_texvec[0]);
			}
			//var cai:AnimInfo=_animinfo[action];
			//trace(cai.getTypeName());
			//trace("CurrentAnimInfo: (reset="+cai.reset+", loop="+cai.loop+")");
			if (texvec.length!=0) {
				//trace("texvec ("+texvec.length+"):"+texvec.toString());
				init(texvec,fps);
            	//readjustSize();
            	sizeNeedsAdjusting=true;
            	pivotX=width/2;
            	pivotY=height/2;                
				loop=currentAnimInfo.loop;				
				if (keepFrame) currentFrame=curFrame;
				//currentTime=curTime;
			} else {
				trace("No textures found matching '"+prefix+"'");
				action=defaultAction;
			}		
		}

		function findTextures(prefix:String):Vector.<Texture> {
			var ret:Vector.<Texture> = [];
			trace("looking for "+prefix);
			atlasses.forEach(function(ta:Object) {
				var atlas=ta as TextureAtlas;
				var texes=atlas.getTextures(prefix);
				if (texes) { 
					trace("found "+texes.length+" matches");
					texes.forEach(function(o:Object) {
						var t=o as Texture;
						ret.push(t);
					});
				}
			});
			trace("ret.length:"+ret.length);
			return ret;
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
