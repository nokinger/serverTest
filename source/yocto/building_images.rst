***************
Building Images
***************

Prerequisites
=============

* :ref:`common_tasks_docker_install`

Building an image
=================

* It is assumed, that you have cloned the os-repository in ``~/projects/sca-os``
* ``CONTAINER`` is the name of a folder in ``./tools/container`` and is used as a template
  to build a docker-container for building
* ``BUILDCONFIG`` is the name of a folder in ``./build`` (e.g. app-carrier-board, sys6000-11-cpu)) that
  is used as the config-directory for bitbake to build.
* ``IMAGE`` is the name of the image-recipe; currently ``sca-enterprise-image``, ``sca-sys6000-image``
  and ``sca-asc5000-image`` are available.

.. code-block:: console

    $ cd ~/projects/sca-os
    $ ./tools/run_in_container.sh CONTAINER ./tools/build/bitbake.sh ./build/BUILDCONFIG none IMAGE

To build the ``sca-enterprise-image`` for the ``application-carrier-board`` run this command:

.. code-block:: console

    $ cd ~/projects/sca-os
    $ ./tools/run_in_container.sh build ./tools/build/bitbake.sh ./build/app-carrier-board none sca-enterprise-image

To build the ``sca-enterprise-image`` for the ``application-carrier-board`` with a common cache on nfs at
AVANTYS run this command:

.. code-block:: console

    $ cd ~/projects/sca-os
    $ ./tools/run_in_container.sh build ./tools/build/bitbake.sh ./build/app-carrier-board nas.pb.avantys.de:/mnt/nas/data/Projekte/SCA/yocto sca-enterprise-image

The images build will be placed in ``build/app-carrier-board/tmp/deploy/images/ls1021atwr``.

.. _yocto_build_flash_sdcard:

Flashing an image to an sd-card
===============================

To write the image built previously to an sd-card, use this command:

.. code-block:: console

    $ sudo dd if=./build/app-carrier-board/tmp/deploy/images/ls1021atwr/sca-image-application-ls1021atwr.sca-sdimg of=/dev/MMCDEVICE bs=1M

MMCDEVICE
    The name of the mmc-device in ``/dev``. You must use the full device
    not a partition on it. For buildin card-readers this is usually
    ``/dev/mmcblk0`` and for usb-readers something like ``/dev/sdc``.

.. danger::

    **Doublecheck the device you are writing to!!**

    When you use the wrong device you can make your system unbootable and even loose
    your data. To the right device run ``tail -f /var/log/messages`` and plug in
    your sd-card. The devicename used by the sd-card will now show up in the log.
    