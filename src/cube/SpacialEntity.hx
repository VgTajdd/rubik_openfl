package cube;

import openfl.display.Sprite;
import utils.SpriteDepth;
import utils.Vector3D;

/**
 * ...
 * @author Agustin
 */
class SpacialEntity
{
    public static var SIZE:Int = 100;

    public var position:Vector3D;
    public var canvas:SpriteDepth;
    public var inRotation:Bool;
    public var faces:Array<EntityFace>;

    public function new( sCanvas:SpriteDepth, mCanvas:SpriteDepth, pos3D:Vector3D, faceVertices:Array<Array<Vector3D>> )
    {
        canvas = new SpriteDepth();

        _staticCanvas = sCanvas;
        _movingCanvas = mCanvas;

        inRotation = false;
        _staticCanvas.addChild( canvas );

        position = Vector3D.create();
        position.copyValuesFrom( pos3D );
        Vector3D.dispose( pos3D );

        faces = new Array<EntityFace>();

        var direction:Vector3D;
        var colorFace:Int = 1;

        while( Vector3D.directions[colorFace] != null )
        {
            direction = Vector3D.directions[colorFace].clone();
            faces.push( new EntityFace( this, canvas, direction,
                ( direction.dot( position ) > 0 ) ? colorFace : 0, faceVertices[colorFace - 1] ) );
            colorFace++;
        }
    }

    public function onRotation( value:Bool ):Void
    {
        if ( inRotation == value ) { return; }
        inRotation = value;
        if ( value )
        {
            _movingCanvas.addChild( canvas );
        }
        else
        {
            _staticCanvas.addChild( canvas );
            for ( face in faces )
            {
                face.normal.roundValues();
                position.roundValues();
            }
        }
    }

    public function rotateX( angle:Float ):Void
    {
        position.rotateX( angle );
        for ( face in faces )
        {
            face.rotateX( angle );
        }
    }

    public function rotateY( angle:Float ):Void
    {
        position.rotateY( angle );
        for ( face in faces )
        {
            face.rotateY( angle );
        }
    }

    public function rotateZ( angle:Float ):Void
    {
        position.rotateZ( angle );
        for ( face in faces )
        {
            face.rotateZ( angle );
        }
    }

    private var _staticCanvas:SpriteDepth;
    private var _movingCanvas:SpriteDepth;
}
