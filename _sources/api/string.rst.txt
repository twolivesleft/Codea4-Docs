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

.. lua:function:: save(assetKey, text [, callback])

    Saves text to a file.

    If a callback is supplied, saving will happen in the background. Multiple calls to save the same file are grouped and only the latest save will be performed.

    .. helptext:: save the text to a file

    :param assetKey assetKey: The asset key of the file.
    :param string text: The text to save.
    :param function callback: Optional completion callback ``function(ok, err)``.

    .. code-block:: lua

        string.save(asset.documents .. "Config.json", json.encode(config), function(ok, err)
            if not ok then
                print("Save failed:", err)
            end
        end)
