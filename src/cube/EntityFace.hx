package cube;

import core.Common;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Vector;
import utils.SpriteDepth;
import utils.Vector3D;

/**
 * ...
 * @author Agustin
 */
class EntityFace
{
    public var canvas:SpriteDepth;
    public var color:Int;
    public var bitmapData:BitmapData;
    public var relativeVertexArray:Array<Vector3D>;
    public var normal:Vector3D;
    public var relativeCenter:Vector3D;
    public var fVector:Vector<Float>;
    public var parent:SpacialEntity;

    public function new( parent:SpacialEntity, parentCanvas:Sprite, vec3D:Vector3D, color:Int, _vertexArray:Array<Vector3D> )
    {
        this.parent = parent;
        canvas = new SpriteDepth();
        canvas.face = this;
        parentCanvas.addChild( canvas );
        normal = Vector3D.create();
        relativeCenter = Vector3D.create();
        normal.copyValuesFrom( vec3D );
        this.color = RubikCube.getColorRGB( color );
        relativeVertexArray = new Array<Vector3D>();
        for ( _vertex in _vertexArray )
        {
            relativeVertexArray.push( _vertex.clone() );
            relativeCenter.add( _vertex );
        }
        relativeCenter.scale( 0.25 );
        bitmapData = Common.instance.getTexture( color ).clone();
        fVector = new Vector<Float>();
        for ( i in 0...7 )
        {
            fVector.push( 0 );
        }
        RubikCube.instance.addFaceToBuffer( color, this );
    }

    public function rotateX( angle:Float ):Void
    {
        normal.rotateX( angle );
        relativeCenter.rotateX( angle );
        for ( vertex in relativeVertexArray )
        {
            vertex.rotateX( angle );
        }
    }

    public function rotateY( angle:Float ):Void
    {
        normal.rotateY( angle );
        relativeCenter.rotateY( angle );
        for ( vertex in relativeVertexArray )
        {
            vertex.rotateY( angle );
        }
    }

    public function rotateZ( angle:Float ):Void
    {
        normal.rotateZ( angle );
        relativeCenter.rotateZ( angle );
        for ( vertex in relativeVertexArray )
        {
            vertex.rotateZ( angle );
        }
    }
}
