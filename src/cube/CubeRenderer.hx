package cube;

import core.Common;
import cube.SpacialEntity;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.Vector;
import utils.SpriteDepth;
import utils.Vector3D;
import utils.View3D;

/**
 * ...
 * @author Agustin
 */
class CubeRenderer
{
    public function new( cube:RubikCube, staticCanvas:SpriteDepth,
        movingCanvas:SpriteDepth, canvas:SpriteDepth )
    {
        _staticCanvas = staticCanvas;
        _movingCanvas = movingCanvas;
        _canvas = canvas;
        _cube = cube;
    }

    public function render():Void
    {
        for ( el in _cube.elements )
        {
            renderElement( el );
            sortDepth( el.canvas );
        }

        var totalChildren:Int = 0;

        sortDepth( _staticCanvas );

        _staticCanvas.depth = 0;
        totalChildren = _staticCanvas.numChildren;
        for ( i in 0...totalChildren )
        {
            _staticCanvas.depth += cast( _staticCanvas.getChildAt( i ), SpriteDepth ).depth / totalChildren;
        }

        sortDepth( _movingCanvas );

        _movingCanvas.depth = 0;
        totalChildren = _movingCanvas.numChildren;
        for ( i in 0...totalChildren )
        {
            _movingCanvas.depth += cast( _movingCanvas.getChildAt( i ), SpriteDepth ).depth / totalChildren;
        }

        sortDepth( _canvas );

        if ( SpriteDepth.swaps != 0 )
        {
            SpriteDepth.swaps = 0;
        }
    }

    public function renderElement( element:SpacialEntity ):Void
    {
        var v3d:Vector3D = Vector3D.create();
        var pScreen:Vector<Float>;
        var k:Int = 0;

        for ( face in element.faces )
        {
            face.canvas.graphics.clear();
#if 1
            if ( View3D.instance.camera.dot( face.normal ) > 0 )
            {
                face.canvas.visible = true;
            }
            else
            {
                face.canvas.visible = false;
                continue;
            }
#end

            k = 0;
            for ( vertex in face.relativeVertexArray )
            {
                v3d.copyValuesFrom( element.position );
                v3d.add( vertex );
                pScreen = View3D.instance.getScreenPosition( v3d.getVectorFloat() );
                face.fVector[k] = pScreen[0];
                face.fVector[k + 1] = pScreen[1];
                k += 2;
            }

            Common.drawQuad( face.canvas, face.fVector, face.bitmapData, face.color );

            v3d.copyValuesFrom( face.relativeCenter );
            v3d.add( element.position );
            pScreen = View3D.instance.getScreenPosition( v3d.getVectorFloat() );
            face.canvas.depth = -pScreen[2];
        }

        v3d.copyValuesFrom( element.position );
        pScreen = View3D.instance.getScreenPosition( v3d.getVectorFloat() );
        element.canvas.depth = -pScreen[2];

        Vector3D.dispose( v3d );
    }

    public function sortDepth( canvas:SpriteDepth ):Void
    {
        var swapped:Bool = false;
        var total:Int = canvas.numChildren - 1;
        var sprite1:SpriteDepth = null;
        var sprite2:SpriteDepth = null;

        do {
            swapped = false;
            for ( i in 0...total )
            {
                sprite1 = cast( canvas.getChildAt( i ), SpriteDepth );
                sprite2 = cast( canvas.getChildAt( i + 1 ), SpriteDepth );

                if ( !sprite1.visible ) { continue; }
                if ( !sprite2.visible ) { continue; }

                if ( sprite1.depth < sprite2.depth )
                {
                    canvas.swapChildrenAt( i, i + 1 );
                    swapped = true;
                }
            }
        }
        while ( swapped );
    }

    private var _staticCanvas:SpriteDepth;
    private var _movingCanvas:SpriteDepth;
    private var _canvas:SpriteDepth;
    private var _cube:RubikCube;
}
