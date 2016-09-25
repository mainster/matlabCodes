% Galvo_proto_Cdisc_PT1cont_cc_v63
FILES={ 'Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13',
        'Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_OFFSETS_MODEL'};

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Read logging data from model logging 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sweep parameters 
%   + KshM      Shunt monitor gain
%   + Kpcc      Current compensator proportional gain
%
% open_system(FILES{1});

sweepBlk={
    {'/Gcc(s)/Cc(s)','P'},...
	{'/Gcc(s)/shuntMonGain','Gain'}};

%% backup initial value
for k=1:length(sweepBlk) 
    sweepBlk{1,k}{3} = get_param([FILES{1} sweepBlk{1,k}{1}], sweepBlk{1,k}{2});
end

%% simulate and sweep   Kpcc
ret = 'No';
if exist('swKpcc','var')
    options.Default = 'No';
    ret = questdlg('Kpcc exists. Overwrite?','Kpcc found','Yes','No',options);
end
    
if strcmpi(ret, 'yes') 
    for k=1:5
        clear l
        set_param([FILES{1} sweepBlk{1,1}{1}], sweepBlk{1,1}{2}, num2str( 5*k ));
        sim(FILES{1});

        for i=1:logsout.numElements  
            l.(strrep( logsout.getElement(i).Values.Name ,'*','_star'))=...
                logsout.getElement(i).Values.Data;
        end
        l.time = logsout.getElement(1).Values.Time;
        L{k}=l;
    end
    swKpcc = L;
    clear L;
    
    set_param([FILES{1} sweepBlk{1,1}{1}], sweepBlk{1,1}{2}, sweepBlk{1,1}{3});
end

%% simulate and sweep   KshM
ret = 'No';
if exist('swKshM','var')
    options.Default = 'No';
    ret = questdlg('swKshM exists. Overwrite?',...
        'swKshM found','Yes','No',options);
end
    
if strcmpi(ret, 'yes') 
    for k=1:5
        clear l
        set_param([FILES{1} sweepBlk{1,2}{1}], sweepBlk{1,2}{2}, num2str( 20*k ));
        sim(FILES{1});

        for i=1:logsout.numElements  
            l.(strrep( logsout.getElement(i).Values.Name ,'*','_star'))=...
                logsout.getElement(i).Values.Data;
        end
        l.time = logsout.getElement(1).Values.Time;
        L{k}=l;
    end
    swKshM = L;
    clear L;
	
    set_param([FILES{1} sweepBlk{1,2}{1}], sweepBlk{1,2}{2}, sweepBlk{1,2}{3});
end

%% Plot swept Kpcc data
fnam = fields(swKpcc{1});

f3=figure(3);
delete(findall(f3, 'type', 'line'));
ro = round( sqrt(length(fnam)-1) );

for m=1:length(swKpcc)
    for k=1:length(fnam)-1
        sp(k) = subplot(ro, ro, k);
        plot(swKpcc{m}.time, swKpcc{m}.(fnam{k})); hold all;
    end
end

for k=1:length(fnam)-1
    legend(sp(k),fnam{k});
end


%% Plot swept KshM data
fnam = fields(swKshM{1});

f4=figure(4);
delete(findall(f4, 'type', 'line'));
ro = round( sqrt(length(fnam)-1) );

for m=1:length(swKshM)
    for k=1:length(fnam)-1
        sp(k) = subplot(ro, ro, k);
        plot(swKshM{m}.time, swKshM{m}.(fnam{k})); hold all;
    end
end

for k=1:length(fnam)-1
    legend(sp(k),fnam{k});
end
return
    
%%
clear Gsys;

LIMOD={ 'Galvo_proto_Cdisc_PT1cont_cc_v63',
        'test_plant'};
selSys = 2;
varlis = {'Variant_RC','Variant_LR'};
for k=1:2
    set_param([LIMOD{selSys}, '/Plant'],'overrideUsingVariant',varlis{k});
    set_param(LIMOD{selSys}, 'MaxStep', '1e-6');
    clear S;

    S = linmod(LIMOD{selSys});
    S.filename = LIMOD{selSys};
    u_ = strrep(S.InputName, [S.filename '/'], '');
    y_ = strrep(S.OutputName, [S.filename '/'], '');
    S.InputName = u_;
    S.OutputName = y_;

    %GvCCa = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);           % Kompletter Regelkreis 
    statespace = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);           % Kompletter Regelkreis 

    if ((length(S.InputName) > 1) && (length(S.OutputName) > 1))
        sprintf('%s\n\tMIMO system\n%s',ds,ds)
    else
        if length(S.InputName) > 1
            sprintf('%s\n\tMISO system\n%s',ds,ds)
        else
            sprintf('%s\n\tSIMO system\n%s',ds,ds)
        end
    end

    [num, den] = tfdata(statespace);
    if exist('Gsys','var') > 0
        n = length(Gsys);
    else
        n = 1;
    end

    Gsys{n,1} = tf(num , den, 'u', u_, 'y', y_)
    Gsys{n,1}.Name = varlis{k};
    Gsys{n,2} = LIMOD{selSys}
end
%%

f1=figure(1);
SUBS=220;
delete(findall(f1,'type','line'));
%%
leg=[];
length(Gsys(:,1))
for k=1:length(Gsys(:,1))
    subplot(SUBS+k);
    step(Gsys{k,1})
    leg = [leg sprintf('%s:',Gsys{k,2})]
    le=legend(Gsys{k,1}.Name);
    set(le,'Interpreter','none');
    hold all;
end
hold off;

% legend(strsplit(leg(1:end-1),':'))
%%
f2=figure(2);
SUBS=420;
leg=[];
length(Gsys(:,1))
subctr=1
for k=1:length(Gsys(:,1))
    subplot(2,2,subctr);
%    bodeplot(Gsys{k,1},ol.optb)
    margin(Gsys{k,1}(1))
    subctr = subctr+1;
    subplot(2,2,subctr);
    subctr = subctr+1;
    margin(Gsys{k,1}(2))
    le=legend(Gsys{k,1}.Name);
    set(le,'Interpreter','none');
    hold all;
end
hold off;

% legend(strsplit(leg(1:end-1),':'))