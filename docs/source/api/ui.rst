ui
==

A module for creating basic UI elements in scenes

.. lua:module:: ui

.. lua:class:: canvas

   Provides a 2D layer for rendering UI elements within a scene

   **Canvas Entities**

   Child entities created with ``ui.canvas``, are 2D elements that use an automatic layout system

   Canvas children have additional properties and methods:

   * ``entity.size``, ``vec2`` - the 2D size of the entity in canvas units
   * ``entity.pivot``, ``vec2`` - the centre privot point of the entity
   * ``entity.anchorX``, ``enum`` - the horizontal alignment of the entity
   * ``entity.anchorY``, ``enum`` - the vertical alignment of the entity
   * ``entity:anchor(x, y)`` - shortcut for setting ``anchorX``, ``anchorY``

   **Anchors**

   Canvas entities are laid out using an anchor and pivot system

   For horizontal alignment use:

   * ``LEFT`` - Align relative to the left side of the parent entity
   * ``RIGHT`` - Align relative to the right side of the parent entity
   * ``CENTER`` - Align relative to the center of the parent entity

   For vertical alignment use:

   * ``BOTTOM`` - Align relative to the bottom of the parent entity
   * ``MODDLE`` - Align relative to the middle of the parent entity
   * ``TOP`` - Align relative to the top of the parent entity

   Both horizonal and vertical alignment can be stretched

   * ``STRETCH`` - Stretch the component relative to it's parent


   .. code-block:: lua
      
      scn = scene()

      -- Create an entity to contain the button
      ent = scn.canvas:child("button")

      -- Adjust the button size
      ent.size = vec2(300, 150)

      -- Add a button component
      btn = ent:add(ui.button)
      btn.label.text = "Press Me!"

      -- Add a callback function to react to button taps
      function ent:tapped()
         print("Tapped!")
      end

   .. lua:attribute:: entity: entity

      The entity for this canvas

   .. lua:attribute:: scale: number

      Scale factor for canvas drawing


.. lua:class:: label : component

   Draws text on a canvas entity

   .. lua:attribute:: text: string

      The text to render on the label

   .. lua:attribute:: color: color

      The label's text color

   .. lua:attribute:: fontSize: number

      The label's font size

   .. lua:attribute:: align: flags

      The label's text alignment

   .. lua:attribute:: style: flags

      The label's text style

   .. lua:attribute:: shadowOffset: vec2

      The offset of the labels text shadow

   .. lua:attribute:: shadowSoftner: number

      The softness of the labels text shadow

.. lua:class:: image : component

   Draws an image on a canvas entity

   .. lua:attribute:: image: image

   The image to draw

.. lua:class:: button: component

   Makes a canvas entity into an interactive button

   .. lua:attribute:: style : table

      The button's style. Background image and color tint can be set for each button state

      .. code-block:: lua
         :caption: Button table structure

         btn.style =
         {
            normal = { sprite = ..., color = ... },
            pressed = { sprite = ..., color = ... },
            disabled = { sprite = ..., color = ... },
            selected = { sprite = ..., color = ... }
         }


.. lua:class:: vstack: component

   Lays out child entities in a vertical stack

   .. lua:attribute:: padding: number

      The outer padding for the stack, used to create a border around the edge

   .. lua:attribute:: spacing: number

      The spacing between each item in the stack


.. lua:class:: hstack: component

   Lays out child entities in a horizontal stack

   .. lua:attribute:: padding: number

      The outer padding for the stack, used to create a border around the edge

   .. lua:attribute:: spacing: number

      The spacing between each item in the stack
