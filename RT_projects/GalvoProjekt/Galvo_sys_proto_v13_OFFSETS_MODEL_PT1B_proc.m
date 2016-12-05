if (0)
    %%
    clear inT* xnum in 
    
    fd=fopen('/media/storage/kabelBW_longtimeSpeedtest/analysed'); 
    in=textscan(fd,'%f %s %s %s'); 
    fclose(fd); 

    for k=1:length(in{3})
        in{3}{k}=[in{3}{k} ' ' in{4}{k}];
    end
    
    xnum=datenum(in{3});
    
    f1=figure(1); clf; 
    s(1)=subplot(211);
    br=stairs(xnum, in{1})
    set(s(1),'XTick', linspace(startDate,endDate,20))
    ylabel(s(1), in{2}{1})
    
    datetick(s(1),'x','dd/mmm')
    
    s(2)=subplot(212);
    hist(in{1},100)
    xlabel(s(2), in{2}{1})
    
%     startDate = datenum(in{3}(1), DFORM)
%     endDate = datenum(in{3}(end))
%     xData = linspace(startDate,endDate,200);
%%
%%
%     set(gca,'Layer','top')
    hold off;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  tfs der einzelnen OpAmp-Stufen erstellen / testen 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  M.DelBasso 31-05-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SYSTEMS={ 'analog_model_power_v13' };
FILES.sys=SYSTEMS;
FILES.sysD=1;       % Default system
%%
if (0); load_system(FILES.sys{FILES.sysD}); end;
%%
if (1); open_system(FILES.sys{FILES.sysD}); end;
%%
% Summierer
R1=3.3e3; R2=R1; R3=R1; R4=R1; C1=10e-12;
s=tf('s');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       getlinio (linmod für subsysteme)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sys=FILES.sys{FILES.sysD};

%% Inverting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1); cla; hold all;
SUB=310;

subplot(SUB+1); cla; hold all;
vC2=[10e-12 100e-12 10e-9];     % C2 step vector
io(1)=linio([sys '/sm1'], 1, 'input');
io(2)=linio([sys '/inv1'], 1, 'openoutput');
setlinio(sys,io);
for k=1:length(vC2)
    set_param([sys '/inv1'],'C2',num2str( vC2(k) ));
    linsys=linearize(sys,io);
    bh=bodeplot(linsys,ol.optb);
end
hold off;

legend(['C2=' num2str(vC2(1))], num2str(vC2(2:end)'));
title('Inverting opamp')

%% Noninverting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%f2=figure(2); clf; hold all;
subplot(SUB+2); cla; hold all;
vC2=[10e-12 100e-12 10e-9];     % C2 step vector
io(1)=linio([sys '/sm1'], 1, 'input');
io(2)=linio([sys '/noninv1'], 1, 'openoutput');
setlinio(sys,io);
for k=1:length(vC2)
    set_param([sys '/noninv1'],'C2',num2str( vC2(k) ));
    linsys=linearize(sys,io);
    bh=bodeplot(linsys,ol.optb);
end
hold off;

legend(['C2=' num2str(vC2(1))], num2str(vC2(2:end)'));
title('NonInverting opamp')

%% Differential opamp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%f2=figure(2); clf; hold all;
subplot(SUB+3); cla; hold all;
vC2=[10e-12 100e-12 10e-9];     % C2 step vector
io(1)=linio([sys '/sm1'], 1, 'input');
io(2)=linio([sys '/diff2'], 1, 'openoutput');
setlinio(sys,io);
for k=1:length(vC2)
    set_param([sys '/diff2'],'C1',num2str( vC2(k) ));
    linsys=linearize(sys,io);
    bh=bodeplot(linsys,ol.optb);
end
hold off;

legend(['C2(1)=' num2str(vC2(1))], num2str(vC2(2:end)'));
title('Differential opamp')

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_OFFSETS_MODEL_PT1B_proc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  M.DelBasso 25-05-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FPA=[   '/media/storage/data_notebook/HS_Karlsruhe/xy_galvoscanner/',...
        'bilder_screenshots_messungen/spice_screenshots/'];

IMAGES={[FPA, 'power_v1.3_reqorked_rekonst.png']
        [FPA, 'power_v1.3_reqorked_most.png']
        [FPA, 'power_v1.3_reconstr.png']
        [FPA, 'power_v1.3_reconstr_dac_lvlshift.png']
        [FPA, 'power_v1.3_reqorked_shuntmon.png']
        [FPA, 'power_v1.3_reqorked_sum_ltc6090_hv.png']
        [FPA, 'power_v1.3_reqorked_SAR.png']
        [FPA, 'power_v1.3_reqorked_sum_ltc6090.png']};

SYSTEMS={ 'Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_OFFSETS_MODEL_PT1B.slx',...
          'Galvo_sys_Cdisc_Pcont_cc_v64_proto_v20_OFFSETS_MODEL_PT1B.slx'};

SPICES={ 'sysCompl_endstufe_FET_v20_transducer_v13_Shunt_R075.asc',...
         'sysCompl_endstufe_FET_v20_transducer_v13_Shunt_R075.asc' };   

FILES.image=IMAGES;
FILES.imageD=1;
FILES.sys=SYSTEMS;
FILES.sysD=2;
FILES.spice=SPICES;
FILES.spiceD=2;

par2 = ol.par2; par3 = ol.par3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mit diesem Skript + Simulink Model soll eine detailierte Systembeschreibung 
% des Stellglieds aufgebaut werden.
% Actuator
%% ... ist die Endstufe inklusive untersetztem Stromregler !?
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (1); load_system(FILES.sys{FILES.sysD}); end;
%%
if (1); open_system(FILES.sys{FILES.sysD}); end;
%% Place subsystem frames for image presentation
% BH=get_param(gcs,'Handle');%%, 'Handle');
% idx=find(~cellfun(@isempty, (strfind(BH,'newSub'))));
% bh=BH(idx);
%%
if 0% isempty(idx)
 %%  
    vimg=[2 6 7 8 9];
%%    
    for k=1:length(vimg)
        bl(k) = add_block('Simulink/Ports & Subsystems/Subsystem', [gcs sprintf('/newSub%i', k)]);
    end
  %%  
    BH=get(get_param(gcs,'Handle'), 'Handle');
    idx=find(~cellfun(@isempty, (strfind(BH,'newSub'))));
    bh=BH(idx);
end

if ~exist('bffh','var')
    error 'Error line 60'
end
%         try 
%             delete(bh); clear bh;
%         catch err 
%             delete(findall(0, 'Type', 'Block', 'Tag', 'image@mdb'));
%         end
%     end 
% end
%%
XOFF=800;
YOFF=-1000;

xsum = 0;
ysum = 0;

for k=1:length(vimg)
    blkNam(k)= {['newSub_', timeDate('_'), sprintf('_%i', k)]};
    bh(k) = add_block('Simulink/Ports & Subsystems/Subsystem',...
                            [gcs '/' bh{k}]);

	set(bh(k),'MaskDisplay',['image(imread(''', FILES.image{vimg(k)}, '''));']);
    
    ii{k} = imfinfo(FILES.image{vimg(k)});
    set(bh(k),'Tag','image');
        
    set(bh(k),'Position', [xsum+XOFF ysum+YOFF ii{k}.Width+xsum+XOFF,...
                                                    ii{k}.Height+ysum+YOFF]/5);
    xsum=xsum + ii{k}.Width;
%     ysum=ysum + ii{k}.Height;
end
% pos = disp(get(bl(1),'Position'));
return

%%    
clear bpos
for k=1:length(vimg)
end
%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ga2: Hv OpAmp LTC6090 als nichtinvertierender Treiber der Endstufen-FET's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms R1 R2 R3 Xc1 Xc2 C1 C2 p Kp;
% Übertragungsfunktion von a2 unter Annahme dass die komplementäre Kollektor-
% Grundschltung (Emitterfolger) eine Verstärkung von ~1 besitzt.
ga2s = 1+par2(R2, Xc2)/par2(R1, R3+Xc1);

R1 = 5.1e3; 
R2 = (Kp-1)*R1;  % Poti
% C1 + R3: lead glied am inv einganh
R3=1e33; C1=1e-12; C2=10e-12; 
Xc1=1/(p*C1);
Xc2=1/(p*C2);
ga2s = 1+par2(R2, Xc2)/par2(R1, R3+Xc1);

GA2S = 1+par2(R2, Xc2)/par2(R1, R3+Xc1);

gvc=1+par2(R2, Xc2)/par2(R1, R3+Xc1);
ga2 = sym2tf(subs(gvc,'Kp',[2:2:10]'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% gp:  Plant model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V_Rsh / V_coil
Rsh = 0.075; RL=3.54; L=170e-6;
gp=Rsh/(Rsh+RL+s*L);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% gm:  current monitor + filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R8=270; R9=27*3; R11=100; C5=1/(2*pi*100*50e3);
gm=-R8/R9*1/(s*R11*C5+1);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Plot system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f1=figure(1);
delete(findall(f1,'type','line'));

hold all;

for k=1:length(ga2.num)
    bodeplot(ga2(k),ol.optb); 
    xlim([10,5e6]);
end
hold off;

f2=figure(2);
nyquist(ga2,ol.optn)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       getlinio (linmod für subsysteme)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IO=getlinio(gcs);
systo=strsplit(FILES.sys{FILES.sysD},'.');
systo=cell2mat(systo(1))
io=get(getlinio(systo));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Spice Laplace output string?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf2spiceLaplace(ga2(end),'NumDen', 3)
