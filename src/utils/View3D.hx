package utils;

import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Vector3D;
import openfl.ui.Keyboard;
import openfl.Vector;

/**
 * ...
 * @author Agustin
 */
class View3D
{
    public var camera:utils.Vector3D;

    public static var instance:View3D;

    public function new()
    {
        angle1 = 45;
        angle2 = -45;

        m_matrixA = new Matrix3D();

        m_vectorA = new Vector3D( 0, 0, 1 );
        m_vectorB = new Vector3D( 0, 1, 0 );

        m_temporalPoint = new Point();

        camera = new utils.Vector3D();

        m_initialCamera = new Vector<Float>();
        m_initialCamera.push( 1 );// To fix to use perspective.
        m_initialCamera.push( 0 );
        m_initialCamera.push( 0 );

        instance = this;

        _dirty = true;
    }

    public function onKeyDown( keyCode:Int ):Void
    {
        switch( keyCode )
        {
            case Keyboard.UP:
                angle2--;
                _dirty = true;
            case Keyboard.DOWN:
                angle2++;
                _dirty = true;
            case Keyboard.LEFT:
                angle1--;
                _dirty = true;
            case Keyboard.RIGHT:
                angle1++;
                _dirty = true;
        }
    }

    public function onKeyUp( keyCode:Int ):Void
    {
        switch( keyCode )
        {
            case Keyboard.UP:
            case Keyboard.DOWN:
            case Keyboard.LEFT:
            case Keyboard.RIGHT:
        }
    }

    public function update( dt:Int = 0 ):Void
    {
        //
        onKeyDown( Keyboard.RIGHT );
        //
        if ( !_dirty ) { return; }
        m_matrixA.identity();
        m_matrixA.appendRotation( angle2, m_vectorB );
        m_matrixA.appendRotation( angle1, m_vectorA );
        m_matrixA.transformVectors( m_initialCamera, camera.getVectorFloat() );
        camera.copyFromFloatVector();
        m_matrixA.invert();
        _dirty = false;
    }

    public function getScreenPosition( point:Vector<Float> ):Vector<Float>
    {
        m_matrixA.transformVectors( point, point );

#if 0 //Perspective used.
        m_temporalPoint.x = point[1] * ( 0.9 + point[0] / 1500 );
        m_temporalPoint.y = -point[2] * ( 0.9 + point[0] / 1500 );
#else
        m_temporalPoint.x = point[1];
        m_temporalPoint.y = -point[2];
#end
        m_temporalPoint;

        point[2] = point[0];          // Depth
        point[0] = m_temporalPoint.x + 250; // screenX
        point[1] = m_temporalPoint.y + 250; // screenY

        return point;
    }

    private var m_matrixA:Matrix3D;
    private var m_vectorA:Vector3D;
    private var m_vectorB:Vector3D;
    private var m_temporalPoint:Point;
    private var m_initialCamera:Vector<Float>;
    public var angle1:Float;
    public var angle2:Float;

    private var _dirty:Bool;
}
