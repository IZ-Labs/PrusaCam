# PrusaCam

Reworked version of the PrintCam project from @Jerzeek (https://github.com/Jerzeek/PrintCam-Firmware) with the updated board packages avaliable in latest version of ESP32CAM-RTSP. Other MISC improvements on the instructions are completed and there are planned changes to lighting control

I had a couple old FREENOVE ESP32-WROVER-DEV camera modules around and wanted to use them for my printer. 

## Setting up the PrusaCam
Connect to the wifi access point the ESP32 will generate: ESP32CAM-RTSP-xxxxxxxx

- Click the settings icon
- Add a password for the ESP32 wifi.
- Add the SSID and password for your local network you wish to connect the camera to.
- Generate your PrusaConnect token via PrusaConnect (add other camera option)
- Generate a 16 character minimum, 64 char max fingerprint unique ID for the ESP32.
- Enter both these values along with the url: https://connect.prusa3d.com/c/snapshot when prompted at the bottom of the settings menu.
- Click save and reboot the ESP32 (manually is usually better for rebooting)

ENSURE YOUR PRUSA PRINTER IS POWERED ON. Due to recent changes aimed at improving effciencey, Prusa has disabled camera streaming when the printer is not powered on. 

## Supported Board Packages
This software supports the following ESP32-CAM (and alike) modules:

- AI THINKER
- EspressIf ESP-EYE
- EspressIf ESP32S2-CAM
- EspressIf ESP32S3-CAM-LCD
- EspressIf ESP32S3-EYE
- Freenove WROVER KIT
- M5STACK ESP32CAM
- M5STACK_PSRAM
- M5STACK_UNITCAM
- M5STACK_UNITCAMS3
- M5STACK_V2_PSRAM
- M5STACK_PSRAM
- M5STACK_WIDE
- M5STACK
- Seeed Studio XIAO ESP32S3 SENSE
- TTGO T-CAMERA
- TTGO T-JOURNAL


## Compiling and deploying the software

Open a command line or terminal window and clone this repository from GitHub.

```sh
git clone https://github.com/IZ-Labs/PrusaCam.git
```

go into the folder

```sh
cd PrusaCam
```

Next, the firmware has to be build and deployed to the ESP32.
There are to flavours to do this; using the command line or the graphical interface of Visual Studio Code.

### Using the command line

Make sure you have the latest version of the Espressif toolchain.

```sh
pio pkg update -g -p espressif32
```

First the source code has to be compiled to build all targets. I reccomend only builidng for a specific target, for example the ```esp32cam_freenove_wrover_kit``` type I created this fork for:

```sh
pio run -e esp32cam_freenove_wrover_kit
```

When finished, firmware has to be uploaded.
Make sure the ESP32-CAM is in download mode (see previous section) and type:

```sh
pio run -t upload -e esp32cam_freenove_wrover_kit
```

When done remove the jumper when using a FTDI adapter or press the reset button on the ESP32-CAM.
To monitor the output, start a terminal using:

```sh
 pio device monitor
```

## Issues / Nice to know

- The red LED on the back of the device indicates the device is not connected.
- Sometimes after configuration a reboot is required.
  If the error screen is shown that it is unable to make a connection, first try to reboot the device,
- When booting, the device waits 30 seconds for a connection (configurable).
  You can make a connection to the SSID and log in using the credentials below,
- When connected, go to the ip of the device and, when prompted for the credentials, enter 'admin' and the AP password.
  This is a **required** field before saving the credentials,
- When the password is lost, a fix is to completely erase the ESP32 using the ```pio run -t erase``` command.
  This will reset the device including configuration.
  If using the esptool, you can do this using ```esptool.py --chip esp32 --port /dev/ttyUSB0 erase_flash```.
  However, after erasing, re-flashing of the firmware is required.
- When finished configuring for the first time and the access point is entered, disconnect from the wireless network provided by the device.
  This should reset the device and connect to the access point.
  Resetting is also a good alternative...
- There are modules that have no or faulty PSRAM (despite advertised as such).
  This can be the case if the camera fails to initialize.
  It might help to disable the use of the PSRAM and reduce the buffers and the screen size.

### Power

Make sure the power is 5 volts and stable, although the ESP32 is a 3.3V module, this voltage is created on the board.
If not stable, it has been reported that restarts occur when starting up (probably when power is required for WiFi).
The software disables the brown out protection so there is some margin in the voltage.
Some people suggest to add a capacitor over the 5V input to stabilize the voltage.

### PSRAM / Buffers / JPEG quality

Some esp32cam modules have additional ram on the board. This allows to use this ram as frame buffer.
The availability of PSRAM can be seen in the HTML status overview.

Not all the boards are equipped with PSRAM:

|  Board            | PSRAM           |
|---                |---              |
| WROVER_KIT        | 8Mb             |
| ESP_EYE           | 8Mb             |
| ESP32S3_EYE       | 8Mb             |
| M5STACK_PSRAM     | 8Mb             |
| M5STACK_V2_PSRAM  | Version B only  |
| M5STACK_WIDE      | 8Mb             |
| M5STACK_ESP32CAM  | No              |
| M5STACK_UNITCAM   | No              |
| M5STACK_UNITCAMS3 | 8Mb             |
| AI_THINKER        | 8Mb             |
| TTGO_T_JOURNAL    | No              |
| ESP32_CAM_BOARD   | ?               |
| ESP32S2_CAM_BOARD | ?               |
| ESP32S3_CAM_LCD   | ?               |

Depending on the image resolution, framerate and quality, the PSRAM must be enabled and/or the number of frame buffers increased to keep up with the data generated by the sensor.
There are (a lot of?) boards around with faulty PSRAM. If the camera fails to initialize, this might be a reason. See on [Reddit](https://www.reddit.com/r/esp32/comments/z2hyns/i_have_a_faulty_psram_on_my_esp32cam_what_should/).
In this case disable the use of PSRAM in the configuration and do not use camera modes that require PSRAM,

For the setting JPEG quality, a lower number means higher quality.
Be aware that a very high quality (low number) can cause the ESP32 cam to crash or return no image.

The default settings are:

- No PSRAM
  - SVGA (800x600)
  - 1 frame buffer
  - JPEG quality 12

- With PSRAM
  - UXGA (1600x1200)
  - 2 frame buffers
  - JPEG quality 10

### Camera module

Be careful when connecting the camera module.
Make sure it is connected the right way around (Camera pointing away from the board) and the ribbon cable inserted to the end before locking it.

## Credits
improved upon PrintCam by @Jerzeek (https://github.com/Jerzeek/PrintCam-Firmware)
esp32cam-rtsp depends on PlatformIO, Bootstrap 5 and Micro-RTSP by Kevin Hester.
