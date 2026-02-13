string
======

Used to interact with text files.

.. code-block:: lua
   :caption: Reading and saving text files

    function setup()
        local contentsOrNil = string.read(asset.."Hello.txt")
        print("Contents: " .. tostring(contentsOrNil))
        if test == "World" then
            string.save(asset.."Hello.txt", "Hello")
        else
            string.save(asset.."Hello.txt", "World")
        end
    end

.. lua:module:: string

.. lua:function:: read(assetKey)

    Reads the contents of a file as text.

    .. helptext:: read the file contents

    :param assetKey assetKey: The asset key of the file.

    :return: The contents of the file.
    :rtype: string

.. lua:function:: save(assetKey, text)

    Saves text to a file.

    .. helptext:: save the text to a file

    :param assetKey assetKey: The asset key of the file.
    :param string text: The text to save.

.. lua:function:: saveAsync(assetKey, text [, callback])

    Saves text to a file asynchronously. Multiple calls to the same file are coalesced and only the latest content is written.

    The optional callback is called from the main thread with ``(ok, err)``. ``err`` is ``nil`` on success.

    .. helptext:: save the text to a file asynchronously

    :param assetKey assetKey: The asset key of the file.
    :param string text: The text to save.
    :param function callback: Optional completion callback ``function(ok, err)``.

    .. code-block:: lua

        string.saveAsync(asset.documents .. "Config.json", json.encode(config), function(ok, err)
            if not ok then
                print("Save failed:", err)
            end
        end)
