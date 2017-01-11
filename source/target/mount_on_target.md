#### Create the share in development host (Windows)

* Select the directory and go to properties (`Alt+Enter`).

* Under the __Sharing__ tab, click on __Advanced Sharing__.

* Check the box __Share this folder__. Provide a share name. Click on __Permissions__.

* Click __Add__ and enter the username of the user this directory will be accessed as. Click __OK__. In the _Permissions_ dialog, with this user now selected, check the checkbox __Change__ under the __Allow__ column. Click __OK__. *__Important__: This Windows user must have a non-empty password.*

  Although the directory is now shared, without the correct security settings, it will not be accessible.

* In the directory properties, under __Security__, click __Edit__. Click __Add__ and add the same user as before. In the _Permissions_ dialog, with this user now selected, check the box __Modify__ under the __Allow__ column. Click __OK__.

#### Mount the share in target system (Linux)

* Support for _cifs_ like file systems is usually not present by default. It can be added in Debian like systems by installing __cifs-utils__:

```bash
    apt-get install cifs-utils
```
* Create a mount point and ensure the Windows host is reachable.

* Mount the share with the following command:

```bash
    # interactive
    sudo mount -t cifs -o user=<windows_user> //<windows_host>/<share_name> <mount_point>
    # unattended
    sudo mount -t cifs -o user=<windows_user>,password=<password> //<windows_host>/<share_name> <mount_point>
```

  `windows_host` is either the hostname or the IP address.
