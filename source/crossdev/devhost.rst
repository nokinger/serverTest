*******************************
Setup your host for development
*******************************

To develop applications for the SCA embedded linux devices you need a recent linux system;
Windows is currently not supported . The recomended distribution is Ubuntu >= 16.04.

**Install these ubuntu-packages:**

================    =======
Packagename         Purpose
================    =======
build-essential     Basic development packages
git                 Version-Control
nodejs              Required for bower dependency manager
npm                 Required to be able to install bower
cmake               Buildmanagement
wget                Download-Tool
libgtest-dev        Unittesting
coco-cpp            Used by the application-controller build
================    =======

**Install bower dependency manager via npm:**

.. code-block:: console

    $ npm install -g bower

**Install google test-framework:**

.. code-block:: console

    $ cd /usr/src/gtest
    $ sudo cmake ./CMakeLists.txt
    $ sudo make
    $ sudo cp ./*.a /usr/lib

**Install a yocto SDK:**

Depending on the device-type you are developing for there will be different SDKs.
Get the debian package of the required SDK from Mr. Windisch, copy it to your
harddisk and install it:

.. code-block:: sh

    $ sudo dpkg -i PATH-TO-SDK.deb
