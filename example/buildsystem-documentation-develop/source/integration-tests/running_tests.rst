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

Run the tests with the help of the provided script ``./testrunner/run_in_container.sh``. An example for testing the ``app_carrier_board`` with the ``enterprise`` image from your local computer is given below.

.. code-block:: console

    $ ./testrunner/run_in_container.sh -i COMMAND ROBOT --variable TARGET_TYPE:app_carrier_board  --variable TEST_HOST:local --variable TARGET_IP:<TARGET_IP> --variable IMAGE_TYPE:enterprise

A detailed description is given within the script and an explanation of the used tagging structure in :ref:`tagging_system`. Reading the description within the script is probably essential for further reading.


Viewing Testresults
===================

After running the integration-test a report can be found in ``output/report.html`` in the
source folder.


.. _tagging_system:

Tagging System
==============

Robotframework offers the possibility to set several tags for test cases. These can be used to exclude or include tests, which allows partitioning the whole test setup.
Commonly a test which is not tagged is run always. Using tags tests can be prevented from being run or chosen to be run.
For that the robotframework uses the command line options ``--include`` and ``--exclude``. These keywords can be used behind ``COMMAND ROBOT``. 
In this test setup an important addition has been made. Depending on the specified ``TARGET_TYPE`` and ``IMAGE_TYPE`` all tests tagged with another ``TARGET_TYPE`` or ``IMAGE_TYPE`` but the specified are excluded.
So the first important tag category are the board and image tags like ``app_carrier_board``, ``sbc_eval_board``, ``enterprise`` and ``asc_5000``. 

Another tag category is the testlocation. The two given tags are ``local`` and ``gateway``. Those tags are used to determine the host which runs the test. The difference of the host/location is given by the assumption, that on ``gateway`` every peripheral interface can be tested and on ``local`` not. So by default `local` assumes that tests tagged with ``can``, ``serial`` and ``gpio`` cannot be run and excludes them.

.. note::

    To change the exclusion tags defined by ``local`` modify ``./inc/TestInclusionModifier.py``. In-file documentation is given.

Board Specific Global Variables
===============================

For some tests it is useful to make use of global, board specific variables, which are used within all tests. Two good example are ``can`` and ``cpu`` tests. Being able to iterate over the number of devices as a variable makes the test cases generic and reduces space complexity. Those `number of CPUs` can be set within ``tests/000_global_setup.robot``. Again using tags those variables can be done board specific.
