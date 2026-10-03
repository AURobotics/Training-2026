#import "/Theme/presentation.typ": *
#show: presentation-theme
#import "@preview/codly-languages:0.1.10": codly-languages
#import "@preview/pinit:0.2.2": *
#import "@preview/merman:0.2.0": show-mermaid-blocks

#import "@preview/dtree:0.1.1": dtree
#import "@preview/calloutly:1.2.0": tip, warning

#show: codly-init.with()
#codly(
  languages: (
    python: (
      name: "",
      icon: codly-languages.python.icon,
      color: white,
    ),
    c: (
      name: "",
      icon: codly-languages.c.icon,
      color: white,
    ),
    sh: (
      name: "",
      icon: box(inset: 0% + 0pt, outset: 0% + 0pt)[
          #image("assets/terminal.svg", height: 130% + 0pt, fit: "contain")
      ],
      color: white,
    ),
    Terminal: (
      name: "",
      icon: none,
      color: white,
    )
  ),
  zebra-fill: none,
  fill: white,
  number-format: none
)

#show raw: it => {
  show regex("pin\d"): it => pin(eval(it.text.slice(3)))
  it
}

#show raw.where(lang: "mermaid"): show-mermaid-blocks()


#title-slide(
  title: [Linux for Robotics],
  subtitle: "Session 4",
  topic: "Software Training | Phase 2",
)

= Foundations in Operating Systems and Shells <common-part>

== Operating Systems

=== Modern Operating System Landscape
#figure(caption: "Operating System Category Diagram")[#block(height: 80%)[
```mermaid
graph TD
    subgraph OS [Operating Systems]
        subgraph Server
        linuxS[Linux]
        freebsd[FreeBSD]
        windowsS[Windows]
    end
        subgraph Mobile
            android[Android]
            ios[iOS]
        end
        subgraph Desktop
            windowsD[Windows]
            linuxD[Linux]
            osx[OSX]
            chromeos[ChromeOS]
        end
    end
    classDef outerBox fill:#f4f6f8,stroke:#cbd5e1,stroke-width:2px,color:#1e293b;
    classDef mobileGroup fill:#e0f2fe,stroke:#7dd3fc,stroke-width:1.5px,color:#0369a1;
    classDef desktopGroup fill:#fae8ff,stroke:#e879f9,stroke-width:1.5px,color:#86198f;
    classDef serverGroup fill:#dcfce7,stroke:#86efac,stroke-width:1.5px,color:#166534;
    
    classDef nodeStyle fill:#ffffff,stroke:#94a3b8,stroke-width:1px,color:#334155;

    class OS outerBox;
    class Mobile mobileGroup;
    class Desktop desktopGroup;
    class Server serverGroup;
    class android,ios,chromeos,windowsD,linuxD,osx,linuxS,freebsd,windowsS nodeStyle;
```
]
]


=== Historical Overview of Operating Systems
#figure(caption: "Operating System Evolution Diagram")[#block(height: 80%)[
```mermaid
graph TD
    subgraph Era1 ["1969 – 1970s: The Unix Foundation"]
        Unix["Unix Created (1969)<br/>AT&T Bell Labs"]
    end

    subgraph Era2 ["1980s: Personal Computing & Precursors"]
        MSDOS["MS-DOS & Early Windows (1981–1985)<br/>Microsoft PC dominance begins"]
        Minix["Minix & GNU Project (1983–1987)<br/>Open-source and academic unix-likes"]
        Next["NeXTSTEP (1988)<br/>Object-oriented Unix workstation OS"]
    end

    subgraph Era3 ["1990s: Birth of Modern Systems"]
        Linux["Linux Kernel (1991)<br/>Linus Torvalds combines Unix ideas with PC hardware"]
        WinNT["Windows 95 & NT (1993–1995)<br/>Unified consumer GUI and stable enterprise core"]
        MacOSX["Mac OS X / Darwin (1999–2001)<br/>Apple pivots to a Unix foundation via NeXT"]
    end

    subgraph Era4 ["2000s – Present: Modern Ecosystems"]
        LinuxMod["Linux<br/>Powers servers, cloud, embedded systems, and Android"]
        WinMod["Windows<br/>Dominates desktop computing and enterprise IT"]
        MacMod["macOS & iOS<br/>Powers Apple's desktop and mobile ecosystems"]
    end

    Unix --> Minix
    Unix --> Next
    Minix --> Linux
    MSDOS --> WinNT
    Next --> MacOSX
    
    Linux --> LinuxMod
    WinNT --> WinMod
    MacOSX --> MacMod
```
]
]

=== Why Linux

Linux is:
- Free and open-source
- Secure
- Lightweight and easy to install on single-board computers (SBCs) like the Raspberry Pi
- Made by developers for developers, with many developer tools installed by default

=== Jobs of an Operating System

- File System management
- Hardware access
- Package & app management
- User settings & user separation
- Service management
  - Wireless connections services
  - Credential storage services
  - Notification services
  - Anti-malware services
- Bridge user interfaces and hardware
  - I/O device handling

=== File System Management

All operating systems have a file system. File system is a system that:
- Makes sure files are stored reliably
- Organizes files according to their #emphasis[purpose] and #emphasis[access level]
- Isolates different users into their own spaces
  - *Allow different users to use the device at the same time*
- Allows access to files using #emphasis[file paths]
- Distinguishes between files and _directories_ (folders)
- Allows for shortcuts and links

Most file systems work like a "tree" which has a root, with a unique path given to the root.

Paths in file systems are addresses to files and directories. To access anything under a directory, you typically end its path with `/` on all systems or `\` on Windows.

=== File System Paths

On Windows, the "root" typically refers to the `C:\` directory. There are directories under it like `C:\Users\` and `C:\Program Files\` --- each with a given purpose.

On other systems, the root refers to the `/` directory. Other directories may live under it like `/bin/` for binaries (similar to `C:\Program Files\`) or `/home/` (similar to `C:\Users\`).

On all systems, a file or folder is considered _hidden_ if its name starts with a dot `.`.

Tip: when managing a project for users of different systems, make sure not to have two files with the same name aside from capitalization, i.e: `test` and `Test`. Windows can not differentiate between files on the basis of capitalization in their names and considers them identical.

=== Services

When Windows boots up, it runs tens of services. Some services check for updates, other keep your Bluetooth connection alive.

The exact same thing happens on other operating systems. A good portion of what makes systems take some time to boot up is the fact that they're starting up important services --- like the ones that manage your files or display things on the screen.


=== Computer-Human Interfacing

Computers are calculation machines that started out by taking a punch card rack of instructions as input and produced computational output.

When the Unix operating system was introduced, one of the main selling points of it was multiple user logins at the same time. Operating systems streamlined the input/output flow by utilizing *terminals* at which data is input and output to each user.

Nowadays we use mice, keyboards, touchpads, touchscreens and mics to _talk_ to the computer, the computer _talks_ back using display and audio output.

== Computer-Human Interfacing

=== User Interfaces

User interfaces can be classified into:
- #reverse-emphasis[GUI] --- Graphical User Interface
- #reverse-emphasis[CLI] --- Command-Line Interface
- #reverse-emphasis[TUI] --- Terminal User Interface

=== Graphical User Interfaces

- Clickable components, buttons, input fields and #emphasis[windows]


#figure(caption: "GUI Text Editor: Notepad")[
  #image("assets/editor-gui.png", height: 70%)
]


=== Terminal User Interface
- Needs a terminal window, has clickable or focusable components
#figure(caption: "TUI Text Editor: MS Edit")[
  #image("assets/editor-tui.png", height: 70%)
]

=== Origin of TUI
- Started with the early VT (Video Terminal) series, the most famous of which is the VT100
- Fully digital screen
- Cursor can move
- Can erase/ backspace/ clear screen
- No advanced graphics, relied on characters and fonts to make TUIs
- Limited colors
- Predefined character set + font

=== Origin of TUI (Visual)
#figure(caption: "Early VT100 Terminal, Picture By Jason Scott")[
  #image("assets/DEC_VT100_terminal.jpg", height: 80%)
]

=== Command-Line Interface

#figure(caption: [CLI Text Editing: `cat` and `echo`])[
  #image("assets/editor-cli.png")
]

=== Origin of CLI
- Originated with the teletypewriter + Unix
 - Single-line commands
 - Line-by-line output
 - No backspace or moving cursor

=== Origin of CLI (Visuals)

#figure(caption: [Unix output on a teletypewriter])[
  #image("assets/cli-tty-demo.png", width: 65%)
]

#set-ribbon(content: [Watch video: https://www.youtube.com/watch?v=WqgFK9h75eg])

=== Running Programs

We just saw 2 ways of running programs: from the terminal, and from the start menu.

When we ran our programs from the terminal, we ran them by entering their name in our _shell_, in this case: PowerShell.

So what is a shell? Is it just for running programs?

== Intro to Shells

=== What is a Shell?

A #reverse-emphasis[shell] is a program that allows the user to #emphasis[interact] with the operating system, manage the #emphasis[file system], #emphasis[run programs], and manage running programs.

Unix systems have a command-line shell: `bash` or `sh`.

Windows systems have a command-line shell: PowerShell or Command Prompt.

Both systems have GUI shells as well. We'll briefly talk about them, but our focus is on the command-line shells.

=== GUI Shells on Windows: `explorer.exe`

#align(center + horizon)[
  #block(
    height: 1fr,
    width: 90%,
    grid(
      columns: 2,
      rows: (1fr, 0.2fr),
      gutter: 0.5cm,
      grid.cell(rowspan: 2)[
        #figure(caption: "Program runner")[#image("assets/start-menu.png")]
      ],
      [#figure(caption: "File manager")[#image("assets/explorer.png")]],
      [#figure(caption: "Running programs manager")[#image("assets/taskbar.png")]]
    )
  )
]

=== GUI Shells on Linux: Ubuntu's GNOME

#align(center + horizon)[
  #block(
    height: 1fr,
    width: 90%,
    grid(
      columns: (1fr, 1fr, 0.1fr),
      gutter: 0.5cm,
      grid.cell(rowspan: 2)[
        #figure(caption: "Program runner")[#image("assets/gnome-launcher.png")]
      ],
      [#figure(caption: "File manager")[#image("assets/nautilus.png")]],
      [#figure(caption: "Programs Dock")[#image("assets/dash-to-dock.png")]]
    )
  )
]

=== CLI Shells on Windows & Linux

#align(center + horizon)[
  #block(
    height: 1fr,
    width: 90%,
    grid(
      columns: (1fr, 1fr),
      gutter: 0.5cm,
      grid.cell(rowspan: 2)[
        #figure(caption: "PowerShell on Windows")[#image("assets/powershell.png")]
      ],
      [#figure(caption: "Bash on Linux")[#image("assets/bash-cli-shells.png")]],
    )
  )
]

=== CLI Shell

When we refer to shells, we typically are referring to the CLI type.

CLI shells run programs, manage running programs, perform file operations, and interact with the operating system.

CLI shells also are scripting languages used by the operating systems to perform certain operations on startup.

In this context, shells can handle:
- Program launching
- Process management
- File navigation
- File redirection
- Scripting and basic programming

= Linux & Bash


== The Setup

=== Follow Along

The remainder of the session will rely heavily on demonstrations that you should follow along with from a Linux-like environment using Bash.

We expect you to use any of the following setups to follow along, less stars mean you will stop being able to follow along at a certain point.
- #link("https://git-scm.com/install/windows", [Git Bash on Windows #emoji.chain])
- The Terminal app on MacOS #emoji.star
- #link("https://colab.research.google.com/notebook#create=true", [Google Colab #emoji.chain]) #emoji.star
- #link("https://distrosea.com/", [Distrosea #emoji.chain]) #emoji.star #emoji.star
- Linux on Windows via #link("https://www.youtube.com/watch?v=myMcHTMJZng", [VM #emoji.chain]) or #link("https://ubuntu.com/wsl", [WSL #emoji.chain]) #emoji.star #emoji.star
- Linux on M-series Mac via #link("https://www.youtube.com/watch?v=1PL-0-5BNXs", [VM #emoji.chain]) #emoji.star #emoji.star
- A stand-alone Linux installation or #link("https://www.youtube.com/watch?v=UTqDuWHbZkw", [Linux dualboot with Windows #emoji.chain]) #emoji.star #emoji.star #emoji.star

=== Linux Distributions

Linux refers to just the core of the operating system, the #reverse-emphasis[kernel].

What you install instead is called a *distribution*. You can think of distributions as editions.

Typically, people install Ubuntu for desktop or server. The differences between distributions for normal users usually boil down to:
- Updates: how fast & how often
- How your desktop looks

If you already use a distribution of Linux just know that, for our purposes, we'll need a standard Linux distribution with a package manager, `systemd` and an interactive POSIX shell. If you are proficient enough to know alternatives to these, feel free to work with them.

== Bash Basics

=== What is Bash?

Bash (Bourne Again SHell) is a shell program that's famous for being installed by default on Linux, and is installable on Windows via Git Bash.

Linux & MacOS use shells that follow a common _POSIX_ standard. This means a script written on MacOS will most likely work on Linux, even though MacOS doesn't use `bash`.

Bash allows you to interact with the computer or write elaborate scripts for managing your system.

=== First Looks
The shell prompt will look something like this:
```Terminal
pin1traineepin2@pin3auroboticspin4:pin5~pin6$
```
#pinit-highlight(1, 2, fill: rgb(255, 127, 127, 80))
#pinit-highlight(3,4, fill: rgb(255, 255, 0, 80))
#pinit-highlight(5,6, fill: rgb(127, 0, 127, 80))

- The #highlight(fill: rgb(255, 127, 127, 80))[first part]  refers to your _username_.
- The #highlight(fill:  rgb(255, 255, 0, 80))[second part] refers to your machine's name (the _hostname_).
- The #highlight(fill: rgb(127, 0, 127, 80))[third part] refers to your _current working directory_ --- the place your are currently in.

At any point, you may use the following tricks to help you navigate your commands easily:
- Arrow-up: go back in history and inspect or re-run commands
- `Ctrl-C`: cancel the prompt or exit the running program
- `Ctrl-L` or `clear`: clear the terminal screen
- `TAB`: see if the shell can auto-complete your command
- `!!`: re-run the immediately previous command

=== Commands: Navigation

The most used commands are navigation commands. Here's a list:
#figure(caption: "Common navigation commands")[
  #table(
    columns: 3,
    align: (center + horizon, center + horizon, left),
    [*Command*], [*Description*], [*Usage Examples*],
    [`ls`], [list files and directories], [
      - `ls`
      - `ls -a`
      - `ls /dev/`
    ],
    [`cd`], [change current working directory], [
      - `cd /home/trainee`
      - `cd "../Parent Directory"`
    ],
    [`pwd`], [print current working directory], [
      - `pwd`
    ],
  )
]

=== Navigation: Relative & Absolute Paths

A relative path is a path that contains `./` at its start or `..` in any part of it.

When standing inside any directory, if you type `ls -a` you will find two special files: `.` and `..`.
- `.` refers to "this directory"
- `..` refers to "go up one directory"

You can use the previous special paths for:
- get files under current directory: `cat ./file` or `cat ./subfolder/file`
- get files in neighboring directories: `cp ../sibling-folder/file ./copy`
- travel up the directory tree: `cd ..` or `cd ../../` or `cd ../sibling-folder/subfolder/`
- do something completely unnecessary: `cd ./` or `cd .` or `cd ./subfolder/../` or `cd /home/trainee/../trainee/`

=== Commands: File Management

We mentioned shells can manage files. Here's a list of file management commands:

#figure(caption: "Common file management commands")[
  #table(
    columns: 3,
    align: (center + horizon, center + horizon, left),
    [*Command*], [*Description*], [*Usage Examples*],
    [`touch`], [create a new file], [
      - `touch new_file`
      - `touch "New File.txt"`
      - `touch /home/trainee/file.txt`
    ],
    [`mkdir`], [create a new directory], [
      - `mkdir test`
      - `mkdir "Test Dir"`
      - `mkdir -p ./test1/test2`
    ],
    [`mv`], [move file or directory], [
      - `mv test ./test1/`
    ],
    [`cp`], [copy file or directory], [
      - `cp -r "Test Dir" ./test/`
    ],
    [`rm`], [delete file or directory], [
      - `rm file`
      - `rm -r folder`
    ]
  )
]

=== Command Arguments & Options

We previously explored `sys.argv` in Python. This is what we'll discuss now, but in terms of how most Linux programs use them.

We can categorize arguments into:
- Value-only arguments `cat file.txt` or `git push`
- Option switches: `rm -rf ./folder/` or `rm -r -f ./folder`
- Key-value options: `git commit --message="Fix bug"` or `git commit -m "Fix bug"`
- The standalone `--` --- end of options: `rm -f -- -r ./folder/` (`-r` is ignored)

All of these apply to the _command itself_. Interactive programs use something else: #link-ref(<stdfiles>, show-content: true, show-label: false).

=== Regular Expressions & Wildcards

A regular expression is a syntax that allows for advanced pattern matching. It is also called "regex" for short.

A wildcard is an asterisk `*` that is put between text to indicate "anything goes here".

Regex and wildcards are used in techniques that allow us to make advanced #reverse-emphasis[search] (pattern-matching) and #reverse-emphasis[mass-operations] (text expansion or "globbing") efficiently.

For example, we can use `cp ./wrong_folder/* ./correct_folder/` to copy all files under `wrong_folder/` into `correct_folder/`.

We can use something like `rm ./*.txt` to remove all files ending in `.txt` under the current directory.

We can use something like `rm ./folder/**/*.txt` to remove all files ending in `.txt` under _all *direct* subfolders_ of `./folder/`. For a more advanced file finder, use #link("https://www.man7.org/linux/man-pages/man1/find.1.html", [`find` #emoji.chain])

#set-ribbon(content: [Read more: #link("https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html", [File Name Expansions Reference #emoji.chain])])

=== Extra: Text Expansions

To read in-depth about text expansions and substitutions in bash, check these resources out:
- https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html
- https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html
- https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html
- https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html
- https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_04.html


=== Commands: File Editing & Text Operations

We can do more advanced file operations using the following commands:

#figure(caption: "Common file operation commands")[
  #table(
    columns: 3,
    align: (center + horizon, center + horizon, left),
    [*Command*], [*Description*], [*Usage Examples*],
    [`cat`], [output file content to `stdout`], [
      - `cat file.txt`
    ],
    [`echo`], [print arguments into `stdout`], [
      - `echo "Hello World"`
    ],
    [`nano` or `vi`], [TUI text editor], [
      - `nano file.txt`
    ],
    [`grep`], [search using regular expressions], [
      - `cat file.txt | grep "World"`
    ],
  )
]

You can read more about #link("https://www.cyberciti.biz/faq/grep-regular-expressions/", [regular expressions for grep #emoji.chain]).


=== Getting Help

We only scratched the surface of what each command does.

In Unix-like systems, core utilities and commands often have one of two ways of getting help for them:

- `<command> --help` or `<command> -h`
- `man <command>` --- to get the #reverse-emphasis[man pages] (manuals) for the program

Typically commands specify whether arguments or options are required or optional by using `<argument>` for required and `[argument]` for optional. They also specify whether a specific combination of them is valid by using groups like `[-i <input_file>]` where the group as a whole is optional, but when using it you have required sub-parts.

Sometimes required arguments are documented without the angled brackets `< >`, ex: `kill PROCESS_ID` is equivalent to `kill <process_id>` in documentation.

=== Text Streams: `stdin`, `stdout` & `stderr` <stdfiles>

For interactive input and output, each program gets 3 separate spaces or "files":
- `stdin`: standard input
- `stdout`: standard output
- `stderr`: standard error

As we'll learn later, this is part of the "everything is a file" philosophy in Linux/Unix.

- Text can be _redirected_ from one *file* to another, including the standard I/O files
- Text can be _piped_ from the output of one *program* to the input of another

=== Text Streams: Redirection & Piping

- `cat` pushes contents of text files into `stdout`
- `echo` pushes its arguments into `stdout`

Shells provide multiple other operations for text redirection:
- `>`: from `stdout` to file, creates new file
  - `echo "Hello World" > hello.txt`
- `>>`: from `stdout` to file, appends contents to existing files
  - `echo "This is a new line" > hello.txt`
- `<`: from a file into `stdin` of a program (alternatively use `cat` and `|`)
  - `grep "World" < hello.txt` or `cat hello.txt | grep "World"`
As for piping:
- `|`: from `stdout` of one program to `stdin` of the next program
  - `ls | grep "*.txt"`

=== Text Streams: Redirecting `stdout` & `stderr`

`stdout` and `stderr` are both given "file descriptors" of `1` and `2` respectively.

We can use these file descriptors to choose if we want a specific one of them to be redirected into a file, or one of them to be redirected into the other.

- `echo "This goes to stdout" >&1`
- `echo "This goes to stderr" >&2`
- `some_command 2>&1`: all errors going to `stderr` are put on `stdout` instead
- `ls -1 > stdout.log 2> stderr.log`: errors into `stderr.log`, output into `stdout.log`
- `ls -1 > combined.log 2>&1`: `stderr` into `stdout`, `stdout` into `combined.log`

  
=== Text Streams: `/dev/null`

Using a special file (see #link-ref(<everything-is-a-file>)) called `/dev/null`, we can #emphasis[hide] outputs or discard text by redirecting it into `/dev/null`.

- `ls -1 > /dev/null`: `stdout` into `/dev/null`; show me errors only
- `ls -1 2> /dev/null`: `stderr` into `/dev/null`; show me normal output only
- `ls -1 > /dev/null 2>&1`: hide all outputs

This is useful for:
- hiding outputs of a background process
- hiding/ showing only debugging information, since debugging information is usually sent to `stderr`. Programs may need a `debugging mode` switch or setting for these purposes

=== Text Streams: Piping

Piping is done using the `|` operator. It can be used to chain commands together.

For example we can get all lines of a file, check which lines have "World" in them, and then sort these lines alphabetically:

```sh
cat file.txt | grep "World" | sort
```

=== Basics of Control Flow

Shells are scripting languages. We will expand on that later, but they can evaluate values as true and false.

We can abuse some of the programming syntax of bash for chaining commands that depend on each other. Commands are successful or true if their exit code is 0 --- we learned about exit codes or "main function return value" in C.

To see the status of a previous command in bash, echo `$?` variable. Any non-zero value is a failed command. This relies on programs that are made to provide meaningful values via the return value.

=== Basics of Control Flow: Continued

- Dependency (`&&`): `rm secret && touch new-file` if they first command fails, the second doesn't run
- Inverse Dependency (`||`): `rm secret || echo "File doesn't exist"`, only if the first command fails, the second runs
  - Can be combined with `&&`: `rm secret && echo "Success" || echo "Failure"` if the second command here fails due to the first command failing, the third will run
- Chaining (`;`): `rm secret && touch new-file` both will run, even if any of them fails. `touch new-file` will only run #emphasis[after] the previous command *ends*, regardless of its success.
- Parallelism (`&`): `run_server & print_server_data` in this example the server will run, and once the server _begins_ to run, we will print the server data. The first command may continue running or may fail at some point, the second command runs right away anyway.


=== Variables

In bash you can save, use and _run_ variables:
```sh
name="TRAINEE" # notice no space before or after =
echo "My name is $name"
LOVELY_COMMAND="echo 'Hello World'"
$LOVELY_COMMAND # executes and prints Hello World
command_result=$($LOVELY_COMMAND) # saves result: "Hello World"
```

== Linux File System

=== File Hierarchy Standard <fhs-section>

This is a standard that most Linux distributions follow for #emphasis[directory structure] and #emphasis[file organization]. Here is a limited subset of these folders:

#dtree(
  stroke: 1.2pt + blue.darken(20%),
  size: 0.75em,
  fill: navy,
  "📁 | /              # Root directory
  📁 | bin/            # Program binaries
  📁 | boot/           # Static boot loader files and kernel images
  📁 | dev/            # Device files (hardware interfaces)
  📁 | etc/            # System-wide configuration files
  📁 | home/           # User home directories (documents, settings)
  📁 | lib/            # Essential shared libraries and kernel modules
  📁 | media/          # Mount point for removable media (USB, CD-ROM)
  📁 | mnt/            # Temporarily mounted filesystems
  📁 | proc/           # Process states files
  📁 | tmp/            # Temporary files (often cleared on reboot)
  📁 | var/            # Variable data (logs, spools, caches, lock files)
  "
)
#set-ribbon(content: [Read More: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard])

=== Everything is a File <everything-is-a-file>

In Linux, everything is a file.
- The camera you just connected? A file.
- A portable blackhole? A file `/dev/null`.
- Network sockets? Files.
- A list of running programs? A set of files.
- Services that keep your system functional? A set of files.
- Settings? Files.
- Random noise? A file `/dev/random`.

We can go on and on.

=== Current Working Directory: `pwd` & `$PWD`

We can use `pwd` as the command to get the current working directory. We could also use it directly as a variable: `$PWD`.

=== Home Folder

We previously observed that the home folder for the currently logged in user is abbreviated as `~`. We can use this if we are not currently at our home folder:
- `cd ~/Downloads/`
- `cp ~/Downloads/Doc.txt ~/Documents/Legal/Doc.txt`

Instead of using tedious relative imports or the full expansion, ex: `/home/trainee`.

The home folder also often contains hidden files and folders for configuration known as _dotfiles_, and local extensions to system-level folders. The user-specific files usually are prioritized over the system-level ones.
- `~/.config/` extends `/etc/`
- `~/.local/bin/` extends `/bin/`
- `~/.var/` extends `/var/`

=== Bash Config Files & Environment Variables

`~/.bashrc` is the file that contains variable definitions, alias definitions and other settings that is automatically `source`d by bash.

`~/.bash_history` is the file that contains the history of your previous commands.

Variables sourced from files like `~/.bashrc` can be _optionally_ accessed via "environment variables" libraries in different programming languages that programs are made in.

You can also pass a specific temporary variable to any program by  defining the variable on the same line as the command:
```sh
IP="192.168.1.64" run_server
```

=== Aliases & Shortcuts

An alias is a bash variable that is specifically meant to be run as a command. It can be considered a shortcut in a sense.

You can also create actual shortcut files to programs, files and folders using the `ln` (link) command.

```sh
ln -s /path/to/original_file.txt ~/Desktop/my_shortcut.txt
```

To check a shortcut, you can use:
```sh
readlink -f /path/to/shortcut
```
which will output the location of the original file if it's different.

=== `bin` Folders and `$PATH`

As we established, `/bin/` is where most system programs live. Sometimes programs live elsewhere, usually in your home folder under `~/.local/bin/`.

How does the shell keep track of where programs are stored? The `$PATH` variable.

It contains colon separated paths of directories that contain programs to be considered commands.

=== `which`: Provider Finder

If you have a Python project and want to see whether you are using the `venv` Python or the system Python, you use `which`.

`which` tells you _which_ file is chosen by the shell when you run a specific command.


== Package Management

=== Linux Package Management

Linux distributions ship with package managers that allow you to install all sorts of things:
- Apps
- Fonts
- Services
- Desktop
- Development tools
- etc

These packages are installed at the system-level. It is recommended to keep packages installed from the package manager to a minimum.

On Ubuntu, the package manager is called `apt`. It's `brew` on MacOS, `winget` on Windows, `dnf` on Fedora and `pacman` on Arch. Curiously, on Android it's just called `pm`.

=== Using `apt`: the Ubuntu Package Repository

Linux distributions maintain a repository of packages online.

When you try to install something like Firefox, the package manager has to use a URL to download the correct package and install it.

The repositories also contain information about the _dependencies_ of packages: other packages that they depend on and may need to be installed.

=== `apt update`: Update the Repository First

Note: we'll use `sudo` before our commands to run them as administrator. We'll discuss permissions in depth later.

```sh
sudo apt update
```

Many online tutorials use an _alias_ of `apt`: `apt-get`
```sh
sudo apt-get update
```

They are the same exact thing

=== `apt install`

If you decide to install a specific package, you use `apt install`. Let's say we wanted to install and try `vim`:
```sh
sudo apt install vim
```

=== `apt search` & `apt-file`

What if we know the command is "something", but we can't find the correct package name?

We use `apt search` to look up keywords that may be in the package name or description --- and notice theres's no need for `sudo`, we're just searching.

We can also use an advanced utility, `apt-file`, to search for a package by the file name or program name that it provides. We'll need to install `apt-file` first though:

```sh
sudo apt install apt-file
sudo apt-file update
apt-file search bin/firefox
```

=== `apt upgrade`

We use `sudo apt upgrade` to actually update the packages themselves. It's commonly paired with `sudo apt update` to ensure that `apt` knows which version is the latest version before comparing it to the installed version for each package.

```sh
sudo apt update && sudo apt upgrade
```

=== `apt remove`

To remove a package, simply `sudo apt remove <package_name>`.

= Deployable Linux

== SSH & Remote Access

=== What is SSH?

SSH (Secure SHell) is a system that allows you to securely and remotely log into devices and gain access to shells.

SSH relies on a _client_ and _server_ dynamic. Almost all systems have an SSH client pre-installed and ready to use. We typically only setup the SSH server once on our deployed robots once and keep reusing it afterwards.

SSH is critical for maintenance and remote development.


=== SSH Basics: Opening a Connection

An SSH connection is started with this syntax:
```sh
ssh username@hostname
```
Examples of connections are:
```sh
ssh trainee@aurobotics
# or
ssh trainee@aurobotics.local
# or
ssh trainee@192.168.1.64
```

The _hostname_ part of the connection is the _address_ of the device on the network. After starting a connection, you may be asked to trust the remote and enter the user's password.

=== SSH Basics: The Local Network

For SSH to work, you typically need to have both devices connected to the same network. This is called a LAN. 

SSH works on a specific _network port_: `22` by default, configurable. Due to local restrictions, you can not easily expose that port over the internet to other devices without something like tailscale. On a local network, all devices can contact each other using their addresses.

#tip(title: "For Windows Users")[
  You may need to set your network to *PRIVATE* not public. This can be done from the settings app.
]

A hostname may have need an explicit `.local` to work on LAN, or it may work without it. It depends on how your device resolves these addresses and if `avahi-daemon` is on the remote.

=== `scp`

`scp` is the command used to do a "copy-over-SSH" for files and folders.

An optional flag `-r` can be used to copy full folders around.
```sh
# upload to remote
scp /local/path/ username@hostname:/remote/path/
# download from remote
scp username@hostname:/remote/path/ /local/path/
```

=== Users & Login Sessions

You can open multiple SSH sessions to the same remote, and even to the same user on the same remote.

Each session gets its own shell and terminates when the connection ends or the shell exits.

You can check a list of online users via the `w` command and check your username (for scripting) via the `whoami` command.

=== Shutdown & Reboot

To shutdown or reboot the system, you can run either of the following commands:

```sh
# shutdown now:
sudo shutdown +0
# reboot now:
sudo reboot +0
```

== System Configuration

=== Permissions

In Linux, access to files, devices and commands is integrated into a robust permission system.

We will discuss:
- File permissions
- User groups
- Privilege escalation

Other topics you may look into include:
- Firewalls
- Access Control Lists (ACLs)

=== File Permissions

Every file in Linux belongs to #emphasis[one user] and #emphasis[one group].

Every file has 3 operations restricted by permission flags. The following is a list of the operations, their equivalent numerical flag and their equivalent mnemonic flag:
- #reverse-emphasis[Write] | `4` | `w`
- #reverse-emphasis[Read] | `2` | `r`
- #reverse-emphasis[Execute] | `1` | `x`

A permission applies at one of 3 levels: #reverse-emphasis[user], #reverse-emphasis[group], #reverse-emphasis[others]

For example, a file may be `rwx` for the #emphasis[user] that owns it, `rw` for the #emphasis[group] that owns it and `r` for everyone else. These flags will numerically be `7-6-2`. A "no permissions" is a `0`.

=== `chmod`

We previously used `chmod +x` to make files executable.

`chmod` changes the file permission mode.

Here are examples of its usage
- `chmod +x <file>`: add executable permission for all levels
- `chmod u+x <file>`: add executable permission for the *user* who owns the file
- `chmod g+rw <file>`: add `r` and `w` permissions for the *group* which owns the file
- `chmod -x <file>`: remove executable permission from all levels
- `chmod u=rw <file>`: set the permissions to `rw` for the *user* who owns the file
- `chmod 762 <file>`: set the permissions to `u:rwx`, `g:rw`, `o:r`

=== `chmod` Syntax Summary
Form 1: `chmod [who]<operator><permission> <file>`
- `who` is (`u`, `g`, `o`, or `a` by default for all levels)
- `operator` is (`+`, `-` or `=`). Permission is a permission flag either in mnemonic form or single-digit numeric form

Form 2: `chmod <XYZ> <file>`:
- Sets `u:<X>`, `g:<Y>`, `o:Z`

=== User Groups

A user group is a way to make managing access easier by giving permissions to groups and then assigning users to the groups.

Common groups include:
- `wheel` for users who can use `sudo`
- `video` for users who can access `/dev/video*`
- `dialout` for users who can access `/dev/ttyACM*` and `/dev/ttyUSB*`

User groups are often made unnecessary by systems that use ACLs instead.

=== `sudo` and the Root User

We previously used `sudo` to use `apt`.

`sudo` is the #highlight[su]per-user #highlight[do] command. It allows you to run commands as an admin.

In Linux, access to the `root` account --- the most privileged account --- is highly restricted. To run privileged commands, you use `sudo` and type in your own password.

`sudo` requires that you be in the `wheel` group.

Using `sudo` once will typically remove the requirement to enter the password for subsequent uses for some time.

You can use `sudo -i` to get an interactive superuser session. This is #emphasis[never recommended] unless you are specifically using with something like `cd` only.

== Hardware Devices

=== `/dev/`

In #link-ref(<fhs-section>) we discussed how the `/dev/` directory is for _files_ that represent devices attached to your system.

Devices in Linux are represented using files, and are put into categories:


#table(
  columns: 3,
  [*Device*],[*Location*],[*Category Location*],
  [Cameras],[`/dev/video*`], [`/dev/v4l/`],
  [USB, Serial &\ Microcontrollers], [
    - `/dev/ttyUSB*`
    - `/dev/ttyACM*`
  ], [`/dev/serial/`],
  [Joysticks, Mice, Keyboards], [many different file names], [`/dev/input/`],
)

=== Video Devices

Video devices are typically found as `/dev/video*`.

If you have one camera connected, you may find: `/dev/video0` and `/dev/video1`

Typically, a single camera device adds two camera _files_. The #emphasis[even-numbered] file helps actually get video frames, the odd-numbered file is used by libraries for camera information.

- `/dev/v4l/by-id/SOMETHING-index<0 or 1>` is a more readable file name pointing to the same `/dev/video<even or odd number>` you may have identified
- `/dev/v4l/by-path/SOMETHING-index<0 or 1>` is a unique file name given to a camera according to the physical location it's connected at, and points back to `/dev/video<even or odd number>`

Recall: to check which file is pointed to by these shortcuts, use:\ `readlink -f /path/to/shortcut`

=== Extra: Reading Video Streams

We typically use the following libraries and utilities to read and stream video:

- `opencv` in Python
- `ustreamer` in Linux (as a service)
- `fswebcam` to capture images
- `gstreamer` in Linux (as an alternative to `ustreamer`)

=== Serial Devices

As we established, serial devices are found commonly under `/dev/ttyACM*` or `/dev/ttyUSB*`. Usually the numbers assigned to them are random, so it's better to use:
- `/dev/serial/by-id/DEVICE-NAME` if you have a single device of each type connected
- `/dev/serial/by-path/DEVICE-NAME+PATH` if you have multiple devices of the same type connected, differentiate them by their hardware connection description, which persists across reboots

You can read and write data to serial devices using `head` or `cat` and `printf` respectively. It's better to use something like Python's `pySerial` library instead.


== Scripting

=== Overview of Scripting

Scripting in Linux can be done using any scripting language.

A script is a standalone file that takes input in the form of arguments or `stdin`, and outputs on `stdout`. This follows the Unix philosophy of having one program do one thing well, and combining programs to do a larger task.

A script's content starts with a header file that specifies where the program is for interpreting the script, like:
```sh
#!/bin/bash
```
```sh
#!/bin/sh
```
```sh
#!/bin/python3
```

=== Python Script Example
```python
#!/bin/python3
from sys import argv, exit

if len(argv) == 1:
  exit(1)
if argv[1] == "Hello":
  print("Hi!")
else:
  print("Please say hello.")
# exit(0) is implied
```

We then use: `python3 ./script.py Hello`


=== Bash Script Example

```sh
#!/bin/bash

if [[ "$1" == "" ]]; then
  exit 1
elif [[ "$1" == "Hello" ]]; then
  echo "Hi!"
else
  echo "Please say hello."
fi
# exit 0 is implied
```

=== Arithmetic Operations

All arithmetic operations must be enclosed in `(( ))`.

There is no floating-point arithmetic.

=== Condition Operators: Equality & Arithmetic

- `-eq`: Equal `[[ $a -eq $b ]]` or `(( a == b ))`
- `-ne`: Not equal `[[ $a -ne $b ]]` or `(( a != b ))`
- `-gt`: Greater than `[[ $a -gt $b ]]` or `(( a > b ))`
- `-ge`: Greater than or equal to `[[ $a -ge $b ]]` or `(( a >= b ))`
- `-lt`: Less than `[[ $a -lt $b ]]` or `(( a < b ))`
- `-le`: Less than or equal to `[[ $a -le $b ]]` or `(( a <= b ))`
- `=`: String equality `[[ "$a" == "$b" ]]`
- `!=`: String inequality `[[ "$a" != "$b" ]]`

=== Condition Operators: File Existence
- `-e <file>`: True if the file or directory exists
- `-f <file>`: True if the file exists and is a regular file
- `-d <file>`: True if the file exists and is a directory
- `-s <file>`: True if the file exists and is not empty (size greater than zero)
- `-r <file>`: True if the file exists and is readable by the user
- `-w <file>`: True if the file exists and is writable by the user
- `-x <file>`: True if the file exists and is executable by the user

=== Looping in Bash: For-Loop
Count-based:
```sh
for i in {0..10}; do
  echo "$i"
done
```

List-based:
```sh
for arg in "$@"; do
  echo "Processing: $arg"
done
```

=== Looping in Bash: While
```sh
count=1
while [[ $count -le 3 ]]; do
  echo "Iteration number: $count"
  ((count++))
done
```

=== Defensive Scripting

When writing bash scripts, it's important to:
+ Use as many `if` conditions as possible
+ Realize that variables are always valid even if unset, and contain `""`
+ Realize that a single failed line will not stop the whole script

- To change (2): write `set -u` after the header.
- To change (3): write `set -e` after the header.
The options can be chained: `set -eu`. The `-x` option is also use to enable "tracing mode".

Also a bash-specific trick to get the absolute path to the scrip and avoid using `$PWD` since it may not necessarily be that:
```sh
SCRIPT_PATH=$(realpath "${BASH_SOURCE[0]}")
```


== Process Management

=== Background Processes

To run a process in the background while you use other commands, use:
- `command &` or `command > /dev/null 2>&1`

If you forgot to background a process, press `Ctrl-Z` to send it off.

To run a process in the background that will not die when you close your shell:
- `command > /dev/null 2>&1 & disown`
- use something like #link("https://github.com/tmux/tmux/wiki", [tmux #emoji.chain])

=== Killing a Process

When you run a background process and you get its ID, you can use the `kill` command:
- `kill <process_id>`

To kill _all_ instances of a command, use:
- `killall /path/to/binary`

With `killall`, it's important to specify the path or command that was used to run the actual process. For example, a command like `ping` can't be `killall`ed by `killall /usr/bin/ping`. For that, you need `killall ping`.

=== Seeing Running Processes

Use `top` to see an interactive TUI of running processes.

Use `ps all` for a one-time list of all running processes.



== Configuration & Services

=== Configuration

System configuration is usually done via files living under `/etc/`. This can be tedious and involve multiple commands to reload the settings.

As an alternative, we typically resort to TUI options like:
- `raspi-config` for Raspberry Pi configuration
- `nmtui` for network configuration using `NetworkManager` on servers
- "`ctl`" programs like `bluetoothctl`

=== Services & Daemons

A service --- or daemon --- refers to a background process that is run by a service manager.

A service can be run on startup, or can be set up in more advanced configurations like restarting every few seconds or restarting on failure or a specific event.

The most widely used service manager on Linux is `systemd` via a command called `systemctl` or "system control".

You can manage services using the following commands, remember to use `sudo`:
- `systemctl status <service_name>`
- `systemctl enable <service_name>` or `systemctl disable <service_name>`
- `systemctl start <service_name>` or `systemctl restart <service_name>`
- `systemctl stop <service_name>`

=== Creating a Basic Service

Services are stored as `/etc/systemd/system/*.service`.

Here's a basic example of a service:
```service
[Unit]
Description=Basic Network-Reliant Service
After=network.target
[Service]
Type=simple
ExecStart=/path/to/executable
[Install]
WantedBy=multi-user.target
```

#set-ribbon(content: [Read more: https://linuxhandbook.com/create-systemd-services/])

== Edge Hardware

=== Raspberry Pi

We typically use Raspberry Pi 4 or 5 for our competitions for a balance of power efficiency, budget-friendliness and computation power.

The Raspberry Pi has an ethernet port, 4 USB ports, an HDMI output port, Bluetooth and WiFi support, GPIO pins and an SD card reader for reading the installed operating system.

#set-ribbon(content: [Read more: https://www.raspberrypi.com/products/raspberry-pi-5/])

=== Other Devices & Technologies:

Here's a list of other devices and technologies we used or are considering using:
- #link("https://www.tp-link.com/us/home-networking/5-port-switch/ls1005g/",[TP-Link LS1005G Gigabit Switch #emoji.chain])
- #link("https://developer.nvidia.com/embedded/jetson-nano", [Jetson Nano #emoji.chain])
- #link("https://www.tp-link.com/us/business-networking/pharos-cpe/cpe210/", [TP-Link Pharos CPE210 Outdoor Router #emoji.chain])
- #link("https://www.virtualhere.com/usb_client_software", [VirtualHere USB Server #emoji.chain])

= Linux for Software Engineers

=== Linux for Software Engineers: Note

The purpose of covering the coming topics is to give you an overview of what Linux and Bash are used for in modern software engineering, and certain standards and conventions people in robotics use.

You do not need to deeply engage in any of the following topics. They are for enrichment and self-study.

== Containers

=== Containerization vs Virtualization

#grid(
  columns: 2,
  rows: 1fr,
  [
    #figure(caption: "Containers",
      image("assets/containers.png"),
    )
  ],
  [
    #figure(caption: "Virtual Machines",
      image("assets/vms.png"),
    )
  ]
)

=== Package Management Options

We have the following options when it comes to package management:
- System package manager
- Project-level package manager

The choice is almost always in favor of the latter. However, people sometimes use Linux _containers_ with pre-specified packages as an alternative to virtual environments.

This works well at deployment-time, but what about at development-time?


=== Devcontainers

Devcontainers are _live_ versions of the pre-specified images containing development packages for your specific project.

A devcontainer is a drop-in replacement or extension to virtual environments, ensuring a 100% repeatable setup and an uncluttered host system.

#set-ribbon(content: [Read more: https://code.visualstudio.com/docs/devcontainers/containers])

=== CI/CD Pipelines

We use containers in CI/CD pipelines, which are automated workflows that run on the cloud directly on your Git repository.

We use images and containers to ensure our pipelines are repeatable and robust.

CI/CD pipelines typically rely on extensive shell scripting --- though not specifically in bash.

#set-ribbon(content: [Read more: https://docs.github.com/en/actions/get-started/continuous-integration])

#end-slide()