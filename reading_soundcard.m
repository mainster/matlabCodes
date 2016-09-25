function reading_soundcard(varargin)
%% READING_SOUNDCARD()
% READING_SOUNDCARD(FS)
% READING_SOUNDCARD(FS,FRS)
% READING_SOUNDCARD(FS,FRS,DUR)
%
% FS:    Samplerate
% FRS:   Frame size
% DUR:   Record duration in sec
%

global loops lineinput secs2rec secsPerFrame loopsStatic;
  
  if ~evalin('base', 'exist(''lineinput'')')
      disp('no lineinput var found')
      evalin('base', 'global lineinput')
  end
  
  if ~evalin('base', 'exist(''s'')')
      disp('no s var found')
      evalin('base', 'global s')
  end
  
  if (nargin > 0) 
     fs = varargin{1};
  else
     fs = 8000;
  end
  
  Ts=1/fs;
  
  if (nargin > 1) 
     frs = varargin{2};
  else
     frs = 80;
  end

  if (nargin > 2) 
     secs2rec = varargin{3};
  else
     secs2rec = 1;
  end
%% time needed to run a frame
	secsPerFrame = frs*Ts

%% overall n loops needed to process sound record requested 
   loops = round(secs2rec/secsPerFrame); 
   loopsStatic = round(secs2rec/secsPerFrame) - 1; 
   fprintf('Loops: %i\n', loops)
   if (secsPerFrame > secs2rec)
   % enlarge record duration or lower the framesize
      fprintf('err, secsPerFrame > secs2rec, (%g > %g)', secsPerFrame, secs2rec);
      return;
   end
   
   nbits = 16;    % number of bits
   acq_ch = 1;    % acquisition channel


   %% construct global object for recording:
   lineinput = audiorecorder(fs, nbits, acq_ch);
   lineinput.StopFcn = {@record_off,lineinput};

   % The function recording_off will be called when the
   % recording is done.

   tic
   fprintf('Start frame (Duration=% .2gs): tic... \n',secs2rec);
   record(lineinput, secs2rec); % start the recording
end

%% Callback for record end event
%
function record_off(obj,event,lineinput)
global s loops secsPerFrame;



   s = [s; getaudiodata(lineinput, 'double')];
   
   if (loops) 
      loops=loops-1;
      record(lineinput, secsPerFrame); % start the recording
   else
      disp('loopend\n');
   end
   
   ti=double(toc);
%   fprintf('recOff toc after % .2gms or % .2gs \n', ti*1e3, ti)   
   
end