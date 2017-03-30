.. _valgrind:

***********************
Profiling with Valgrind
***********************

Valgrind is an instrumentation framework for building dynamic analysis tools. It comes with a set of tools each of which performs some kind of debugging, profiling, or similar task that helps you improve your programs. All of those programs are called via ``valgrind --tool=<TOOL>``.
Some of them can like memcheck be used within a ``Continous Integration`` setup :ref:`valgrind_jenkins`. The most often important tools and in this project used tools are

1. **Memcheck** is a memory error detector, which helps you to make your programs, particularly those written in C and C++, more correct.
2. **Callgrind** is a call-graph generating cache profiler. It helps you make your programs run faster.

In the following sections basic usage example for **Memcheck** and **Callgrind** are given.

.. _memcheck:

Memcheck
========

Memcheck is a memory error detector. It can detect the following problems that are common in C and C++ programs.

* Accessing memory you shouldn't, e.g. overrunning and underrunning heap blocks, overrunning the top of the stack, and accessing memory after it has been freed.
* Using undefined values, i.e. values that have not been initialised, or that have been derived from other undefined values
* Incorrect freeing of heap memory, such as double-freeing heap blocks, or mismatched use of ``malloc/new/new[]`` versus ``free/delete/delete[]``
* Overlapping src and dst pointers in memcpy and related functions.
* Passing a fishy (presumably negative) value to the size parameter of a memory allocation function.
* Memory leaks.

Problems like these can be difficult to find by other means, often remaining undetected for long periods, then causing occasional, difficult-to-diagnose crashes.

To receive readable outputs by memcheck the program to examine needs debug symbols, which means you should ``BUILD_TYPE DEBUG``.
The basic way of calling memcheck to check your program is 
	
	valgrind --tool=memcheck <VALGRIND-OPTIONS> <PATH-TO-PROGRAM> <PROGRAM-OPTIONS>

Often the default options are sufficient, though, there are occasions where modifying them is useful. A basic option you should use is ``--unw-stack-scan-thresh=5`` which gives the depth of a stack-trace.

A complete reference for options and to understand memcheck reports is given at [Memcheck Reference](http://valgrind.org/docs/manual/mc-manual.html#mc-manual.options ).


.. _callgrind:

Callgrind
=========


.. _valgrind_jenkins:

Integration in Jenkins 
======================

[Memcheck Reference](http://valgrind.org/docs/manual/mc-manual.html#mc-manual.options )
[ein Beispiel](http://valgrind.org/docs/manual/manual-core.html "Valgrind Core Reference")
