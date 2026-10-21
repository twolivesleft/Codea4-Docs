font
====

Choose a font with ``font("Helvetica")`` and set its size with
``style.fontSize(32)``. Use ``font.metrics()`` when arranging text along a
shared baseline or aligning text with other elements.

.. lua:module:: font

.. lua:function:: metrics()

   Returns a new table of measurements for the current font, size, and text
   renderer. All measurements are in points. Changing the drawing style later
   does not change a previously returned table.

   Ascent and descent are positive distances above and below the baseline.
   Leading is the extra spacing between lines. These describe the font, not
   the bounds of a particular string; use ``textSize()`` to measure a string.
   Shadows, outlines, and tags within a string do not affect these measurements.

   .. code-block:: lua

      font("Helvetica")
      style.fontSize(32)
      local metrics = font.metrics()
      local baseline = 200
      style.textMode(CORNER)
      text("Hello", 40, baseline - metrics.descent)

   Native and atlas measurements can differ. Atlas font sizes use whole points.

   .. helptext:: measure the current font

   :returns: A snapshot of the current font measurements.
   :rtype: table$private.metrics

.. lua:class:: private.metrics

   .. visibility:: private

   A table of font measurements, in points.

   .. lua:attribute:: size: number

      The effective font size.

      .. helptext:: the effective font size

   .. lua:attribute:: ascent: number

      The distance above the baseline.

      .. helptext:: the distance above the baseline

   .. lua:attribute:: descent: number

      The distance below the baseline.

      .. helptext:: the distance below the baseline

   .. lua:attribute:: leading: number

      The additional spacing between lines.

      .. helptext:: the additional spacing between lines

   .. lua:attribute:: xHeight: number

      The height of a lowercase x.

      .. helptext:: the height of a lowercase x

   .. lua:attribute:: capHeight: number

      The height of a capital letter.

      .. helptext:: the height of a capital letter

   .. lua:attribute:: underlinePosition: number

      The signed underline position relative to the baseline; negative is below it.

      .. helptext:: the signed underline position relative to the baseline; negative is below it

   .. lua:attribute:: underlineThickness: number

      The underline thickness.

      .. helptext:: the underline thickness
