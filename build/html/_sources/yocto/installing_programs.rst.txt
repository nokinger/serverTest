*******************
Installing Programs
*******************

Installing
==========

.. note::

	Programs installed into an image are automatically added to the corresponding sdk

Installing programs can be done mainly at 3 places:

1. ./meta-sca/recipes-core/images/sca-base-image
2. ./meta-sca/recipes-core/images/sca-<NAME>-image
3. local.conf   (Not recommended)

Whether you use 1. or 2. depends on where you want to have the program installed. Variant 1. installs the program in every other image within that folder. Variant 2. installs it only in the specified one.
To install you have to append the variable ``IMAGE_INSTALL_append`` as it is done with other packages.

At this point is necessary to emphasize that **Packages** are installed, not recipes. A receipe produces different packages where the main package has often the same name as the receipe, which might lead to confusion. If you want to know which packages are delivered by a receipe the easiest way is to build the receipe using 

.. code:: CONSOLE 

	./tools/run_in_container.sh <CONTAINER-TEMPLATE> tools/build/bitbake.sh <PATH-TO-BUILD-CONFIG> <SSTATE-CACHE-NFS>	<RECEIPE-NAME>

Common packages delivered by a receipe ``<PN>`` are: <PN>-dbg <PN>-staticdev <PN>-dev <PN>-doc <PN>-locale <PN>

Searching a recipe for a package
================================

.. _OE: https://layers.openembedded.org/layerindex/branch/master/recipes/

.. _here: http://packages.ubuntu.com/

Often there is a receipe with a corresponding name to the package. The first place to look for such recipe are the already installed layers ``./poky`` and the other ``./meta-<LAYERNAME>``.
If there is not such a file you have to search for the receipe here OE_.
If the name of the package, which contains the needed program, is not known, seek here_.

