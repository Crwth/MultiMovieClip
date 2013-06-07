MultiMovieClip
==============

LoomScript class to provide Starling-like MovieClip functionality with support for directions and actions. includes port of Starling MovieClip class.


MultiMovieClip supports the idea of a single class that can select various strips of animation based on the character (alien, ogre, player), the action (run, shoot, jump, crawl, explode) and direction. It provides a simple interface for developers to provide information based on whether an animation loops or not, its animation speed, and even a default animation or frame.
It allows game logic to easily change these variables to easily animate your figures and objects.

MultiMovieClip wraps the MovieClip class, allowing it to be used anywhere you're used to using that. Since at this time (06/06/2013) there's no support in LoomScript for MovieClip, a local port is provided. This will be removed when official support is provided.
Internally, MultiMovieClip relies on TextureAtlas to pull in the frames of the animations. The naming scheme is defined as:

  objname_action_direction_frameno
  
Such as "marine_shoot_right_0" or "ogre_walk_d_0". MultiMovieClip builds up everything but the frameno as a filter to pull out current textures. Note that both action and direction are freeform values, so they can be used for any purpose to define two variables on an objname.


The constructor takes the following parameters:

  new MultiMovieClip(filelist, objname, animinfo, defaultaction, directions, defaultdirection, defaultfps);
  
    filelist - a Vector.<String> of file prefixes that define the .xml and .png of each sprite atlas. A single atlas prefix must still be in a Vector by itself.
    objname - the prefix at the start of all subtextures that will be pulled from the atlas(ses). While this can technically be changed via the .objname property, the idea is that a MultiMovieClip represents a type of object, like a ball or marine or monster, and this wouldn't change like actions and directions do.
    animinfo - A Dictionary.<String,AnimInfo>, which maps action names to a small structure that contains three flags: 
    
      reset - whether to return to the default action upon completion
      loop - whether this action plays once or loops continuously
      defaction - the default action to return to upon reset; this overrides the object's default action
      
      FPS will be included here, but is not currently supported.
      
    defaultaction - the name of the default action for this object, which defines its starting action, it fallback action if an invalid one is specified, and the action to reset to when finished another action.
    directions - a Vector.<String> of the names of the supported directions
    defaultdirection - the starting direction for the object
    defaultfps - default frames-per-second for animation, if not overridden per-animation (which isn't currently supported)

Example:

  var animinfo = {
      "walk":new AnimInfo(true,true),
      "shoot":new AnimInfo(true,false),
      "die":new AnimInfo(false,false),
      "idle":new AnimInfo(false,false)
    };
    
  var mmc = new MultiMovieClip(["assets/data/marine","marine", animinfo, "idle", ["up", "down", "left", "right"], "up", 12); 
