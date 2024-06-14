objc
====

Exposes native Objective-C classes.

**Native Classes**

To access a native Objective-C class, append its name to ``objc``.

..  code-block:: lua

    -- access the UIScreen class
    UIScreen = objc.UIScreen

**Constructor**

If the native class has a ``new`` constructor, you can invoke it directly instead of calling the ``new`` method.

..  code-block:: lua

    -- create an instance of NSDateComponents
    dateComponents = objc.NSDateComponents()

**Properties**

Properties can be read and modified directly.

..  code-block:: lua

    -- read the screen brightness
    brightness = objc.UIScreen.mainScreen.brightness
    
    -- change the screen brightness
    objc.UIScreen.mainScreen.brightness = 0.5
    
**Methods**

Methods are invoked using the ':' operator and their full selector name, including named arguments separated by underscores '_' instead of colons. Note that the Objective-C method names must always end with an underscore in Codea. The underscores are required for Codea to find the corresponding signatures in Objective-C.

..  code-block:: lua

    -- Calling a method with multiple arguments
    controller:presentViewController_animated_completion_(newController, true, nil)

    -- Calling a method with no argument
    webView:goBack_()

**Callbacks**
    
Callbacks such as completion handlers with up to 7 arguments are supported by passing a function where each parameter is prefixed to indicate the corresponding native type.
    
The following prefixes are supported for callback arguments:

* c: char
* i: int, NSInteger
* uc: unsigned char
* ui: unsigned int, NSUInteger
* f: float
* d: double, CGFloat
* b: bool, BOOL
* s: char*
* o: NSObject, NSString, etc.

Note that only the first one or two characters are important in your argument names. ``bGranted`` and ``boolGranted`` will both work for a boolean argument, but for our examples, we decided to go with the second option.

Struct members are passed separately. For example, for an NSRange argument, you could use intLocation and intLength arguments.

Pointers for value types are also supported by prefixing them with ``p``, (e.g. ``pboolStop``). The actual value can be accessed and modified using ``.value``.

Note that when using objc from within a callback, changes are not guaranteed to occur on the main thread. Consider using ``objc.async`` inside your callback if you need changes to happen on the main thread, such as modifying UIControls.

**Automatic Conversions**

Some Codea types will be converted to corresponding Objective types automatically when passed to native methods or properties.

* **color**: UIColor
* **vec2**: CGPoint

..  code-block:: lua

    --- uiView: objc.UIView
    uiView.backgroundColor = Color(255, 0, 0)
    
    --- uiTextView: objc.UITextView
    uiTextView:setContentOffset_(vec2(0, 100))

**Examples**

.. collapse:: Change the screen brightness to 50%

    .. code-block:: lua

        objc.UIScreen.mainScreen.brightness = 0.5

.. collapse:: Request application review

    .. code-block:: lua

        scene = objc.app.keyWindow.windowScene
        store = objc.SKStoreReviewController
        store:requestReviewInScene_(scene)

.. collapse:: Request notifications permission

    .. code-block:: lua

        center = objc.
            UNUserNotificationCenter.
            currentNotificationCenter
        options = objc.enum.UNAuthorizationOptions
        center:requestAuthorizationWithOptions_completionHandler_(
            options.badge | options.sound | options.alert,
            function(boolGranted, objError)
            if boolGranted then
                print("granted")
            elseif objError then
                print("error " .. objError.code)
            end
            end)

.. collapse:: Enumerate words until the word stop is found

    .. code-block:: lua

        txt = "First second stop third fourth"
        str = objc.string(txt)
        str:enumerateSubstringsInRange_options_usingBlock_(
            objc.range(0, txt:len()),
            objc.enum.NSStringEnumerationOptions.byWords,
            function(objWord,
                    isubstringLocation,
                    iSubstringLength,
                    iEnclosingLocation,
                    iEnclosingLength,
                    pboolStop)
                if objWord == "stop" then
                    pboolStop.value = true
                else
                    print(objWord)
                end
            end)
    
.. lua:module:: objc

.. lua:function:: delegate(name)

    Returns a type which can be instantiated and used as an Objective-C delegate for the specified type.
    
    :param name: The name of the delegate.
    :type name: string
    :returns: A type to be used as an Objective-C delegate.
    :rtype: table
    :syntax:
    
        .. code-block:: lua

            objc.delegate("DelegateName")

    .. collapse:: UITextViewDelegate Example

        .. code-block:: lua

            Delegate = objc.delegate("UITextViewDelegate")

            function Delegate:textViewShouldBeginEditing_(objTextView)
                -- replace with false to prevent editing
                return true
            end

            function Delegate:textViewDidChange_(objTextView)
                print(objTextView.text)
            end
            
            -- uiTextView.delegate = Delegate()

    .. collapse:: WKScriptMessageHandler Example

        .. code-block:: lua

            -- Exposes the following method to JavaScript:
            -- window.webkit.messageHandlers.log.postMessage
            Handler = objc.delegate("WKScriptMessageHandler")

            function Handler:
                userContentController_didReceiveScriptMessage_(
                objUserContentController, objMessage)
                print(objMessage.body)
            end

            function setup()
                local ctrl = objc.WKUserContentController()
                local logHandler = Handler()
                ctrl:addScriptMessageHandler_name_(
                logHandler, "log")
            end

.. lua:function:: class(name)

    Returns a type which can be instantiated and used as an Objective-C class, for example combined with a selector when registering for notifications through the NSNotificationCenter.
    
    :param name: The name of the class.
    :type name: string
    :returns: A type to be used as an Objective-C class.
    :rtype: table
    :syntax:
    
        .. code-block:: lua

            objc.class("ClassName")

    .. collapse:: NotificationHandler Example

        .. code-block:: lua

            NotificationHandler = objc.class("NotificationHandler")

            function NotificationHandler:textDidChange(objNotification)
                print(objNotification.object.text)
            end

            handler = NotificationHandler()

            notificationCenter = objc.NSNotificationCenter.defaultCenter
            notificationCenter:addObserver_selector_name_object_(
                handler,
                objc.selector("textDidChange"),
                "UITextViewTextDidChangeNotification",
                nil)

.. lua:function:: selector(name)

    Returns an Objective-C selector with the specified name which can be used in combination with an objc.class, for example to register for notifications through the NSNotificationCenter.
    
    :param name: The name of the selector.
    :type name: string
    :returns: An Objective-C selector (or SEL).
    :rtype: table
    :syntax:
    
        .. code-block:: lua

            objc.selector("SelectorName")

    .. collapse:: NotificationHandler Example

        .. code-block:: lua

            NotificationHandler = objc.class("NotificationHandler")

            function NotificationHandler:textDidChange(objNotification)
                print(objNotification.object.text)
            end

            handler = NotificationHandler()

            notificationCenter = objc.NSNotificationCenter.defaultCenter
            notificationCenter:addObserver_selector_name_object_(
                handler,
                objc.selector("textDidChange"),
                "UITextViewTextDidChangeNotification",
                nil)

.. lua:function:: set(table)

    Returns an Objective-C NSSet initialized from a Lua table.
    
    By default, NSSet returned from calls to Objective-C (or reading properties) are automatically converted to Lua tables. If you need to use the NSSet, you can convert the table to NSSet using ``objc.set``.
    
    :param table: A Lua table.
    :type table: table
    :returns: An Objective-C NSSet.
    :rtype: table
    :syntax:
    
        .. code-block:: lua

            objc.set({1, 2, 3})

.. lua:function:: string(text)

    Returns an Objective-C NSString initialized from a Lua string.
    
    By default, strings returned from calls to Objective-C (or reading properties) are automatically converted to Lua strings and vice versa. If you need to access NSString methods, you can convert the strings to NSString using ``objc.string``.
    
    :param text: The text to convert to an NSString.
    :type text: string
    :returns: An Objective-C NSString.
    :rtype: table
    :syntax:
    
        .. code-block:: lua

            objc.string("Text")

.. lua:attribute:: enum: table
    
        Exposes native Objective-C enumerations.
        
        When value names are prefixed with their enumeration's name, the prefix is removed to simplify their usage.
        
        For example, ``objc.enum.NLTokenUnit.paragraph`` is the integer value for ``NLTokenUnitParagraph`` (``2``).
        
        Unnamed enum values can be found directly under ``objc.enum``, e.g. ``objc.enum.NSUTF8StringEncoding``.
        
        :returns: A table containing native enumerations and their values.
        :rtype: table
        :syntax:
        
            .. code-block:: lua
    
                objc.enum.EnumName.ValueName
    
        .. collapse:: Combine UNAuthorizationOptions
    
            .. code-block:: lua
    
                opts =
                    objc.enum.UNAuthorizationOptions.badge |
                    objc.enum.UNAuthorizationOptions.sound |
                    objc.enum.UNAuthorizationOptions.alert

.. lua:attribute:: app: table

        The UIApplication's ``sharedApplication``.
        
        :returns: The UIApplication's ``sharedApplication``.
        :rtype: table

.. lua:attribute:: viewer: table
    
        The runtime ``UIViewController``.
        
        :returns: The runtime ``UIViewController``.
        :rtype: table

.. lua:attribute:: info: table
        
        Exposes the info dictionary keys and values.
        
        For better readability, all keys have their Apple prefix removed.
        
        For example, to get the value of ``NSBundleIdentifier``, use ``objc.info.bundleIdentifier``.
        
        :returns: A table containing the info dictionary keys and values.
        :rtype: table
        
        ..  collapse:: Test if running in an exported project
        
            .. code-block:: lua
        
                isStandalone = objc.info.bundleIdentifier ~= "com.twolivesleft.Codify"

.. lua:attribute:: insets: table

        Create a UIEdgeInsets.
        
        :param top: top value of the UIEdgeInsets
        :type top: number
        :param left: left value of the UIEdgeInsets
        :type left: number
        :param bottom: bottom value of the UIEdgeInsets
        :type bottom: number
        :param right: right value of the UIEdgeInsets
        :type right: number
        :returns: The UIEdgeInsets struct.
        :rtype: table
        :syntax:
        
            .. code-block:: lua
        
                objc.insets(top, left, bottom, right)

.. lua:function:: log(message)

    Log a message using NSLog instead of the Codea console.
    
    :param message: Message to display.
    :type message: string
    :syntax:
    
        .. code-block:: lua
    
            objc.log(message)

.. lua:function:: inspect(class)

    Inspect an Objective-C class, listing its variables, properties, methods and protocols.
    
    Returns a table with the following information:
    
    * **super**: the superclass which can be used as if it was accessed through ``objc``
    
    * **variables**: array of instance variables

      * **name**: name of the variable
      * **typeEncoding**: see `Type Encoding <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html>`_
      * **type**: user-friendly name of the variable type
    
    * **properties**: array of instance properties

      * **name**: name of the property
      * **attributes**: see `Property Type String <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html>`_
      * **type**: user-friendly name of the property type
    
    * **methods**: array of instance methods

      * **name**: name of the methods
      * **returnType**: user-friendly name of the method's return type
      * **arguments**: array of method arguments

        * **name**: name of the arguments
        * **typeEncoding**: see `Type Encoding <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html>`_
        * **type**: user-friendly name of the argument's type
        
    * **protocols**: array of instance protocols

      * **name**: name of the protocol
        
    Class members are accessible by prefixing with ``class.``, for example using ``objc.inspect(myClass).class.variables`` to list the class variables of myClass.
    
    :param class: Objective-C class to inspect.
    :type class: table
    :returns: A table with the class information
    :rtype: table
    :syntax:
    
        .. code-block:: lua
    
            objc.inspect(class)

    ..  collapse:: Inspect the SFSpeechRecognizer class
    
        .. code-block:: lua
    
            inspect = objc.inspect(objc.SFSpeechRecognizer)
            print("Class has " .. #inspect.methods .. " instance methods.")

.. lua:function:: async(function)

    Calls the function parameter on the main thread asynchronously.
    
    :param function: Parameterless function to run on the main thread.
    :type function: function
    :syntax:
    
        .. code-block:: lua
    
            objc.async(someFunction)

    ..  collapse:: Run a function on the main thread
        
            .. code-block:: lua
        
                objc.async(function()
                    print("This will run on the main thread.")
                end)

.. lua:function:: point(x, y)
    
    Create a CGPoint.
    
    :param x: x position of the CGPoint
    :type x: number
    :param y: y position of the CGPoint
    :type y: number
    :returns: The CGPoint struct.
    :rtype: table
    :syntax:
    
        .. code-block:: lua
    
            objc.point(x, y)

    ..  collapse:: Create a CGPoint
    
        .. code-block:: lua
    
            point = objc.point(100, 200)

.. lua:function:: rect(x, y, width, height)

    Create a CGRect.
    
    :param x: x position of the CGRect
    :type x: number
    :param y: y position of the CGRect
    :type y: number
    :param width: width of the CGRect
    :type width: number
    :param height: height of the CGRect
    :type height: number
    :returns: The CGRect struct.
    :rtype: table
    :syntax:
    
        .. code-block:: lua
    
            objc.rect(x, y, width, height)

    ..  collapse:: Create a CGRect
    
        .. code-block:: lua
    
            rect = objc.rect(100, 200, 300, 400)

.. lua:function:: size(width, height)

    Create a CGSize.
    
    :param width: width of the CGSize
    :type width: number
    :param height: height of the CGSize
    :type height: number
    :returns: The CGSize struct.
    :rtype: table
    :syntax:
    
        .. code-block:: lua
    
            objc.size(width, height)

    ..  collapse:: Create a CGSize
    
        .. code-block:: lua
    
            size = objc.size(300, 400)

.. lua:function:: range(loc, len)

    Create a NSRange.
    
    :param loc: location of the NSRange
    :type loc: number
    :param len: length of the NSRange
    :type len: number
    :returns: The NSRange struct.
    :rtype: table
    :syntax:
    
        .. code-block:: lua
    
            objc.range(loc, len)

    ..  collapse:: Create a NSRange
    
        .. code-block:: lua
    
            range = objc.range(10, 20)

.. lua:function:: color(r, g, b, a)

    Create a CGColor. For UIColor, use the Codea Color type instead.
    
    :param r: red value of the CGColor
    :type r: number
    :param g: green value of the CGColor
    :type g: number
    :param b: blue value of the CGColor
    :type b: number
    :param a: alpha value of the CGColor
    :type a: number
    :returns: The CGColor struct.
    :rtype: table
    :syntax:
    
        .. code-block:: lua
    
            objc.color(r, g, b, a)

    ..  collapse:: Create a CGColor
    
        .. code-block:: lua
    
            color = objc.color(1, 0, 0, 1)

.. lua:function:: vector(dx, dy)

    Create a CGVector.
    
    :param dx: x direction of the CGVector
    :type dx: number
    :param dy: y direction of the CGVector
    :type dy: number
    :returns: The CGVector struct.
    :rtype: table
    :syntax:
    
        .. code-block:: lua
    
            objc.vector(dx, dy)

    ..  collapse:: Create a CGVector
    
        .. code-block:: lua
    
            vector = objc.vector(1, 0)

.. lua:function:: affineTransform
    
        Create a `CGAffineTransform <https://developer.apple.com/documentation/coregraphics/cgaffinetransform?language=objc>`_.
        
        :param a: a value of the CGAffineTransform
        :type a: number
        :param b: b value of the CGAffineTransform
        :type b: number
        :param c: c value of the CGAffineTransform
        :type c: number
        :param d: d value of the CGAffineTransform
        :type d: number
        :param tx: tx value of the CGAffineTransform
        :type tx: number
        :param ty: ty value of the CGAffineTransform
        :type ty: number
        :returns: The CGAffineTransform struct.
        :rtype: table
        :syntax:
        
            .. code-block:: lua
        
                objc.affineTransform(a, b, c, d, tx, ty)
        
        ..  collapse:: Create a CGAffineTransform

            .. code-block:: lua
        
                affineTransform = objc.affineTransform(1, 0, 0, 1, 100, 200)

**Frameworks**

Here are some of the frameworks included with the Codea runtime.

Refer to Apple's documentation for how to interact with them.

* `ARKit <https://developer.apple.com/documentation/arkit?language=objc>`_
* `AssetsLibrary <https://developer.apple.com/documentation/assetslibrary?language=objc>`_
* `AudioKit <https://audiokit.io>`_
* `AudioToolbox <https://developer.apple.com/documentation/audiotoolbox?language=objc>`_
* `AuthenticationServices <https://developer.apple.com/documentation/authenticationservices?language=objc>`_
* `CFNetwork <https://developer.apple.com/documentation/cfnetwork?language=objc>`_
* `CoreBluetooth <https://developer.apple.com/documentation/corebluetooth?language=objc>`_
* `CoreGraphics <https://developer.apple.com/documentation/coregraphics?language=objc>`_
* `CoreHaptics <https://developer.apple.com/documentation/corehaptics?language=objc>`_
* `CoreLocation <https://developer.apple.com/documentation/corelocation?language=objc>`_
* `CoreMedia <https://developer.apple.com/documentation/coremedia?language=objc>`_
* `CoreMIDI <https://developer.apple.com/documentation/coremidi?language=objc>`_
* `CoreML <https://developer.apple.com/documentation/coreml?language=objc>`_
* `CoreMotion <https://developer.apple.com/documentation/coremotion?language=objc>`_
* `CoreText <https://developer.apple.com/documentation/coretext?language=objc>`_
* `CoreVideo <https://developer.apple.com/documentation/corevideo?language=objc>`_
* `FileProvider <https://developer.apple.com/documentation/fileprovider?language=objc>`_
* `GameController <https://developer.apple.com/documentation/gamecontroller?language=objc>`_
* `GameplayKit <https://developer.apple.com/documentation/gameplaykit?language=objc>`_
* `GLKit <https://developer.apple.com/documentation/glkit?language=objc>`_
* `JavaScriptCore <https://developer.apple.com/documentation/javascriptcore?language=objc>`_
* `MapKit <https://developer.apple.com/documentation/mapkit?language=objc>`_
* `MediaPlayer <https://developer.apple.com/documentation/mediaplayer?language=objc>`_
* `MessageUI <https://developer.apple.com/documentation/messageui?language=objc>`_
* `MLCompute <https://developer.apple.com/documentation/mlcompute?language=objc>`_
* `NaturalLanguage <https://developer.apple.com/documentation/naturallanguage?language=objc>`_
* `OpenGLES <https://developer.apple.com/documentation/opengles?language=objc>`_
* `PDFKit <https://developer.apple.com/documentation/pdfkit?language=objc>`_
* `PencilKit <https://developer.apple.com/documentation/pencilkit?language=objc>`_
* `ReplayKit <https://developer.apple.com/documentation/replaykit?language=objc>`_
* `Social <https://developer.apple.com/documentation/social?language=objc>`_
* `Speech <https://developer.apple.com/documentation/speech?language=objc>`_
* `UIKit <https://developer.apple.com/documentation/uikit?language=objc>`_
* `UserNotifications <https://developer.apple.com/documentation/usernotifications?language=objc>`_
* `WebKit <https://developer.apple.com/documentation/webkit?language=objc>`_

For a more exhaustive list, use the example code below.

.. collapse:: List all included system Frameworks

    .. code-block:: lua

        -- list all included system Frameworks
        local bundles = objc.NSBundle.allFrameworks
        local systemBundles = {}
        
        for i, b in ipairs(bundles) do
            if string.find(
                b.bundlePath,
                "System/Library/Frameworks/") then
                table.insert(systemBundles, b.bundlePath)
            end
        end
        
        table.sort(systemBundles)
        
        for i, bundle in ipairs(systemBundles) do
            print(bundle)
        end
