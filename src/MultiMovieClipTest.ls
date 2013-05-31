package
{
	import Loom2D.Display.BitmapFontLabel;
	import Loom2D.Display.Image;    
    import Loom2D.Display.Loom2DGame;
	import Loom2D.Display.StageScaleMode;
	import Loom2D.Display.MovieClip;
	
	import Loom2D.Events.EnterFrameEvent;
	import Loom2D.Events.Event;
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

            // Comment out this line to turn off automatic scaling.
            stage.scaleMode = StageScaleMode.LETTERBOX;
			
			//var mmc=new MultiMovieClip(
//				"assets/data/polySprites",
//				"circle",
//				["blue","red","purple","yellow"],
//				null,
//				5);
			var mmc=new MultiMovieClip(
				"assets/data/ogremulti",
				"ogre",
				["walk", "idle", "die1", "die2",
"attack1", "attack2", "attack3",
"attackbow", "attackcrossbow", "attackthrow",
"gethit", "pillage", "stomp",
"cast1", "cast2",
"blockright", "blockleft",
"fidget1", "fidget2",
"fly", "land", "gethitinair"],
				["d","dl","l","ul","u","ur","r","dr"],
				12
			);
			mmc.setDefaultActionByName("idle");
			mmc.setLoopingByName("walk",true);
			mmc.addEventListener(Event.COMPLETE,function(e:Event) {
				//trace("last frame");
			});
			mmc.x=stage.stageWidth/2;
			mmc.y=stage.stageHeight/2;
			stage.addChild(mmc);
			mmc.play();
			var a=0;
			stage.addEventListener(TouchEvent.TOUCH_DOWN,function(e:Event) {
				a=(a+1)%mmc.numActions;
				mmc.action=a;
				//mmc.direction=(mmc.direction+1)%8;
			});
			/*
			var sizelabel=new BitmapFontLabel("assets/Curse-hd.fnt");
			stage.addChild(sizelabel);
			*/
			
			var actionlabel=new BitmapFontLabel("assets/Curse-hd.fnt");
			stage.addChild(actionlabel);
			
			stage.addEventListener(EnterFrameEvent.ENTER_FRAME, function(e:Event):void {
				//sizelabel.text=""+mmc.width+","+mmc.height;
				actionlabel.text=""+mmc.currentActionName+"-"+mmc.currentDirectionName;
				actionlabel.x=(stage.stageWidth-actionlabel.bounds.width)/2;
				actionlabel.y=stage.stageHeight-actionlabel.bounds.height/2;
			});
			
        }
    }
}