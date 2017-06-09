************
Common Tasks
************

.. _common_tasks_docker_install:

Docker Installation
===================

Ubuntu >=16.04
--------------

This Ubuntu version has an up-to-date version of docker that can be installed from the ubuntu packages:

.. code-block:: console

    $ sudo apt-get install docker.io

* Add your user to the docker-group:

.. code-block:: console

    $ sudo adduser USERNAME docker

* To apply the group-changes please logoff from your system and login again.

Ubuntu 14.04
------------

This ubuntu version does not have an up-to-date version of docker; you have to update your sources:

* Add the docker key-server:

.. code-block:: console

    $ sudo apt-get update
    $ sudo apt-get install apt-transport-https ca-certificates
    $ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

* Create a file `/etc/apt/sources.list.d` to add the docker package-repositories:

.. code-block:: console

    deb https://apt.dockerproject.org/repo ubuntu-trusty main

* Now install docker:

.. code-block:: console

    $ sudo apt-get update
    $ sudo apt-get purge lxc-docker
    $ sudo apt-get install apparmor
    $ sudo apt-get install docker-engine
    $ sudo service docker start

* Add your user to the docker-group:

.. code-block:: console

    $ sudo adduser USERNAME docker

* To apply the group-changes please logoff from your system and login again.

..
    ## Shared Network Storage

    A nfs-server emulator is needed for the os-developer. This emulator is realized as a docker container running on the server.

    ### Installation on Server

    * To start the emulator with <Path> as storage-to-share path: 

    ```
    docker run -v --privileged /<Path>:/nfs nfs-server 
    ```

    * The os-developer now can mount the storage using the <SERVER-IP> at <MOUNT-POINT> by:

    ```
    sudo mount -t nfs <SERVER-IP>:/nfs /<MOUNT-POINT> 
    ```

    ## Tools Installation

    ### Eclipse 

    * Download latest eclipse version for Linuxfrom the website.

    * Open the terminal in your system with the root permissions

    * Install latest Java 1.8-JDK
        
    ```
    $ sudo apt-get update
    ```
    ```
    $ sudo apt-get install oracle-java8-installer	
    ```

    * Install Neon: 

    ```
    $ sudo apt-get install neon
    ```

    * Configuring Java Environment.

    ```
    $ sudo apt-get install oracle-java8-set-default
    ```

    * Get rid of the root access as you won't need it anymore:
      # exit

    * Extract the Eclipse installation of tar into your home directory:

    ```
    $ tar -xzvf path	<!--path=path to your tar file -->
    ```

    * Run Eclipse:

    ```
    $ ~/eclipse/eclipse
    ``` 
