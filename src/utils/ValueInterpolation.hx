
package utils;

class ValueInterpolation
{
    public var onEndInterpolation:ValueInterpolation->Void;

    public function new( initValue:Float,
                         finalValue:Float,
                         duration:Int,
                         timeInit:Int = 0,
                         stop:Bool = false )
    {
        m_isStopped = stop;
        m_duration = duration;
        if ( m_duration <= 0 )
        {
            trace( "ValueInterpolation> Duration must be a positive integer" );
            m_duration = 1;
        }
        m_currentTime = 0;
        m_currentValue = initValue;
        m_initValue = initValue;
        m_finalValue = finalValue;
        m_timeInit = timeInit;
        m_timeEnd = timeInit + duration;
        m_isAwaitingDelete = false;
        m_startCalculation = ( timeInit > 0 ) ? false : true;
    }

    public inline function setDataInterpolation( data:Dynamic ):Void
    {
        m_dataInterpolation = data;
    }

    public inline function getDataInterpolation():Dynamic
    {
        return m_dataInterpolation;
    }

    public inline function value():Float
    {
        return m_currentValue;
    }

    public inline function stop():Void
    {
        m_isStopped = true;
    }

    public inline function timeInit():Int
    {
        return m_timeInit;
    }

    public inline function timeEnd():Int
    {
        return m_timeEnd;
    }

    public inline function initValue():Float
    {
        return m_initValue;
    }

    public inline function finalValue():Float
    {
        return m_finalValue;
    }

    public inline function resume():Void
    {
        m_isStopped = false;
    }

    public inline function isStopped():Bool
    {
        return m_isStopped;
    }

    public function reset( ?initValue:Null<Float>,
                           ?finalValue:Null<Float>,
                           duration:Int = -1,
                           timeInit:Int = -1 ):Void
    {
        m_isStopped = false;
        m_currentTime = 0;
        m_initValue =  ( initValue == null ) ? m_initValue : initValue;
        m_finalValue = ( finalValue == null ) ? m_finalValue : finalValue;
        m_duration = ( duration == -1 ) ? m_duration : duration;
        m_timeInit = ( timeInit == -1 ) ? m_timeInit : timeInit;
        m_currentValue = m_initValue;
        m_startCalculation = ( m_timeInit > 0 ) ? false : true;

        initInterpolationVars();
    }

    public function isAwaitingDelete():Bool
    {
        return m_isAwaitingDelete;
    }

    public function setAwaitingDelete( value:Bool ):Void
    {
        m_isAwaitingDelete = value;
    }

    public function calculateValue( currentTime:Int ):Float
    {
        // Override this.
        return 0;
    }

    private function initInterpolationVars():Void
    {
        // Override this.
    }

    public function update( dt:Int ):Void
    {
        if ( m_isStopped )
        {
            return;
        }

        if ( !m_startCalculation )
        {
            m_currentTime += dt;
            if ( m_currentTime > m_timeInit )
            {
                m_startCalculation = true;
                m_currentTime = 0;
            }
            return;
        }

        m_currentTime += dt;
        m_currentValue = calculateValue( m_currentTime );
        if ( m_currentTime >= m_duration )
        {
            m_currentValue = m_finalValue;
            if ( onEndInterpolation != null )
            {
                onEndInterpolation( this );
            }
            m_isStopped = true;
        }
    }

    public function free():Void
    {
        m_dataInterpolation = null;
        onEndInterpolation = null;
    }

    public inline function hasEnded():Bool
    {
        return ( m_currentTime >= m_duration );
    }

    private var m_currentTime:Int;
    private var m_timeInit:Int;
    private var m_timeEnd:Int;
    private var m_startCalculation:Bool;
    private var m_duration:Int;
    private var m_isStopped:Bool;
    private var m_currentValue:Float;
    private var m_initValue:Float;
    private var m_finalValue:Float;
    private var m_isAwaitingDelete:Bool;
    private var m_dataInterpolation:Dynamic;
}
