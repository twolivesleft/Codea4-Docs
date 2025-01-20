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