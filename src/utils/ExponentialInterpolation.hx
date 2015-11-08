package utils;

/**
 * ...
 * @author Agustin
 */
class ExponentialInterpolation extends ValueInterpolation
{

    public function new( initValue:Float,
                         finalValue:Float,
                         duration:Int,
                         alpha:Float = -1,
                         timeInit:Int = 0,
                         stop:Bool = false )
    {
        super( initValue, finalValue, duration, timeInit, stop );
        m_initAlpha = alpha;
        initInterpolationVars();
    }

    override public function calculateValue( currentTime:Float ):Float
    {
        return m_c1 * Math.exp( m_alpha * currentTime * 0.001 ) + m_c2;
    }

    override private function initInterpolationVars():Void
    {
        m_alpha = m_initAlpha / m_duration * 1000;
        m_c1 = ( m_finalValue - m_initValue ) / ( Math.exp( m_alpha * m_duration * 0.001 ) - 1 );
        m_c2 = m_initValue - m_c1;
    }

    // Math constants.
    // Follwing the equation : value = c1 * exp( alpha * t ) + c2.
    private var m_c1:Float;
    private var m_c2:Float;
    private var m_alpha:Float;
    private var m_initAlpha:Float;
}
