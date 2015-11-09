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
    }

    function findFaces( colorWhite:Int ):Array<EntityFace>
    {
        var faces:Array<EntityFace> = [];
        return faces;
    }

    private var _cube:RubikCube;
    private var _state:Int;
}
