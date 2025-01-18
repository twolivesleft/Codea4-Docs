pasteboard
==========
      
Exposes pasteboard functionnalities to copy and paste strings, images, colors and URLs.

To minimize unnecessary notifications when accessing pasteboard data from other applications,
first call ``hasStrings``, ``hasImages``, ``hasColors`` or ``hasURLs`` to check if the desired
data type is available before retrieving it. This prevents a notification when the requested
type is not present, but a notification may still appear if data is accessed.

.. lua:module:: pasteboard

.. lua:attribute:: name: string

   The name of the pasteboard.

.. lua:attribute:: numberOfItems: number

   The number of items in the pasteboard.

.. lua:attribute:: hasStrings: boolean

   Whether the pasteboard contains one or more strings.

.. lua:attribute:: string: string

    The first string in the pasteboard.

.. lua:attribute:: strings: table

    A table of strings in the pasteboard.

.. lua:attribute:: hasImages: boolean

    Whether the pasteboard contains one or more images.

.. lua:attribute:: image: image

    The first image in the pasteboard.

.. lua:attribute:: images: table

    A table of images in the pasteboard.

.. lua:attribute:: hasColors: boolean

    Whether the pasteboard contains one or more colors.

.. lua:attribute:: color: color

    The first color in the pasteboard.

.. lua:attribute:: colors: table

    A table of colors in the pasteboard.

.. lua:attribute:: hasURLs: boolean

    Whether the pasteboard contains one or more URLs.

.. lua:attribute:: URL: string

    The first URL in the pasteboard.

.. lua:attribute:: URLs: table

    A table of URLs in the pasteboard.
