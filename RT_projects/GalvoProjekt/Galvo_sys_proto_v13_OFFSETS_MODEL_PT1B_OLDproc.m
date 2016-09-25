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
BH=get(get_param(gcs,'Handle'), 'Handle');
idx=find(~cellfun(@isempty, (strfind(BH,'newSub'))));
bh=BH(idx);

if isempty(idx)
    vimg=[2 6 7 8 9];
% % for k=1:length(vimg)
% %     bl(k) = add_block('Simulink/Ports & Subsystems/Subsystem', [gcs sprintf('/newSub%i', k)]);
% % end
% 

if exist('bh','var') 
        try 
            delete(bh); clear bh;
        catch err 
            delete(findall(0, 'Type', 'Block', 'Tag', 'image@mdb'));
        end
    end 
end
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



%% a2: Hv OpAmp LTC6090 als nichtinvertierender Treiber der Endstufen-FET's
syms R1 R2 R3 Xc1 Xc2 C1 C2 p;
% Übertragungsfunktion von a2 unter Annahme dass die komplementäre Kollektor-
% Grundschltung (Emitterfolger) eine Verstärkung von ~1 besitzt.
ga2s = 1+par2(R2, Xc2)/par2(R1, R3+Xc1);

R1 = 5e3; 
R2 = 9*R1;  % Poti

R3=1e3; C2=100e-12; C1=1e-9;
Xc1=1/(p*C1);
Xc2=1/(p*C2);

gvc=1+par2(R2, Xc2)/par2(R1, R3+Xc1);
ga2 = sym2tf(gvc)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Plot system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
bodeplot(ga2,ol.optb), xlim([10,5e6])

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
tf2spiceLaplace(ga2,'NumDen', 5)
