*******************************
Setup your host for development
*******************************

To develop applications for the SCA embedded linux devices you need a recent linux system;
Windows is currently not supported . The recomended distribution is Ubuntu >= 16.04.

Required ubuntu-packages
=============================

================    =======
Packagename         Purpose
================    =======
build-essential     Basic development packages
git                 Version-Control
cmake               Buildmanagement
wget                Download-Tool
libgtest-dev        Unittesting
coco-cpp            Used by the application-controller build
================    =======

Google test-framework
=====================

The google-test framework must be compiled and installed on your host; the installed debian
package only includes the sources:

.. code-block:: console

    $ cd /usr/src/gtest
    $ sudo cmake ./CMakeLists.txt
    $ sudo make
    $ sudo cp ./*.a /usr/lib

Install a Yocto SDK
===================

See :ref:`yocto_building_sdks_install`.
