*************
Building SDKs
*************

Prerequisites
=============

* :ref:`common_tasks_docker_install`

Building a SDK (toolchain)
==========================

* A Toolchain is always build for a specific image and contains all libraries installed in that image
* First build the toolchain with Yocto:

.. code-block:: console

    $ cd ~/projects/sca-os
    $ ./tools/run_in_container.sh CONTAINER ./tools/build/bitbake.sh ./build/BUILDCONFIG none IMAGE -c populate_sdk

To generate the ``enterprise-sdk`` for the ``application-carrier-board`` run:

.. code-block:: console

    $ cd ~/projects/sca-os
    $ ./tools/run_in_container.sh build ./tools/build/bitbake.sh ./build/app-carrier-board none sca-enterprise-image -c populate_sdk

* Afterwards generate a Debian-Package for the generated SDK:

.. code-block:: console

    $ cd ~/projects/sca-os
    $ ./tools/make_sca_[enterprise|sys6000|asc5000]_sdk.sh ./build/BUILDCONFIG

To generate a debian-package of the ``enterprise-sdk`` for the ``application-carrier-board`` run:

.. code-block:: console

    $ cd ~/projects/sca-os
    $ ./tools/make_sca_enterprise_sdk.sh ./build/app-carrier-board

* The generated Debian-Package can now be found in ``~/projects/sca-os/build/BUILDCONFIG/tmp/deploy/sdk``

Installing an SDK to a developer host
=====================================

* Copy the generated debian-package for the SDK you want to a developer host and install it with ``dpkg`` (e.g. the enterprise-sdk):

.. code-block:: console

    $ dpkg -i sca-enterprise-image-cortexa7hf-neon-toolchain_amd64_2.1.1-1.0.0.deb