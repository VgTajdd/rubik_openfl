package utils;

import cube.EntityFace;
import openfl.display.Sprite;

/**
 * ...
 * @author Agustin
 */

class SpriteDepth extends Sprite
{
    public var depth:Float = 0;
    public var face:EntityFace = null;

    public static var swaps:Int = 0;

    public function new()
    {
        super();
    }

    override public function swapChildrenAt( child1:Int, child2:Int ):Void
    {
        super.swapChildrenAt( child1, child2 );
        swaps++;
    }

}
