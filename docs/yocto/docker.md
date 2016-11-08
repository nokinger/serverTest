This section offers an in-depth look into the process of building and using Docker images.

### Building an Image

To run operations, such as building Yocto distributions and compiling software applications, in an isolated environment that is also known as a __container__, an image is the primary prerequisite. An image is the result of a series of instructions, such as package installations and administrative tasks, performed on a stripped down operating system distribution. The operating system name and version and the subsequent operations, can be listed in a __recipe__. Every user sharing a recipe will have the same image as the starting point.

To build an image from a recipe, the command is:

```bash
    docker build -t <tag name> <recipe directory>
```

Most of the time, when minor changes have been made to the recipe, re-issuing the command will make necessary changes to the existing image using cached packages and configuration files. To force image creation without cached files, issue the following command:

```bash
    docker build -t <tag name> --no-cache <recipe directory>
```

As an example, from the SCA OS project root, issue the following command to build an image with the configuration named __build__:

```bash
    docker build -t build tools/container/build
```

This will create a docker image and give it the name (also known as tag) __build__. For a list of locally available images, use the command:

```bash
    docker images
```

### Starting a Container

To execute commands inside a container based on the __build__ image, a bash console can be started with the following:

```bash
    docker run -it build /bin/bash
```

This method might be constrained if the user requires additional consoles to the same container. A Docker container lives only as long as there is a task to execute. Exiting from this console will also kill the container. Therefore, a more convenient approach is to run the container as a daemon with an infinitely blocking task and opening and closing bash consoles to it as necessary. Use the following command to start a container in daemon mode:

```bash
    docker run -d build /bin/cat
```

This command will return a container id. This container id can now be used to execute commands in that container, optionally in interactive mode. To open a bash console in interactive mode:

```bash
    docker exec -it <container id> /bin/bash
```

When all the commands have been executed, the container will have to be explicitly killed.

```bash
    docker kill <container id>
    # To remove the dead container
    docker rm <container id>
```

### Automating the Operation

To simplify the aforementioned series of operations, a also mount necessary directories and add network capabilities, a convenience script `run_in_container.sh` has been provided in the `tools` directory. To build an image (if necessary) with recipe __build__ and execute a command inside a container based on it and kill and remove the container when command has finished executing:

```bash
    tools/run_in_container.sh build <command>
```

To open a bash console in the container with this script, use the following command:

```bash
    tools/run_in_container.sh build /bin/bash
```

This process will not show a container id. To find the container id, a list of running containers can be filtered by image name with the following command:

```bash
    docker ps --filter="ancestor=build"
```

If there is only one running container based on the image __build__ or the starting time of the container is approximately known, the container id can be easily determined. And then additional commands can be executed in the same container as follows:

```bash
    docker exec -it <container id> <command>
```

### Running the _bitbake_ Script

One of the intended uses of the container is to build a Yocto distribution, which can be easily done by executing the script __bitbake.sh__. The script could be run from a bash console in the container with the following command:

```bash
    tools/build/bitbake.sh <config directory> <cache location> <arguments>
```

The __config directory__ is where the configuration files are stored and the built images will later be found. The __cache location__ is a network share location for __Yocto__ cache. If no cache is available, the value __none__ is given. The arguments are standard _bitbake_ arguments. The argument __core-image-minimal__ builds a minimal distribution.

If a cache location is provided, the script tries to mount it as __NFS__ to the directory __/yocto-cache__. If mount fails, execution continues without the cache, locally building every package required by the distribution.

The call to __bitbake.sh__ can be passed as the _command_ argument to __build_in_container.sh__ to automatise the entire process:

```bash
    tools/run_in_container.sh build tools/build/bitbake.sh <config directory> <cache location> core-image-minimal

```