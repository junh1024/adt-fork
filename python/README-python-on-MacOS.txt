I'm using the Anaconda distribution of Python.

1. download installer from 
   http://continuum.io/downloads

2. install for me only (so as not to interfere with system installs)

3. in a shell  
   conda install mayavi

4.


Getting Mayavi to work from within Spyder:

http://stackoverflow.com/questions/12442938/mayavi-doesnt-run-from-within-spyder-complains-about-valueerror-api-qstring

According to this and this the error can be fixed by activating the Ignore API change errors (sip.setapi) checkbox in Preferences > Console > External Modules.
