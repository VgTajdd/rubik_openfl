package utils;

import core.Common;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Agustin
 */
class Console extends TextField
{
    private var _times:Array<Float>;

    public function new()
    {
        super();
        selectable = false;
        defaultTextFormat = new TextFormat( "Arial", 20, 0, true );
        _times = [];
        width = 250;
    }

    public function update():Void
    {
        var now:Float = Common.getTimer() / 1000;
        _times.push( now );
        while( _times[0] < now - 1 )
        {
            _times.shift();
        }
        if ( visible )
        {
            text = "FPS:" + _times.length + "/" + Lib.current.stage.frameRate;
            text += "\nA1: " + View3D.instance.angle1 + " - A2: " + View3D.instance.angle2;
        }
    }
}
