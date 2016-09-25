
% Monitor 24"=60.96cm
% 16:9
% Breite:   53cm
% Höhe:     37cm
%
ppc=1920/((60.96/sqrt(16^2+9^2))*16);


%DimFigure=[3,3,45,24]*ppc;
deltaVert=-12;
%DimFigure=[3,6,45+deltaVert,16]*ppc;
%DimFigure=[8.8, 11.6, 33.7, 16]*ppc;
DimFigure=[4.8 5.7 42 23];
WX=DimFigure(3);
WY=DimFigure(4);
%DimAxis=[1,1,8,7];
DimAxis=[1.5, 1.5 , 12, 10];
hiaxis=DimAxis(end);
wiaxis=DimAxis(end-1);

DimButton=[ 40+deltaVert, 4, 3, 1.4];
hspace=0.4;
vspace=0.4;


DimPoleEdit=[45+deltaVert-6*(2.2+0.25*vspace/ppc), 8, 2.2, 0.9];

for i=1:5
    editsv(i,:)=DimPoleEdit+[(i-1)*(DimPoleEdit(end-1)+vspace),0, 0, 0];
end
%editsv(6,[3 4])=editsv(6,[3 4])/1.6;

editsh=editsv;
editsh(:,2)=editsh(:,2)+ones(length(editsh),1)*0.5*(DimPoleEdit(end-1)'+hspace);

editsv(6,:)=DimPoleEdit;
editsv(6,2)=editsv(6,2)-4;

editsv(7,:)=DimPoleEdit;
editsv(7,3)=editsv(7,3)*1.2;
editsv(7,2)=editsv(7,2)-4;
editsv(7,1)=editsv(7,1)+3;


buts(1,:)=DimButton;
buts(2,:)=DimButton+[0, DimButton(end)+vspace, 0,  0];

for i=1:5
    posax(i,:)=DimAxis;
end
% posax(2,1)=posax(2,1)+wiaxis+2*vspace;
% posax(3,2)=posax(3,2)+hiaxis+2*hspace;
% posax(4,1)=posax(4,1)+wiaxis+2*vspace;
% posax(4,2)=posax(4,2)+hiaxis+2*hspace;
% posax(5,1)=posax(5,1)+2*(wiaxis+2*vspace);
% posax(5,2)=posax(5,2)+hiaxis+2*hspace;

markSize=7;
hpl=[];
hplMa=[];

% pol=char(zeros(1,10));
% ns=char(zeros(1,10));
pol=[];
ns=[];

str=@(x) get(x,'String');
getWrap=@(x,y) get(x,y);
mm2pix=@(x) (x*72/25.4)


P=nyquistoptions;
P.ShowFullContour='off';

RANGES=struct( 'rlocus',    [1 1 1 1],...
                'pzmap',    [1 1 1 1],...
                'nyquist',  [1 1 1 1],...
                'step',     [1 1 1 1]);

md=struct(  'auto',1,...
            'hold',0,...
            'num',[],...
            'den',[],...
            'zeros',[],...
            'poles',[],...
            'gain',[],...
            'ranges', RANGES,...
            'lineWidth',1,...
            'markerSize',10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Only for development purposes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evalin('base',['RANGES=struct( ''rlocus'',    [1 1 1 1],''pzmap'',    [1 1 1 1],''nyquist'',  [1 1 1 1],''step'',     [1 1 1 1]);']);
evalin('base',['md=struct(  ''auto'',1,''hold'',0,''num'',[],''den'',[],''zeros'',[],''poles'',[],''gain'',[],''ranges'', RANGES,''lineWidth'', 1,''markerSize'',10);']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    currPlant=zpk([2],[-2 -1-j -1+j],1);        
    [tfN tfD]=zp2tf([2],[-2 -1-j -1+j],1);
    initsym=tf2sym(tf(tfN,tfD));
    
    md.num=tfN;
    md.den=tfD;
    md.num=[1 -3];
    md.den=[1 2 1];

    
% ns= currPlant.z{:};
% pol=currPlant.p{:};
    Initstr={'s-2';'s^3+4*s^2+6*s+4'};
    Initstr={'s-2';'s^2+2*s+1'};
    Initstr={'s-2';'s+5*s^2+3*s^3+s^4-10'};
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%      Constructed and the main GUI 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pos=struct('wok',1,'pzmap',2,'bode',3,'nyquist',4,'step',5)

f = figure('Visible','on','Position',DimFigure*ppc);
    set(f,'Units','Centimeters');
%  Construct the components.


    hbut(1)=uicontrol(  'Style','pushbutton','String','plot',...
                        'Position',buts(1,:)*ppc,...
                        'Callback',{@buttonZPK_Callback});

    hbut(2)=uicontrol(  'Style','pushbutton','String','do what',...
                        'Position',buts(2,:),...
                        'Callback',{@doWhat_Callback});

    for i=1:5
        hpoedit(i)=uicontrol('Style','edit',...
                        'String','',...
                        'Tag',sprintf('po#%i',i),...
                        'Position',editsv(i,:)*ppc,...
                        'Callback',{@pzedit_Callback}); 

        hzoedit(i)=uicontrol('Style','edit',...
                        'String','',...
                        'Tag',sprintf('zo#%i',i),...
                        'Position',editsh(i,:)*ppc,...
                        'Callback',{@pzedit_Callback}); 
    end

    hpoedit(i+1)=uicontrol('Style','edit',...
                        'String','markersize',...
                        'Position',editsv(6,:)*ppc,...
                        'Callback',{@markerin_Callback}); 


    hauto = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'Position',  editsv(7,:)*ppc, ...
                        'String',   'Autoscale', ...
                        'Tag',      'autosc',...
                        'Value',    1);

    hhold = uicontrol( 'Style', 'radiobutton', ...
                        'Callback', {@radio_Callback},...
                        'Units',    'pixels', ...
                        'Position',  (editsv(7,:)+[0 1 0 0])*ppc, ...
                        'String',   'Hold', ...
                        'Tag',      'hold',...
                        'Value',    0);
                    

    for i=1:5
        ha(i)=axes('Units','Pixels','Position',DimAxis*ppc);
    end
    
    % Create the button group.
    hui = uibuttongroup('visible','on','Position',[0 0 20 20]*ppc);
    set(hui,'units','pixels')
    
        htfnum = uicontrol('Style','edit','String', Initstr{1},...
                            'Tag','numerator','Units', 'pixel',...
                            'BackgroundColor',[1 1 1],...
                            'Position',[1, 8, 8, 1.1]*ppc,...
                            'parent',hui,...
                            'Callback',{@tfeditbox_Callback}); 

        htfden = uicontrol('Style','edit','String',Initstr{2},...
                            'Tag','denominator','Units', 'pixel',...
                            'BackgroundColor',[1 1 1],...
                            'Position',[1, 7, 8, 1.1]*ppc,...
                            'parent',hui,...
                            'Callback',{@tfeditbox_Callback});
                    
    % Create three radio buttons in the button group.
    u0 = uicontrol('Style','radiobutton','String','Option 1',...
        'pos',[10 350 100 30],'parent',hui,'HandleVisibility','off');
    u1 = uicontrol('Style','radiobutton','String','Option 2',...
        'pos',[10 250 100 30],'parent',hui,'HandleVisibility','off');
    u2 = uicontrol('Style','radiobutton','String','Option 3',...
        'pos',[10 150 100 30],'parent',hui,'HandleVisibility','off');
    % Initialize some button group properties. 
    set(hui,'SelectionChangeFcn',@selcbk);
    set(hui,'SelectedObject',[]);  % No selection
    set(hui,'Visible','on');


    set(ha(1:5),'box','on')
    
    na={'wok' 'pzmap' 'bode' 'nyquist' 'step'}
    for i=1:5
        axes(ha(i));
        text(0.5,0.5, na(i))
    end

    align([ha([pos.wok pos.pzmap pos.bode])], 'Fixed',mm2pix(10),'HorizontalAlignment')
    align([ha([pos.nyquist pos.step])], 'Fixed',mm2pix(10),'HorizontalAlignment')

    align([ha([pos.step pos.bode  ])],'Bottom','Fixed',mm2pix(10))
    align([ha([pos.nyquist pos.pzmap ])],'Bottom','Fixed',mm2pix(10))
    align([ha([pos.nyquist pos.wok ])],'Bottom','Fixed',mm2pix(10))
    
    posui=[get(ha(pos.bode),'Position') get(ha(pos.nyquist),'Position')]/ppc;

    set(hui,'position',[posui(1) posui(6) DimAxis(3:4)]*ppc)
    

    