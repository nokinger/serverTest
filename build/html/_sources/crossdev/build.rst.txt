***********************************
Building the application-controller
***********************************

With your development-host and target-board prepared you can now get the code of
the application you are working on.

Clone your the repository
=========================

The ``application-controller`` will be used as an example here and it is assumed,
that you have a folder ``~/git`` to manage all your git-repositories.

.. code-block:: console

    $ cd ~/git
    $ git clone git@DESVML02.dev.sca-solutions.com:core-system/application-controller.git
    $ cd application-controller
    $ git checkout -b cmake-project-structure
    
Configure a build from command-line
===================================

Before you can build you have to create a build-configuration with cmake using a toolchain
file corresponding to your sdk and target-board.

To generate a release-build using the ``enterprise-sdk`` for the ``app-carrier-board`` in
the folder ``build/release`` run these commands from your toplevel source-directory:

.. code-block:: console

    $ mkdir -p build/release
    $ cd build/release
    $ cmake -DCMAKE_TOOLCHAIN_FILE=../../Linux-sca_enterprise_image_sdk_gcc.cmake -DCMAKE_BUILD_TYPE=Release ../../
    
Configure a build from CLion
============================

.. figure:: images/CLion_OpenProject.png

    Select ``Open Project`` and choose the ``application-controller`` source directory. 

.. figure:: images/CLion_MarkProjectRoot.png

    Mark the source-directory as project-root.

.. figure:: images/CLion_OpenCMakeSettings.png

    Open the CMake settings.

.. figure:: images/CLion_SettingsBundledCMake.png

    Choose bundled CMake and GDB.

.. figure:: images/CLion_SettingsBuildConfigType.png

    Specify build configuration type, external build directory, and toolchain file path.
    Click OK to generate build configuration.

.. figure:: images/CLion_ReloadProject.png

    Reload CMake project if files have been changed externally.

Build
=====

.. code-block:: console

    $ cd build/release
    $ make

Deploy to a target
==================

When the build has finished you can copy the application-controller binary to the target-board
through ssh.

Running on target
=================

Login to the target via ssh and run the application-controller binary on command-line.
