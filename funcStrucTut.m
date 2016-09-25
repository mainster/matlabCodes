%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%   Export Blockdiagram to bitmap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveas(get_param('GalvoModel_v3_detailed','Handle'),'RT_projects/topmodel.bmp');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SIMFILES={  'GalvoModel_v31_19082014',...
            'GalvoModel_v31_CC'} ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kleiner workaround wegen Simulink SegFault %%%
%%% bei geöffneten scope- views                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
open_bd = find_system('type', 'block_diagram');
for k=1:length(SIMFILES)
    ind=find(~cellfun(@isempty, strfind(open_bd, SIMFILES{k})))

    if isempty(ind)
        disp('blockdiagram not found')
    else
        save_system(open_bd(ind));
        close_system(open_bd(ind));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SIMO systeme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1=linmod('GalvoModel_v3_SIMO');
[num, den] = linmod('GalvoModel_v3_SIMO');
sys1(:,2)=fieldnames(t1);
sys1(1,1)={t1}
sys1(:,3)=struct2cell(t1);
tf1=tf({num(1,:) ; num(2,:)}, den, 'OutputName',sys1{1}.OutputName );
%--------------- ^ ----------------------------------------
%-------------- | | ----------------------------------------
%-------------- | | ----------------------------------------
%-------------- | | ----------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return
%%%%%%%%%%%%  gen multiple transformation of cont. to discret systems
for k=[10,20,25,50,100], eval( sprintf(['tfGvD%i=c2d(gv.tfGv,%f,''zoh'')'],k,k*1e-6) ), end
for k=[10,20,25,50,100], eval( sprintf(['tfCCp1D%i=c2d(gv.tfCCred1,%f,''zoh'')'],k,k*1e-6) ), end
for k=[10,20,25,50,100], eval(sprintf(['Gp1D%i=gv.tfCCp1D%i*gv.tfGvD%i,%f;'],[1,1,1]*k,k*1e-6)), end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
st=whos;
sc=struct2cell(whos)
%ind1=strfind(ss(1,:),'tf')   %var name
%ind2=strfind(ss(4,:),'tf')   %var class

ind1=find(~cellfun(@isempty,strfind(ss(4,:),'tf')))
ind2=find(~cellfun(@isempty,strfind(ss(4,:),'zpk')))

%%% erzeuge liste mit variablennamen welche zur class 'tf' gehören
Vars=ss(1,find(~cellfun(@isempty,strfind(ss(4,:),'tf'))))


return 
fia=@(x,y)findall(x,y)
fia(f2,{'type','line'})


return

for k=1:5
    G0(k,:)=tf(10,[1 k*8 3 4]);
end

marg=arrayfun(@allmargin, G0)
marg(1:2,1).PhaseMargin

ma1=struct2cell(marg(:))
ma1a=[cell2mat(ma1(3:4,:)); zeros(1,size(ma1,2)); cell2mat(ma1(5,:))] 

Tres=(cell2mat(ma1(3,:))*pi/180)./(cell2mat(ma1(4,:)))

ma2=struct2array(marg(1,1))


return


        clear s p

        num='s^2+3s+p*j';
        den='s^2+g3s+p*js+i';
        num='(s+1)*(s+2)';
        den='(s+4)*(s+1+2*j)*(s+1-2*j)';
        num='(s+1)*(s+2)';
        den='(s+1)*(s+2)*(s+7)';
        
        
        nude={num;den};
        search={'s';'k';'i';'j'};
        for k=1:length(search)
            is=strfind(nude,search{k});
            nude{1}([is{1,:}])=[];    
            nude{2}([is{2,:}])=[];    
        end
        if ~isempty(find(isstrprop(nude{1},'alpha'))) || ~isempty(find(isstrprop(nude{2},'alpha')))
            disp('ffff22 gggg')
            return
        end
        di={num,den}
        
        % -----------------------------------------------------
        % Nullstellen und Pole berechnen
        % -----------------------------------------------------
        solc=cellfun(@solve,di(:),'UniformOutput',false)
        z1=eval(solc{1,1})        
        p1=eval(solc{2,1})

        syms s
        % -----------------------------------------------------
        % Koeffizienten von Zähler- und Nennerpolynom
        % -----------------------------------------------------
        if ~isempty(symvar(num))
            znum=sym2poly(eval(num));
        end
        if ~isempty(symvar(den))
            zden=sym2poly(eval(den));
        end
        
        % -----------------------------------------------------
        % bleiben komplexe Koeffizienten übrig:
        % --> keine konjugiert komplexen pole vorhanen!
        % -----------------------------------------------------
        if ~isempty(find(imag(p1))) || ~isempty(find(imag(z1)))
            disp('imag')
        end
        
%        sym(solc{2,:}(3))
        
%             
%         is2=cell2mat(is)
%         is3=arrayfun(@isempty,is)        
         return
        
%         if cellfun(@find isstrprop(nude{x},'alpha'))
%             disp('unknown non- numeric')
%             return;
%         end
        nude=[];
        di={sym(num); sym(den)};
        solc=cellfun(@solve,di(:),'UniformOutput',false);
        
        return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hh=[1 0 1 1 2 6 0 -j 2];
hh2={1 {''} 1 1 2 6 0 -j 2};
%??????????????
find(~arrayfun(@isempty,hh2'))
find(~cellfun(@isempty,hh2'))
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 cellfun(@isempty, {'';'54';'ef'})
 
 
figChilds=[get(1,'Children') ; get(1,'Children')]

inc=strfind(get(figChilds(:),'type'),'axes')        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc))            % take all children handles of all axes handle into structure

axisChilds=get(figChilds(ind),'Children')'
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hh=[1 0 1 1 2 6 0 -j 2];
hh2={1 {''} 1 1 2 6 0 -j 2};

find(~arrayfun(@isempty,hh))
find(~cellfun(@isempty,hh2))
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:3, figure; end;

all=findall(0,'type','figure');
getWrap=@(x,y)get(x,y);

cell2mat(getWrap(all,'Position'))

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms s
di={'s+4','','s+1+j','s+1-j','1','-1','s-3','s+3-2*j','s+3+2*j','7','-3','s-3'}

ind1=cellfun(@symvar,di,'UniformOutput',false)   % Test cell di including pole symbolic 
ind2=~cellfun(@isempty,ind1)
solc=cellfun(@solve,di(ind2),'UniformOutput',false)
sold=cellfun(@eval,solc,'UniformOutput',false)
sole=cell2mat(sold)
cmpxInd=find(arrayfun(@imag, sole))
try
    SOL=[cplxpair(sole(cmpxInd)) sort(sole(reInd))] 
catch err
    SOL=[]
    disp('he error')
end

reInd=find(~arrayfun(@imag, sole))
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms s
di={'s+4','','s+1+j','s+1-j','1','-1','s-3'};

ind1=cellfun(@symvar,di,'UniformOutput',false)   %<----------
ind2=~cellfun(@isempty,ind1)
solc=cellfun(@solve,di(ind2),'UniformOutput',false)
sold=cellfun(@eval,solc,'UniformOutput',false)
sole=cell2mat(sold)
arrayfun(@imag, sole)

cplxpair(sole(find(arrayfun(@imag, sole)))) % Testen ob konj. komplexes polpar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return

ed={'s+4','','s+1+j','s+1-j','1','-1','s-3'};


cellfun(@isempty, ed)
dd=cellfun(@symvar, ed,'UniformOutput',false)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cc=cellfun(@symvar,ed,'UniformOutput',false)   %<----------
cellfun(@isempty,cc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return

clf
subplot(121)
f1=figure(1);
plot(rand(1,10));
hold all;
plot(rand(1,10));

subplot(122)

nyquist(tf([1 2],[1 3 4]));

% for q=1:5
%     buff{q}=get(hpoedit(q),'String');
% end

load('funcStruc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all=findall(0,'type','text')
get(all(1),'String')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st=@(x) get(x,'String')

a.string=@(x) get(x,'String');
a.tag=@(x) get(x,'tag');

ge=@(x) symvar(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a.string(all)

%s.a=@(x) arrayfun(@get,x)     % <--------------------------

%b=@(x,y) arrayfun(@(y)get,x,y)     % <--------------------------


return


S.a = @sin;  S.b = @cos;  S.c = @tan;
structfun(@(x)x(linspace(1,4,3)), S, 'UniformOutput', false)


days = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};
abbrev = cellfun(@(x) x(1:3), days, 'UniformOutput', false)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num='s+1'; den='(s+2)*(s+3)*(s+2+3*j)*(s+2-3*j)'
di={sym(num); sym(den)}
solc=cellfun(@solve,di(:),'UniformOutput',false)
sold=cellfun(@eval,solc,'UniformOutput',false)
sole=cell2mat(sold)
cmpxInd=~isempty(arrayfun(@imag, sole))
reInd=isempty(arrayfun(@imag, sole))

try
    SOL=[cplxpair(sole(cmpxInd)) sort(sole(reInd))]; 
    disp('Alle pole liegen komplex konjugiert vor')
catch err
    SOL=[];
    disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return

rang=@(x)[min([x{:}]);max([x{:}])]
A={ sqrt(10*(rand(2,10)-0.5)), [sqrt(10*(rand(2,10)-0.5)) sqrt(10*(rand(2,5)-0.5))] }

%min([A{:}])
hh=rang(A(:))
min(hh(1))
max(hh(2))

min(hh(2))
max(hh(1))
return

ed={'s+4','','s+1+j','s+1-j','1','s-3'};
minW=@(x,y)min(x,y)
minW([1 2 3 3], [4 2 5 0.9])

gg=rand(2,10)-0.5;
min( minW(gg(1,:),gg(2,:)) )

return 

ed={'s+4','','s+1+j','s+1-j','1','s-3'};

clf
subplot(121)
f1=figure(1);
plot(rand(1,10));
hold all;
plot(rand(1,10));

subplot(122)

nyquist(tf([1 2],[1 3 4]));

% for q=1:5
%     buff{q}=get(hpoedit(q),'String');
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all=findall(0,'type','text')
get(all(1),'String')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str=@(x) get(x,'String')
str(all)

a.string=@(x) get(x,'String')
a.tag=@(x) get(x,'tag')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getWrap= @(x,y)get(x,y)
cell2mat(getWrap(ha,'Position'))/ppc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


s.a=@(x) arrayfun(@get,x)     % <--------------------------

b=@(x,y) arrayfun(@(y)get,x,y)     % <--------------------------


return


S.a = @sin;  S.b = @cos;  S.c = @tan;
structfun(@(x)x(linspace(1,4,3)), S, 'UniformOutput', false)


days = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};
abbrev = cellfun(@(x) x(1:3), days, 'UniformOutput', false)