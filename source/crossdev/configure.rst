*****************
Configure a build
*****************

After getting the source a build-configuration has to be generated with cmake
for every toolchain and build-type (Debug, Release, ...).

Generate configs using the commandline
======================================


Generate configs using CLion
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
