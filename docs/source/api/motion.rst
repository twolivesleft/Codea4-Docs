Motion
======
      
Exposes Core Motion functionalities such as accessing the device's accelerometer, gyroscope, and magnetometer data.

Tracking of motion metrics can impact performance and battery drain. Use this feature judiciously to avoid negatively affecting the user experience.

.. lua:module:: motion

.. lua:attribute:: autoStart: boolean

   If set, motion tracking will start automatically as soon as any attribute is read. Default is ``true``.

   .. helptext:: start motion tracking automatically on first access

   Set to false if you want to control when motion is tracked manually using the ``start`` and ``stop`` functions.

.. lua:function:: start(referenceFrame)

   Start tracking motion metrics.

   .. helptext:: start motion tracking

   :param referenceFrame: The reference frame in which to track motion metrics. Can be one of the following values:
   :type referenceFrame: number

   - ``motion.referenceFrame.XArbitraryZVertical`` (default): The X-axis is arbitrary and the Z-axis is vertical.
   - ``motion.referenceFrame.XArbitraryCorrectedZVertical``: The X-axis is arbitrary and the Z-axis is vertical. If available, the magnetometer will be used to correct for accumulated yaw errors.
   - ``motion.referenceFrame.XMagneticNorthZVertical``: The X-axis points toward the magnetic north and the Z-axis is vertical.
   - ``motion.referenceFrame.XTrueNorthZVertical``: The X-axis points toward the true north and the Z-axis is vertical.

.. lua:attribute:: referenceFrame: table

   Reference frame constants for motion tracking.

   .. helptext:: motion reference frame constants

   :param const XArbitraryZVertical: The X-axis is arbitrary and the Z-axis is vertical.
   :param const XArbitraryCorrectedZVertical: The X-axis is arbitrary and the Z-axis is vertical. If available, the magnetometer will be used to correct for accumulated yaw errors.
   :param const XMagneticNorthZVertical: The X-axis points toward the magnetic north and the Z-axis is vertical.
   :param const XTrueNorthZVertical: The X-axis points toward the true north and the Z-axis is vertical.

.. lua:function:: stop()

   Stop tracking motion metrics and set autoStart to false.

   .. helptext:: stop motion tracking

.. lua:attribute:: updateInterval: number

   The interval, in seconds, at which motion data is updated. This value can be set to control the frequency of motion updates. A lower value means more frequent updates, which can provide smoother motion tracking but may consume more power. The default value is 1/30 second.

   .. helptext:: interval between motion updates

   Note that the interval is clamped between limits defined by the system.

.. lua:attribute:: gravity: vec2

   The gravity vector in the device's reference frame. This vector is automatically rotated to follow device orientation changes.

   .. helptext:: current gravity vector

.. lua:attribute:: acceleration: vec2

   The acceleration vector in the device's reference frame. This vector is automatically rotated to follow device orientation changes.

   .. helptext:: current acceleration vector

.. lua:attribute:: rotationRate: vec2

   The rotation rate in the device's reference frame. This vector is automatically rotated to follow device orientation changes.

   .. helptext:: current rotation rate

.. lua:attribute:: sensorLocation: table

   Sensor location constants.

   .. helptext:: motion sensor location constants

   :param const default: The location of the device's sensors is the default one.
   :param const headphoneLeft: The device's sensors are located near the left headphone.
   :param const headphoneRight: The device's sensors are located near the right headphone.

.. lua:attribute:: heading: number

   The heading in degrees relative to the current reference frame.

   .. helptext:: current device heading

Device Orientation
==================

.. lua:attribute:: attitude: table

   Represents a measurement of your device attitude. This orientation of a body relative to a given frame of reference.

   You can set ``motion.attitude.referenceFrame`` to specify the frame of reference in which the attitude is expressed.

   The value can be one of the following ``motion.referenceFrame.XArbitraryZVertical``, ``motion.referenceFrame.XArbitraryCorrectedZVertical``, ``motion.referenceFrame.XMagneticNorthZVertical``, ``motion.referenceFrame.XTrueNorthZVertical``.

   :param number pitch: The pitch of the device, in radians.
   :param number yaw: The yaw of the device, in radians.
   :param number roll: The roll of the device, in radians.
   :param mat3x3 rotationMatrix: The rotation matrix that describes the device's orientation.
   :param quat quaternion: The quaternion that describes the device's orientation.
   :param integer referenceFrame: The reference frame in which motion metrics are tracked.

Magnetic Field Data
===================

.. lua:attribute:: magnetic: table

   Magnetic field data.

   .. helptext:: current magnetic field data

   :param vec3 field: The magnetic field vector in the device's reference frame.
   :param integer accuracy: The accuracy of the magnetic field data.

.. lua:attribute:: magneticAccuracy: table

   Magnetic field accuracy constants.

   .. helptext:: magnetic field accuracy constants

   :param const uncalibrated: The magnetic field data is uncalibrated.
   :param const low: The magnetic field data is of low accuracy.
   :param const medium: The magnetic field data is of medium accuracy.
   :param const high: The magnetic field data is of high accuracy.
