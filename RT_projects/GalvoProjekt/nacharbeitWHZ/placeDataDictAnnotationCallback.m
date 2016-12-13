function placeDataDictAnnotationCallback(varargin)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Place annotation and callback for selection dialog
% for dictionary file                         11-12-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
callbackFcn={'an = getCallbackAnnotation;\n'
    '[a b]=regexpi(an.text, '':.*'');\n'
    '\n'
    'wd=''~/CODES_local/matlab_workspace/RT_projects/GalvoProjekt/nacharbeitWHZ/'';\n'
    '\n'
    '[fnam, fpath] = uigetfile(fullfile(wd, ''*.sldd''),...\n'
    '	''Select Data Dictionary file'');\n'
    '\n'
    'if ~isempty(fpath)\n'
    '	set_param(gcs, ''DataDictionary'', fnam)\n'
    'end\n'
    '\n'
    'anstr=sprintf(''%%s\\n\\\\bf{\\\\it %%s}'', an.text(1:a),...\n'
    '    strrep(get_param(gcs,''DataDictionary''), ''_'',''\\_''));\n'
    'an.text=anstr;\n'};
%%
if nargin==0
    bds{1}=gcs;
else
    if ischar(varargin{1})
        if strcmpi(varargin{1}, 'all')
            bds = find_system('type', 'block_diagram');
        else
            bds{1} = varargin{1};
        end
    else
        error(['Unknown argument type of ' varargin{1}])
    end
end

for NN=1:length(bds)
    blks=find_system(bds{NN});
    x=1e9;
    y=-1e9;

    for k=1:length(blks)
        try
            pos=get_param(blks(k),'position');
            pos=pos{1}(1:4);
            if pos(1)<x
                x=pos(1);
            end
            if pos(4)>y
                y=pos(4);
            end
        catch err

        end
    end

    anh=find_system(bds{NN},'FindAll','on','Type','annotation');
    for k=1:length(anh)
        if strfind(get(anh(k),'text'),'Data dictionary source:')
            break;
        end
    end

    %%
    if k==length(anh)
        note = Simulink.Annotation(bds{NN}, 'Data dictionary source:');

        set(note, 'ClickFcn', sprintf(strjoin(callbackFcn)));
        set(note, 'backgroundColor', '[1,1,0]');
        set(note, 'foregroundColor', 'black');
        set(note,'TeXMode','on');
        note.position = [x y+40];
    else
        warning 'Annotation already exists!'
    end
end

return