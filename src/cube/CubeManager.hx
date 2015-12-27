package cube;

import cube.CubeManager.DataRotation;
import cube.RubikCube;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Agustin
 */
class CubeManager
{
    public var onEndInitialTransition:Void->Void;

    public function new( cube:RubikCube )
    {
        _cube = cube;
        _cube.onEndRotation = onEndRotation;
        _queue = [];
        _auxQueue = [];
        _ctrlPressed = false;
    }

    public function unsort( steps:Int = 50 ):Void
    {
        var k:Int = 0;
        while ( k < steps )
        {
            _queue.push( new DataRotation( Math.round( Math.random() * 5 ) + 1 ) );
            k++;
        }

        // Saving unsorting queue.
        while ( k > 0 )
        {
            k--;
            _tempDataRotation = _queue[k];
            _auxQueue.push( new DataRotation( _tempDataRotation.face, false ) );
        }
        checkQueue();
    }

    private function checkQueue():Void
    {
        if ( _queue.length != 0 )
        {
            _tempDataRotation = _queue.shift();
            _cube.rotateFace( _tempDataRotation.face, _tempDataRotation.clockwise,
             _tempDataRotation.time );
            _cubeInRotation = true;
        }
        else
        {
            if ( onEndInitialTransition != null )
            {
                onEndInitialTransition();
                onEndInitialTransition = null;
            }
        }
    }

    public function onKeyDown( keycode:Int ):Void
    {
        var face:Int = -1;
        switch ( keycode )
        {
            case Keyboard.CONTROL:
                _ctrlPressed = true;
            case Keyboard.NUMBER_1:
                face = 1;
            case Keyboard.NUMBER_2:
                face = 2;
            case Keyboard.NUMBER_3:
                face = 3;
            case Keyboard.NUMBER_4:
                face = 4;
            case Keyboard.NUMBER_5:
                face = 5;
            case Keyboard.NUMBER_6:
                face = 6;
            case Keyboard.S:
                if ( !_cubeInRotation )
                {
                    revertUnsorting();
                }
        }
        if ( face != -1 )
        {
            _auxQueue.unshift( new DataRotation( face, _ctrlPressed ) );
            if ( _cubeInRotation )
            {
                _queue.push( new DataRotation( face, !_ctrlPressed, 200 ) );
            }
            else
            {
                _cube.rotateFace( face, !_ctrlPressed, 200 );
                _cubeInRotation = true;
            }
        }
    }

    public function onKeyUp( keycode:Int ):Void
    {
        switch ( keycode )
        {
            case Keyboard.CONTROL:
                _ctrlPressed = false;
        }
    }

    public function revertUnsorting():Void
    {
        while ( _auxQueue.length != 0 )
        {
            _queue.push( _auxQueue.shift() );
        }
        checkQueue();
    }

    public function update( dt:Int ):Void
    {

    }

    private function onEndRotation():Void
    {
        _cubeInRotation = false;
        checkQueue();
    }

    private var _cube:RubikCube;
    private var _queue:Array<DataRotation>;
    private var _auxQueue:Array<DataRotation>;
    private var _tempDataRotation:DataRotation;
    private var _ctrlPressed:Bool;
    private var _cubeInRotation:Bool;
}

class DataRotation
{
    public var face:Int;
    public var clockwise:Bool;
    public var time:Int;
    public function new( f:Int, cw:Bool = true, t:Int = 50 )
    {
        face = f;
        clockwise = cw;
        time = t;
    }
}
