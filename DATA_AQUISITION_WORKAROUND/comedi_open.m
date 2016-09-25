%COMEDI_OPEN Open a comedi device.
%	device = COMEDI_OPEN(Path) opens the comedi device specified in the 
%	string Path.  If path is omitted, the default is '/dev/comedi0'.  If
%	there is a problem opening the device, an error occurs.
%
%	The return value is used as an argument for the comedi measurement
%	commands
%
%	The mex file keeps track of open devices and closes them at exit.
%
%	Examples:
%
%	  dev = comedi_open			Opens the default device
%
%	  dev = comedi_open('/dev/comedi1')	Opens the specified device
%
%
%	See also COMEDI_AO, COMEDI_SCAN
