package
{
	import Loom2D.Display.Image;    
    import Loom2D.Display.Loom2DGame;
	import Loom2D.Display.StageScaleMode;
	import Loom2D.Display.MovieClip;
	
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
				"assets/data/ogreattack1",
				"ogre",
				["attack1","attack2"],
				["d","dl","l","ul","u","ur","r","dr"],
				5
			);
			mmc.addEventListener(Event.COMPLETE,function(e:Event) {
				//trace("last frame");
			});
			stage.addChild(mmc);
			mmc.play();
			stage.addEventListener(TouchEvent.TOUCH_DOWN,function(e:Event) {
				//if (mmc.action==0) mmc.action=1; else mmc.action=0;
				mmc.direction=(mmc.direction+1)%8;
			});
        }
    }
}