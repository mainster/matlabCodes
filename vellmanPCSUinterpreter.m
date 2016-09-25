function [varargout] = vellmanPCSUinterpreter(path, varargin)
%% [SAM, LSBS] = vellmanPCSUinterpreter(PATH, WRITEWAV)
%
% Read a (or multiple) DSO export file from pcsu200se USB scope     @@@MDB
%
%   PATH:       String or cellstrings that holds one or more full
%               filepathes to the exportet txt samples.
%   WRITEWAV:   set 1 to export input vector data to a wav file in input
%               directory
% 
%  SAM:         returns a struct with the parsed input files(s)
%  LSBS:        returns the LSB values as additional vector / matrix
%               (one row per input file)                
%

if nargin == 0
    errror('Erro, path to exported PCSU samples needed ');
end

if (~iscellstr(path))
    path={path};
end

for k=1:length(path)
    if (exist(path{k}))
        [~, name, ~] = fileparts(path{k});
        sam.(name) = importdata(path{k}, '\t',9);
    else
        error('Erro, file not found');
    end

    sam.(name).n_samples = length(sam.(name).data);


    %% Parse some coding information from file header
    %% Example Header:
    % 
    % TIME STEP:
    % 250 = 5us
    % 
    % VOLTAGE STEP:
    % CH1:  32 = 0.1V
    % CH2:  32 = 0.1V
    % GND   228   233
    % N     CH1     CH2
    % 
    % 0     105     92
    % 1     112     100

    % 32 = 0.1V means that the LSB of channel 1 equals 0.1V/32 = 0.003125V
    % 250 = 5us means that the sample rate is equal to 5us/250 = 20ns

    tmp = strsplit(sam.(name).textdata{6},{':','=','V'});
    ch = [str2num(tmp{2}), str2num(tmp{3})];
    ch1LSB = ch(2)/ch(1);
    tmp = strsplit(sam.(name).textdata{7},{':','=','V'});
    ch = [str2num(tmp{2}), str2num(tmp{3})];
    ch2LSB = ch(2)/ch(1);

	sam.(name).LSBs = [ch1LSB, ch2LSB];
    exLSB(k,:) = [ch1LSB, ch2LSB];
    
    
    %% Find Gnd offset settings for both channels
    Str = sam.(name).textdata{8};            % copy of 8. header lines
    key = 'gnd';                             % key to find  value for.
    idx = strfind(lower(Str), key);          % start index   
    offs = sscanf(Str(idx+length(key):end),'%g %g');
    
    
    sam.(name).data_raw = sam.(name).data;      % backup raw values

    % sample vector represents physical  % values in V
    sam.(name).data = [(sam.(name).data_raw(:,2) - offs(1)) * ch1LSB, ...
                       (sam.(name).data_raw(:,3) - offs(2)) * ch2LSB];
    

    %% Make a time vector based on header information
    unit = sam.(name).textdata{3}(regexp(sam.(name).textdata{3},'[a-z]'));

    switch unit
        case 'us'
            sam.(name).ts = 1e-6;
        case 'ms'
            sam.(name).ts = 1e-3;
        otherwise
            error('Error, cannot interpret timebase');
    end

    Str = strjoin(sam.(name).textdata(1:3)); % copy of first 3 header lines
    Str(strfind(Str, '=')) = [];             % Omit all = characters
    Str(strfind(Str, ':')) = [];             % Omit all : characters
    key = 'time step';                       % key to find  value for.
    idx = strfind(lower(Str), key);  % start index
    if iscell(idx); idx = cell2mat(idx); end

    values = sscanf(Str(idx+length(key):end),'%g %g');

    sam.(name).ts = values(2) * sam.(name).ts / values(1);
    sam.(name).time = [0:1:sam.(name).n_samples-1]*sam.(name).ts;

    sam.(name).input_file = path{k};


end

fn = fields(sam);

if nargin > 1
    if (varargin{1} == 1) 
        for k=1:length(fn)
            tmps = sam.(fn{k});

            % Find the closest match for repeating sequenze
            y = tmps.data(:,1);
            idx=1;
            while (y(idx)<mean(y))
                idx=idx+1;
            end
            idxr = idx;

            y = tmps.data(1:end,1);
            idx=length(y)-20;
            while (y(idx)<=mean(y))
                idx=idx+1;
            end
            idxf = idx;

            
            [pathstr, namestr, ~] = fileparts(tmps.input_file);
            audiowrite([fullfile(pathstr, namestr) '_ch12.wav'],...
                tmps.data(idxr:idxf,:), cast(1/tmps.ts,'uint32'));
            
            seq = tmps.data(idxr:idxf,:);
            audiowrite([fullfile(pathstr, namestr) '_ch12x4.wav'],...
                [seq; seq; seq; seq], cast(1/tmps.ts,'uint32'));
        end
        fprintf('wave out!');
    end
end

switch nargout
    case {0, 1}
    case {2}
        varargout{2} = exLSB;       
    otherwise
        error('Too many output arguments.');
end    

varargout{1} = sam;        

    
return

%% Find the closest match for repeating sequenze
y = vel.PCSU_100mA_cw.data(:,1);
idx=1;
fprintf('mean: %g\n', mean(y))
while (y(idx)<mean(y))
    idx=idx+1;
end

idxr = idx;

y = vel.PCSU_100mA_cw.data(1:end,1);
idx=length(y)-20;
fprintf('mean: %g\n', mean(y))
while (y(idx)<=mean(y) || idx<2 )
    idx=idx+1;
end

idxf = idx;

%%
figure(10); 
% subplot(211);
% plot(vel.PCSU_100mA_cw.time(1:100), vel.PCSU_100mA_cw.data(1:100,1));
% subplot(212);
A=0;
sel1=vel.PCSU_100mA_cw.data(idxr-A:idxr+100-A,1);
sel2=vel.PCSU_100mA_cw.data(idxf-100+A:idxf+A,1);
tt1 = vel.PCSU_100mA_cw.time(1:length(sel1));

hold all
plot(tt1, sel1,'x-');
plot(tt1, sel2,'o-');
plot(vel.PCSU_100mA_cw.time(1:101), repmat(mean(y),1,101),'r--');
hold off    
    
    
    