package cube;

import cube.CubeRenderer;
import cube.EntityFace;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.ds.Vector;
import openfl.display.Sprite;
import utils.ExponentialInterpolation;
import utils.SpriteDepth;
import utils.ValueInterpolation;
import utils.Vector3D;

/**
 * ...
 * @author Agustin
 */
class RubikCube
{
    public static inline var COLOR_GREEN:Int = Vector3D.DIR_Y_N;
    public static inline var COLOR_BLUE:Int = Vector3D.DIR_Y_P;
    public static inline var COLOR_ORANGE:Int = Vector3D.DIR_X_N;
    public static inline var COLOR_RED:Int = Vector3D.DIR_X_P;
    public static inline var COLOR_YELLOW:Int = Vector3D.DIR_Z_N;
    public static inline var COLOR_WHITE:Int = Vector3D.DIR_Z_P;

    public static inline var ST_ROTATION_FACE:Int = 1;
    public static inline var ST_STAND:Int = 2;

    public var elements:Array<SpacialEntity>;

    public var faces:IntMap<Array<EntityFace>>;

    public static var instance:RubikCube;

    public var staticCanvas:SpriteDepth;
    public var movingCanvas:SpriteDepth;

    public var onEndRotation:Void->Void;

    public static function init( canvasToRender:SpriteDepth = null ):Void
    {
        new RubikCube( canvasToRender );
    }

    static public function getColor( value:Float ):Int
    {
        switch( value )
        {
            case COLOR_BLUE:
                return 0x0000ff;
            case COLOR_GREEN:
                return 0x00ff00;
            case COLOR_RED:
                return 0xff0000;
            case COLOR_YELLOW:
                return 0xffff00;
            case COLOR_ORANGE:
                return 0xff7700;
            case COLOR_WHITE:
                return 0xffffff;
        }
        return 0;
    }

    public function new( canvasToRender:SpriteDepth = null )
    {
        instance = this;

        _rotatingElements = [];
        _state = 0;
        _interpolator = null;
        _lastAngle = 0;

        var _vertices:Array<Vector3D>;
        var halfSize:Float = SpacialEntity.SIZE / 2;
        _vertices = new Array<Vector3D>();
        _vertices.push( Vector3D.create( -halfSize, -halfSize, -halfSize ) );
        _vertices.push( Vector3D.create( -halfSize, -halfSize, halfSize ) );
        _vertices.push( Vector3D.create( -halfSize, halfSize, -halfSize ) );
        _vertices.push( Vector3D.create( -halfSize, halfSize, halfSize ) );
        _vertices.push( Vector3D.create( halfSize, -halfSize, -halfSize ) );
        _vertices.push( Vector3D.create( halfSize, -halfSize, halfSize ) );
        _vertices.push( Vector3D.create( halfSize, halfSize, -halfSize ) );
        _vertices.push( Vector3D.create( halfSize, halfSize, halfSize ) );

        var _faceVerticesArray:Array<Array<Vector3D>> = new Array<Array<Vector3D>>();

        // Face X - P
        var _faceVerticesXP:Array<Vector3D> = new Array<Vector3D>();
        _faceVerticesXP.push( _vertices[5].clone() );
        _faceVerticesXP.push( _vertices[4].clone() );
        _faceVerticesXP.push( _vertices[6].clone() );
        _faceVerticesXP.push( _vertices[7].clone() );

        // Face X - N
        var _faceVerticesXN:Array<Vector3D> = new Array<Vector3D>();
        _faceVerticesXN.push( _vertices[1].clone() );
        _faceVerticesXN.push( _vertices[0].clone() );
        _faceVerticesXN.push( _vertices[2].clone() );
        _faceVerticesXN.push( _vertices[3].clone() );

        // Face Y - P
        var _faceVerticesYP:Array<Vector3D> = new Array<Vector3D>();
        _faceVerticesYP.push( _vertices[3].clone() );
        _faceVerticesYP.push( _vertices[2].clone() );
        _faceVerticesYP.push( _vertices[6].clone() );
        _faceVerticesYP.push( _vertices[7].clone() );

        // Face Y - N
        var _faceVerticesYN:Array<Vector3D> = new Array<Vector3D>();
        _faceVerticesYN.push( _vertices[1].clone() );
        _faceVerticesYN.push( _vertices[0].clone() );
        _faceVerticesYN.push( _vertices[4].clone() );
        _faceVerticesYN.push( _vertices[5].clone() );

        // Face Z - P
        var _faceVerticesZP:Array<Vector3D> = new Array<Vector3D>();
        _faceVerticesZP.push( _vertices[3].clone() );
        _faceVerticesZP.push( _vertices[1].clone() );
        _faceVerticesZP.push( _vertices[5].clone() );
        _faceVerticesZP.push( _vertices[7].clone() );

        // Face Z - N
        var _faceVerticesZN:Array<Vector3D> = new Array<Vector3D>();
        _faceVerticesZN.push( _vertices[2].clone() );
        _faceVerticesZN.push( _vertices[0].clone() );
        _faceVerticesZN.push( _vertices[4].clone() );
        _faceVerticesZN.push( _vertices[6].clone() );

        _faceVerticesArray.push( _faceVerticesXN );
        _faceVerticesArray.push( _faceVerticesXP );
        _faceVerticesArray.push( _faceVerticesYN );
        _faceVerticesArray.push( _faceVerticesYP );
        _faceVerticesArray.push( _faceVerticesZN );
        _faceVerticesArray.push( _faceVerticesZP );

        while ( _vertices.length > 0 )
        {
            Vector3D.dispose( _vertices.pop() );
        }

        elements = new Array<SpacialEntity>();
        faces = new IntMap<Array<EntityFace>>();

        if ( canvasToRender != null )
        {
            staticCanvas = new SpriteDepth();
            movingCanvas = new SpriteDepth();
            canvasToRender.addChild( staticCanvas );
            canvasToRender.addChild( movingCanvas );
            _renderer = new CubeRenderer( this, staticCanvas, movingCanvas, canvasToRender );
        }

        var x:Int = -1;
        var y:Int = -1;
        var z:Int = -1;

        while ( x < 2 )
        {
            y = -1;
            while ( y < 2 )
            {
                z = -1;
                while ( z < 2 )
                {
                    elements.push( new SpacialEntity( staticCanvas, movingCanvas, Vector3D.create( SpacialEntity.SIZE * x,
                        SpacialEntity.SIZE * y, SpacialEntity.SIZE * z ), _faceVerticesArray ) );
                    z++;
                }
                y++;
            }
            x++;
        }

        for ( array in _faceVerticesArray )
        {
            for ( vector in array )
            {
                Vector3D.dispose( vector );
                vector = null;
            }
        }

        _faceVerticesArray = null;
    }

    public function rotateFace( direction:Int, clockwise:Bool = true, time:Int = 50 ):Void
    {
        startRotation( direction, clockwise? Math.PI / 2: -Math.PI / 2, time );
    }

    private function startRotation( direction:Int, angle:Float, time:Int = 50 ):Void
    {
        if ( Vector3D.directions[direction] == null )
        {
            throw( "No valid direction" );
        }

        for ( element in elements )
        {
            if ( element.position.dot( Vector3D.directions[direction] ) > 0 )
            {
                element.onRotation( true );
                _rotatingElements.push( element );
            }
        }

        _state = ST_ROTATION_FACE;
        _currentDirection = direction;
        _interpolator = new ExponentialInterpolation( 0, angle, time, -5 );
        _interpolator.onEndInterpolation = onEndInterpolation;
    }

    private function onEndInterpolation( interpolator:ValueInterpolation ):Void
    {
        updateRotation();
        for ( element in _rotatingElements )
        {
            element.onRotation( false );
        }
        _rotatingElements.splice( 0, _rotatingElements.length );
        _state = ST_STAND;
        interpolator.free();
        _interpolator = null;
        _lastAngle = 0;
        if ( onEndRotation != null )
        {
            onEndRotation();
        }
    }

    private function updateRotation():Void
    {
        for ( element in _rotatingElements )
        {
            switch( _currentDirection )
            {
                case Vector3D.DIR_X_P:
                    element.rotateX( _interpolator.value() - _lastAngle );
                case Vector3D.DIR_X_N:
                    element.rotateX( _interpolator.value() - _lastAngle );
                case Vector3D.DIR_Y_P:
                    element.rotateY( _interpolator.value() - _lastAngle );
                case Vector3D.DIR_Y_N:
                    element.rotateY( _interpolator.value() - _lastAngle );
                case Vector3D.DIR_Z_P:
                    element.rotateZ( _interpolator.value() - _lastAngle );
                case Vector3D.DIR_Z_N:
                    element.rotateZ( _interpolator.value() - _lastAngle );
            }
        }

        _lastAngle = _interpolator.value();
    }

    public function renderCube():Void
    {
        if ( _renderer != null )
        {
            _renderer.render();
        }
    }

    public function update( dt:Int ):Void
    {
        switch( _state )
        {
            case ST_ROTATION_FACE:
                _interpolator.update( dt );
                if ( _interpolator != null )
                {
                    updateRotation();
                }
        }
        renderCube();
    }

    public function addFaceToBuffer( color:Int, entityFace:EntityFace ):Void
    {
        if ( !faces.exists( color ) )
        {
            faces.set( color, new Array<EntityFace>() );
        }
        faces.get( color ).push( entityFace );
    }

    private var _renderer:CubeRenderer;

    private var _state:Int;
    private var _rotatingElements:Array<SpacialEntity>;
    private var _interpolator:ExponentialInterpolation;
    private var _currentDirection:Int;
    private var _lastAngle:Float;
}
