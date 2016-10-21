## Docker

### Installation on Ubuntu 16

* To install docker on your system run:
```
$ sudo apt-get install docker.io
```

* Afterwards add your user to the group `docker`:
```
$ adduser <YOUR-USERNAME> docker
```

* To apply the group-changes please logoff from your system and login again.

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
