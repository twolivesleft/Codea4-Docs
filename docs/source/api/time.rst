time
=====

.. lua:class:: time

    .. lua:attribute:: delta: number

        The time between the last frame and this frame

    .. lua:attribute:: unscaledDelta: number

        Time delta without being affected by the time scale

    .. lua:attribute:: fixedDelta: number

        Set delta of the program (like setting the fps)

    .. lua:attribute:: elapsed: number

        The time that has past since the program started

    .. lua:attribute:: unscaledElapsed: number

        The time that has past without being affected by the time scale

    .. lua:attribute:: scale: number

        Allowing the scaling of time to speed up or slow down (default is 1)

Settings
########

For the scene time properties

.. lua:class:: time.settings

    .. lua:attribute:: autoUpdate: boolean

        Set to false prevents the scene from updating, draw, touching automatically (for manual use)

    .. lua:attribute:: maximumTimeStep: number

    .. lua:attribute:: fixedDelta: number

        Set delta of the scene (like setting the fps)

    .. lua:attribute:: scale: number

        Allowing the scaling of time to speed up or slow down (default is 1)