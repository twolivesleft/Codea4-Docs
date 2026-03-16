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

   .. helptext:: get the name of this pasteboard

.. lua:attribute:: numberOfItems: number

   The number of items in the pasteboard.

   .. helptext:: get the number of items on this pasteboard

.. lua:attribute:: hasStrings: boolean

   Whether the pasteboard contains one or more strings.

   .. helptext:: get whether this pasteboard has strings

.. lua:attribute:: string: string

    The first string in the pasteboard.

   .. helptext:: get or set the string on this pasteboard

.. lua:attribute:: strings: table

    A table of strings in the pasteboard.

   .. helptext:: get or set the strings on this pasteboard

.. lua:attribute:: hasImages: boolean

    Whether the pasteboard contains one or more images.

   .. helptext:: get whether this pasteboard has images

.. lua:attribute:: image: image

    The first image in the pasteboard.

   .. helptext:: get or set the image on this pasteboard

.. lua:attribute:: images: table

    A table of images in the pasteboard.

   .. helptext:: get or set the images on this pasteboard

.. lua:attribute:: hasColors: boolean

    Whether the pasteboard contains one or more colors.

   .. helptext:: get whether this pasteboard has colors

.. lua:attribute:: color: color

    The first color in the pasteboard.

   .. helptext:: get or set the color on this pasteboard

.. lua:attribute:: colors: table

    A table of colors in the pasteboard.

   .. helptext:: get or set the colors on this pasteboard

.. lua:attribute:: hasURLs: boolean

    Whether the pasteboard contains one or more URLs.

   .. helptext:: get whether this pasteboard has URLs

.. lua:attribute:: URL: string

    The first URL in the pasteboard.

   .. helptext:: get or set the URL on this pasteboard

.. lua:attribute:: URLs: table

    A table of URLs in the pasteboard.

   .. helptext:: get or set the URLs on this pasteboard
