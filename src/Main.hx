package;

import core.Application;
import core.Common;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

class Main extends Sprite
{

    public function new ()
    {
        super ();
        init();
        addEventListener( Event.ENTER_FRAME, onEnterFrame );
        m_lastTime = Common.getTimer();
    }

    private function onEnterFrame( e:Event ):Void
    {
        Application.instance.update( Common.getTimer() - m_lastTime );
        m_lastTime = Common.getTimer();
    }

    public function init():Void
    {
        new Application( this );
    }

    public static function main ()
    {
        Application.setupLogs();
        Lib.current.addChild ( new Main () );
    }

    private var m_lastTime:Int;
}
