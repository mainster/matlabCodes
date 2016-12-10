%COMEDI_SCAN Asynchronous analog input for comedi
%	[buf, done]=COMEDI_SCAN(device, subdevice, [min max], channels, rate, 
%				n, trig) 
%	Performs scanning analog input.  Device comes from a call to 
%	COMEDI_OPEN.  The info program in the demo directory of comedilib 
%	provides valid values for subdevice and channels.  The range of input 
%	voltages is given by min and max.  Channels is a row vector the 
%	channels to scan.  Rate is the sampling frequency.  N is the number of 
%	scans to perform.  Trig specifies the external input channel used to 
%	start the scan.  To start a scan immediately, leave trig empty.
%
%	Although COMEDI_SCAN returns immediately, the scan may be waiting for 
%	a trigger.  When the scan is complete, the return value done=true.
%	When finished, buf contains each scan as a column vector by channel:
%
%	(1st scan)  | (2nd scan)  | ... | (Nth scan)  |
%	-----------------------------------------------
%	(channel 1) | (channel 1) |     | (channel 1) |  
%	(channel 2) | (channel 2) | ... | (channel 2) |
%	 ...        |  ...        |     |  ...        |
%	(channel n) | (channel n) |     | (channel n) |
%
%	Example
%
%	[buf, done] = comedi_scan(dev, 0, [-5 5], 0, 10e3, 100)
%			Takes 100 samples at 10 kHz from the first channel of 
%			the first subdevice.
%
%	See also COMEDI_OPEN, COMEDI_BLOCK
