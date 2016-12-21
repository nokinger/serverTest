***************************************
Setup your target-board for development
***************************************

To run and test applications on your target-device it must be accessible from your
development host through ssh and in some cases a serial console would also be required.

Connections Overview
====================

.. image:: images/board_conn.svg

**Network Connections:**

Make sure your target-board and development host are on the same network and can ping
each other. As a default the target-board uses DHCP to get an IP address.

To verify your connection try to login to the target-board via SSH from your host:

.. code-block:: console

    $ ssh root@TARGET-IP
    
.. note::

    Currently there are only development-images in use which do not have a passord set
    for the root-user.

**Serial Connections:**

Use a USB-Serial-Converter on your development host to connecto to the target-board. Be
aware, that you must use a nullmodem cable to connect the converter to the board.

Install an Image
================

Now get an SD-Card image from Mr. Windisch, copy it to a folder on your development host
and write it to your SD-Card:

.. code-block:: console

    $ sudo dd if=PATH-TO-THE-IMAGE of=/dev/MMCDEVICE bs=1M

PATH-TO-IMAGE
    This is the filename of the image you copied to your harddisk.
    
MMCDEVICE
    The name of the mmc-device in ``/dev``. You must use the full device
    not a partition on it. For buildin card-readers this is usually
    ``/dev/mmcblk0`` and for usb-readers something like ``/dev/sdc``.

.. danger::

    **Doublecheck the device you are writing to!!**

    When you use the wrong device you can make your system unbootable and even loose
    your data. To the right device run ``tail -f /var/log/messages`` and plug in
    your sd-card. The devicename used by the sd-card will now show up in the log.
    
.. hint::

   Usually you are using the latest sd-card image which should work fine with the newest
   version of the application you are developing. But when you have to fix a bug in an
   old version of your application you should also install an sd-card-image that
   corresponds to your application version. 