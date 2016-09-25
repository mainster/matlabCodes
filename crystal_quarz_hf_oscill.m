%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bericht psberichtv2 SS2016 - Abschnitt Oszillatoren
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Crystal / Ceramic resonator 3. order model
spa=['\n' repmat('-',1,20) '\n'];
% clear w*

syms Cp Cs Rs Ls fp fs ; 
solve(fs==1/(2*pi*sqrt(Ls*Cs)),Cs)

clear Cp Cs Rs Ls fp fs ; 
% assumeAlso([Cp Cs Rs Ls fp fr] > 0);
syms s w

if 1
   syms Cp Cs Rs Ls fp fs w reals ; 
   syms s
   
   Zlr=  @(s) Rs+s*Ls;
   Xcp=  @(s) 1./(s*Cp);
   Zs=   @(s) Rs+s*Ls+1./(s*Cs);
   Z=    @(s) ol.par2(Zs(s),Xcp(s));
   
   pretty(simplify(Z(s),'steps',300))
   
   return
end
% Bauteile H. Sapotta S.49
Rs=1;   
Cp=2e-9;   
Ls=1e-6;
fs=1e6;
Cs=1/(4*Ls*pi^2*fs^2);  
Cs=98.9e-12;
%
% Zlr=  @(w) Rs+1i.*w.*Ls;
% Xcp=   @(w) 1./(1i.*w.*Cp);
% Zs=   @(w) Rs+1i.*w.*Ls+1./(1i.*w.*Cs);
% Z=    @(w) ol.par2(Zs(w),Xcp(w));

Zlr=  @(f) Rs+1i*2*pi.*f.*Ls;
Xcp=  @(f) 1./(1i.*2*pi.*f.*Cp);
Zs=   @(f) Rs+1i.*2*pi.*f.*Ls+1./(1i.*2*pi.*f.*Cs);
Z=    @(f) ol.par2(Zs(f),Xcp(f));

s=tf('s');
ss.Zlr = Rs+s*Ls;
ss.Xcp = 1/(s*Cp);
ss.Zs = Rs+s*Ls+1/(s*Cs);
ss.Z  = parallel(ss.Zs, ss.Xcp);
% fs=1/(2*pi*sqrt(Ls*Cs));
% fp=1/(2*pi*sqrt(Ls*Cs*Cp/(Cs+Cp)));
% fprintf([spa 'fs=%3g\nfp=%3g\t\tdf=%0gkHz\n'],fs, fp, (fp-fs)*1e-3)
%ww=logspace(6,9,1000);
%ff=linspace(1e5,30e6,2000);
ff=logspace(4,8,2000);
% ww2=ww;

%%

f1 = figure(1);
delete(findall(0,'type','line'));
SUBS=220;
%%
sp(1)=subplot(SUBS+1);
loglog(ff,abs(Zlr(ff))); hold all; 
loglog(ff,abs(Xcp(ff))); hold off;

sp(2)=subplot(SUBS+3);
loglog(ff,abs(Zs(ff))); hold all; 
loglog(ff,abs(Z(ff))); hold off;

sp(3)=subplot(SUBS+2);
bodeplot(ss.Xcp,ff,ol.optb);   hold all;
bodeplot(ss.Zlr,ff,ol.optb);   hold off;

sp(4)=subplot(SUBS+4);
bodeplot(ss.Zs,ff,ol.optb);   hold all;
bodeplot(ss.Z,ff,ol.optb);   hold off;
%%
% 
% for k=1:length(sp)
%    xlim([1e6 1e7 ])
% end

return

%%
% Zsp=simplify(ol.par2(Zs,Zp),'steps',250);
% pretty(Zsp)
% 
% ZZs=Rs_+s*Ls_+1/(s*Cs_);
% ZZp=1/(s*Cp_);
% ZZsp=parallel(ZZs,ZZp)
% 
% gg=subs(Zsp,{'Rs','Ls','Cs','Cp'},{Rs_,Ls_,Cs_,Cp_})
% 
% g.Zp=vpa(subs(Zp,{'Cp','s'},{Cp_,1i*w}), 3);
% g.Zl=vpa(subs(Zl,{'Ls','s'},{Ls_,1i*w}), 3);
% g.Zs=vpa(subs(Zs,{'Rs','Ls','Cs','s'},{Rs_,Ls_,Cs_,1i*w}), 3);
% g.Zsp=vpa(subs(Zsp,{'Rs','Ls','Cs','Cp','s'},{Rs_,Ls_,Cs_,Cp_,1i*w}), 3);

Zp=vpa(subs(Zp,'s',1i*w));
Zl=vpa(subs(Zl,'s',1i*w));
Zs=vpa(subs(Zs,'s',1i*w));
Zsp=vpa(subs(ol.par2(Zs,Zp),'s',1i*w),3);
% %%
% sv=symvar(char(Zp))';
% g.Zpf = str2func([sprintf(['@(%s',repmat(',%s',1,length(sv)-1),')'],sv{:}) char(Zp)]);
% sv=symvar(char(Zl))';
% g.Zlf = str2func([sprintf(['@(%s',repmat(',%s',1,length(sv)-1),')'],sv{:}) char(Zl)]);
% sv=symvar(char(Zs))';
% g.Zsf = str2func([sprintf(['@(%s',repmat(',%s',1,length(sv)-1),')'],sv{:}) char(Zs)]);
% sv=symvar(char(Zsp))';
% g.Zspf = str2func([sprintf(['@(%s',repmat(',%s',1,length(sv)-1),')'],sv{:}) char(Zsp)]);
% 
% dotExpansion('g.Zpf');
% dotExpansion('g.Zlf');
% dotExpansion('g.Zsf');
% dotExpansion('g.Zspf');

Zp=dotExpansion(Zp);
Zl=dotExpansion(Zl);
Zs=dotExpansion(Zs);
Zsp=dotExpansion(Zsp);
%%
clear ffl
ffl=logspace(7,9,20000);
%%
f1 = figure(1);
delete(findall(0,'type','line'));
SUBS=210;

subplot(SUBS+1);
% loglog(ffl,abs(subs(Zp,'w',ffl))); hold all; legend('show')
loglog(ffl,abs(subs(Zl,'w',ffl))); hold off;

subplot(SUBS+2);
loglog(ffl,subs(Zs,'w',ffl)); hold all; legend('show')
loglog(ffl,subs(Zsp,'w',ffl));  hold off


















% http://ffw.ti.com/lit/an/szza043/szza043.pdf
% https://de.wikipedia.org/wiki/Thomsonsche_Schwingungsgleichung
% http://ffw.ti.com/lit/an/szza043/szza043.pdf
% http://ffw.janson-soft.de/pe/pek08.pdf
% http://ffw.ti.com/lit/an/slua119/slua119.pdf
% https://de.wikipedia.org/wiki/Pierce-Schaltung
% http://ffw.electronics-tutorials.ws/oscillator/crystal.html
% http://ffw.crystek.com/documents/appnotes/pierce-gateintroduction.pdf
% https://de.wikipedia.org/wiki/Oszillatorschaltung#cite_note-4
% http://ffw.elektronikpraxis.vogel.de/analogtechnik/articles/168520/index3.html
% http://ffw.elektroniknet.de/e-mechanik-passive/passive/artikel/85677/2/
% https://de.wikipedia.org/wiki/Oszillatorschaltung#Kategorisierung
% https://de.wikipedia.org/wiki/Oszillator
% http://ffw.rainers-elektronikpage.de/Grundlagen-der-Quarztechnik/osckochbuch.pdf
% https://ffw.planet-schule.de/wissenspool/meilensteine-der-naturwissenschaft-und-technik/inhalt/hintergrund/elektrizitaet/michael-faraday-strom-aus-magneten.html
% https://home.zhaw.ch/kunr/ASV/scripts/ASV%20FS2009%20Oszillatoren_2009.pdf
% http://adamsiembida.com/negative-resistor-tutorial/
% http://ffw.jauch.de/ablage/med_00000818_1327049076_Quartz%20Crystal%20Theory%202007.pdf
% http://electronicdesign.com/analog/fundamentals-crystal-oscillator-design#10
% http://ffw.elektroniknet.de/e-mechanik-passive/passive/artikel/847/1/
% http://ff1.microchip.com/downloads/en/AppNotes/00826a.pdf
% https://ffw.google.de/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8&client=ubuntu#q=folgen+fehlerhafter+oszillatorschaltungen
% file:///tmp/MT41_05.pdf
% https://matlab.mathworks.com/
% https://de.wikipedia.org/wiki/Colpitts-Schaltung
% https://de.wikipedia.org/wiki/George_W._Pierce
% http://ganz.dummes-gelapp.de/dateien/brief-vertauschte-adressen.gif
% http://ffw.electronics-tutorials.ws/oscillator/oscillators.html
% http://ffw.infography.com/content/244921069240.html
% https://de.wikipedia.org/wiki/Schwingkreis#Oszillator
% https://de.wikipedia.org/wiki/Stabilit%C3%A4tskriterium_von_Barkhausen
% http://wff.ece.ohio-state.edu/~berger/summ_ritd/summ_ritd05.pdf
% http://ffw.rte.de/wp-content/uploads/2015/02/RTE-ARTIK-EF-Messung-Eigenfrequenzen-Fertigung-Labor-D-120727.pdf
% http://ffw.infineon.com/cms/de/product/microcontroller/8051-compatible-8-bit-microcontroller/xc800-i-family-industrial-and-multimarket/xc87x-series-industrial-and-multimarket/SAF-XC878-16FFI+5V+AC/productType.html?productType=db3a30442239c7bb0122bce3e1c2541f#ispnTab4
% http://unendlichkeit.net/wordpress/
% http://ffw.elektroniknet.de/e-mechanik-passive/passive/artikel/85677/1/
% http://wuerstchenundbier.com/5dc97eec22ae9841.html
% https://ffw.google.de/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8&client=ubuntu#q=Oszillatorschaltung+up+mit+parallelwiderstands
% http://ffw.elektronik-kompendium.de/sites/slt/0706241.htm
% https://ffw.tu-ilmenau.de/fileadmin/media/mne_ess/IEP_V13_Oszillatoren.pdf
% http://ffw.mikrocontroller.net/topic/380604#new
% http://electronicdesign.com/analog/fundamentals-crystal-oscillator-design
% http://ffw.loetstelle.net/grundlagen/schwingkreis/schwingkreis.php
% https://ffw.unibw.de/rz/dokumente/getFILE?fid=350767
% https://elearning.physik.uni-frankfurt.de/data/FB13-PhysikOnline/lm_data/lm_281/modul_2/teil_6/node50.html
% https://ffw.google.de/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8&client=ubuntu#q=definition%20oszillator
% http://ffw.elektroniknet.de/e-mechanik-passive/passive/artikel/847/





