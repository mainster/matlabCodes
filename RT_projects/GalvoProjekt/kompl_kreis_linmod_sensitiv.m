%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     kompletter Kreis 
%                   G0  Gtot    S(s)    T(s)
%               Sensitivität, komplementäre- 
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FILES={ %%Galvo_sys_Cdisc_Pcont_cc_nosub_GUT_v63',...
        'Galvo_sys_Ccont_Pcont_cc_GUT_v63'};

if ~exist('param','var')
    warning(sprintf(['\n%s%s\nNo parameter struct found in reachable workspace!!!',...
        '\n\n\t\t\tparam = loadGalvoParam(4);\n\t\t\tevalGalvoParam();\n',...
        '\t\t\tbetter choice: param = loadGalvoParam(5,''eval'');\n\n%s%s\n'],...
        ds,ds,ds,ds))
    loadGalvoParam(5,'eval')
    
%     param = loadGalvoParam(4);
%     paramCtrl = loadCtrlParam(4);
%     evalGalvoParam(4);
end
%%
open_system(FILES)

FB_EN=0;
S0c=linmodHighLevel(FILES{1});
FB_EN=1;
% Stc=linmodHighLevel(FILES{2});

G0c=S0c.ss(1);

Gw = G0c/(1+G0c);
Gz = 1/(1+G0c);
Gm = -G0c/(1+G0c);


wv=logspace(0,5,75);

optb.FreqUnits='rad/s';
f3=figure(3);
clf;
subplot(121);
hold all;
optb.PhaseVisible='on';
optb.MagVisible ='on';

bp(1)=bodeplot(Gw,'b*-',wv);
bp(2)=bodeplot(Gz,'g*-',wv);
bp(3)=bodeplot(Gm,'r-',wv);
bp(4)=bodeplot(G0c,'c*-',wv);


    

%legend('Gw(s) = T(s)','Gz(s) = S(s)','Gm(s)','G0(s)');
%%
childrenHnd =get(f3, 'Children');
axes(childrenHnd(3));
legend('T(s) = Gw','S(s) = Gz','Gm(s) = -Gw(s)','G0(s)');

hold off;
title(S0c.linmod.filename,'interpreter','none')

%legend(S1.ss.OutputName);
%%
% *********************************************************************
% nochmal das gleiche aber mit höherer genauigkeit im bereich von wc 
% *********************************************************************
NN=400;
[~,Pm,Wgm,Wpm]=margin(G0c);
% |G0(j.Wpm)| = 1

nwc=log10(Wpm);

% ca. eine dekade über und unter wc (= Wpm)
%wv=logspace(nwc-0.35, nwc+0.5,NN);
wv=logspace(nwc-0.5, nwc+0.5,NN);

%f4=figure(4);
sh=subplot(122);
hold all;

optb.FreqUnits='rad/s';
optb.PhaseVisible='off';
optb.MagVisible ='on';

% bodeplot(Gw,'b*-',wv,optb);
% bodeplot(Gz,'g*-',wv,optb);
% bodeplot(Gm,'r-',wv,optb);
% bodeplot(G0c,'c*-',wv,optb);
bp(1)=bodeplot(Gw,'b*-',wv);
bp(2)=bodeplot(Gz,'g*-',wv);
bp(3)=bodeplot(Gm,'r-',wv);
bp(4)=bodeplot(G0c,'c*-',wv);

childrenHnd =get(f3, 'Children');
axes(childrenHnd(3));
xl=get(gca,'Xlim');

% wbs wbt wc
% Find point of intersection between sensitivity S(s) and -3dB line
[magz, ~, wvq]=bode(Gz, wv);
magz=20*log10(squeeze(magz));
[magw, ~, wvq]=bode(Gw, wv);
magw=20*log10(squeeze(magw));

idz = find(magz > -3, 1);
%px = wv(idx)/(2*pi);
ptzx = wv(idz);
ptzy = magz(idz);

idw = find(magw < -3,1);
%px = wv(idx)/(2*pi);
ptwx = wv(idw);
ptwy = magw(idw);

db3=repmat(-3,length(wv),1);

%plot(wv/(2*pi),repmat(-3,1,length(wv)),'m--')
mk={'x'; [17 3]; 'Red' };
plot(wv,repmat(-3,1,length(wv)),'r--')
plot(Wpm, 0, mk{1}, 'MarkerSize', mk{2}(1), 'LineWidth',mk{2}(2),'MarkerEdgeColor',mk{3})
plot(ptzx, ptzy, mk{1}, 'MarkerSize', mk{2}(1), 'LineWidth',mk{2}(2),'MarkerEdgeColor',mk{3})
plot(ptwx, ptwy, mk{1}, 'MarkerSize', mk{2}(1), 'LineWidth',mk{2}(2),'MarkerEdgeColor',mk{3})
legend('T(s) = Gw','S(s) = Gz','Gm(s) = -Gw(s)','G0(s)');

fsiz=22;

text(ptzx, ptzy*0.7,['W_{BS}= ' num2str(round(ptzx)) ' rad/s  '],...
    'FontSize',fsiz(1),'HorizontalAlignment','right')
text(ptwx, ptwy*0.7,['W_{BT}= ' num2str(round(ptwx)) ' rad/s  '],...
    'FontSize',fsiz(1),'HorizontalAlignment','left')
text(Wpm, -ptwy*0.7,['W_{c}= ' num2str(round(Wpm)) ' rad/s  '],...
    'FontSize',fsiz(1),'HorizontalAlignment','center')
hold off;

fprintf('W_{BS} = %i rad/s = %iHz\n',ptzx,ptzx*180/pi)
fprintf('W_{BT} = %i rad/s = %iHz\n',ptwx,ptwx*180/pi)
fprintf('W_{C} = %i rad/s = %iHz\n',Wpm,Wpm*180/pi)

title(S0c.linmod.filename,'interpreter','none')



