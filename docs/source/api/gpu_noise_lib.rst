GPU Noise Library
=================

Codea includes the GPU noise library written by Brian Sharpe (http://briansharpe.wordpress.com), all credit goes to the original author

The library can be inclued via ``#include <codea/noise/noise.glsl>`` within any GLSL source

An example using this library can be found `here`_

.. _here: https://talk.codea.io/t/compute-builder-particles-200k-sprite-rendering-example-compute-shaders
   

.. code-block:: glsl

    //
    //	Code repository for GPU noise development blog
    //	http://briansharpe.wordpress.com
    //	https://github.com/BrianSharpe
    //
    //	I'm not one for copyrights.  Use the code however you wish.
    //	All I ask is that credit be given back to the blog or myself when appropriate.
    //	And also to let me know if you come up with any changes, improvements, thoughts or interesting uses for this stuff. :)
    //	Thanks!
    //
    //	Brian Sharpe
    //	brisharpe CIRCLE_A yahoo DOT com
    //	http://briansharpe.wordpress.com
    //	https://github.com/BrianSharpe
    //

Value Noises
------------

.. image:: http://briansharpe.files.wordpress.com/2011/11/valuesample1.jpg
    :width: 200

.. code-block:: glsl

    //	Value Noise 2D
    //	Return value range of 0.0->1.0
    //	http://briansharpe.files.wordpress.com/2011/11/valuesample1.jpg
    //
    float Value2D( vec2 P )

.. code-block:: glsl

    //	Value Noise 3D
    //	Return value range of 0.0->1.0
    //	http://briansharpe.files.wordpress.com/2011/11/valuesample1.jpg
    //
    float Value3D( vec3 P )


.. code-block:: glsl

    //	Value Noise 4D
    //	Return value range of 0.0->1.0
    //
    float Value4D( vec4 P )

.. image:: http://briansharpe.files.wordpress.com/2011/11/perlinsample.jpg
    :width: 200

.. code-block:: glsl

    //	Perlin Noise 2D  ( gradient noise )
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2011/11/perlinsample.jpg
    //
    float Perlin2D( vec2 P )

.. code-block:: glsl

    //	Perlin Noise 3D  ( gradient noise )
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2011/11/perlinsample.jpg
    //
    float Perlin3D( vec3 P )

.. code-block:: glsl

    // Perlin Noise 4D ( gradient noise )
    // Return value range of -1.0->1.0
    //
    float Perlin4D( vec4 P )

.. image:: http://briansharpe.files.wordpress.com/2011/11/valueperlinsample.jpg
    :width: 200

.. code-block:: glsl

    //	ValuePerlin Noise 2D	( value gradient noise )
    //	A uniform blend between value and perlin noise
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2011/11/valueperlinsample.jpg
    //
    float ValuePerlin2D( vec2 P, float blend_val )

.. code-block:: glsl

    //	ValuePerlin Noise 3D	( value gradient noise )
    //	A uniform blend between value and perlin noise
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2011/11/valueperlinsample.jpg
    //
    float ValuePerlin3D( vec3 P, float blend_val )

.. image:: http://briansharpe.files.wordpress.com/2011/12/cubistsample.jpg
    :width: 200

.. code-block:: glsl

    //	Cubist Noise 2D
    //	http://briansharpe.files.wordpress.com/2011/12/cubistsample.jpg
    //
    //	Generates a noise which resembles a cubist-style painting pattern.  Final Range 0.0->1.0
    //	NOTE:  contains discontinuities.  best used only for texturing.
    //	NOTE:  Any serious game implementation should hard-code these parameter values for efficiency.
    //
    float Cubist2D( vec2 P, vec2 range_clamp )	// range_clamp.x = low, range_clamp.y = 1.0/(high-low).  suggest value low=-2.0  high=1.0

.. code-block:: glsl

    //	Cubist Noise 3D
    //	http://briansharpe.files.wordpress.com/2011/12/cubistsample.jpg
    //
    //	Generates a noise which resembles a cubist-style painting pattern.  Final Range 0.0->1.0
    //	NOTE:  contains discontinuities.  best used only for texturing.
    //	NOTE:  Any serious game implementation should hard-code these parameter values for efficiency.
    //
    float Cubist3D( vec3 P, vec2 range_clamp )	// range_clamp.x = low, range_clamp.y = 1.0/(high-low).  suggest value low=-2.0  high=1.0

Cellular Noises
---------------

.. image:: http://briansharpe.files.wordpress.com/2011/12/cellularsample.jpg
    :width: 200

.. code-block:: glsl

    //	Cellular Noise 2D
    //	Based off Stefan Gustavson's work at http://www.itn.liu.se/~stegu/GLSL-cellular
    //	http://briansharpe.files.wordpress.com/2011/12/cellularsample.jpg
    //
    //	Speed up by using 2x2 search window instead of 3x3
    //	produces a range of 0.0->1.0
    //
    float Cellular2D(vec2 P)

.. code-block:: glsl

    //	Cellular Noise 3D
    //	Based off Stefan Gustavson's work at http://www.itn.liu.se/~stegu/GLSL-cellular
    //	http://briansharpe.files.wordpress.com/2011/12/cellularsample.jpg
    //
    //	Speed up by using 2x2x2 search window instead of 3x3x3
    //	produces range of 0.0->1.0
    //
    float Cellular3D(vec3 P)

.. image:: http://briansharpe.files.wordpress.com/2011/12/polkadotsample.jpg
    :width: 200

.. image:: http://briansharpe.files.wordpress.com/2012/01/polkaboxsample.jpg
    :width: 200

.. code-block:: glsl

    //	PolkaDot Noise 2D
    //	http://briansharpe.files.wordpress.com/2011/12/polkadotsample.jpg
    //	http://briansharpe.files.wordpress.com/2012/01/polkaboxsample.jpg
    //	TODO, these images have random intensity and random radius.  This noise now has intensity as proportion to radius.  Images need updated.  TODO
    //
    //	Generates a noise of smooth falloff polka dots.
    //	Allow for control on radius.  Intensity is proportional to radius
    //	Return value range of 0.0->1.0
    //
    float PolkaDot2D( 	vec2 P,
                        float radius_low,		//	radius range is 0.0->1.0
                        float radius_high	)

.. code-block:: glsl

    //	PolkaDot Noise 3D
    //	http://briansharpe.files.wordpress.com/2011/12/polkadotsample.jpg
    //	http://briansharpe.files.wordpress.com/2012/01/polkaboxsample.jpg
    //	TODO, these images have random intensity and random radius.  This noise now has intensity as proportion to radius.  Images need updated.  TODO
    //
    //	Generates a noise of smooth falloff polka dots.
    //	Allow for control on radius.  Intensity is proportional to radius
    //	Return value range of 0.0->1.0
    //
    float PolkaDot3D( 	vec3 P,
                        float radius_low,		//	radius range is 0.0->1.0
                        float radius_high	)


.. image:: http://briansharpe.files.wordpress.com/2011/12/starssample.jpg
    :width: 200

.. code-block:: glsl

    //	Stars2D
    //	http://briansharpe.files.wordpress.com/2011/12/starssample.jpg
    //
    //	procedural texture for creating a starry background.  ( looks good when combined with a nebula/space-like colour texture )
    //	NOTE:  Any serious game implementation should hard-code these parameter values for efficiency.
    //
    //	Return value range of 0.0->1.0
    //
    float Stars2D(	vec2 P,
                    float probability_threshold,		//	probability a star will be drawn  ( 0.0->1.0 )
                    float max_dimness,					//	the maximal dimness of a star ( 0.0->1.0   0.0 = all stars bright,  1.0 = maximum variation )
                    float two_over_radius )				//	fixed radius for the stars.  radius range is 0.0->1.0  shader requires 2.0/radius as input.

Simplex Noises
--------------

.. image:: http://briansharpe.files.wordpress.com/2012/01/simplexperlinsample.jpg
    :width: 200

.. code-block:: glsl

    //	SimplexPerlin2D  ( simplex gradient noise )
    //	Perlin noise over a simplex (triangular) grid
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2012/01/simplexperlinsample.jpg
    //
    //	Implementation originally based off Stefan Gustavson's and Ian McEwan's work at...
    //	http://github.com/ashima/webgl-noise
    //
    float SimplexPerlin2D( vec2 P )

.. image:: http://briansharpe.files.wordpress.com/2012/01/simplexpolkadotsample.jpg
    :width: 200

.. code-block:: glsl

    //	SimplexPolkaDot2D
    //	polkadots over a simplex (triangular) grid
    //	Return value range of 0.0->1.0
    //	http://briansharpe.files.wordpress.com/2012/01/simplexpolkadotsample.jpg
    //
    float SimplexPolkaDot2D( 	vec2 P,
                                float radius, 		//	radius range is 0.0->1.0
                                float max_dimness )	//	the maximal dimness of a dot ( 0.0->1.0   0.0 = all dots bright,  1.0 = maximum variation )

.. image:: http://briansharpe.files.wordpress.com/2012/01/simplexcellularsample.jpg
    :width: 200

.. code-block:: glsl

    //	SimplexCellular2D
    //	cellular noise over a simplex (triangular) grid
    //	Return value range of 0.0->~1.0
    //	http://briansharpe.files.wordpress.com/2012/01/simplexcellularsample.jpg
    //
    //	TODO:  scaling of return value to strict 0.0->1.0 range
    //
    float SimplexCellular2D( vec2 P )

.. code-block:: glsl

    //	SimplexPerlin3D  ( simplex gradient noise )
    //	Perlin noise over a simplex (tetrahedron) grid
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2012/01/simplexperlinsample.jpg
    //
    //	Implementation originally based off Stefan Gustavson's and Ian McEwan's work at...
    //	http://github.com/ashima/webgl-noise
    //
    float SimplexPerlin3D(vec3 P)

.. code-block:: glsl

    //	SimplexCellular3D
    //	cellular noise over a simplex (tetrahedron) grid
    //	Return value range of 0.0->~1.0
    //	http://briansharpe.files.wordpress.com/2012/01/simplexcellularsample.jpg
    //
    //	TODO:  scaling of return value to strict 0.0->1.0 range
    //
    float SimplexCellular3D( vec3 P )

.. code-block:: glsl

    //	SimplexPolkaDot3D
    //	polkadots over a simplex (tetrahedron) grid
    //	Return value range of 0.0->1.0
    //	http://briansharpe.files.wordpress.com/2012/01/simplexpolkadotsample.jpg
    //
    float SimplexPolkaDot3D( 	vec3 P,
                                float radius, 		//	radius range is 0.0->1.0
                                float max_dimness )	//	the maximal dimness of a dot ( 0.0->1.0   0.0 = all dots bright,  1.0 = maximum variation )

Hermite Noises
--------------

.. image:: http://briansharpe.files.wordpress.com/2012/01/hermitesample.jpg
    :width: 200

.. code-block:: glsl

    //	Hermite2D
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2012/01/hermitesample.jpg
    //
    float Hermite2D( vec2 P )

.. code-block:: glsl

    //	Hermite3D
    //	Return value range of -1.0->1.0
    //	http://briansharpe.files.wordpress.com/2012/01/hermitesample.jpg
    //
    float Hermite3D( vec3 P )

.. image:: http://briansharpe.files.wordpress.com/2012/01/valuehermitesample.jpg
    :width: 200

.. code-block:: glsl

    //	ValueHermite2D
    //	Return value range of -1.0->1.0
    //	( allows for a blend between value and hermite noise )
    //	http://briansharpe.files.wordpress.com/2012/01/valuehermitesample.jpg
    //
    float ValueHermite2D( 	vec2 P,
                            float value_scale,			//	value_scale = 2.0*MAXVALUE
                            float gradient_scale, 		//	gradient_scale = 2.0*MAXGRADIENT
                            float normalization_val )	//	normalization_val = ( 1.0 / ( MAXVALUE + MAXGRADIENT * 0.3125 * 2.0 ) )

.. code-block:: glsl

    //	ValueHermite3D
    //	Return value range of -1.0->1.0
    //	( allows for a blend between value and hermite noise )
    //	http://briansharpe.files.wordpress.com/2012/01/valuehermitesample.jpg
    //
    float ValueHermite3D( 	vec3 P,
                        float value_scale,			//	value_scale = 2.0*MAXVALUE
                        float gradient_scale, 		//	gradient_scale = 2.0*MAXGRADIENT
                        float normalization_val )	//	normalization_val = ( 1.0 / ( MAXVALUE + MAXGRADIENT * 0.3125 * 3.0 ) )    


Derivative Noises
-----------------

.. code-block:: glsl

    //
    //	Value2D_Deriv
    //	Value2D noise with derivatives
    //	returns vec3( value, xderiv, yderiv )
    //
    vec3 Value2D_Deriv( vec2 P )

.. code-block:: glsl

    //	Value3D_Deriv
    //	Value3D noise with derivatives
    //	returns vec4( value, xderiv, yderiv, zderiv )
    //
    vec4 Value3D_Deriv( vec3 P )

.. code-block:: glsl

    //	Perlin2D_Deriv
    //	Classic Perlin 2D noise with derivatives
    //	returns vec3( value, xderiv, yderiv )
    //
    vec3 Perlin2D_Deriv( vec2 P )

.. code-block:: glsl

    //	Perlin3D_Deriv
    //	Classic Perlin 3D noise with derivatives
    //	returns vec4( value, xderiv, yderiv, zderiv )
    //
    vec4 Perlin3D_Deriv( vec3 P )

.. code-block:: glsl

    //	PerlinSurflet2D_Deriv
    //	Perlin Surflet 2D noise with derivatives
    //	returns vec3( value, xderiv, yderiv )
    //
    vec3 PerlinSurflet2D_Deriv( vec2 P )

.. code-block:: glsl

    //	PerlinSurflet3D_Deriv
    //	Perlin Surflet 3D noise with derivatives
    //	returns vec4( value, xderiv, yderiv, zderiv )
    //
    vec4 PerlinSurflet3D_Deriv( vec3 P )

.. code-block:: glsl

    //	Cellular2D_Deriv
    //	Cellular 2D noise with derivatives
    //	returns vec3( value, xderiv, yderiv )
    //
    vec3 Cellular2D_Deriv(vec2 P)

.. code-block:: glsl

    //	Cellular3D Deriv
    //	Cellular3D noise with derivatives
    //	returns vec3( value, xderiv, yderiv )
    //
    vec4 Cellular3D_Deriv(vec3 P)

.. code-block:: glsl

    //	SimplexPerlin2D_Deriv
    //	SimplexPerlin2D noise with derivatives
    //	returns vec3( value, xderiv, yderiv )
    //
    vec3 SimplexPerlin2D_Deriv( vec2 P )

.. code-block:: glsl

    //	SimplexPerlin3D_Deriv
    //	SimplexPerlin3D noise with derivatives
    //	returns vec3( value, xderiv, yderiv, zderiv )
    //
    vec4 SimplexPerlin3D_Deriv(vec3 P)

.. code-block:: glsl

    //	Hermite2D_Deriv
    //	Hermite2D noise with derivatives
    //	returns vec3( value, xderiv, yderiv )
    //
    vec3 Hermite2D_Deriv( vec2 P )

.. code-block:: glsl

    //	Hermite3D_Deriv
    //	Hermite3D noise with derivatives
    //	returns vec3( value, xderiv, yderiv, zderiv )
    //
    vec4 Hermite3D_Deriv( vec3 P )