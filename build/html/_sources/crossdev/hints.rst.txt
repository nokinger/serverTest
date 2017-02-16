************************************
Hints on programming rt-applications
************************************

Programming real-time applications on common OS adds some facets which must be taken care about. Even when a rt-patch is applied, as it is done in the linux-qoriq, running on the application-carrier-board. A main concern of rt-applications is fullfilling repetive jobs reliably in a certain period. To reach this several thins have to be done in a program.


Setting scheduler 
=================

Each task has a scheduler configuration set. This can be set via the command ``sched_setscheduler``. As argmunets must be given a scheduling policy and the task priority. The highest priority is given by 99 and the lowest real time priority by 1. For certain reasons it is not recommended to use a priority higher than 90. Since there are 90 priority levels left, it is easy to take care about that recommandation. Realtime policies are FIFO and RoundRobin (RR).

To demonstrate the effect of that command the program given below has been executed several times. As policies the default realtime policy has been taken and RR.
Having the toolchain installed, you can :download:`latencyTest <../crossdev/downloads/src.tar.xz>` and try the program.

The program starts a thread in which a function is running for 10 seconds in a loop pausing periodically for 500 microseconds. It measures the time before pausing, after pausing and calculates the difference between the desired 500 microseconds sleep and the actual real sleep. In the end the minimal and the maximum latency is printed on the commandline.  

.. code-block:: cpp

    int main(int argc, char* argv[])
    {
        CyclictestRunner    t1(std::chrono::microseconds(500),SchedPolicy::RR,90,CPUAffinity::CPU1,std::chrono::seconds(10));
        t1.start();
        t1.wait();

  	    return 0;
    }

    void CyclictestRunner::run(){
	    struct sched_param param;
	    std::chrono::duration<int,std::micro> latency;
	    std::chrono::high_resolution_clock::time_point start,actTimePoint,oldTimePoint;
	    minMaxLatency minMaxLatency;
	    memset(&minMaxLatency, 0, sizeof(minMaxLatency));
	    /* Declare ourself as a real time task */

	    param.sched_priority = mPriority;

	    int rv;
	    switch(mPolicy){
	        case SchedPolicy::FIFO:
	            rv = sched_setscheduler(0, SCHED_FIFO, &param);
	            break;
	        case SchedPolicy::RR:
                rv = sched_setscheduler(0, SCHED_RR, &param);
                break;
	        default:
                rv = sched_setscheduler(0, SCHED_OTHER, &param);
                break;
	    }
	    if( rv == -1) {
			    perror("sched_setscheduler failed");
			    exit(-1);
	    }
	    
	    start = std::chrono::high_resolution_clock::now();

	    while( 1 ) {
		    /* wait until next shot */
	        oldTimePoint = std::chrono::high_resolution_clock::now();
	        std::this_thread::sleep_for(std::chrono::microseconds(mIntervalInmSec));
	        actTimePoint = std::chrono::high_resolution_clock::now();

	        latency = std::chrono::duration_cast<std::chrono::duration<int,std::micro>> (actTimePoint - oldTimePoint - mIntervalInmSec);

		    if(latency > minMaxLatency.max){
			    minMaxLatency.max = latency;
		    }
		    if(latency < minMaxLatency.min){
			    minMaxLatency.min = latency;
		    }

		    if(actTimePoint - start > mDuration){
		        std::cout<<" Min Latency: "<< minMaxLatency.min.count()<< " Max Latency: "<< minMaxLatency.max.count()<<std::endl;
                break;
		    }
	    }
    }

The average latencies of a test with 1 thread and 10 executions per policy are shown below.

============== ===================
Policy         Average Latency us
============== ===================
default        3400
RR             54
============== ===================

Avoiding page-faults 
====================

Another source of non-deterministic latencies are page-faults. Page-faults occur when the cpu needs data or instructions not loaded in the L1, the highest, cache. The picture below shows the internal structure of the core component of the application-carrier-board.

.. figure:: images/LS1021_Blockdiagram.png

To avoid page faults each thread has to call early as possible the command ``mlockall(MCL_CURRENT|MCL_FUTURE)``. mlockall locks all the pages in a process' virtual memory address space, and/or any that are added to it in the future. This includes the pages of the code, data and stack segment, as well as shared libraries, user space kernel data, shared memory, and memory mapped files.
Another aspect is that creating a new thread new memory will be allocated for a new stack and for the thread administration. These allocations will result in new page faults too. Therefore all threads need to be created at startup time, before RT show time. This can be done by allocating and touching the later needed process memory at program start. An example is given by the next code snippet.

.. code-block:: cpp

    #define PROCESS_MEMORY  some_useful_value
    int main(int argc,char**argv[]){
        buffer = static_cast<char*>(malloc(PROCESS_MEMORY));
             
        /* Touch each page in this piece of memory to get it mapped into RAM */   
        for (i = 0; i < size; i += sysconf(_SC_PAGESIZE)) {
        /* Each write to this buffer will generate a pagefault.
           Once the pagefault is handled a page will be locked in
           memory and never given back to the system. */
        buffer[i] = 0;
        }
       /* buffer will now be released. As Glibc is configured such that it
       never gives back memory to the kernel, the memory allocated above is
       locked for this process. All malloc() and new() calls come from
       the memory pool reserved and locked above. Issuing free() and
       delete() does NOT make this locking undone. So, with this locking
       mechanism we can build C++ applications that will never run into
       a major/minor pagefault, even with swapping enabled. */
    free(buffer);
    }
    

A useful command for measuring the maximal used memory is ``getrusage``

To test the use of mlock and prefault allocation the dowloadable program has been used. 
Setup:
* Scheduler: RR
* Taskinterval: 500 us
* Threads:  8
* MLockAll: yes
* Duration: 30 s
* 4 each runs with/without mlockalland and prefault
Latencies in us are shown in the table below.



+---------------+----------------+----------------------------+
|Thread         |   mlockall ON  |      mlockall OFF          |
+======+========+===+===+===+====+===+=======+=======+========+
|Run(No thread) | 0 | 1 | 2 | 3  | 0 | 1     |     2 | 3      |
+---------------+---+---+---+----+---+-------+-------+--------+    
| Thread 1      |58 | 66| 52| 58 | 53|  65   |``742``| 79     |
+---------------+---+---+---+----+---+-------+-------+--------+
| Thread 2      |65 | 62| 77| 71 | 89|  75   | 53    |``772`` |
+---------------+---+---+---+----+---+-------+-------+--------+
| Thread 3      |76 | 71| 89|  63| 68|``672``| 59    |  53    |
+---------------+---+---+---+----+---+-------+-------+--------+
| Thread 4      |60 | 54| 69|  54| 79|  79   | 54    |  89    |
+---------------+---+---+---+----+---+-------+-------+--------+

This few runs hints that it is very probable to catch high latencies if memory is not locked.


Using cpu-affinity 
==================

CPU affinity means that a thread is given a certain cpu on which it may run. Other cpus will not receive that thread by the scheduler. 
A thread has by default no cpu-affinity. It can be set at any time, but best at the beginning, by using ``sched_setaffinity`` which might be used like

.. code-block:: cpp
    
    cpu_set_t cpu_mask;
    CPU_ZERO( &cpu_mask );
    CPU_SET( static_cast<int>( mCpu ) , &cpu_mask );

    if( sched_setaffinity( 0 , sizeof(cpu_set_t) , &cpu_mask ) == -1)
    {
        perror("sched_setscheduler failed");
        exit(-1);
    }

Setting affinity forces a thread on a cpu which avoid thread migration between cpus. The stack need'nt be moved to another cache. A disadvantage is that a heavy thread, compared to the others, can influence the performance badly, as the tasks cannot be scheduled to other cpus.

Several tests have been done to explore the effect of affinity. 
Base setup:

* Scheduler: RR
* Taskinterval: 500 us
* Threads:  8
* MLockAll: yes
* Duration: 30 s
* Iterations: 4

Tests:

1. No affinity
2. cpu0/cpu1:   4/4     Even affinity 
3. cpu0/cpu1:   1/7
4. cpu0/cpu1:   7/1

The table shows the worst iterations of each setup. It can be seen that using no affinity shows the shortest delays and the values have the smallest spread. Using affinity leaded to larger jitter.

+---------------+----------------+
|               |   Test         |
+===============+===+===+===+====+
|Thread         | 1 | 2 | 3 | 4  |
+---------------+---+---+---+----+
| Thread 1      |110|122| 52|122 |
+---------------+---+---+---+----+
| Thread 2      |92 |205| 97| 267|
+---------------+---+---+---+----+
| Thread 3      |82 |228|233| 289|
+---------------+---+---+---+----+
| Thread 4      |95 |101|184| 339|
+---------------+---+---+---+----+
| Thread 5      |98 |102|236|172 |
+---------------+---+---+---+----+
| Thread 6      |74 | 95|230| 74 |
+---------------+---+---+---+----+
| Thread 7      |82 | 83|223| 193|
+---------------+---+---+---+----+
| Thread 8      |101|220|190| 250|
+---------------+---+---+---+----+


