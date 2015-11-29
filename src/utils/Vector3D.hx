package utils;

import openfl.Vector;

/**
 * ...
 * @author Agustin
 */
class Vector3D
{
    public static inline var DIR_X_N:Int = 1;
    public static inline var DIR_X_P:Int = 2;
    public static inline var DIR_Y_N:Int = 3;
    public static inline var DIR_Y_P:Int = 4;
    public static inline var DIR_Z_N:Int = 5;
    public static inline var DIR_Z_P:Int = 6;

    public var x:Float;
    public var y:Float;
    public var z:Float;

    public var disposed:Bool;

    public static var pool:Array<Vector3D> = new Array<Vector3D>();
    public static var instancesCreated:Int = 0;

    public static var directions:Array<Vector3D> =
    [
        Vector3D.create( 0, 0, 0 ),
        Vector3D.create( -1, 0, 0 ),
        Vector3D.create( 1, 0, 0 ),
        Vector3D.create( 0, -1, 0 ),
        Vector3D.create( 0, 1, 0 ),
        Vector3D.create( 0, 0, -1 ),
        Vector3D.create( 0, 0, 1 )
    ];

    public var vectorFloat:Vector<Float>;

    public function new( x:Float = 0, y:Float = 0, z:Float = 0 )
    {
        this.x = x;
        this.y = y;
        this.z = z;

        vectorFloat = new Vector<Float>();
        vectorFloat.push( 0 );
        vectorFloat.push( 0 );
        vectorFloat.push( 0 );
        disposed = false;
        ++instancesCreated;
        //trace( "New Vector3D created - [" + instancesCreated + " instances]" );
    }

	public function toString():String
	{
		return "[X: " + x + " - Y: " + y + " - Z: " + z + "]";
	}

    public static inline function create( x:Float = 0, y:Float = 0, z:Float = 0 ):Vector3D
    {
        var vector:Vector3D;
        if ( pool.length > 0 )
        {
            vector = pool.pop();
            vector.x = x;
            vector.y = y;
            vector.z = z;
            vector.disposed = false;
        }
        else
        {
            vector = new Vector3D( x, y, z );
        }
        return vector;
    }

    public function product( b:Vector3D ):Vector3D
    {
        var result:Vector3D = Vector3D.create();
        result.x = y * b.z - b.y + z;
        result.y = -x * b.z + b.x + z;
        result.z = x * b.y - b.x + y;
        return result;
    }

    public function dot( b:Vector3D ):Float
    {
        return x * b.x + y * b.y + z * b.z;
    }

    public function rotateX( angle:Float ):Void
    {
        var result:Vector3D = Vector3D.create( x, y, z );
        result.y = y * Math.cos( angle ) - z * Math.sin( angle );
        result.z = y * Math.sin( angle ) + z * Math.cos( angle );
        copyValuesFrom( result );
        Vector3D.dispose( result );
    }

    public function rotateY( angle:Float ):Void
    {
        var result:Vector3D = Vector3D.create( x, y, z );
        result.x = x * Math.cos( angle ) + z * Math.sin( angle );
        result.z = -x * Math.sin( angle ) + z * Math.cos( angle );
        copyValuesFrom( result );
        Vector3D.dispose( result );
    }

    public function rotateZ( angle:Float ):Void
    {
        var result:Vector3D = Vector3D.create( x, y, z );
        result.x = x * Math.cos( angle ) - y * Math.sin( angle );
        result.y = x * Math.sin( angle ) + y * Math.cos( angle );
        copyValuesFrom( result );
        Vector3D.dispose( result );
    }

    public function copyValuesFrom( a:Vector3D ):Void
    {
        x = a.x;
        y = a.y;
        z = a.z;
    }

    public function clone():Vector3D
    {
        return Vector3D.create( x, y, z );
    }

    public static inline function dispose( a:Vector3D ):Void
    {
        a.disposed = true;
        pool.push( a );
        //trace( "Vector3D pool size = [" + pool.length + "]" );
    }

    public function scale( scale:Float ):Void
    {
        x *= scale;
        y *= scale;
        z *= scale;
    }

    public function add( b:Vector3D ):Void
    {
        x += b.x;
        y += b.y;
        z += b.z;
    }

    public function length():Float
    {
        return Math.pow( x * x + y * y + z * z, 0.5 );
    }

    public function normalize():Void
    {
        scale( ( 1 / length() ) );
    }

    public function getVectorFloat():Vector<Float>
    {
        vectorFloat[0] = x;
        vectorFloat[1] = y;
        vectorFloat[2] = z;
        return vectorFloat;
    }

    public function copyFromFloatVector():Void
    {
        x = vectorFloat[0];
        y = vectorFloat[1];
        z = vectorFloat[2];
    }

    public function roundValues() :Void
    {
        x = Math.round( x );
        y = Math.round( y );
        z = Math.round( z );
    }

}
