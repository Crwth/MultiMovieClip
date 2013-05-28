package
{
	import Loom2D.Display.Image;    
    import Loom2D.Display.Loom2DGame;
	import Loom2D.Display.StageScaleMode;
	import Loom2D.Display.MovieClip;
	
	import Loom2D.Events.Event;
	    
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

			var texvec:Vector.<Texture> =[];

			var polyTex:Texture=Texture.fromAsset("assets/data/polySprites.png");
			var xmldoc:XMLDocument=new XMLDocument();
			xmldoc.loadFile("assets/data/polySprites.xml");
			var xmlroot:XMLElement=xmldoc.rootElement();
			var ta:TextureAtlas=new TextureAtlas(polyTex,xmlroot);
			texvec=ta.getTextures("circle_");
			
			var mc=new MovieClip(texvec,5);
			mc.addEventListener(Event.COMPLETE,function(e:Event) {
				//trace("last frame");
			});
			stage.addChild(mc);
			mc.play();
        }
    }
}