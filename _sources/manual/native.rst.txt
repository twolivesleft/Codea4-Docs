Using Native APIs
=================

The ``objc`` bridge gives Lua access to Objective-C classes and system
frameworks. Prefer Codea's built-in APIs for drawing, input, sound and files;
use the bridge when your project needs a native capability beyond them.

Start small
-----------

Look up the native class, create an object, and call one method at a time. Check
the Objective-C method signature: Lua values, native objects, selectors and
structs have different conversions. The ``objc`` reference includes class and
framework lookup, callbacks, and helpers for common structs.

Native UI belongs to the active view controller and scene. Keep callback objects
alive for as long as native code needs them, and release observers or delegates
when the project stops. Some frameworks require permissions or entitlements;
bridging a class does not grant those capabilities.
