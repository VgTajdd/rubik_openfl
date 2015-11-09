package cube;

import cube.CubeManager.DataRotation;
import cube.RubikCube;

/**
 * ...
 * @author Agustin
 */
class CubeManager
{
    public function new( cube:RubikCube )
    {
        _cube = cube;
        _cube.onEndRotation = onEndRotation;
        _queue = [];

        // Temporal code.
        var steps:Int = 50;

        var k:Int = 0;
        while ( k < steps )
        {
            _queue.push( new DataRotation( Math.round( Math.random() * 5 ) + 1 ) );
            k++;
        }

        //while ( k > 0 )
        //{
            //k--;
            //_tempDataRotation = _queue[k];
            //_queue.push( new DataRotation( _tempDataRotation.face, false ) );
        //}
    }

    public function start():Void
    {
        checkQueue();
    }

    private function checkQueue():Void
    {
        if ( _queue.length != 0 )
        {
            _tempDataRotation = _queue.pop();
            _cube.rotateFace( _tempDataRotation.face, _tempDataRotation.clockwise );
        }
    }

    public function update( dt:Int ):Void
    {

    }

    private function onEndRotation():Void
    {
        checkQueue();
    }

    private var _cube:RubikCube;
    private var _queue:Array<DataRotation>;
    private var _tempDataRotation:DataRotation;
}

class DataRotation
{
    public var face:Int;
    public var clockwise:Bool;
    public function new( f:Int, cw:Bool = true )
    {
        face = f;
        clockwise = cw;
    }
}
