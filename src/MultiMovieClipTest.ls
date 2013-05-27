package
{
	import Loom2D.Display.Image;    
    import Loom2D.Display.Loom2DGame;
	import Loom2D.Display.StageScaleMode;
	import Loom2D.Display.MovieClip;    
    import Loom2D.Textures.Texture;
    
    import Loom2D.UI.TextureAtlasManager;
    import Loom2D.UI.TextureAtlasSprite;

    public class MultiMovieClipTest extends Loom2DGame
    {
        override public function run():void
        {
            super.run();

            // Comment out this line to turn off automatic scaling.
            stage.scaleMode = StageScaleMode.LETTERBOX;

			TextureAtlasManager.register("polySprites", "assets/data/");
			var texvec:Vector.<Texture> =[];

			texvec.push(TextureAtlasManager.getTexture("polySprites","circle_blue_down.png"));
			texvec.push(TextureAtlasManager.getTexture("polySprites","circle_yellow_down.png"));
			texvec.push(TextureAtlasManager.getTexture("polySprites","circle_purple_down.png"));
			texvec.push(TextureAtlasManager.getTexture("polySprites","circle_red_down.png"));
			
			var mc=new MovieClip(texvec,1);
			group.injectInto(mc);
			mc.play();
			stage.addChild(mc);
        }
    }
}