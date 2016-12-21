**************
Get the Source
**************

With your development-host and target-board prepared you can now get the code of
the application you are working on.

Clone your application repository
=================================

The ``application-controller`` will be used as an example here and it is assumed,
that you have a folder ``~/git`` to manage all your git-repositories.

.. code-block:: console

    $ cd ~/git
    $ git clone git@DESVML02.dev.sca-solutions.com:core-system/application-controller.git
    $ cd application-controller
    

Update the imports
==================

The ``application-controller`` needs a few other repositories cloned into a subfolder. These
are called imports and defined in the file ``bower.json``. To update all imports to the
versions defined in that file run these command in the source-directory of the
``application-controller``:

.. code-block:: console

    $ bower update

Usually all imports are placed into subfolders in ``external``.
For a detailed description of import management see :ref:`crossdev_imports`.
