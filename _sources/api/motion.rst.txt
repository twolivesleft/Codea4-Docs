Motion Overview
===============
      
Exposes Core Motion functionalities such as accessing the device's accelerometer, gyroscope, and magnetometer data.

Tracking of motion metrics can impact performance and battery drain. Use this feature judiciously to avoid negatively affecting the user experience.

Motion
======

.. lua:module:: motion

.. lua:attribute:: autoStart: boolean

   If set, motion tracking will start automatically as soon as any attribute is read. Default is ``true``.

   Set to false if you want to control when motion is tracked manually using the ``start`` and ``stop`` functions.

.. lua:function:: start(referenceFrame)

   Start tracking motion metrics.

   :param referenceFrame: The reference frame in which to track motion metrics. Can be one of the following values:
   :type referenceFrame: number

   - ``motion.referenceFrame.XArbitraryZVertical`` (default): The X-axis is arbitrary and the Z-axis is vertical.
   - ``motion.referenceFrame.XArbitraryCorrectedZVertical``: The X-axis is arbitrary and the Z-axis is vertical. If available, the magnetometer will be used to correct for accumulated yaw errors.
   - ``motion.referenceFrame.XMagneticNorthZVertical``: The X-axis points toward the magnetic north and the Z-axis is vertical.
   - ``motion.referenceFrame.XTrueNorthZVertical``: The X-axis points toward the true north and the Z-axis is vertical.

.. lua:function:: stop()

   Stop tracking motion metrics and set autoStart to false.

.. lua:attribute:: updateInterval: number

   The interval, in seconds, at which motion data is updated. This value can be set to control the frequency of motion updates. A lower value means more frequent updates, which can provide smoother motion tracking but may consume more power. The default value is 1/30 second.

   Note that the interval is clamped between limits defined by the system.

.. lua:attribute:: gravity: vec2

   The gravity vector in the device's reference frame. This vector is automatically rotated to follow device orientation changes.

.. lua:attribute:: acceleration: vec2

   The acceleration vector in the device's reference frame. This vector is automatically rotated to follow device orientation changes.

.. lua:attribute:: rotationRate: vec2

   The rotation rate in the device's reference frame. This vector is automatically rotated to follow device orientation changes.

.. lua:attribute:: sensorLocation: integer

   The location of the device's sensors.

   The value can be one of the following:

   - ``motion.sensorLocation.default``: The location of the device's sensors is the default one.
   - ``motion.sensorLocation.headphoneLeft``: The device's sensors are located near the left headphone.
   - ``motion.sensorLocation.headphoneRight``: The device's sensors are located near the right headphone.

.. lua:attribute:: heading: number

   The heading in degrees relative to the current reference frame.

Device Orientation
==================

.. lua:class:: attitude

   Represents a measurement of your device attitude. This orientation of a body relative to a given frame of reference.

   You can set ``motion.attitude.referenceFrame`` to specify the frame of reference in which the attitude is expressed.

   The value can be one of the following ``motion.referenceFrame.XArbitraryZVertical``, ``motion.referenceFrame.XArbitraryCorrectedZVertical``, ``motion.referenceFrame.XMagneticNorthZVertical``, ``motion.referenceFrame.XTrueNorthZVertical``.

   :param pitch: The pitch of the device, in radians.
   :type pitch: number

   :param yaw: The yaw of the device, in radians.
   :type yaw: number

   :param roll: The roll of the device, in radians.
   :type roll: number   

   :param rotationMatrix: The rotation matrix that describes the device's orientation.
   :type rotationMatrix: mat3x3

   :param quaternion: The quaternion that describes the device's orientation.
   :type quaternion: quat

   :param referenceFrame: The reference frame in which motion metrics are tracked.
   :type referenceFrame: integer      

   .. lua:attribute:: XArbitraryZVertical: integer

      The X-axis is arbitrary and the Z-axis is vertical.

   .. lua:attribute:: XArbitraryCorrectedZVertical: integer

      The X-axis is arbitrary and the Z-axis is vertical. The system will attempt to correct for the device's orientation.

   .. lua:attribute:: XMagneticNorthZVertical: integer
      
      The X-axis points toward the magnetic north and the Z-axis is vertical.

   .. lua:attribute:: XTrueNorthZVertical: integer
      
      The X-axis points toward the true north and the Z-axis is vertical.

Magnetic Field Data
===================

.. lua:class:: magnetic

   .. lua:attribute:: field: vec3

      The magnetic field vector in the device's reference frame.
   
   .. lua:attribute:: accuracy: integer

      The accuracy of the magnetic field data.

      The value can be one of the following:

      - ``motion.magneticAccuracy.uncalibrated``: The magnetic field data is uncalibrated.
      - ``motion.magneticAccuracy.low``: The magnetic field data is of low accuracy.
      - ``motion.magneticAccuracy.medium``: The magnetic field data is of medium accuracy.
      - ``motion.magneticAccuracy.high``: The magnetic field data is of high accuracy.
