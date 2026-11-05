Using Native APIs
=================

Use ``objc`` to call Objective-C classes from Lua. This gives your project
access to system features beyond Codea’s built-in drawing, input, and sound commands.

Start small
-----------

Look up a class, create an object, and call its methods. Check the method’s
parameter types: Lua values, native objects, selectors, and structs are passed
in different ways. See :doc:`/api/objc` for conversions and examples.

Present native controls from the active view controller. Keep callback objects
alive while native code uses them, and release observers or delegates when the
project stops. System permissions and entitlements still apply.
