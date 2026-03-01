animation
=========

Api for creating animation

**It Contains**
    - ``animation`` - infomation on a animation
    - ``animation.track`` - infomation on how animation tracks

Animation
#########

.. lua:class:: animation

    .. code-block:: lua
        :caption: How to create a animation

        newAnimation = animation("my animation")

        local ball = { x = 0, y = 3, col = color.red }

        newTrack = newAnimation:addTrack("color", ball, "col")
        newAnimation:play()

        -- every frame
        newAnimation:update()
    
    .. lua:attribute:: id: number

        Can get and set an id for an animation

    .. lua:attribute:: name: string

    .. lua:method:: addTrack(trackType[, target, property])

        Adds a new track to the animation.

        :param trackType: The type of track to play 
        :type trackType: enum or string
        :param target: The table/userdata that contains that animated property
        :type target: table or userdata
        :param property: The string that direct to the proper target (property name)
        :type property: string
      
        No parameter:

        :return: A new animation track
        :rtype: animation.track

        `The Track Types:`

        * ``animation.track.boolean`` - boolean track
        * ``animation.track.number`` - number track
        * ``animation.track.vec2`` - vec2 track
        * ``animation.track.vec3`` - vec3 track
        * ``animation.track.vec4`` - vec4 track
        * ``animation.track.color`` - color track
        * ``animation.track.quat`` - quat track
        * ``animation.track.sprite`` - sprite track
        * ``animation.track.sound`` - sound track
        * ``animation.track.function`` - function track: calls a function at a the time
        * ``animation.track.animationClip`` - animationClip track: plays other animations as a key frame

    .. lua:method:: removeTrack(trackIndex)

        Remove track from a list

        :param trackIndex: the index order that track is in the animation
        :type trackIndex: number

    .. lua:method:: update([timeElapsed])

        Updates that animation based on ``time.elapsed`` or custom elapsed time

        :param timeElapsed: optional parameter to play the animation at a custom time.
        :type timeElapsed: number

    .. lua:method:: play()

        Start to plays the animation

    .. lua:method:: pause()

        Pauses the animation
        
    .. lua:method:: pause()

        Pauses the animation

    .. lua:method:: restart([shouldPlay = true])

        Restarts the animation from the beginning

        :param shouldPlay: Whether the animation should start playing
        :type shouldPlay: boolean

    .. lua:attribute:: playing: boolean

        Checks if the animation is playing

    .. lua:attribute:: tracks: table<animation.track>

        Allow one to get and set tracks for the animation

    .. lua:attribute:: duration: number

        Can get the duration of an animation

    .. lua:attribute:: time: number

        Can get and set the time past through the animation

    .. lua:method:: loop(loopAmount)

        Sets the amount of times the animation loop (once it is done the animation will stop)

        :param loopAmount: How many times the animation loops
        :type loopAmount: number

        Set to ``animation.infiniteLoop`` for an infinite loop

        If no parameter:

        :return: The loop amount
        :rtype: number

    .. lua:method:: onComplete(onCompleteFunction)

        Set the function that is called when animation is complete

        :param onCompleteFunction: The function to call
        :type onCompleteFunction: function()

        If no parameter:

        :return: The function that was inputed before
        :rtype: function()

    .. lua:method:: bundle(animation1, ... , animationX)

        Groups multiple animations into one animaiton so they can be played synchronously using the same time. 
        Each animation gets their own track (``type: animationClip``).
        At the front of the track (0 second), an animation clip key frame is place with each animation as a animation clip.

        `Note that duration of the bundled animation is the length of the longest animation`

        :param animation1: A single animation to be added to the bundle
        :type animation1: animation

        :return: A new animation able to play all the animations synchronously
        :rtype: animation

Animation Track
###############

.. lua:class:: animation.track

    .. code-block:: lua
            :caption: How to create a animation.track

            ballColorAnimation = animation("ball color animation")

            local ball = { x = 0, y = 3, col = color.red, image = asset.ball1 }

            -- animate ball color
            colorTrack = ballColorAnimation:addTrack("color", ball, "col")
            
            -- Set the key frames of the ball
            colorTrack:setKey(0.0, color.red):ease("quadratic", "inout", 1)
            colorTrack:setKey(1.0, color.blue):ease("hold") 
            colorTrack:setKey(2.0, color.green)

            colorTrack[1.0]:value(color.magenta) -- change blue to magenta

            ballSpriteAnimation = animation("ball sprite animation")

            -- animate ball sprite with frames
            spriteTrack = ballAnimation:addTrack("sprite", ball, "image")
            spriteTrack.frames = {asset.ball1, asset.ball2, asset.ball3}
            spriteTrack.fps = 4

            groupAnimation = animaiton.bundle(ballColorAnimation, ballSpriteAnimation)
            spriteAnimationTrack = groupAnimation.tracks[2] -- get the second track
            local theDuration = spriteAnimationTrack:keyAt(1):keyInfo("duration") -- get first keyframe
            spriteAnimationTrack:keyInfo("duration", theDuration * 3) -- make sprite animation loop 3 times

            groupAnimation:play()

            -- every frame
            groupAnimation:update()
        
    .. lua:attribute:: type: trackType

        What type of track this track is (enums are located in ``animation``)

    .. lua:attribute:: target: table/userdata
            
        The table/userdata that contains that animated property

    .. lua:attribute:: property: string

        The string that direct to the proper target (property name)

    .. lua:attribute:: duration: number

        The duration of the track which is the last key frame's time, in seconds, plus its duration (most of the time being 0)

    .. lua:attribute:: fps: integer

        The frames one can place pre second

    .. lua:attribute:: timeDelta: number

        Gap of time each frame must be placed.

    .. lua:attribute:: frames: table<sprite>

        A way to quickly get/set the keyframes for a sprite track (``type = animation.track.sprite``). It uses the timeDelta as a way to space out the sprites

    .. lua:method:: adjustFrames()

        If the timeDelta/fps gets changed this method will adjust all the frames to fit the new fps

    .. lua:attribute:: count: integer

        The amount of keyframes in a track


    **Below is how KeyFrames work in Codea**

    The way keyframes work is by chaining functions. You create the a key frame but it returns this track but the program set the last 
    created key frame as the selected keyframe for future functions

    .. lua:method:: setKey(time, value)

        This is the function is add a keyframe to the track it can also replace old values of a previous time. 

        :param time: The time of the key frame
        :type time: number
        :param value: The value of the key frame. If ``trackType = animation.track.vec2`` then value should be a ``vec2``. Every type follow this rule.
        :type value: any type
        
        `Note the a function track takes a string as the parameter representing the name of the funciton. If the track type is a entity it will call dispatch`

        :return: Self to continue function chaining
        :rtype: animation.track

    .. lua:method:: [index] (time)

        Select the key frame at this time as the selected keyframe for chaining

        :param time: The time of the key frame
        :type time: number

        :return: Self to continue function chaining
        :rtype: animation.track

    .. lua:method:: keyAt(keyIndex)

        Select the key frame at this index

        :param keyIndex: The index of the keyframe in the track keyframe list
        :type keyIndex: integer

        :return: Self to continue function chaining
        :rtype: animation.track

    **The below functions apply to Keyframes created/set above**

    .. lua:method:: time([newTime])

        Changes the time of the keyframe

        `Note: This method might change the key frames index in the list`

        :param newTime: The new time of the key frame
        :type newTime: number

        If there is a parameter than continue function chaining. Else:

        :return: The time of this key frame
        :rtype: number

    .. lua:method:: value([newValue])

        Changes the value of the keyframe

        :param newValue: The new value of the key frame
        :type newValue: any type

        If there is a parameter than continue function chaining. Else:

        :return: The value of this key frame
        :rtype: value type

    .. lua:method:: delete()

        Deletes the selected key frame from the list

    .. lua:method:: keyInfo (infoName[, infoValue])

        Gives access to extra infomation about the key frame

        :param infoName: The new value of the key frame
        :type infoName: string

        :param infoValue: The new value of the infomation above
        :type infoValue: info value type

        If infoValue is not nil than continue function chaining. Else:

        :return: The infomation of that key frame
        :rtype: info value type

        `Info Names:`

        * ``"duration"`` - give the duration of the keyframe for sound and animation clip key frames
        * ``"startTime"`` - gives the start time (offset) of sound and animation clip
        * ``"originalDuration"`` - (Getter) gets the original duration of sound and animation clip

    .. lua:method:: restoreDuration()

        Resets the duration of the selected key frame (sound or animation clip) to it original duration

    .. lua:method:: ease([easingName, easingMode, easeStrength/easeLoopAmount])

        Quick way to set the easing of the Key Frame (easingName and easingMode can be a string representing the last part of the enum name)

        :param easingName: A enum that represent the name of the the easing
        :type easingName: enum

        :param easingMode: A enum that represent the way the easing behaviors
        :type easingMode: enum

        :param easeStrength/easeLoopAmount: Represents the strength of the easing curve or if the easing is ``animation.easing.loop`` it the amount of previous key frames that should be looped
        :type easeStrength/easeLoopAmount: number

        If there is a parameter than continue function chaining. Else:

        :return: The easingName, easingMode, and easingStrength
        :rtype: enum, enum, number  

        `Easing Names:`

        * ``animation.easing.linear`` - From a to b it goes a linear speed
        * ``animation.easing.quadratic`` - From a to b it goes a quadratic speed
        * ``animation.easing.cubic`` - From a to b it goes a cubic speed
        * ``animation.easing.quartic`` - From a to b it goes a quartic speed
        * ``animation.easing.quintic`` - From a to b it goes a quintic speed
        * ``animation.easing.elastic`` - From a to b it goes a elastic speed
        * ``animation.easing.exponential`` - From a to b it goes a exponential speed
        * ``animation.easing.sine`` - From a to b it goes a sine speed
        * ``animation.easing.circular`` - From a to b it goes a circular speed
        * ``animation.easing.back`` - From a to b it goes a back speed
        * ``animation.easing.hold`` - Hold the current key frame until the next one
        * ``animation.easing.loop`` - Loops this key frame and a number previous key frames until the next key frame

        `Easing Mode:`

        * ``animation.easing.in`` - ease in the key frame
        * ``animation.easing.out`` - ease out the key frame
        * ``animation.easing.inout`` - ease in and ease out the key frame

    .. lua:method:: easeInfo (infoName[, infoValue])

        Gives access to extra infomation of the easing of the selected key frame

        :param infoName: The new value about the easing of the selected key frame
        :type infoName: string

        :param infoValue: The new value of the infomation above
        :type infoValue: info value type

        If infoValue is not nil than continue function chaining. Else:

        :return: The infomation of that key frame
        :rtype: info value type

        `Info Names:`

        * ``"name"`` - Change the easing name (enum)
        * ``"mode"`` - Change the easing mode (enum)
        * ``"strength"`` - Change the strength of the easing 
        * ``"loopAmount"`` - Change the amount of previous frames needing to loop
    
