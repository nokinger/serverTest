************
Test Gateway
************

The test gateway is a hardware setup that comprises a **Raspberry Pi 3 model B** and numerous physical connections to the application carrier board to be tested. For a detailed look into the hardware setup, see :ref:`itest_testrig_test_hardware`. The following sections describe the minimal software setup inside the Raspberry Pi required to run tests manually or as a part of an automated pipeline through *Jenkins*.

Setting up the Raspberry Pi
===========================

Creating an OS Image:
_____________________

- Download the `Raspbian image <https://www.raspberrypi.org/downloads/raspbian/>`_. If a graphical desktop environment is not required, a `Minibian image <https://sourceforge.net/projects/minibian/>`_ might be preferable.

- Copy the image to a microSD card:

    .. code-block:: console

        $ sudo dd if=/path/to/image of=/device/name bs=100M

- Boot into the Raspberry Pi with the microSD card and an ethernet connection (along with other necessary peripherals like display unit and input device(s)).

- If you chose *Minibian*, there are some minor differences to note from *Raspbian*:

    * *Minibian* installation does not automatically expand partitions. It can be done by installing and running ``raspi-config``:

        .. code-block:: console

            $ apt-get install raspi-config

    * *Minibian* by default only has user *root*

    * There is no utility pre-installed to change keyboard layout. To set the keyboard layout of your choice, install **console-data** and choose the correct layout during installation:

        .. code-block:: console

            $ apt-get install console-data

- Log in with the default credentials (username: **root** (*Minibian*) or **pi** (*Raspbian*), password: **raspberry**) and change the password for security reasons.

Installing Required Software:
_____________________________

Use :download:`this <./installPrograms.sh>` script to install needed programs or execute the following steps manually.


- Install **curl**, which is a requirement for Docker installation:

    .. code-block:: console

        $ apt-get install curl

- Install **Docker**:

    .. code-block:: console

        $ curl -sSL get.docker.com | sh

- Install **dnsmasq** for running a private network:

    .. code-block:: console

        $ apt-get install dnsmasq

- Install **UncomplicatedFirewall** for logging on to the test target by using port forwarding:

    .. code-block:: console

        $ apt-get install ufw

- Install **misc-programs** for test automation:

    .. code-block:: console

        $ apt-get install libftdi-dev


Configuring the DHCP Server:
____________________________

.. note:: The Raspberry Pi has two ethernet interfaces: **eth0** and **eth1**. **eth1** is connected to the outside network and its MAC address has been issued a fixed IP address and/or a fixed DNS name, e.g., **sca-app-carrier-board-test-gw**. This is an external ethernet adapter. **eth0** is used to provide a private network exclusively for the test target. This is the own ethernet interface of the Raspberry Pi.

- Assign a static IP address to Raspberry Pi's **eth0** interface. The ``/etc/network/interfaces`` file should look similar to this:

    .. code-block:: console

        auto lo
        iface lo inet loopback

        auto eth0
        iface eth0 inet static
        address 10.1.1.1
        netmask 255.255.255.0

        auto eth1
        iface eth1 inet dhcp

- Restart networking daemon and ensure eth0 indeed has the IP addredd:

    .. code-block:: console

        $ systemctl restart networking

- Set up DHCP server with minimal configuration. Edit the ``/etc/dnsmasq.conf`` file to have only the following settings:

    .. code-block:: console

        interface=eth0
        no-resolv
        log-dhcp
        dhcp-range=10.1.1.100,10.1.1.150,60s
        dhcp-host=00:50:c2:f8:0e:5d,10.1.1.60,60s
        dhcp-host=00:50:c2:f8:0e:5e,10.1.1.61,60s
        dhcp-host=00:50:c2:f8:0e:5f,10.1.1.62,60s

    As long as the hardware address of the network interfaces of the test target are unchanged, the interfaces will have known IP addresses.

- Restart dnsmasq daemon and verify that the interfaces indeed have been assigned known IP addresses:

    .. code-block:: console

        $ systemctl restart dnsmasq

Configuring Route to Test Target:
_________________________________

.. note:: The test target should ideally not be able to access a public network. But for testing purposes it should be reachable over SSH only through the test gateway, both locally and remotely.

- In ``/etc/default/ufw``, change the value of ``DEFAULT_INPUT_POLICY`` and ``DEFAULT_FORWARD_POLICY`` to ``"ACCEPT"``.

- In ``/etc/ufw/sysctl.conf``, set the value of ``net/ipv4/ip_forward`` to 1 (uncomment line if necessary).

- Add the following line at the bottom of ``/root/.bashrc`` and reload it:

    .. code-block:: console

        echo 1 | sudo tee /proc/sys/net/ipv4/conf/eth0/route_localnet &>/dev/null
        source /root/.bashrc

- Add the following lines at the bottom of ``etc/ufw/before.rules`` (immediately after a COMMIT statement):

    .. code-block:: console

        *nat
        :PREROUTING ACCEPT [0:0]
        :POSTROUTING ACCEPT [0:0]

        -A PREROUTING -p tcp --dport 9022 -j DNAT --to-destination 10.1.1.62:22
        -I POSTROUTING -p tcp -d 10.1.1.62 --dport 22 -o eth0 -j MASQUERADE
        -A OUTPUT -p tcp --dport 9022 -j DNAT --to-destination 10.1.1.62:22 -o lo

        COMMIT

- Restart **UncomplicatedFirewall**:

    .. code-block:: console

        $ ufw disable
        $ ufw enable

- Now it should be possible to log in to the test target:

    .. code-block:: console

        # From the Raspberry Pi
        $ ssh root@localhost -p 9022
        # From another node in the network
        $ ssh root@sca-app-carrier-board-test-gw -p 9022

- Now the system is ready for manual integration testing.

Best Practises for Running Tests Manually
=========================================

- Add your private keys to the *SSH Authentication Agent*:

    .. code-block:: console

        $ ssh-add ~/.ssh

- Login to the Raspberry Pi with forwarding to *SSH Authentication Agent*:

    .. code-block:: console

        $ ssh -A root@hostname

- Create a directory under ``/home`` named after your uniquely recognisable username:

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

        $ adduser jenkins

- Add the public key of an RSA key-pair known to Jenkins to ``/home/jenkins/.ssh/authorized_keys``

- Install JDK. Depending on your choice of distribution, this might not be necessary. If it is:

    .. code-block:: console

        $ apt-get install oracle-java8-jdk

- Add the Raspberry Pi as a Jenkins `Permanent Agent` using the `SSH Slaves plugin <https://wiki.jenkins-ci.org/display/JENKINS/SSH+Slaves+plugin>`_.

- Since only very specific jobs are to be run on this agent, set the **Usage** option to **Only build jobs with label expressions matching this node**.

- Assign a label to the agent, e.g., ``sca-test-host``.

Setting Up a Jenkins Pipeline for the Slave
============================================

- Ensure that the ``sca-test-host`` has all peripheral devices attached as necessary.

- Add the user ``jenkins`` to the group ``docker``:

    .. code-block:: console

        $ usermod -a -G docker jenkins

- Install ``sudo`` on the test host if it is not present already:

    .. code-block:: console

        $ apt-get install sudo

- Install any other utilities necessary for running the pipeline script as user ``jenkins`` on the ``sca-test-host``:

    .. code-block:: console

        $ apt-get install pv lsof

- After the package ``sudo`` has been installed, the file ``/etc/sudoers`` will be available. Add permissions for the jenkins user to run certain commands as necessary for the pipeline script:

    .. code-block:: console

        $ echo '$USER ALL= NOPASSWD: /bin/dd' >> /etc/sudoers"

- From the Jenkins dashboard home, choose `New Item > Pipeline` (assuming the *Pipeline* plugin is already installed).

- In the general options, check *Do not allow concurrent builds*.

- In the *Build Triggers* options, set a *Poll SCM* schedule, e.g., ``H/5****``.

- Add a build script. It must be ensured that ``docker exec`` commands are NOT run from this script with ``--interactive`` argument. A working example has been provided below:

    .. code-block:: groovy

        // This script requires the Jenkins node 'sca-test-host' to have the console utility 'pipe view'
        // It can be installed with the following command:
        //     apt-get install pv

        BUILD_CONFIG = "app-carrier-board-kernel4.1"
        BUILD_TARGET = "sca-enterprise-image"
        TARGET_HW = "ls1021atwr"
        REMOTE_YOCTO_CACHE = "nas.pb.avantys.de:/mnt/nas/data/Projekte/SCA/yocto"  // set to "none" if no cache available
        IMAGE_NAME = ""

        stage('Image Build') {
            node('docker'){
                checkout([$class: 'GitSCM', branches: [[name: 'develop']], doGenerateSubmoduleConfigurations: false, userRemoteConfigs: [[credentialsId: '8d553a3a-6a07-4c8d-89c4-ac74d7878434', url: 'ssh://git@phabricator.pb.avantys.de/diffusion/86/sca-os.git']]])
                sh "tools/run_in_container.sh build tools/build/bitbake.sh ./build/${BUILD_CONFIG} ${REMOTE_YOCTO_CACHE} ${BUILD_TARGET}"
                fileExists "${JOB_NAME}/build/${BUILD_CONFIG}/tmp/deploy/images/${TARGET_HW}/${BUILD_TARGET}-${TARGET_HW}.sca-sdimg"
                dir("build/${BUILD_CONFIG}/tmp/deploy/images/${TARGET_HW}") {
                    img_path = sh(returnStdout: true, script: "readlink -f sca-enterprise-image-${TARGET_HW}.sca-sdimg").trim()
                    IMAGE_NAME = sh(returnStdout: true, script: "basename ${img_path}").trim()
                    stash includes: "${IMAGE_NAME}", name: 'sca-sdimg'
                }
            }
        }

        stage('Image Deploy') {
            node('sca-test-host') {
                dir("build/${BUILD_CONFIG}/tmp/deploy/images/${TARGET_HW}") {
                    unstash 'sca-sdimg'
                    sh 'pv `ls -t *.rootfs.sca-sdimg | head -1` | sudo dd of=/dev/sda bs=100M'
                }
            }
        }

        stage('Manual Approval') {
            timeout(time:5, unit:'HOURS') {
                input message: 'Please boot the test target with the newly written microSD card', ok: 'Ready'
            }
        }

        stage('Integration Test') {
            node('sca-test-host'){
                checkout([$class: 'GitSCM', branches: [[name: 'develop']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'itests'], [$class: 'BuildChooserSetting', buildChooser: [$class: 'DefaultBuildChooser']]], userRemoteConfigs: [[credentialsId: 'ada433f1-3c4a-4ec9-a8b2-68ad746e01fa', url: 'ssh://git@phabricator.pb.avantys.de/diffusion/92/sca-integration-tests.git']]])
                dir("itests") {
                    sh "testrunner/run_in_container.sh"
                }
            }
        }

        stage('Deliver') {
            node('docker') {
                archiveArtifacts artifacts: "build/${BUILD_CONFIG}/tmp/deploy/images/${TARGET_HW}/${IMAGE_NAME}", onlyIfSuccessful: true
            }
        }

- For a new push to branch ``develop``, a new build job will start within 5 minutes.

- For different build configurations and target hardware, it suffices to adjust the global variable values at the top of the script.
