### System Service Initialization Manager
## Enabling a Manager for yocto images as Yocto Developer
For enabling system services yocto offers the older SysVinit and the newer systemd initialitation manager.
As systemd is state-of-the-art it is reasonable to choose that manager. 
To enable it for your yocto images put the following lines into your local.conf

```
DISTRO_FEATURES_append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"
VIRTUAL-RUNTIME_initscripts = ""
```

The first two lines selects systemd and the following lines prevent the system to incorporate the unused SysVinit.
## Using systemd as Appication Developer
Each recipe that shall be automatically started on boot needs to use 
```
inherit systemd
```
Services are set up to start on boot automatically unless you have set SYSTEMD_AUTO_ENABLE to "disable".

Using this class the recipe or Makefile (i.e. whatever the recipe is calling during the do_install task) installs unit files into ${D}${systemd_unitdir}/system. If the unit files being installed go into packages other than the main package, you need to set SYSTEMD_PACKAGES in your recipe to identify the packages in which the files will be installed. 
You should set SYSTEMD_SERVICE to the name of the service file. You should also use a package name override to indicate the package to which the value applies. If the value applies to the recipe's main package, use ${PN}. Here is an example from the connman recipe: 
```
SYSTEMD_SERVICE_${PN} = "connman.service"
```
How-To-Write *.service files can be read in
[How-To-Do-*.service](https://wiki.ubuntuusers.de/systemd/Service_Units/)



