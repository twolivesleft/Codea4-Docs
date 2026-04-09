time
=====

.. lua:class:: time

    .. lua:attribute:: delta: number

        The time between the last frame and this frame

        .. helptext:: the time between the last frame and this frame

    .. lua:attribute:: unscaledDelta: number

        Time delta without being affected by the time scale

        .. helptext:: time delta without being affected by the time scale

    .. lua:attribute:: fixedDelta: number

        Sets the time delta of the program (like setting the fps)

        .. helptext:: sets the time delta of the program (like setting the fps)

    .. lua:attribute:: elapsed: number

        The time that has past since the program started

        .. helptext:: the time that has past since the program started

    .. lua:attribute:: unscaledElapsed: number

        The time that has past without being affected by the time scale

        .. helptext:: the time that has past without being affected by the time scale

    .. lua:attribute:: scale: number

        Sets/gets the scaling of time to speed up or slow down (default is 1)

        .. helptext:: the scaling of time

Settings
########

For the scene time properties

.. lua:class:: time.settings

    .. lua:attribute:: autoUpdate: boolean

        Set to false prevents the scene from updating, draw, touching automatically (for manual use)

        .. helptext:: sets if the scene should auto update

    .. lua:attribute:: maximumTimeStep: number

        .. helptext:: the maximum Time Step

    .. lua:attribute:: fixedDelta: number

        Sets the time delta of the scene (like setting the fps)

        .. helptext:: sets the time delta of the scene (like setting the fps)

    .. lua:attribute:: scale: number

        Sets the scaling of time to speed up or slow down (default is 1)

        .. helptext:: sets the scaling of time to speed up or slow down