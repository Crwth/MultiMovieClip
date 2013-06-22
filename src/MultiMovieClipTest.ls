package
{
	import loom.Application;

	import loom2d.Loom2D;
	import loom2d.animation.Juggler;

	//import Loom2D.Display.BitmapFontLabel; // Gone after 1.0.1892
	import loom2d.display.DisplayObject;
	import loom2d.display.Image;    
	import loom2d.display.StageScaleMode;
	import loom2d.display.MovieClip;
	
	import loom2d.events.EnterFrameEvent;
	import loom2d.events.Event;
	import loom2d.events.KeyboardEvent;
	import loom2d.events.TouchEvent;
	    
	import loom2d.math.Point; 
	
	import loom2d.text.BitmapFont;
	
    import loom2d.textures.Texture;
    import loom2d.textures.TextureAtlas;

	import loom2d.ui.Label;    
    
    import system.xml.XMLNode;
    

    public class MultiMovieClipTest extends Application
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
				"gethitinair":new AnimInfo(true,false,"fly"),
			};
			
			var mmc=new MultiMovieClip(
				//"assets/data/ogremulti", "ogre", animinfo, "idle",
				//["assets/data/ettin0","assets/data/ettin1"],"ettin",animinfo,"idle",
				//["assets/data/zombie0","assets/data/zombie1","assets/data/zombie2"],"zombie",animinfo,"idle",
				[
				"assets/data/gargoyle0",
				"assets/data/gargoyle1",
				"assets/data/gargoyle2",
				"assets/data/gargoyle3",
				"assets/data/gargoyle4",
				"assets/data/gargoyle5",
				"assets/data/gargoyle6",
				"assets/data/gargoyle7",
				"assets/data/gargoyle8",
				"assets/data/gargoyle9",
				"assets/data/gargoyleA",
				"assets/data/gargoyleB",
				"assets/data/gargoyleC",
				"assets/data/gargoyleD",
				"assets/data/gargoyleE",
				"assets/data/gargoyleF",
				"assets/data/gargoyleG",
				"assets/data/gargoyleH"],"gargoyle",animinfo,"idle",
				
				["d","dl","l","ul","u","ur","r","dr"], "d", 12
			);

			mmc.x=stage.stageWidth/2;
			mmc.y=stage.stageHeight/2;
						
			//stage.reportFps=true;						
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
					
				var action=actions[c];
				if (mmc.hasTextures(mmc.objname+"_"+action))
					mmc.action=action;				
			});

			/*
			var sizelabel=new BitmapFontLabel("assets/Curse-hd.fnt");
			stage.addChild(sizelabel);
			*/
			
			var fontFile="assets/Curse-hd.fnt";
			var font = BitmapFont.load(fontFile);
			var actionlabel=new Label(fontFile,new Point(stage.stageWidth,100));
			actionlabel.y=stage.stageHeight/2;
			stage.addChild(actionlabel);
			
			stage.addEventListener(EnterFrameEvent.ENTER_FRAME, function(e:Event):void {
				var oldtext=actionlabel.text;
				var text=""+mmc.action+"-"+mmc.direction;
				if (text!=oldtext) {
			/*
				var dims=font.getStringDimensions(
					text,
					stage.stageWidth,
					stage.stageHeight,
					12);
				*/	
				//stage.removeChild(actionlabel);
				//actionlabel=new Label(fontFile,dims);
				actionlabel.text=""+mmc.action+"-"+mmc.direction;
				//actionlabel.x=(stage.stageWidth-100)/2;
				//actionlabel.y=stage.stageHeight/2;
				//stage.addChild(actionlabel);
				}
			});
			
			
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