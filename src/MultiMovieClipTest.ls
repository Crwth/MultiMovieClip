package
{
	import Loom2D.Loom2D;
	import Loom2D.Animation.Juggler;

	//import Loom2D.Display.BitmapFontLabel; // Gone after 1.0.1892
	import Loom2D.Display.DisplayObject;
	import Loom2D.Display.Image;    
    import Loom2D.Display.Loom2DGame;
	import Loom2D.Display.StageScaleMode;
	import Loom2D.Display.MovieClip;
	
	import Loom2D.Events.EnterFrameEvent;
	import Loom2D.Events.Event;
	import Loom2D.Events.KeyboardEvent;
	import Loom2D.Events.TouchEvent;
	    
    import Loom2D.Textures.Texture;
    import Loom2D.Textures.TextureAtlas;
    
    //import Loom2D.UI.TextureAtlasManager;
    //import Loom2D.UI.TextureAtlasSprite;
    
    import System.XML.XMLNode;
    

    public class MultiMovieClipTest extends Loom2DGame
    {
        override public function run():void
        {
            super.run();

            stage.scaleMode = StageScaleMode.LETTERBOX;
			
			var animinfo:Dictionary.<String,AnimInfo> = {
				"walk":new AnimInfo(true,true), 
				"idle":new AnimInfo(false,false),
				"die1":new AnimInfo(false,false),
				"die2":new AnimInfo(false,false),
				"attack1":new AnimInfo(true,false),
				"attack2":new AnimInfo(true,false),
				"attack3":new AnimInfo(true,false),
				"attackbow":new AnimInfo(true,false),
				"attackcrossbow":new AnimInfo(true,false),
				"attackthrow":new AnimInfo(true,false),
				"gethit":new AnimInfo(true,false),
				"pillage":new AnimInfo(true,false),
				"stomp":new AnimInfo(true,false),
				"cast1":new AnimInfo(true,false),
				"cast2":new AnimInfo(true,false),
				"blockright":new AnimInfo(true,false),
				"blockleft":new AnimInfo(true,false),
				"fidget1":new AnimInfo(true,false),
				"fidget2":new AnimInfo(true,false),
				"fly":new AnimInfo(false,true),
				"land":new AnimInfo(true,false),
				"gethitinair":new AnimInfo(true,false),
			};
			
			var mmc=new MultiMovieClip(
				//"assets/data/ogremulti", "ogre", animinfo, "idle",
				["assets/data/ettinmulti"],"ettin",animinfo,"idle",
				["d","dl","l","ul","u","ur","r","dr"], "d", 12
			);

			mmc.x=stage.stageWidth/2;
			mmc.y=stage.stageHeight/2;
						
			stage.addEventListener(TouchEvent.TOUCH,function(e:Event) {
				var te=e as TouchEvent;
				var touches=te.getTouches(mmc);
				var touch=touches[0];
				if (touch) {
					var loc=touch.getLocation(stage);
					var direction=getDirectionFor(mmc,loc.x,loc.y);
					var directions:Vector.<String> =["d","dl","l","ul","u","ur","r","dr"];
					mmc.direction=directions[direction];
				}
			});
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:Event) {
				var ke=e as KeyboardEvent;
				//trace(ke.charCode+" "+ke.keyLocation);
				
				var c=ke.charCode-4;
				var actions:Vector.<String> =["walk","idle","die1","die2","attack1","attack2","attack3",
					"attackbow","attackcrossbow","attackthrow","gethit","pillage",
					"stomp","cast1","cast2","blockright","blockleft","fidget1","fidget2",
					"fly","land","gethitinair"];
				mmc.action=actions[c];				
			});

			/*
			var sizelabel=new BitmapFontLabel("assets/Curse-hd.fnt");
			stage.addChild(sizelabel);
			*/
			
			/*
			var actionlabel=new BitmapFontLabel("assets/Curse-hd.fnt");
			stage.addChild(actionlabel);
			
			stage.addEventListener(EnterFrameEvent.ENTER_FRAME, function(e:Event):void {
				//sizelabel.text=""+mmc.width+","+mmc.height;
				actionlabel.text=""+mmc.currentActionName+"-"+mmc.currentDirectionName;
				actionlabel.x=(stage.stageWidth-actionlabel.bounds.width)/2;
				actionlabel.y=stage.stageHeight-actionlabel.bounds.height/2;
			});
			*/
			
			stage.addChild(mmc);						
			Loom2D.juggler.add(mmc);						
			mmc.stop();
			mmc.play();
        }
        function getDirectionFor(obj:DisplayObject, x:int, y:int):int {
            	//Console.print("obj.x:"+obj.x+" obj.y:"+obj.y);
            	//Console.print("touch.x:"+x+" touch.y:"+y);
            	var x2=x-obj.x;
            	var y2=obj.y-y;
            	var rad=Math.atan2(y2,x2);
            	//Console.print("atan2:"+rad);
            	var deg=(rad*(180/Math.PI)+360)%360;
            	var dir=degToDirection(deg);
            	//Console.print("deg:"+deg+" dir:"+dir);
            	return dir;
        }
        
        function degToDirection(deg:int):int {
        	var rotdeg=((360-deg)+(360-67.5))%360;
        	return Math.floor(rotdeg/45);
        }
    }
}