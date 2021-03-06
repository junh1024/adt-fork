Update 29-Feb-2016

There is now a binary installer for Octave 3.8.0 for OSX 10.9.1 or
later (Mavericks).  See the following URL for details.  I have tested
the ADT with this version.  The  

  http://wiki.octave.org/Octave_for_MacOS_X#Binary_installer_for_OSX_10.9.1

The GUI version complains that it can't find the binary for fig2dev.
This can be installed from MacPorts by doing

 sudo port install xfig +universal

(see below for installing MacPorts)





------
There are no pre-built binaries for Gnu Octave 3.6 on MacOS.  
Here are the steps I used to build, install, and test it on MacOS 10.8
("Mountain Lion"). 
     
1. Install XCode from Apple App Store (free)

1a. clear out old installations of MacPorts
sudo rm -rf \
    /opt/local \
    /Applications/DarwinPorts \
    /Applications/MacPorts \
    /Library/LaunchDaemons/org.macports.* \
    /Library/Receipts/DarwinPorts*.pkg \
    /Library/Receipts/MacPorts*.pkg \
    /Library/StartupItems/DarwinPortsStartup \
    /Library/Tcl/darwinports1.0 \
    /Library/Tcl/macports1.0 \
    ~/.macports
 
2. Install and configure MacPorts, http://www.macports.org

3. Open Terminal in /Applications/Utilities/Terminal.  At the unix prompt

  % sudo port
  > selfupdate
  > install fltk-devel
  > install ghostscript +cups
  > install arpack +atlas  
//  > install octave-devel +fltk +atlas +gcc47
//  > install octave-devel +fltk +atlas +gcc48 
  > install octave-devel +fltk +atlas +gcc5

or

  > install SuiteSparse +metis
  > install octave-devel +atlas +fltk +gcc48 +metis +x11

This works as of 23 Feb 2016:

  > install octave-devel

4. Start Octave, select fltk for graphics, and run example 

  % /opt/local/bin/octave
  octave:1> graphics_toolkit('fltk');
  octave:2> cd ~/Documents/MATLAB/AmbiDecoderToolbox
  octave:3> run_example_AK


There are some notes on getting FLTK working with Octave on MacOS here
  http://trac.macports.org/ticket/37356

Julius Smith has some notes here:
  https://ccrma.stanford.edu/~jos/mypc/Additional_Installs_Mac_OS.html



$Id: README-Octave-on-MacOS.txt 26460 2014-03-02 01:34:32Z heller $


Other notes

sudo port install cairo  +quartz
sudo port install pango +quartz
sudo port install gtk3 +quartz
