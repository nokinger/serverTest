************
Test Gateway
************

The test gateway is a hardware setup that comprises a **Raspberry Pi 3 model B** and numerous physical connections to the application carrier board to be tested. For a detailed look into the hardware setup, see :ref:`itest_testrig_test_hardware`. The following sections describe the minimal software setup inside the Raspberry Pi required to run tests manually or as a part of an automated pipeline through *Jenkins*.

Setting up the Raspberry Pi
===========================

- Download the `Raspbian image <https://www.raspberrypi.org/downloads/raspbian/>`_. If a desktop environment is not required, a `Minibian image <https://sourceforge.net/projects/minibian/>`_ might be more preferable.

- Copy the image to a microSD card:

    .. code-block:: console

        $ sudo dd if=/path/to/image of=/device/name bs=100M

- For cards with large capacity, there will be unpartitioned space left on the card. Use a partitioning utility like **parted** to expand the root partition as necessary. This expansion is recommended for working with Docker images.

- Boot into the Raspberry Pi with the microSD card and an ethernet connection (along with other necessary peripherals like display unit and input device).

- Log in with the default credentials (username: **root** or **pi**, password: **raspberry**) and change the password for security reasons.

- *Optional:* It is likely that the OS will not have the keyboard layout you prefer. If there is no graphical interface to choose keyboard layout, install **console-data** and choose the correct layout during installation:

    .. code-block:: console

        $ apt-get install console-data

- Install **curl**, which is a requirement for Docker installation:

    .. code-block:: console

        $ apt-get install curl

- Install **Docker**:

    .. code-block:: console

        $ curl -sSL get.docker.com | sh


- Install **UncomplicatedFirewall** for logging on to the test target by using port forwarding:

    .. code-block:: console

        $ apt-get install ufw


- In ``/etc/default/ufw``, change the value of ``DEFAULT_INPUT_POLICY`` and ``DEFAULT_FORWARD_POLICY`` to ``"ACCEPT"``.

- In ``/etc/ufw/sysctl.conf``, set the value of ``net/ipv4/ip_forward`` to 1 (uncomment line if necessary).

- Add the following line at the bottom of ``/root/.bashrc`` and re-login to the Raspberry Pi:

    .. code-block:: console

        echo 1 | sudo tee /proc/sys/net/ipv4/conf/eth0/route_localnet &>/dev/null


- Add the following lines at the bottom of ``etc/ufw/before.rules`` (ensure COMMIT was called immediately before these lines):

    .. code-block:: console

        *nat
        :PREROUTING ACCEPT [0:0]
        :POSTROUTING ACCEPT [0:0]

        -A PREROUTING -p tcp --dport 9022 -j DNAT --to-destination <target_ip>:22
        -I POSTROUTING -p tcp -d <target_ip> --dport 22 -j MASQUERADE
        -A OUTPUT -p tcp --dport 9022 -j DNAT -o lo --to-destination <target_ip>:22

        COMMIT

- Restart **UncomplicatedFirewall**:

    .. code-block:: console

        $ ufw disable
        $ ufw enable

- Now it should be possible to log in to the test target without knowing the test target's IP address:

    .. code-block:: console

        # From the Raspberry Pi
        $ ssh root@localhost -p 9022
        # From another node in the network
        $ ssh root@<raspberry_pi_ip> -p 9022

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
                checkout([$class: 'GitSCM', branches: [[name: 'jenkinstest']], doGenerateSubmoduleConfigurations: false, userRemoteConfigs: [[credentialsId: '8d553a3a-6a07-4c8d-89c4-ac74d7878434', url: 'ssh://git@phabricator.pb.avantys.de/diffusion/86/sca-os.git']]])
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
                checkout([$class: 'GitSCM', branches: [[name: 'jenkinstest']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'itests'], [$class: 'BuildChooserSetting', buildChooser: [$class: 'DefaultBuildChooser']]], userRemoteConfigs: [[credentialsId: 'ada433f1-3c4a-4ec9-a8b2-68ad746e01fa', url: 'ssh://git@phabricator.pb.avantys.de/diffusion/92/sca-integration-tests.git']]])
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
