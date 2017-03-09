********
Overview
********

The integration tests are based on the Robot Framework.

Robot Framework is a generic test automation framework for acceptance testing and acceptance test-driven development (ATDD). It has easy-to-use tabular test data syntax and it utilizes the keyword-  driven testing approach. Its testing capabilities can be extended by test libraries implemented either with Python or Java, and users can create new higher-level keywords from existing ones using the  same syntax that is used for creating test cases.

Robot Framework project is hosted on GitHub where you can find further documentation, source code, and issue tracker. Downloads are hosted at PyPI. The framework has a rich ecosystem around it   consisting of various generic test libraries and tools that are developed as separate projects.

Robot Framework is operating system and application independent. The core framework is implemented using Python and runs also on Jython (JVM) and IronPython (.NET). 

.. note::
    
    This documentation is not intended to explain robotframework but to give a fast introduction for this specific teststructure. For more information, reference and more, visit ``www.robotframework.org``

For usage of the framework a test structure has been implemented which influences the way tests can be written. The main target of this test structure is actually being able to:

*   test Board and Image specific in a generic way
*   take care about prerequisites of single tests   

The key components of the test structure is a tagging system. The way in which it is used in this test setup is descipted in :ref:`tagging_system`.

.. note:: 
    
     Finally a runscript for the tests has been written. In further documentation, it is assumed that you use it to run tests.

Overall Structure
=================

.. image:: integration_test_structure.svg


