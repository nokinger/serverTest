************
Test Gateway
************

The test gateway is a hardware setup that comprises a **Raspberry Pi 3 model B** and numerous physical connections to the application carrier board to be tested. For a detailed look into the hardware setup, see :ref:`itest_testrig_test_hardware`. The following sections describe the minimal software setup inside the Raspberry Pi required to run tests manually or as a part of an automated pipeline through *Jenkins*.

Setting up the Raspberry Pi
===========================

- Download the `Raspbian image <https://www.raspberrypi.org/downloads/raspbian/>`_. If a desktop environment is not required, a `Minibian image <https://sourceforge.net/projects/minibian/>`_ might be more preferable.

- Copy the image to a microSD card:

    .. code-block:: console

        $ sudo dd if=/path/to/image of=/device/name

- For cards with large capacity, there will be unpartitioned space left on the card. Use a partitioning utility like **parted** to expand the root partition as necessary. This expansion is recommended for working with Docker images.

- Boot into the Raspberry Pi with the microSD card and an ethernet connection (along with other necessary peripherals like display unit and input device).

- Log in with the default credentials (username: **root**, password: **raspberry**) and change the password for security reasons.

- *Optional:* It is likely that the OS will not have the keyboard layout you prefer. Install **console-data** and choose the correct layout during installation to remedy that:

    .. code-block:: console

        $ apt-get install console-data


- Install **curl**, which is a requirement for Docker installation:

    .. code-block:: console

        $ apt-get install curl

- Install **Docker**.

    .. code-block:: console

        $ curl -sSL get.docker.com | sh


- Now the system is ready for manual integration testing.

Best Practises for Running Tests Manually
=========================================

- Add your private keys to the *SSH Authentication Agent*:

    .. code-block:: console

        $ ssh-add ~/.ssh

- Login to the Raspberry Pi with forwarding to *SSH Authentication Agent*:

    .. code-block:: console

        $ ssh -A root@hostname

- Create a directory under ``/root`` named after your uniquely recognisable username:

    .. code-block:: console

        $ mkdir -p ~/<username>

- Clone the necessary Git repository there:

    .. code-block:: console

        $ git clone <url> ~/<username>/<dirname>

- For a step-by-step guide on how to run the tests, see :ref:`integration_tests_how_to_run`

Adding the Raspberry Pi as a Jenkins Slave
==========================================

- Add a user named **jenkins** with its own home directory:

    .. code-block:: console

        $ useradd jenkins

- Add the public key of an RSA key-pair known to Jenkins to ``/home/jenkins/.ssh/authorized_keys``

- Install JDK. Depending on your choice of distribution, this might not be necessary. If it is:

    .. code-block:: console

        $ apt-get install oracle-java8-jdk

- Add the Raspberry Pi as a Jenkins `Permanent Agent` using the `SSH Slaves plugin <https://wiki.jenkins-ci.org/display/JENKINS/SSH+Slaves+plugin>`_.

- Now the system can be used to run integration tests as a Jenkins job.
