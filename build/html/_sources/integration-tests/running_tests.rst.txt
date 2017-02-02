.. _integration_tests_how_to_run:

*****************************
Running the Integration Tests
*****************************

Prerequisites
=============

* :ref:`common_tasks_docker_install`

Running the Tests
=================

Get the source:

.. code-block:: console

    $ git clone git@DESVML02.dev.sca-solutions.com:ex.schapaa/integration-tests.git
    $ cd integration-tests
    $ git checkout -b develop

Run the tests with the help of the provided script:

.. code-block:: console

    $ ./testrunner/run_in_container.sh

Viewing Testresults
===================

After running the integration-test a report can be found in ``output/report.html`` in the
source folder.