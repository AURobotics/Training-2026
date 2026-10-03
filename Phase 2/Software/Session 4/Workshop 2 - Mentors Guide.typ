#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": *

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "Workshop 2: Linux (Mentors' Guide)")

#show: report-template.with(ribbon-text: "Workshop 2 | Mentor Guide")

In this workshop we'll deal with Linux hands-on and tackle problems similar to those we tackle in our competitions.

= Setup

Please open up your laptop and log into the WiFi network:
- SSID: `AUR Lab`
- Password: `Linux123`

#caution[
  If using Windows, please make sure to set your network to #reverse-emphasis[PRIVATE] --- not public.
]

= Secrets

== Login Credentials
- `team1`: `AURteam1!`
- `team2`: `AURteam2@`
- `team3`: `AURteam3#`
- `team4`: `AURteam4$`
- `team5`: `AURteam5%`
- `team6`: `AURteam6^`

== Final Codes
- `team1`: `w1L3k5`
- `team2`: `a8K7q2`
- `team3`: `m7J6w9`
- `team4`: `g8J2v6`
- `team5`: `c3N7j4`
- `team6`: `n6P1z9`


= SSH Login

Using SSH, you will log into the Raspberry Pi.

The username will be given to you in a handout along with the password.

The hostname is #reverse-emphasis[aurobotics.local].

In case you get an error `Could not resolve hostname`, try any of the following as the hostname:
- `aurobotics`
- `192.168.1.64`

#tip(title: "Solution")[
  `ssh teamX@aurobotics.local` then enter the password
]

= The Studio

We are going to utilize the main camera connected to the Raspberry Pi at `/dev/video0` to take a picture of one member of your team. We'll save the picture to a file on the Raspberry Pi then copy it to your laptop.

== Capturing the Picture

We'll be using a command called `fswebcam`. You should follow this syntax:\
`fswebcam -d DEVICE_PATH SAVED_FILE_NAME`

Where `DEVICE_PATH` is the camera device and `SAVED_FILE_NAME` is the name of the image you want to create from the picture.

Help your teammate take a picture by running the command once they are in position.

#caution[
  If you get an error that says the camera device file was found but has failed to open, try again. It is likely that some other team is using the camera at the same time.
]

#tip(title: "Solution")[
  Optionally: `ls /dev/ | grep video`\
  `fswebcam -d /dev/video0 image.png`
]

== The Group Picture
To take a picture as a group, you should allow yourself some time to go and stand in front of the camera using `sleep` and command chaining.

#tip(title: "Solution")[
  `sleep 20 && fswebcam -d /dev/video0 image.png`
]

== Download the Images

To view the images, use `scp` to download the image files from the Raspberry Pi to your laptop. #emphasis[Open a new terminal window first]. You may use the following template for an `scp` file download:\
`scp user@remote_host:/path/to/file ~/Desktop/`

#tip(title: "Solution")[
  In a new terminal window without SSH:\
  `scp teamX@aurobotics.local:/home/teamX/image.png ~/Desktop/`
]

= The Detective

Go back to your SSH logged-in terminal window.

An ESP microcontroller is connected to the Raspberry Pi via USB (serial). It constantly outputs a hint for your next task.

Ideally we would use something like `pySerial` to read the output and respect the baudrate, but we'll work around that using `cat` and `head`.

== Find the ESP

The ESP falls into the category of serial devices. You can try to guess its device file name, but you can make use of the category folder for serial devices.

After identifying the ESP device file, notify your mentor.

#tip(title: "Solution")[
  `ls /dev/serial/by-id/`
]

== Get the Clue

We can use `cat` to read the contents of a text file. Luckily, the ESP is programmed to act like one by sending text over serial.

The only problem is you'll need to stop the influx of non-stop lines at some point. Use the `head` command to get only the first 3 lines, to avoid the first few corrupted lines.

If your mentor did not explain the arguments needed for `head`, please use `head --help` to find how to get only a few lines.

Note down the hint given by the ESP.

#tip(title: "Solution")[
  `cat /dev/serial/by-id/DEVICE_ID | head -n 3`
]

= The Hunt

== The Crime Scene

Open the camera device described by the ESP in the previous task and capture a frame using `fswebcam`.

You should download the captured frame and note down its contents. Remember to open a new terminal window for `scp`.

#tip(title: "Solution")[
  `fswebcam -d /dev/videoX clue.png`~~~~`X` is $("team number" * 10 + 2)$\
  then outside SSH: `scp teamX@aurobotics.local:/home/teamX/clue.png ~/Desktop/`\
  Note down the `CODE`
]

== Stringing Together the Clues

The next clue given in the frame should be used to search through a record at:\
`/opt/lab-results/results-sheet`

Get the line that contains the text given in the previous clue using `grep`.

If the line starts with your team name, you just solved the puzzle.

#tip(title: "Solution")[
  `cat /opt/lab-results/results-sheet | grep CODE`
]

= The Big Announcement

We're going to make a big countdown announcing that we just found the solution to the puzzle.

Make a bash script that uses looping and `sleep` to make a countdown of 10 to 1.

Take the previous command that used `grep` and use a bash variable to evaluate and store the result of that command.

Announce the result by:\
```bash
echo "The result of the hunt is:"
echo "$command_output"
```

#tip(title: "Solution")[
  ```bash
  #!/bin/bash
  command_output=$(cat /opt/lab-results/results-sheet | grep CODE)
  for i in {10..1}; do
    echo "$i.."
  done
  echo "The result of the hunt is:"
  echo "$command_output"
  ```
]