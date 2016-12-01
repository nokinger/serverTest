This guide minimally mentions the steps involved to get the system up and running.

### Install the Host Operating System

* An operating system like Ubuntu is recommended. Installation image for 14.04 LTS can be downloaded [here](http://releases.ubuntu.com/trusty/ubuntu-14.04.5-desktop-amd64.iso) and 16.04 LTS can be downloaded [here](http://releases.ubuntu.com/16.04.1/ubuntu-16.04.1-desktop-amd64.iso).

* To create an USB installer, use the ```dd``` command:

```bash
    # Assuming the USB device has designation /dev/sdb
    # It is important to use the device name and not a partition name, e.g., /dev/sdb1
    sudo dd if=ubuntu-<version>-desktop-amd64.iso of=/dev/sdb
```

* Boot from the resulting USB stick and follow the instructions.

### Install Docker on Host

* Add the new GPG key:

```bash
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
```

* Add repository:

```bash
    # For 16.04 LTS
    echo deb https://apt.dockerproject.org/repo ubuntu-xenial main | sudo tee /etc/apt/sources.list.d/docker.list

    # For 14.04 LTS
    echo deb https://apt.dockerproject.org/repo ubuntu-trusty main | sudo tee /etc/apt/sources.list.d/docker.list
```

* Install the Docker engine:

```bash
    sudo apt-get update && sudo apt-get install docker-engine
```


* Add your user to a group named __docker__:

```bash
    sudo groupadd docker && sudo usermod -aG docker $USER
```

* Start Docker service:

```bash
    sudo service docker start
```

* For more detailed explanation, see [Docker Setup](../refmat/index.md).

### Build SD-Card Image

* Check out the SCA OS project to the local system.

* To build the image from scratch locally, issue the following command in the project root:

```bash
    tools/run_in_container.sh build tools/build/bitbake.sh build/AVANTYS/ none core-image-minimal
```

* Alternatively, if you have access to a remote yocto cache, that could be used:

```bash
    tools/run_in_container.sh build tools/build/bitbake.sh build/AVANTYS/ url:/path/to/yocto/cache core-image-minimal
```

### Deploy SD-Card Image

* The images can be found in`build/AVANTYS/tmp/deploy/images/ls1021atwr`.



<!-- # Development Host
## Section 1
### Installing Ubuntu 16.04

* Boot into Ubuntu DVD or bootable USB drive which contains Ubuntu iso files.
* You should be able to see a welcome screen,then select the preferred language and select "Install Ubuntu" option.
* Make sure you have enough space on your computer to install Ubuntu.
* Select Download updates while installing and Install this third-party software now.
* Stay connected to the internet so you can get the latest updates while you install Ubuntu.
* Allocate drive space as preferred.
* Begin installation.
* Select your location and preferred keyboard layout.
* Enter your login and password details.

## Section 2
### Setting up docker

* [Docker Setup](../refmat/index.md) -->
