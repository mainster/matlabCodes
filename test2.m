
function test2()
   syms a b c real

   global xx a_ b_ c_ fx
   xx=linspace(-5,5,500);
   assumeAlso(c > 0);
   a_=1; b_=1; c_=1;

   fx=@(x,a,b,c) c*exp(-abs(x'*a+b));
   f1=figure(1);

   plot(xx,fx(xx,a_,b_,c_))
   sla = uicontrol('Parent',f1,'String','sla','Style','slider','Position',[10,4,210,23],...
      'value',1, 'min',-2, 'max', 2, 'Callback',@display_slider_value);  
   slb = uicontrol('Parent',f1,'String','slb','Style','slider','Position',[240,4,440,23],...
      'value',1, 'min',-2, 'max', 2, 'Callback',@display_slider_value);  

   set(sla,'UserData',{xx,a_,b_,c_,fx})
   set(slb,'UserData',{xx,a_,b_,c_,fx})
end

function display_slider_value(hObject,obj)
   global xx a_ b_ c_ fx
   disp(obj.Source)
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

   disp(['Slider moved to ' num2str(a_)]);
   plot(xx,fx(xx,a_,b_,c_))
   legend(sprintf('fx(xx,%g,%g,%g)',a_,b_,c_))
end
