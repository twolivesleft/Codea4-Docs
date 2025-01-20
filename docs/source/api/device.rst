device
======
      
Exposes the device properties.

.. lua:module:: device

.. lua:attribute:: id: string

   The identifierForVendor UUID string of the device.

.. lua:attribute:: name: string
   
   The user provided name of the device.

.. lua:attribute:: systemName: string

   The name of the operating system running on the device.

.. lua:attribute:: systemVersion: string

   The version of the operating system running on the device.

.. lua:attribute:: model: string

   The model of the device.

.. lua:attribute:: localizedModel: string

   The localized model of the device.

.. lua:attribute:: batteryLevel: number

   The battery level of the device, from 0.0 to 1.0. -1.0 if the battery state is unknown.

.. lua:attribute:: batteryState: string

   The battery state of the device. One of "unknown", "unplugged", "charging", "full".
