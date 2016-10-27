## Docker

#### Prerequisites

* Regardless of your Ubuntu version, Docker requires a 64-bit installation.
* Your kernel must be 3.10 at minimum.
* Check your current kernel version, open a terminal and use uname -r to display your kernel version:
  ```
   $ uname -r                   <!--This displays the Kernel version-->
  ```

#### Prerequisites for Ubuntu 16.04 and 14.04
* For Ubuntu Trusty, and Xenial, it’s recommended to install the linux-image-extra-* kernel packages.
   The linux-image-extra-* packages allows you use the aufs storage driver.
   
* Open a terminal on your Ubuntu host and Update your package manager.
  ```
   $ sudo apt-get update
  ```
* Install the recommended packages.
  ```
   $ sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
  ```
* Go ahead and install Docker.

### Update your apt sources on Ubuntu 16.04 or Ubuntu 14.04

* Log into your machine as a user with sudo or root privileges.

* Open a terminal window.

* Update package information, ensure that APT works with the https method, and that CA certificates are installed.
  ```
   $ sudo apt-get update
  ```
   $ sudo apt-get install apt-transport-https ca-certificates
  ```
* Add the new GPG key.
  ```
   $ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  ```
* Find the entry for your Ubuntu operating system.
  ```
   $ deb https://apt.dockerproject.org/repo ubuntu-xenial main <!--For Ubuntu 16.04-->
   $ deb https://apt.dockerproject.org/repo ubuntu-trusty main <!--For Ubuntu 14.04-->
  ```

* Run the following command, substituting the entry for your operating system for the placeholder <REPO>.
  ```
   $ echo "<REPO>" | sudo tee /etc/apt/sources.list.d/docker.list
  ```
* Update the APT package index.
  ```
   $ sudo apt-get update
  ```
* Verify that APT is pulling from the right repository.
  ```
   $ apt-cache policy docker-engine        <!--This displays Docker Engine installed and Version table-->

  ```
## Installation

* Log into your Ubuntu installation as a user with sudo privileges.
  ```
   $ sudo apt-get update
  ```
* Install Docker.
  ```
   $ sudo apt-get install docker-engine
  ```
* Start the docker daemon.
  ```
   $ sudo service docker start
  ```
* Verify if the docker is installed correctly.
  ```
    $ sudo docker run docker    <!--This command downloads a test image and runs it in a container. When the container runs,it prints  an informational message. Then, it exits.-->
  ```
## Creating Docker Group
 
* Log into Ubuntu as a user with sudo privileges.

* Create the docker group.
  ```
   $ sudo groupadd docker
  ```
* Add your user to docker group.
  ```
   $ sudo usermod -aG docker $USER
  ```
* Log out and log back in.
  <!--This ensures your user is running with the correct permissions.-->

* Verify your work by running docker without sudo.
  ```
   $ docker run docker
  ```
* If this fails with a message similar to this:
   Cannot connect to the Docker daemon. Is 'docker daemon' running on this host?

* Check that the DOCKER_HOST environment variable is not set for your shell. If it is, unset it.


## Shared Networkstorage
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

### Eclipse Installation

* Download latest eclipse version from the website for Linux

* Open the terminal in your system with the root permissions

* Install latest Java 1.8-JDK
 ```
  $ sudo apt-get update
  $ sudo apt-get install oracle-java8-installer
 ```
* Install Maven: 
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
  $ cd 
  $ tar -xzvf path <!--path=path to your tar file -->
 ```
* Run the Eclipse:
  ```
  $ ~/eclipse/eclipse
  ``` 
