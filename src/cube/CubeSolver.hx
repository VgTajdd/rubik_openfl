package cube;

/**
 * ...
 * @author ...
 */
class CubeSolver
{

    private static inline var ST_STAND_BY:Int = 0;
    private static inline var ST_FIRST_CROSS:Int = 1;

    public function new( cube:cube.RubikCube )
    {
        _cube = cube;
        _state = ST_STAND_BY;
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

            }
        }
    }

    function findFaces( color:Int ):Array<EntityFace>
    {
        var faces:Array<EntityFace> = [];
        faces = _cube.faces.get( color );
        for ( face in faces )
        {
            switch( face.parent.type )
            {
                case SpacialEntity.TYPE_CORNER:
                    trace( face.normal.toString() );
                case SpacialEntity.TYPE_EDGE:
                    trace( face.normal.toString() );
            }
        }
        return faces;
    }

    private var _cube:RubikCube;
    private var _state:Int;
}
