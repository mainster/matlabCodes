function simple_gui2
% SIMPLE_GUI2 Select a data set from the pop-up menu, then
% click one of the plot-type push buttons. Clicking the button
% plots the selected data in the axes.

% Monitor 24"=60.96cm
% 16:9
% Breite:   53cm
% Höhe:     37cm
%

subsize=[12 10];
da=3;
posf=[3,3,45,25];
posax(1,:)=[2,2,subsize];
posax(2,:)=[2,subsize(2)+da,subsize];
posax(3,:)=[subsize(1)+da,2,subsize];
posax(4,:)=[subsize(1)+da,subsize(2)+da,subsize];

posui(1,:)=[45-5,4,3,1.4];
posui(2,:)=posui(1,:)+[0 2 0 0];
posui(3,:)=posui(2,:)+[0 2 0 0];
posui(4,:)=posui(3,:)+[0 2 0 0];
posui(5,:)=posui(3,:)+[-4 2 2 2];

width=(60.96/sqrt(16^2+9^2))*16;
hight=(60.96/sqrt(16^2+9^2))*9;

%ppc=1080/hight
ppc=1920/width;  % pix/cm

   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','on','Position',posf*ppc);
    set(f,'Units','Centimeters');
   %  Construct the components.
   hsurf = uicontrol('Style','pushbutton','String','Surf',...
          'Position',posui(1,:)*ppc,...
          'Callback',{@surfbutton_Callback});
   hmesh = uicontrol('Style','pushbutton','String','Mesh',...
          'Position',posui(2,:)*ppc,...
          'Callback',{@meshbutton_Callback});
   hcontour = uicontrol('Style','pushbutton',...
          'String','Countour',...
          'Position',posui(3,:)*ppc,...
          'Callback',{@contourbutton_Callback}); 
   htext = uicontrol('Style','text','String','Select Data',...
          'Position',posui(4,:)*ppc);
  htexin = uicontrol('Style','edit',...
      'String','Countour',...
      'Position',posui(5,:)*ppc,...
      'Callback',{@edittext1_Callback}); 
   hpopup = uicontrol('Style','popupmenu',...
          'String',{'Peaks','Membrane','Sinc'},...
          'Position',[300,50,100,25],...
          'Callback',{@popup_menu_Callback});
   ha(3) = axes('Units','Pixels','Position',posax(1,:)*ppc); 
   ha(1) = axes('Units','Pixels','Position',posax(2,:)*ppc); 
   ha(4) = axes('Units','Pixels','Position',posax(3,:)*ppc); 
   ha(2) = axes('Units','Pixels','Position',posax(4,:)*ppc); 
   align([hsurf,hmesh,hcontour,htext,hpopup],'East','None');
   
	p1=zpk([2],[-2 -1-j -1+j],1);
    c1=zpk([],[],1);
    G0(1)=c1*p1;
   
   % Create the data to plot.
   peaks_data = peaks(35);
   membrane_data = membrane;
   [x,y] = meshgrid(-8:.5:8);
   r = sqrt(x.^2+y.^2) + eps;
   sinc_data = sin(r)./r;
   
   % Initialize the GUI.
   % Change units to normalized so components resize 
   % automatically.
   set([f,ha,hmesh,hsurf,hcontour,htext,hpopup],...
   'Units','normalized');
    
   %Create a plot in the axes.
   current_data = G0(1);
    axes(ha(1))
    rlocus(current_data);
    axes(ha(2))
    pzmap(current_data);
    axes(ha(3))
    nyquist(current_data);
   % Move the GUI to the center of the screen.
%   movegui(f,'center');
   


   %Create a plot in the axes.
%    current_data = peaks_data;
%    surf(current_data);
%    % Assign the GUI a name to appear in the window title.
%    set(f,'Name','Simple GUI')
%    % Move the GUI to the center of the screen.
%    movegui(f,'center')
%    % Make the GUI visible.
%    set(f,'Visible','on');
 
   %  Callbacks for simple_gui. These callbacks automatically
   %  have access to component handles and initialized data 
   %  because they are nested at a lower level.
 
   %  Pop-up menu callback. Read the pop-up menu Value property
   %  to determine which item is currently displayed and make it
   %  the current data.
      function popup_menu_Callback(source,eventdata) 
         % Determine the selected data set.
         str = get(source, 'String');
         val = get(source,'Value');
         % Set current data to the selected data set.
         switch str{val};
         case 'Peaks' % User selects Peaks.
            current_data = peaks_data;
         case 'Membrane' % User selects Membrane.
            current_data = membrane_data;
         case 'Sinc' % User selects Sinc.
            current_data = sinc_data;
         end
      end
  
   % Push button callbacks. Each callback plots current_data in
   % the specified plot type.
 
   function surfbutton_Callback(source,eventdata) 
   % Display surf plot of the currently selected data.
      surf(current_data);
   end
 
   function meshbutton_Callback(source,eventdata) 
   % Display mesh plot of the currently selected data.
      mesh(current_data);
   end
 
   function contourbutton_Callback(source,eventdata) 
   % Display contour plot of the currently selected data.
      contour(current_data);
   end 

    function edittext1_Callback(hObject, eventdata, handles)
    pole = get(hObject,'String');
    sprintf('string is: %s',pole)
    
    c1=zpk([],[str2num(pole)],1);
    G0(1)=c1*p1;

       current_data = G0(1);
    axes(ha(1))
    rlocus(current_data);
    axes(ha(2))
    pzmap(current_data);
    axes(ha(3))
    nyquist(current_data);
    
    end
 
end 