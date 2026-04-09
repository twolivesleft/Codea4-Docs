animation
=========

API for creating animation

Content
#######

    - ``animation`` - information on a animation
    - ``animation.track`` - information on how animation tracks work
    - ``animation.key`` - information on how animation key frames work
    - ``animation.easing`` - information on how animation easing work

Animation
#########

.. lua:class:: animation

    .. code-block:: lua
        :caption: How to create an animation

        local ball = { x = 0, y = 3, col = color.red }

        newAnimation = animation(ball)

        newTrack = newAnimation.col -- creates a animation track using the property "col"
        newTrack2 = newAnimation:property("y") -- another way to create an animation track using the property "y"

        newAnimation:play()

        -- every frame
        newAnimation:update()

    .. lua:method:: constructor (target)

        The constructor of the animation class

        :param target: The target table or userdata of the animation 
        :type target: table or userdata

        :return: A new animation
        :rtype: animation

        .. helptext:: the constructor of the animation class
    
    .. lua:attribute:: id: number

        Sets/gets the animation's identifier

        .. helptext:: the animation's identifier

    .. lua:attribute:: name: string

        .. helptext:: the animation's name

    .. lua:method:: property(propertyName)

        Adds a new track to the animation using that property. 
        
        .. note:: the type of the track is inferred based on the type of the property

        :param propertyName: The string that directs to the proper target (property name)
        :type propertyName: string
      
        :return: A new animation track
        :rtype: animation.track

        **Unique Property Names**

        * ``"call"`` - creates a function track
        * ``"sound"`` - creates a sound track
        * ``"clip"`` - creates an animation clip track

        .. helptext:: adds a new track to the animation

    .. lua:method:: [index] (propertyName)

        Adds a new track by passing the property name as index.

        .. helptext:: adds a new track to the animation

    .. lua:method:: removeTrack(trackObj)

        Removes this track

        :param trackObj: the track to be removed
        :type trackObj: animation.track

        .. helptext:: removes track

    .. lua:method:: update(timeDelta)

        Updates the animation by ``time.delta``

        :param timeDelta: time.delta
        :type timeDelta: number

        .. helptext:: updates the animation

    .. lua:method:: play()

        Starts to play the animation

        .. helptext:: plays the animation

    .. lua:method:: pause()

        Pauses the animation

        .. helptext:: pauses the animation

    .. lua:method:: restart([shouldPlay = true])

        Restarts the animation

        :param shouldPlay: Whether the animation should start playing
        :type shouldPlay: boolean

        .. helptext:: restarts the animation

    .. lua:attribute:: playing: boolean

        Checks if the animation is playing

        .. helptext:: checks if the animation is playing

    .. lua:attribute:: tracks: table<animation.track>

        Gets the tracks of the animation

        .. helptext:: checks if the animation is playing

    .. lua:attribute:: duration: number

        Gets the duration of the animation

        .. helptext:: gets the duration of the animation

    .. lua:attribute:: time: number

        Gets/Sets the time elapsed through the animation

        .. helptext:: the elapsed time through the animation

    .. lua:attribute:: loopAmount: integer

        Sets the amount of times the animation loops. Set to 0 for an infinite loop.

        .. helptext:: the amount of times the animation loops

    .. lua:attribute:: onComplete: function

        Sets a function to call when the animation has been completed.

        .. helptext:: sets a function to call when the animation has been completed.

    .. lua:method:: group(animation1, ... , animationX)

        Groups multiple animations into one animations so they can be played synchronously using the same time. Each animation gets their own track (``type: animationClip``). At the front of the track (0 second), an animation clip key frame is placed with each animation as an animation clip.

        .. note:: Note that the duration of the grouped animation is the length of the longest animation.

        :param animation1: A single animation to be added to the group
        :type animation1: animation

        :return: A new animation able to play all the animations synchronously
        :rtype: animation

        .. helptext:: groups multiple animations to play synchronously

    .. lua:method:: sequence(animation1, ... , animationX)

        Groups multiple animations into a single animation so they can be played sequentially.
        Each animation is placed in a singlar track one after another (``type: animationClip``).

        .. note:: Note that the duration of the sequenced animation is the sum of all the animations' duration.

        :param animation1: A single animation to be added to the sequence
        :type animation1: animation

        :return: A new animation able to play all the animations sequentially
        :rtype: animation

        .. helptext:: groups multiple animations to play in sequence

Animation Track
###############

.. lua:class:: animation.track

    .. code-block:: lua
        :caption: How to create an animation.track

        ball = { x = 500, y = 400, col = color.red, image = asset.builtin.Planet_Cute.Character_Boy }
    
        ballColorAnimation = animation(ball)
        
        -- Animate the ball's color
        colorTrack = ballColorAnimation.col
        
        -- Sets the key frames of the ball
        colorTrack
            :key(0.0) -- because the value was not inputted the first key's value is set to color.red because that is the current value of "col"
            :key(1.0, color.blue, tween.hold)
            :key(2.0, color.green)
        
        
        firstKey = colorTrack:keyAtIndex(1) -- get the first key
        firstKey.value = color.white
        colorTrack:keyAtTime(1.0).value = color.black -- change the key value at time 1.0 from blue to magenta 
        colorTrack[2.0].value = color.magenta -- another way to get time
        
        ballSpriteAnimation = animation(ball)
        
        -- animate ball sprite with frames
        spriteTrack = ballSpriteAnimation:property("image") -- another way to create a track for the "image" property
        spriteTrack:frames({asset.builtin.Planet_Cute.Character_Boy, asset.builtin.Planet_Cute.Character_Cat_Girl, asset.builtin.Planet_Cute.Character_Horn_Girl}, { loop = 4, fps = 6 }) -- add frames to the track and make it loop 4 times at 6 fps 
        
        groupAnimation = animation.group(ballColorAnimation, ballSpriteAnimation)
        spriteAnimationTrack = groupAnimation.tracks[2] -- get the second track
        secondTrackKey = spriteAnimationTrack:keyAtIndex(1)
        local theDuration = secondTrackKey.duration -- get first key frame
        secondTrackKey.duration = theDuration * 2 -- make the sprite animation loop 2 times
        
        groupAnimation:play()

        -- every frame
        groupAnimation:update(time.delta)
        
    .. lua:attribute:: type: trackType

        Returns this track's type.

            * ``animation.track.boolean`` - boolean track
            * ``animation.track.number`` - number track
            * ``animation.track.vec2`` - vec2 track
            * ``animation.track.vec3`` - vec3 track
            * ``animation.track.vec4`` - vec4 track
            * ``animation.track.color`` - color track
            * ``animation.track.quat`` - quat track
            * ``animation.track.sprite`` - sprite track
            * ``animation.track.sound`` - sound track
            * ``animation.track.function`` - function call track
            * ``animation.track.animationClip`` - animationClip track: plays another animation

        .. helptext:: returns this track's type.

    .. lua:attribute:: target: table/userdata
            
        The table/userdata that contains that animated property

        .. helptext:: the table/userdata that contains that animated property

    .. lua:attribute:: property: string

        The string that directs to the proper target (property name)

        .. helptext:: the string that directs to the proper target

    .. lua:attribute:: duration: number

        The duration of the track

        .. helptext:: the duration of the track

    .. lua:attribute:: fps: integer

        The frames that are placed pre second

        .. helptext:: the frames that are placed pre second

    .. lua:attribute:: timeDelta: number

        The gap of time between each frame placed.

        .. helptext:: the gap of time between each frame placed.

    .. lua:method:: frames(theFrames[, frameProperties])

        .. helptext:: quickly sets the frames of the track
    .. lua:method:: frames()

        A way to quickly get/set the keyframes for a sprite track (``type = animation.track.sprite``). It uses the timeDelta as a way to space out the sprites.

        :param theFrames: a table of frames to represent the frames of the sprite animation
        :type theFrames: table<sprite>

        :param frameProperties: a table of properties of how the frames should behave
        :type frameProperties: table

            * ``"delta"`` - sets the space of time each frame should be played. For example: 0.1 (this would space the frames every 0.1 seconds)
            * ``"fps"`` - another way of doing delta but sets the fps of the sprites
            * ``"loop"`` - number of times the sprites should loop

        .. helptext:: quickly gets the frames of the track

    .. lua:method:: adjustFrames()

        Adjusts the frames to fit the new timeDelta/fps.

        .. helptext:: adjusts the frames to fit the new timeDelta/fps

    .. lua:attribute:: count: integer

        The number of key frames in a track.

        .. helptext:: the number of key frames in a track

    .. lua:method:: key(time[, value, properties])

        Add a key frame to the track. (supports chaining)

        :param time: The time of the key frame
        :type time: number
        :param value: The value of the key frame. Should be the same type as the track type. 
        :type value: any type
        :param properties: Quick way to add properties of key
        :type properties: table or easing enum

        .. note:: if value is nil then it will be set to current value of ``target[property]``

        **Possible properties**

        `If easing enum`

            Sets the easing. Examples: ``tween.cubicIn`` or ``tween.hold``

        `If table:`

            * ``"ease"`` - Sets the ease type of the key frame (``type: tween enum``)
            * ``"strength"`` - Sets the strength of the easing (``type: number``)
            * ``"loop"`` - Sets the amount of previous keys to be looped (``type: integer``)

        `If table but type of track is sound or animation clip`

            * ``"duration"`` - Sets the duration of the key frame (``type: number``)
            * ``"start"`` - Sets the start time of the key frame (``type: number``)

        .. helptext:: adds a key to the track

    .. lua:method:: keyAtIndex(keyIndex)

        Returns the key frame at this index

        :param keyIndex: The index of the keyframe in the track keyframe list
        :type keyIndex: integer

        :return: Key at that index
        :rtype: animation.key

        .. helptext:: returns the key frame at this index

    .. lua:method:: keyAtTime(time)

        Returns the key frame at this time

        :param time: The time of the key frame
        :type time: number

        :return: Key at that time
        :rtype: animation.key

        .. helptext:: returns the key frame at this time

    .. lua:method:: [index] (time)

        Does the same thing as ``keyAtTime``

        .. helptext:: returns the key frame at this time

    .. lua:method:: custom ([function])

        Allows track to use a custom function to set the target

        :param function: Sets the custom function if no input then use default behavior
        :type function: function

        .. code-block:: lua
            :caption: How to use custom

            ani:target(boyEntity)
            trac = ani.rz -- creates a track of the "rz" (rotation on z axis).
                :key(0.0, nil)
                :key(1.0, 720.0)
            
            trac:custom(function(value) -- because setting "rz" is unstable it is safer to set the rotation variable directly so we use a custom function
                boy.rotation = quat.eulerAngles(0, 0, value)
            end)

        .. helptext:: allows track to use a custom function to set the target

    .. lua:attribute:: openBeginning: boolean

        This is a variable that sets the 0 second key frame to be open. When true, the track will add a key frame at 0 second time and set the value to the current property value.
        
        .. note:: This can be used to smoothly go from gameplay to a cut scene without an abrupt cut.

        .. helptext:: makes the beginning of the animation open

    .. lua:attribute:: openEasing: animation.easing

        This is the easing of the open key frame

        .. helptext:: this is the easing of the open key frame

Animation Key
#############

.. lua:class:: animation.key

    .. lua:attribute:: time: number

        The time of the keyframe

        .. note:: this method might change the key frames index in the list

        .. helptext:: the time of the keyframe

    .. lua:attribute:: value: number

        The value of the keyframe

        .. helptext:: the value of the keyframe

    .. lua:attribute:: duration: number

        The duration of the keyframe for sound and animation clip key frames

        .. helptext:: the duration of the keyframe

    .. lua:attribute:: startTime: number

        The start time (offset) of sound and animation clip

        .. helptext:: the start time of the keyframe

    .. lua:attribute:: originalDuration: number

        Gets the original duration of sound or animation clip

        .. helptext:: gets the original duration of sound or animation clip

    .. lua:method:: delete()

        Deletes this key frame from its parent track list

        .. helptext:: deletes this key frame from its parent track list
    
    .. lua:attribute:: valid: boolean

        Checks if the keyframe is still valid

        .. helptext:: checks if the keyframe is still valid

    .. lua:attribute:: easing: animation.easing

        Gets the easing of this key

        .. helptext:: gets the easing of this key

Animation Easing
################

.. lua:class:: animation.easing

    .. lua:attribute:: type: tween easing enum

        The type of easing of the key frame

        .. helptext:: gets the easing of this key

    .. lua:attribute:: strength: number

        Sets/gets the strength of the easing

        .. helptext:: the strength of the easing

    .. lua:attribute:: loopAmount: integer

        Sets/gets the amount of previous frames to loop 

        .. helptext:: the amount of previous frames to loop
    
