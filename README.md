# Fasta-Manipulator-FM-GUI
A tool with graphical user interface to manipulate sequence files in fasta format.  
_____________________________________________________________________________________________________________________________________________


Use at your own risk.
I cannot provide support. All information obtained/inferred with this script is without any implied warranty of fitness for any purpose or use whatsoever.

ABOUT: 

A GUI interface for manipulation of fasta files.  

USAGE: 

There are several different features this tool provides:

1) Remove any entries with an N (hard masked).
2) Conversion of a standard fasta formatted file to a two column format.
3) Conversion of fasta sequences to have a user-selected number of bases per line.
4) Random subsetting of a multi-entry fasta.
5) Subsetting a multi-entry fasta based on fasta header information.

WHY: 

This program provides a GUI for some common and some not-so-common fasta manipulations.  

CONSIDER: 

This tool will convert the fasta header information such that it no longer contains spaces. Spaces are converted to :.  This is done to facilitate subsetting and to some known issues with header formats for tools such as SIFT4G.  

INPUT: 

A fasta file .fasta or .fa 

A fasta file may contain one or more lines of sequence following the header. The header should not contain the symbol $ as it may interfere with this program. 

OUTPUTS: 

1) A new file is created for options 2-5. For example if you choose a two column conversion and a random subset, a file of the complete fasta file converted to two columns will be produced and a file in original fasta format with a random selection of user-defined n entries will be produced. If you want this random set to be converted to two columns, you need to run this program a second time. Note that if removal of Ns is selected, this action is applied to all output files.

2) A log file.

DEPENDENCIES:  

Bash, yad, Zenity, seqkit, shuf 

INSTALLATION:

Linux/Ubuntu:

This tool was built to work on Linux Ubuntu and tested on Ubuntu 20.04 and 22.04. Bash, Zenity and shuf should already be installed on these systems. Yad can be installed with sudo apt install. The same method can be used to install seqkit on Ubuntu 22.04.  For installation of seqkit on Ubuntu 20.04, follow the instructions here: https://bioinf.shenwei.me/seqkit/download/ .  Next, download the FM.sh file from this page and provide it permission to execute using chmod +x. Launch the program with ./ . 

macOS: 

This program has not been tested on macOS.  Attempts to install yad failed. Other dependencies can be installed with homebrew.  

Windows:

NOT TESTED. In theory you can install Linux bash shell on Windows (https://itsfoss.com/install-bash-on-windows/) and install the dependencies from the command line. If you try this and it works, please let me know. I don't have a Windows machine for testing.
