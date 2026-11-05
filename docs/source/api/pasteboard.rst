:reference-overview: Copying and Pasting

Pasteboard
==========
      
Copy and paste strings, images, colors and URLs.

Check ``hasStrings``, ``hasImages``, ``hasColors`` or ``hasURLs`` before reading
the corresponding values. Reading data copied from another app may show a
system notification; checking whether it is available does not.

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
