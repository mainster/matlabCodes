function exp_abs_stochastik()
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stochastik Vorbereitung - Erwartungswerte von Prozessen
% mit symmetrischer Dichtefunktion 09-02-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eigenschaften des Erwartungswert-Operators
%
% Def.: E{Y}=E{g(X)}=int(g(x)*fx(x),-inf,inf)
% Linearität ...
% Lin. Transformation:  E{Y}=E{a*X+b}=a*E{X}+b
% Symm. Dichtefunktion: fx(c-X)=fx(X-c --> E{X}=c
%
% SS2015
%
   syms a b c real

   global xx a_ b_ c_ fx sla slb
   xx=linspace(-5,5,500);
   assumeAlso(c > 0);
   a_=1; b_=1; c_=1;

   fx=@(x,a,b,c) c*exp(-abs(x'*a+b));
   f1=figure(1);

   plot(xx,fx(xx,a_,b_,c_))
   sla = uicontrol('Parent',f1,'String','sla','Style','slider','Position',[10,4,210,23],...
      'value',1, 'min',-2, 'max', 2, 'Callback',@display_slider_value);  
   slb = uicontrol('Parent',f1,'String','slb','Style','slider','Position',[240,4,250,23],...
      'value',1, 'min',-2, 'max', 2, 'Callback',@display_slider_value);  

   set(sla,'UserData',{xx,a_,b_,c_,fx})
   set(slb,'UserData',{xx,a_,b_,c_,fx})
end

function display_slider_value(hObject,obj)
   global xx a_ b_ c_ fx

   xx = hObject.UserData{1};
   if strfind(obj.Source.String,'sla')
      a_ = hObject.Value;
%      b_ = hObject.UserData{3};
   end
   
   if strfind(obj.Source.String,'slb')
      b_ = hObject.Value;
%      a_ = hObject.UserData{2};
   end
   
   c_ = hObject.UserData{4};
   fx = hObject.UserData{5};

   plot(xx,fx(xx,a_,b_,c_))
   legend(sprintf('a=%.3g\nfx(x)\nb=%.3g',a_,b_))
end
