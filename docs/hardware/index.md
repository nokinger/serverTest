# Connecting the ECUcore-1021 board to your development system 

![] (ECUCore.png)

* Connect the Serial port cable to the USB slot of your PC and  UART1 port of ECUcore-1021 board.

* Connect the Power adapter to power supply and Power socket port of ECUcore-1021 board.

## Manual for ECUcore-1021 overview can be found in the following link.

 [Overview Manual](ECUcore_overview_manual.pdf)


## Installing Picocom

* Open a new terminal on your PC
* Login as administrator using and entering the password.

```
$ sudo apt-get install picocom
```
* Run Picocom
```
$ sudo picocom -b 115200 /dev/ttyUSB0  <!-- (-b) is baud rate which serial port setting as parameters -->
```

