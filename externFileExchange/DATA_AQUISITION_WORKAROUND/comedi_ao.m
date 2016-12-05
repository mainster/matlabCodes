%COMEDI_AO Analog output for comedi
%	COMEDI_AO(device, subdevice, channel, voltage) sets the voltage for
%	a given device, subdevice, and channel.  The device should come from
%	a call to COMEDI_OPEN.  To find out valid subdevices and channels,
%	run the info program in the demo directory of comedilib.
%
%	Example
%
%	comedi_ao(dev, 0, 0, 5)		Sets the output of the first
%					channel of the second subdevice
%					to 5 V.
%
%	See also COMEDI_OPEN
