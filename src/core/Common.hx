package core;

import cube.RubikCube;
import haxe.ds.IntMap;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.TriangleCulling;
import openfl.geom.Matrix;
import openfl.Vector;

/**
 * ...
 * @author Agustin
 */

class Common
{
    public static var instance:Common;

    static var vIndices:Vector<Int>;
    static var vColors:Vector<Int>;
    static var vUVs:Vector<Float>;

    public function new()
    {
        instance = this;

        vIndices = new Vector<Int>();
        vColors = new Vector<Int>();
        vUVs = new Vector<Float>();

        vColors.push(0xffffffff);
        vColors.push(0xffffffff);
        vColors.push(0xffffffff);
        vColors.push(0xffffffff);

        vUVs.push(0);
        vUVs.push(0);
        vUVs.push(0);
        vUVs.push(1);
        vUVs.push(1);
        vUVs.push(1);
        vUVs.push(1);
        vUVs.push(0);

        vIndices.push(0);
        vIndices.push(1);
        vIndices.push(2);
        vIndices.push(2);
        vIndices.push(3);
        vIndices.push(0);

        loadColorTextures();
    }

    function loadColorTextures():Void
    {
        _textures = new IntMap<BitmapData>();

        // Create the texture. This can be a static image, but it should tile
        // horizontally and be continuous.

        var texture:Shape = new Shape();
        var mtx:Matrix = new Matrix();

        // Flash player 11 requires this texture to be at least 2 pixels high
        mtx.createGradientBox( 400, 2 );

        texture.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0xff0000, 0x000070, 0x00ff00],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx );
        texture.graphics.drawRect( 0, 0, 400, 2 );
        texture.graphics.endFill();

        _textures.set( 10, new BitmapData( Std.int( texture.width ),
                                  Std.int( texture.height ),
                                  false ) );
        _textures.get( 10 ).draw( texture );

        // Black.
        var texture0:Shape = new Shape();
        var mtx0:Matrix = new Matrix();
        mtx0.createGradientBox( 400, 2 );

        texture0.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0x000000, 0x000000, 0x000000],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx0 );
        texture0.graphics.drawRect( 0, 0, 400, 2 );
        texture0.graphics.endFill();

        _textures.set( 0, new BitmapData( Std.int( texture0.width ),
                                  Std.int( texture0.height ),
                                  false ) );
        _textures.get( 0 ).draw( texture0 );

        // Red.
        var texture1:Shape = new Shape();
        var mtx1:Matrix = new Matrix();
        mtx1.createGradientBox( 400, 2 );

        texture1.graphics.clear();
        texture1.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0xff0000, 0xbb0000, 0xff0000],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx1 );
        texture1.graphics.drawRect( 0, 0, 400, 2 );
        texture1.graphics.endFill();

        _textures.set( RubikCube.COLOR_RED, new BitmapData( Std.int( texture1.width ),
                                  Std.int( texture1.height ),
                                  false ) );
        _textures.get( RubikCube.COLOR_RED ).draw( texture1 );

        // Orange.
        var texture2:Shape = new Shape();
        var mtx2:Matrix = new Matrix();
        mtx2.createGradientBox( 400, 2 );

        texture2.graphics.clear();
        texture2.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0xff7700, 0xff8800, 0xff7700],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx2 );
        texture2.graphics.drawRect( 0, 0, 400, 2 );
        texture2.graphics.endFill();

        _textures.set( RubikCube.COLOR_ORANGE, new BitmapData( Std.int( texture2.width ),
                                  Std.int( texture2.height ),
                                  false ) );
        _textures.get( RubikCube.COLOR_ORANGE ).draw( texture2 );

        // Green.
        var texture3:Shape = new Shape();
        var mtx3:Matrix = new Matrix();
        mtx3.createGradientBox( 400, 2 );

        texture3.graphics.clear();
        texture3.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0x00ff00, 0x00bb00, 0x00ff00],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx3 );
        texture3.graphics.drawRect( 0, 0, 400, 2 );
        texture3.graphics.endFill();

        _textures.set( RubikCube.COLOR_GREEN, new BitmapData( Std.int( texture3.width ),
                                  Std.int( texture3.height ),
                                  false ) );
        _textures.get( RubikCube.COLOR_GREEN ).draw( texture3 );

        // Blue.
        var texture4:Shape = new Shape();
        var mtx4:Matrix = new Matrix();
        mtx4.createGradientBox( 400, 2 );

        texture4.graphics.clear();
        texture4.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0x0000ff, 0x0000cc, 0x0000ff],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx4 );
        texture4.graphics.drawRect( 0, 0, 400, 2 );
        texture4.graphics.endFill();

        _textures.set( RubikCube.COLOR_BLUE, new BitmapData( Std.int( texture4.width ),
                                  Std.int( texture4.height ),
                                  false ) );
        _textures.get( RubikCube.COLOR_BLUE ).draw( texture4 );

        // Yellow.
        var texture5:Shape = new Shape();
        var mtx5:Matrix = new Matrix();
        mtx5.createGradientBox( 400, 2 );

        texture5.graphics.clear();
        texture5.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0xffff00, 0xffdd00, 0xffff00],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx5 );
        texture5.graphics.drawRect( 0, 0, 400, 2 );
        texture5.graphics.endFill();

        _textures.set( RubikCube.COLOR_YELLOW, new BitmapData( Std.int( texture5.width ),
                                  Std.int( texture5.height ),
                                  false ) );
        _textures.get( RubikCube.COLOR_YELLOW ).draw( texture5 );

        // White.
        var texture6:Shape = new Shape();
        var mtx6:Matrix = new Matrix();
        mtx6.createGradientBox( 400, 2 );

        texture6.graphics.clear();
        texture6.graphics.beginGradientFill( GradientType.LINEAR,
                                           [0xffffff, 0xffffbb, 0xffffff],
                                           [1, 1, 1],
                                           [0, 128, 255],
                                           mtx6 );
        texture6.graphics.drawRect( 0, 0, 400, 2 );
        texture6.graphics.endFill();

        _textures.set( RubikCube.COLOR_WHITE, new BitmapData( Std.int( texture6.width ),
                                  Std.int( texture6.height ),
                                  false ) );
        _textures.get( RubikCube.COLOR_WHITE ).draw( texture6 );
    }

    public static function showCurrentTime():Void
    {
        trace( Date.now() );
    }

    static public function drawQuad( canvas:Sprite, vVertices:Vector<Float>, bitmapData:BitmapData, color:Int ):Void
    {
        if ( bitmapData == null ) { return; }

#if 1 // drawTriangles

        canvas.graphics.beginBitmapFill( bitmapData );
#if flash
        canvas.graphics.drawTriangles( vVertices, Common.vIndices, Common.vUVs );
#elseif js
        canvas.graphics.drawTriangles( vVertices, Common.vIndices );
#else
        canvas.graphics.drawTriangles( vVertices, Common.vIndices, Common.vUVs, TriangleCulling.NONE, Common.vColors );
#end

#else
        canvas.graphics.beginFill( color );
        canvas.graphics.lineStyle( 1, Math.round( color / 2 ) );
        canvas.graphics.moveTo( vVertices[0], vVertices[1] );
        canvas.graphics.lineTo( vVertices[2], vVertices[3] );
        canvas.graphics.lineTo( vVertices[4], vVertices[5] );
        canvas.graphics.lineTo( vVertices[6], vVertices[7] );
        canvas.graphics.lineTo( vVertices[0], vVertices[1] );
#end
        canvas.graphics.endFill();
    }

    public static inline function stamp() : Float
    {
    #if flash
        return flash.Lib.getTimer() / 1000;
    #elseif (neko || php)
        return Sys.time();
    #elseif js
        return Date.now().getTime() / 1000;
    #elseif cpp
        return untyped __global__.__time_stamp();
    #elseif sys
        return Sys.time();
    #else
        return 0;
    #end
    }

    public static inline function getTimer() : Int
    {
    #if flash
        return flash.Lib.getTimer();
    #elseif (neko || php)
        return Sys.time()*1000;
    #elseif js
        return Common.trunc(Date.now().getTime());
    #elseif cpp
        return trunc(stamp() * 1000.0 + 0.5);
    #elseif sys
        return Sys.time()*1000;
    #else
        return 0;
    #end
    }

    public inline static function trunc( value:Float ):Int
    {
        return (value < 0?  Math.ceil( value ):Math.floor( value ));
    }

    public function getTexture( value:Int ):BitmapData
    {
        return _textures.get( value );
    }

    private var _textures:IntMap<BitmapData>;
}
