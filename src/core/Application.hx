package core;

import cube.CubeManager;
import cube.CubeSolver;
import cube.RubikCube;
import openfl.display.Sprite;
import openfl.display.TriangleCulling;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.Vector;
import utils.Console;
import utils.SpriteDepth;
import utils.View3D;

/**
 * ...
 * @author Agustin
 */

class Application
{
    public static var instance:Application;

    var vVertices:Vector<Float> = null;
    var vIndices:Vector<Int> = null;
    var vColors:Vector<Int> = null;
    var vUVs:Vector<Float> = null;
    var canvasB:Sprite = null;

    public function new( canvas:Sprite )
    {
        instance = this;
        m_canvas = canvas;

        new Common();

        vVertices = new Vector<Float>();
        vIndices = new Vector<Int>();
        vColors = new Vector<Int>();
        vUVs = new Vector<Float>();
        canvasB = new Sprite();

        m_canvas.addChild( canvasB );

        vVertices.push(0);
        vVertices.push(0);
        vColors.push( 0xffffffff );
        vVertices.push(0);
        vVertices.push(500);
        vColors.push( 0xffffffff );
        vVertices.push(500);
        vVertices.push(500);
        vColors.push( 0xffffffff );
        vVertices.push(500);
        vVertices.push(0);
        vColors.push( 0xffffffff );

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

        m_view = new View3D();

        Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );

        Common.showCurrentTime();

        var canvasCube:SpriteDepth = new SpriteDepth();
        m_canvas.addChild( canvasCube );
        RubikCube.init( canvasCube );

        m_console = new Console();
        m_canvas.addChild( m_console );

        m_cubeManager = new CubeManager( RubikCube.instance );
        m_solver = new CubeSolver( RubikCube.instance );
        m_cubeManager.onEndInitialTransition = m_solver.solve;
        m_cubeManager.unsort();
    }

    public function onKeyDown( e:KeyboardEvent ):Void
    {
        m_view.onKeyDown( e.keyCode );
        m_cubeManager.onKeyDown( e.keyCode );
    }

    public function onKeyUp( e:KeyboardEvent ):Void
    {
        m_view.onKeyUp( e.keyCode );
        m_cubeManager.onKeyUp( e.keyCode );
    }

    public static function setupLogs():Void
    {
#if (flash9 || flash10)
        haxe.Log.trace = function(v, ?pos)
        {
            untyped __global__["trace"](pos.className + "#" + pos.methodName + "(" + pos.lineNumber + "):", v);
        }
#elseif flash
        haxe.Log.trace = function(v, ?pos)
        {
            flash.Lib.trace(pos.className + "#" + pos.methodName + "(" + pos.lineNumber + "): " + v);
        }
#end
    }

    public function update( dt:Int ):Void
    {
        if ( RubikCube.instance != null )
        {
            RubikCube.instance.update( dt );
        }

        m_console.update();

        m_view.update( dt );
        m_cubeManager.update( dt );

        canvasB.graphics.clear();
        canvasB.graphics.beginBitmapFill( Common.instance.getTexture( 10 ) );
#if flash
        canvasB.graphics.drawTriangles( vVertices, vIndices, vUVs );
#elseif js
        canvasB.graphics.drawTriangles( vVertices, vIndices );
#else
        canvasB.graphics.drawTriangles( vVertices, vIndices, vUVs, TriangleCulling.POSITIVE, vColors );
#end
        canvasB.graphics.endFill();
    }

    private var m_cubeManager:CubeManager;
    private var m_canvas:Sprite;
    private var m_view:View3D;
    private var m_console:Console;
    private var m_solver:CubeSolver;
}
