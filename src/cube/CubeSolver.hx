package cube;
import openfl.ui.Keyboard;
import utils.Vector3D;

/**
 * ...
 * @author ...
 */
class CubeSolver
{
    private static inline var ST_STAND_BY:Int       = 0;
    private static inline var ST_FIRST_CROSS:Int    = 1;

    public function new( cube:RubikCube )
    {
        _cube = cube;
        _state = ST_STAND_BY;
    }

    private function findCoFaces( face:EntityFace ):Array<EntityFace>
    {
        var coFaces:Array<EntityFace> = getCachedArray();
        for ( coFace in face.parent.faces )
        {
            if ( coFace == face )    { continue; } // same face.
            if ( coFace.color == 0 ) { continue; } // face without color.
            coFaces.push( coFace );
        }
        return coFaces;
    }

    // The color of the current face is the color of the current RubikFace.
    private function isInItsRubikFace( face:EntityFace ):Bool
    {
        return isInRubikFace( face, RubikCube.getColorId( face.color ) );
    }

    // The face is in the RubikFace( color ).
    private function isInRubikFace( face:EntityFace, color:Int ):Bool
    {
        return ( face.normal.dot( Vector3D.directions[color] ) > 0 );
    }

    public function solve():Void
    {
        _state = ST_FIRST_CROSS;
        var arrayFaces:Array<EntityFace> = findFaces( RubikCube.COLOR_WHITE );
        var face:EntityFace = null;
        for ( fface in arrayFaces )
        {
            face = fface;
            if ( face.parent.type == SpacialEntity.TYPE_EDGE )
            {
                // Find edge elements with a white face in the white rubik face.
                if ( isInRubikFace( face, RubikCube.COLOR_WHITE ) )
                {
                    var oFaces:Array<EntityFace> = findCoFaces( face );
                    var numFacesInRightPlace:Int = 0;
                    for ( oFace in oFaces )
                    {
                        trace( RubikCube.getColorName( oFace.color ) );
                        // This element is in the right face.
                        if ( isInItsRubikFace( oFace ) )
                        {
                            trace( "Correct Position" );
                            numFacesInRightPlace++;
                        }
                    }
                    if ( numFacesInRightPlace == 4 )
                    {
                        trace( "Step completed: " + _state );
                    }
                    disposeCachedArray( oFaces );
                }
            }
        }
    }

    private function findFaces( color:Int ):Array<EntityFace>
    {
        var faces:Array<EntityFace> = getCachedArray();
        faces = _cube.faces.get( color );
        for ( face in faces )
        {
            switch( face.parent.type )
            {
                case SpacialEntity.TYPE_CORNER:
                    trace( "CORNER: " + face.normal.toString() );
                case SpacialEntity.TYPE_EDGE:
                    trace( "EDGE: " + face.normal.toString() );
            }
        }
        return faces;
    }

    public function onKeyDown( keycode:Int ):Void
    {
        switch ( keycode )
        {
            case Keyboard.P:
                solve();
        }
    }

    // This gives you an array from pool.
    private function getCachedArray():Array<EntityFace>
    {
        var array:Array<EntityFace> = null;
        if ( _cachedArray.length == 0 )
        {
            array = new Array<EntityFace>();
        }
        else
        {
            array = _cachedArray.shift();
            while ( array.length != 0 )
            {
                array.shift();
            }
        }
        return array;
    }

    // This add an array to pool.
    private function disposeCachedArray( array:Array<EntityFace> ):Void
    {
        _cachedArray.push( array );
    }

    private var _cube:RubikCube;
    private var _state:Int;

    private var _cachedArray:Array<Array<EntityFace>> = new Array<Array<EntityFace>>();
}
