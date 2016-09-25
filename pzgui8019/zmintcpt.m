function     zmintcpt( ReqStr, fig_h )
% Services mouse-clicks in the PZGUI pole/zero map G.U.I's.

% The following copyrighted m-files comprise the PZGUI tool:
%    ** The contents of these files may not be included **
%    **  in any other program without explicit written  **
%    **    consent from the author, Mark A. Hopkins     **
%     bodepl.m        pzg_bodex.m     pzg_islink.m     pzg_seltxt.m
%     contents.m      pzg_box.m       pzg_islogx.m     pzg_tools.m
%     contourpl.m     pzg_c2d.m       pzg_isunwrp.m    pzg_tpwr.m
%     dpzgui.m        pzg_cntr.m      pzg_lims.m       pzg_txan.m
%     dupdatep.m      pzg_cphndl.m    pzg_menu.m       pzg_unre.m
%     figopts.m       pzg_d2c.m       pzg_moda.m       pzg_unwrap.m
%     fr_disp.m       pzg_disab.m     pzg_onoff.m      pzg_updtfilt.m
%     freqserv.m      pzg_efmt.m      pzg_pfesim.m     pzg_xtrfrq.m
%     gainfilt.m      pzg_err.m       pzg_prvw.m       pzgcalbk.m
%     helpserv.m      pzg_errvis.m    pzg_ptr.m        pzgui.m
%     ldlgfilt.m      pzg_fndo.m      pzg_recovr.m     pzmvserv.m
%     nicholpl.m      pzg_gle.m       pzg_reptxt.m     resppl.m
%     nyqistpl.m      pzg_grid.m      pzg_res.m        rlocuspl.m
%     pidfilt.m       pzg_inzpk.m     pzg_rsppfe.m     sensplot.m
%     pz_move.m       pzg_isdby.m     pzg_rss.m        updatepl.m
%     pzg_bkup.m      pzg_ishzx.m     pzg_scifmt.m     updtpzln.m
%                                     pzg_sclpt.m      zmimntcpt.m
% (c) 1996 - 2014
%    by Professor Mark A. Hopkins, Ph.D.
%       Electrical and Microelectronic Engineering
%       Rochester Institute of Technology
%       Rochester NY, USA 14623        Email:  mark.hopkins@rit.edu
%
% SHAREWARE INFORMATION:
%               FREE, IF USED ONLY FOR EDUCATIONAL PURPOSES.
%   Otherwise:
%    (corporations, companies, and other for-profit users) 
%    Individual licenses -- US$200 per computer
%    Site license -- US$2000 per industrial site, any number of users
%    Make check payable to "Mark A. Hopkins", and remit to address above
% ----------------------------------------------------------------------
global PZG 
global PZMoving
global pzg_drawbox
if isempty(PZG) && ~pzg_recovr 
  return
end
evalin('base','global PZG')

if ( nargin > 1 ) && ischar(ReqStr)
  local_service_request( ReqStr, fig_h );
  return
end

pzg_drawbox.button_down = 0;
pzg_drawbox.corner1 = [];
pzg_drawbox.corner2 = [];

gcf0 = gcbf;
if isempty(gcf0)
  gcf0 = gcf;
  if isempty(gcf0)
    return
  end
end
hndl = [];
if isappdata( gcbf,'hndl')
  hndl = getappdata( gcbf,'hndl');
end
if isfield(hndl,'ax') && isequal( 1, ishandle(hndl.ax) )
  gca0 = hndl.ax;
else
  gca0 = get(gcf0,'currentaxes');
end
if isempty(gca0) || ~isequal( gcf0, get( gca0,'parent') )
  return
end

CT_PZGUI = pzg_fndo( 1, 12,'fig_h');
DT_PZGUI = pzg_fndo( 2, 13,'fig_h');

if isfield( hndl,'dom_ndx')
  M = hndl.dom_ndx;
  if M == 1
    Domain = 's';
  else
    Domain = 'z';
  end
else
  if isempty( strfind( get(gcf0,'Name'),'iscrete') )
    Domain = 's';
    M = 1;
  else
    Domain = 'z';
    M = 2;
  end
end

PZG(M).Selection = [];

this_ButtonMotionFcn_string = ...
  ['global PZG;' ...
   'if pzg_disab,return,end,' ...
   'try,' ...
     'pzgcalbk(gcbf,''mouse motion'');' ...
     'pzg_ptr;' ...
   'catch,pzg_err(''C-T PZGUI mouse motion'');end,'];

drawbox = 0;
drawbox_h = pzg_fndo( M, M+11,'draw_box_checkbox');
if ~isempty(drawbox_h)
  drawbox = get( drawbox_h,'value');
end
 
set( gca0,'Interruptible','On','XLimMode','manual','YLimMode','manual');

if strcmp( get(gcf0,'SelectionType'),'open')

  local_service_request('open zoom', gcf0 )
  
  pzg_grid;
  if PZG(hndl.dom_ndx).pzg_show_frf_computation ...
    &&( isequal( hndl.ploth_ndx, 12 ) ||isequal( hndl.ploth_ndx, 13 ) )
    updtpzln( Domain )
  end
  return

elseif strcmp( get(gcf0,'SelectionType'),'normal') ...
  && ~strcmpi( get(gcf0,'pointer'),'hand') ...
  &&( ~strcmpi( get(gcf0,'pointer'),'arrow') || drawbox )
  % Either zooming or drawing a box.
  PZMoving = 0;
  set(gcf0,'WindowButtonMotionFcn', this_ButtonMotionFcn_string );
  
  temp0 = get(gcf0,'UserData');
  set(gcf0,'UserData',temp0,'Pointer','arrow');
  set(gcf0,'Interruptible','On')
  set(gca0,'Interruptible','On')
  if ( get(temp0(16,2),'Value') == 0 ) 
    % Not drawing a box
    
    % Determine if the user has clicked close to the stability boundary.
    CurrPt = get( gca0,'currentpoint');
    CurrPt = CurrPt(1,1)+1i*CurrPt(1,2);
    % If user clicked outside the axes area, ignore it.
    if ( real(CurrPt) < min(get( gca0,'xlim')) ) ...
      ||( real(CurrPt) > max(get( gca0,'xlim')) ) ...
      ||( imag(CurrPt) < min(get( gca0,'ylim')) ) ...
      ||( imag(CurrPt) > max(get( gca0,'ylim')) )
      return
    end
    
    if strcmpi( Domain,'s')
      Dist = abs(real(CurrPt))/diff(get( gca0,'xlim'));
      Dist_PZ = ...
        min( abs( [ CurrPt-PZG(1).PoleLocs; ...
                    CurrPt-PZG(1).ZeroLocs ] ) ...
                          /diff(get( gca0,'xlim')) ); %#ok<NASGU>
    else
      ucPt = exp(1i*angle(CurrPt));
      xDist = abs(real(CurrPt)-real(ucPt))/diff(get( gca0,'xlim'));
      yDist = abs(imag(CurrPt)-imag(ucPt))/diff(get( gca0,'ylim'));
      Dist = sqrt( xDist^2 + yDist^2 );
    end
    
    if Dist < 0.02
      % Determine the DT/CT conversion technique.
      link_menu_h = pzg_fndo( M, 11+M,'LinkMethod');
      if isempty(link_menu_h)
        LinkMethod = 2;
      else
        LinkMethod = get( link_menu_h(1),'value');
      end
      if strcmp( Domain,'s')
        ct_selected_freq_radsec = imag(CurrPt);
        if LinkMethod == 3
          z_pt = ( 2 + PZG(2).Ts*1i*ct_selected_freq_radsec ) ...
                /( 2 - PZG(2).Ts*1i*ct_selected_freq_radsec );
          dt_selected_freq_radsec = angle(z_pt)/PZG(2).Ts;   %#ok<*MSNU,NASGU>
        else
          dt_selected_freq_radsec = ct_selected_freq_radsec; %#ok<NASGU>
        end
      else
        dt_selected_freq_radsec = angle(CurrPt)/PZG(2).Ts;
        if dt_selected_freq_radsec < 0
          dt_selected_freq_radsec = 2*pi/PZG(2).Ts + dt_selected_freq_radsec;
        end
        if LinkMethod == 3
          ct_selected_freq_radsec = ...
            imag( 2/PZG(2).Ts*(exp(1i*angle(CurrPt))-1) ...
                   /(exp(1i*angle(CurrPt))+1) ); %#ok<NASGU>
        else
          ct_selected_freq_radsec = dt_selected_freq_radsec; %#ok<NASGU>
        end
      end
      
      if ~isequal( PZMoving, 1 )
        if strcmp( Domain,'s')
          PZG(1).FrqSelNdx = ...
            pzg_gle( PZG(1).BodeFreqs, abs(ct_selected_freq_radsec),'near');
          if ct_selected_freq_radsec >= 0
            PZG(1).NegSelect = 0;
          else
            PZG(1).NegSelect = 0;
          end
        elseif strcmp( Domain,'z')
          PZG(2).FrqSelNdx = ...
            pzg_gle( PZG(2).BodeFreqs, abs(dt_selected_freq_radsec),'near');
          if ( dt_selected_freq_radsec >= 0 ) ...
            &&( dt_selected_freq_radsec < pi/PZG(2).Ts )
            PZG(2).NegSelect = 0;
          else
            PZG(2).NegSelect = 1;
          end
        end
      end
      
      fig_h = allchild(0);
      fig_names = get(fig_h,'name');
      ct_ndx = strncmp('Continuous-Time', fig_names, 15 );
      dt_ndx = strncmp('Discrete-Time', fig_names, 13 );
      
      if strcmpi(Domain,'s') || sum(ct_ndx) ...
        || strcmpi(Domain,'z') || sum(dt_ndx)
        not_zooming = 0;
        freqserv( gcbf, 1, not_zooming );
        pzg_ptr;
      end
    else
      zoom('down')
    end
    XLims = get(temp0(1,1),'xlim');
    YLims = get(temp0(1,1),'ylim');
    if ( M == 1 ) && isequal( gcf0, PZG(1).plot_h{12}.fig_h )
      PZG(1).plot_h{12}.xlim = XLims;
      PZG(2).plot_h{12}.xlim = XLims;
      PZG(1).plot_h{12}.hndl.ax_xlim = XLims;
      PZG(2).plot_h{12}.hndl.ax_xlim = XLims;
      PZG(1).plot_h{12}.ylim = YLims;
      PZG(2).plot_h{12}.ylim = YLims;
      PZG(1).plot_h{12}.hndl.ax_ylim = YLims;
      PZG(2).plot_h{12}.hndl.ax_ylim = YLims;
    elseif ( M == 2 ) && isequal( gcf0, PZG(2).plot_h{13}.fig_h )
      PZG(1).plot_h{13}.xlim = XLims;
      PZG(2).plot_h{13}.xlim = XLims;
      PZG(1).plot_h{13}.hndl.ax_xlim = XLims;
      PZG(2).plot_h{13}.hndl.ax_xlim = XLims;
      PZG(1).plot_h{13}.ylim = YLims;
      PZG(2).plot_h{13}.ylim = YLims;
      PZG(1).plot_h{13}.hndl.ax_ylim = YLims;
      PZG(2).plot_h{13}.hndl.ax_ylim = YLims;
    end
    if isappdata( gcf0,'hndl')
      hndl = getappdata( gcf0,'hndl');
      hndl.ax_xlim = XLims;
      hndl.ax_ylim = YLims;
      setappdata( gcf0,'hndl', hndl );
    end
    set(temp0(4,1),'Ydata', YLims );
    set(temp0(5,1),'Xdata', XLims );
    set(temp0(1,1),'XLimMode','manual','YLimMode','manual')
    if strcmpi( Domain,'s')
      pzg_grid( temp0, gcf0, gca0, 12, PZG(1).plot_h{12}.hndl );    
    end
    if PZG(hndl.dom_ndx).pzg_show_frf_computation ...
      &&( isequal( hndl.ploth_ndx, 12 ) ||isequal( hndl.ploth_ndx, 13 ) )
      updtpzln( Domain )
    end
  else
    % Drawing a box
    % Make sure the cursor is within the axes limits.
    ax0_h = get( gcf0,'currentaxes');
    ax_xlim = get(ax0_h,'xlim');
    ax_ylim = get(ax0_h,'ylim');
    Corner1 = get(gca0,'CurrentPoint');
    if ( Corner1(1,1) > ax_xlim(1) ) ...
      &&( Corner1(1,1) < ax_xlim(2) ) ...
      &&( Corner1(1,2) > ax_ylim(1) ) ...
      &&( Corner1(1,2) < ax_ylim(2) )
    
      pzg_drawbox.button_down = 1;
      set(gcf0,'WindowButtonUpFcn', ...
        ['global PZMoving pzg_drawbox,' ...
         'PZMoving=0;' ...
         'pzg_drawbox.button_down=0;' ...
         'clear pzg_drawbox PZMoving,' ...
         'pzg_box([],1)']);
      pzg_drawbox.corner1 = Corner1;
      Corner2 = get(gca0,'CurrentPoint');
      pzg_drawbox.corner2 = Corner2;
      pzg_box('redraw box')
    end
  end

elseif ~isempty( strfind( get(gcf0,'SelectionType'),'ext') ) ...
  ||~isempty( strfind( get(gcf0,'SelectionType'),'alt') )  ...
  ||strcmpi( get(gcf0,'pointer'),'arrow') ...
  ||strcmpi( get(gcf0,'pointer'),'hand')
  % Moving a pole or zero?
   
  % If any ui controls are disabled, ignore button down
  if ~isempty(gcbf)
    if pzg_disab
      return
    end
  end
  
  temp0 = get(gcf0,'UserData');
  xlim = get(gca0,'XLim');
  diffX = diff(xlim);
  ylim = get(gca0,'YLim');
  diffY = diff(ylim);
  CurrPt = get(gca0,'CurrentPoint');
  actual_CurrPt = CurrPt(1,1)+1i*CurrPt(1,2);
  CurrPt = CurrPt(1,1)+1i*abs(CurrPt(1,2));
  if ~isempty(PZG(M).ZeroLocs)
    [ temp1, tempNdx1 ] = ...
        sort( sqrt( (abs(real(PZG(M).ZeroLocs-CurrPt))/diffX).^2 ...
                   + (abs(imag(PZG(M).ZeroLocs-CurrPt))/diffY).^2 ) );
    temp1 = temp1(1);
    tempNdx1 = tempNdx1(1);
  else
    temp1 = inf;
  end
  if ~isempty(PZG(M).PoleLocs)
    [ temp2, tempNdx2 ] = ...
        sort( sqrt( (abs(real(PZG(M).PoleLocs-CurrPt))/diffX).^2 ...
                   + (abs(imag(PZG(M).PoleLocs-CurrPt))/diffY).^2 ) );
    temp2 = temp2(1);
    tempNdx2 = tempNdx2(1);
  else
    temp2 = inf;
  end  
  if ( temp1 < temp2 ) && ( temp1 < inf )
    PZG(M).Selection = [1 tempNdx1 ];
    CurrDiff = temp1;
  elseif temp2 < inf
    PZG(M).Selection = [2 tempNdx2 ];
    CurrDiff = temp2;
  else
    CurrDiff = inf;
    PZG(M).Selection = [];
    PZMoving = 0;
  end

  if ( CurrDiff < 0.015 ) ...
    &&( strcmpi( get(gcf0,'pointer'),'hand') ...
       || strcmpi( get(gcf0,'pointer'),'arrow') )
    % YES, moving a pole or zero.
    % Cut link from other plane, if there is one.
    if strcmpi( Domain,'s')
      if ~isempty(DT_PZGUI)
       tempUDZ = get(DT_PZGUI,'UserData');
       set( tempUDZ(14,2),'Value',0 );
       set( tempUDZ(14:15,2),'backgroundcolor',PZG(2).DefaultBackgroundColor );
      end
    else
      if ~isempty(CT_PZGUI)
        tempUD = get(CT_PZGUI,'UserData');
        set( tempUD(14,2),'Value',0 );
        set( tempUD(14:15,2),'backgroundcolor',PZG(1).DefaultBackgroundColor );
      end
    end

    if numel(PZG(M).Selection) > 1
      if PZG(M).Selection(1) == 1
        set( temp0(8,2),'Value',PZG(M).Selection(2) );
        try
          set(gcf0,'Pointer','hand');
        catch %#ok<CTCH>
          set(gcf0,'Pointer','arrow');
        end
      else
        set( temp0(7,2),'Value',PZG(M).Selection(2) );
        try
          set(gcf0,'Pointer','hand');
        catch %#ok<CTCH>
          set(gcf0,'Pointer','arrow');
        end
      end
    end
    
    % The user is trying to drag a pole or zero to a new location.
    save_undo_info(M);
    if strcmpi( Domain,'s')
      ButtonMotionFcn_string = ...
       ['global PZG;' ...
        'global PZMoving;' ...
        'if pzg_disab,return,end,' ...
        'try,' ...
          'if isempty(PZMoving)||~PZMoving;' ...
            'if numel(PZG(1).Selection)>1;' ...
              'PZMoving=1;' ...
              'tempCC=pzg_fndo(1,12,''fig_h'');' ...
              'tempCT=get(tempCC,''UserData'');' ...
              'pz_move(''s'');' ...
            'else;' ...
              'pzgcalbk(gcbo,''mouse motion'');' ...
              'pzg_ptr;' ...
            'end;' ...
          'end;' ...
          'PZMoving=0;' ...
          'pzg_unre;' ...
        'catch,pzg_err(''C-T PZGUI mouse motion'');end,' ...
        'clear tempCC tempCT'];
      set(gcf0,'WindowButtonMotionFcn', ButtonMotionFcn_string );
      
      
      def_ButtonMotionFcn_string = ...
        ['global PZG;' ...
         'if pzg_disab,return,end,' ...
         'try,' ...
           'pzgcalbk(gcbf,''''mouse motion'''');' ...
           'pzg_ptr;' ...
         'catch,pzg_err(''''C-T PZGUI mouse motion'''');end,'];
      def_ButtonUpFcn_string = ...
        ['global PZMoving pzg_drawbox,' ...
         'PZMoving=0;' ...
         'pzg_drawbox.button_down=0;' ...
         'clear pzg_drawbox PZMoving,' ...
         'pzg_box([],1)'];

      set(gcf0,'WindowButtonUpFcn', ...
        ['global PZG PZMoving;' ...
         'if pzg_disab,return,end,' ...
         'try,' ...
           'temp_buttonups2_ui=findobj(gcbf,''type'',''uicontrol'');', ...
           'set(temp_buttonups2_ui,''enable'',''off'');' ...
           'prev_msgs_h=findobj(allchild(0),''name'',''CALCULATING'');' ...
           'if isempty(prev_msgs_h),' ...
             'temp_buMsgHndls=msgbox(' ...
               '''Computation may take a minute.   Please wait ...'',' ...
               '''CALCULATING'');' ...
             'drawnow,pause(0.01),' ...
             'tempH=findobj(temp_buMsgHndls,''Tag'',''OKButton'');' ...
             'if~isempty(tempH),' ...
               'delete(tempH),' ...
             'end,' ...
           'else,' ...
             'temp_buMsgHndls=prev_msgs_h(1);' ...
             'if numel(prev_msgs_h)>1,' ...
               'delete(prev_msgs_h(2:end));' ...
             'end,' ...
           'end,' ...
           'clear prev_msgs_h,' ...
           'set(gcbf,''Pointer'',''arrow'');' ...
           'if ~isempty(PZG(1).Selection);' ...
             'PZMoving=1;figure(gcbf);' ...
             'pz_move(''s'');pzgui;updatepl;' ...
             'PZG(1).Selection=[];' ...
           'end;' ...
           'if exist(''temp_buMsgHndls'',''var'')' ...
             '&&isequal(1,ishandle(temp_buMsgHndls)),' ...
             'close(temp_buMsgHndls);' ...
           'end,' ...
           'PZMoving=0;' ...
           'set(gcbf,''WindowButtonUpFcn'',' ...
                '[''' def_ButtonUpFcn_string ''']);' ...
           'set(gcbf,''WindowButtonMotionFcn'',' ...
                '[''' def_ButtonMotionFcn_string ''']);' ...
           'temp_buttonups2_ui=findobj(gcbf,''type'',''uicontrol'');', ...
           'set(temp_buttonups2_ui,''enable'',''on'');' ...
           'pzg_unre;' ...
           'clear tempH temp_buMsgHndls,' ...
         'catch,' ...
           'pzg_err(''C-T PZGUI button up'');' ...
           'temp_buttonups2_ui=findobj(gcbf,''type'',''uicontrol'');', ...
           'set(temp_buttonups2_ui,''enable'',''on'');' ...
           'pzg_unre;' ...
           'clear tempH temp_buMsgHndls,' ...
         'end,' ...
         'clear PZMoving temp_buttonups2_ui prev_msgs_h']);
    else
      ButtonMotionFcn_string = ...
        ['global PZG;' ...
         'temp_buttonmotionz2_ui=findobj(gcbf,''type'',''uicontrol'');', ...
         'if ~isempty(temp_buttonmotionz2_ui)' ...
           '&&strcmp(get(temp_buttonmotionz2_ui(1),''enable''),''off''),' ...
           'clear temp_buttonmotionz2_ui,' ...
           'return,' ...
         'end,' ...
         'try,' ...
           'global PZMoving,' ...
           'if isempty(PZMoving)||~PZMoving;' ...
             'if numel(PZG(2).Selection)>1;' ...
               'PZMoving=1;' ...
               'tempDD=findobj(allchild(0),''Name'',PZG(2).PZGUIname);' ...
               'tempDT=get(tempDD,''UserData'');' ...
               'pz_move(''z'');' ...
             'else;' ...
               'pzgcalbk(gcbo,''mouse motion'');' ...
               'pzg_ptr;' ...
             'end;' ...
           'end;' ...
           'PZMoving=0;' ...
         'catch,pzg_err(''D-T PZGUI mouse motion'');end,' ...
         'clear tempDT tempDD tempC PZMoving temp_buttonmotionz2_ui;'];
      set(gcf0,'WindowButtonMotionFcn', ButtonMotionFcn_string );
      
      def_ButtonMotionFcn_string = ...
        ['global PZG,' ...
         'temp_mousemotionz_ui=findobj(gcbf,''''type'''',''''uicontrol'''');', ...
         'if ~isempty(temp_mousemotionz_ui)' ...
           '&&strcmp(get(temp_mousemotionz_ui(1),''''enable''''),''''off''''),' ...
           'clear temp_mousemotionz_ui,' ...
           'return,' ...
         'end,' ...
         'try,' ...
           'pzgcalbk(gcbf,''''mouse motion'''');' ...
           'pzg_ptr;' ...
         'catch,pzg_err(''''D-T PZGUI mouse motion'''');end,' ...
         'clear temp_mousemotionz_ui,'];
      def_ButtonUpFcn_string = ...
        ['global PZMoving pzg_drawbox,' ...
         'PZMoving=0;' ...
         'pzg_drawbox.button_down=0;' ...
         'clear pzg_drawbox PZMoving,' ...
         'pzg_box([],1)'];
      
      set(gcf0,'WindowButtonUpFcn', ...
        ['global PZG;' ...
         'temp_buttonupz2_ui=findobj(gcbf,''type'',''uicontrol'');', ...
         'if ~isempty(temp_buttonupz2_ui)' ...
           '&&strcmp(get(temp_buttonupz2_ui(1),''enable''),''off''),' ...
           'clear temp_buttonupz2_ui,' ...
           'return,' ...
         'end,' ...
         'try,' ...
           'global PZMoving,' ...
           'set(temp_buttonupz2_ui,''enable'',''off'');' ...
           'prev_msgz_h=findobj(allchild(0),''name'',''CALCULATING'');' ...
           'if isempty(prev_msgz_h),' ...
             'temp_buMsgHndlz=msgbox(' ...
               '''Computation may take a minute.   Please wait ...'',' ...
               '''CALCULATING'');' ...
             'drawnow,pause(0.01),' ...
             'tempH=findobj(temp_buMsgHndlz,''Tag'',''OKButton'');' ...
             'if~isempty(tempH),' ...
               'delete(tempH),' ...
             'end,' ...
           'else,' ...
             'temp_buMsgHndlz=prev_msgz_h(1);' ...
             'if numel(prev_msgz_h)>1,' ...
               'delete(prev_msgz_h(2:end));' ...
             'end,' ...
           'end,' ...
           'clear prev_msgz_h,' ...
           'set(gcbf,''Pointer'',''arrow'');' ...
           'if ~isempty(PZG(2).Selection),' ...
             'PZMoving=1;' ...
             'figure(gcbf);' ...
             'pz_move(''z'');dpzgui;dupdatep;' ...
             'PZG(2).Selection=[];' ...
           'end,' ...
           'if exist(''temp_buMsgHndlz'',''var'')' ...
            '&&ishandle(temp_buMsgHndlz),' ...
             'close(temp_buMsgHndlz);' ...
           'end,' ...
           'PZMoving=0;' ...
           'set(gcbf,''WindowButtonUpFcn'',' ...
                '[''' def_ButtonUpFcn_string ''']);' ...
           'set(gcbf,''WindowButtonMotionFcn'',' ...
                '[''' def_ButtonMotionFcn_string ''']);' ...
           'set(temp_buttonupz2_ui,''enable'',''on'');' ...
           'pzg_unre;' ...
           'clear tempH tempCT GCF2 prev_msgz_h,' ...
         'catch,' ...
           'pzg_err(''D-T PZGUI button up'');' ...
           'temp_buttonupz2_ui=findobj(gcbf,''type'',''uicontrol'');', ...
           'set(temp_buttonupz2_ui,''enable'',''on'');' ...
           'pzg_unre;' ...
           'clear tempH tempCT GCF2,' ...
         'end,' ...
         'clear temp_buttonupz2_ui temp_buMsgHndlz PZMoving']);
    end
  else
    PZG(M).Selection = [];
    PZMoving = 0;
    set(gcf0,'Pointer','arrow');
    set(gcf0,'WindowButtonMotionFcn', this_ButtonMotionFcn_string );
    set(gca0,'XLimMode','manual','YLimMode','manual');

    temp0 = get(gcf0,'UserData');
    XLims = get(temp0(1,1),'XLim');
    YLims = get(temp0(1,1),'YLim');
    if ( real(actual_CurrPt) < XLims(1) ) ...
      ||( real(actual_CurrPt) > XLims(2) ) ...
      ||( imag(actual_CurrPt) < YLims(1) ) ...
      ||( imag(actual_CurrPt) > YLims(2) )
      return
    end
    deltaX = (XLims(2) - XLims(1))/2;
    XLims(1) = XLims(1) - deltaX;
    XLims(2) = XLims(2) + deltaX;
    deltaY = (YLims(2) - YLims(1))/2;
    YLims(1) = YLims(1) - deltaY;
    YLims(2) = YLims(2) + deltaY;
    
    set(temp0(1,1),'XLim',XLims);
    set(temp0(1,1),'YLim',YLims);
    if ( M == 1 ) && isequal( gcf0, PZG(1).plot_h{12}.fig_h ) ...
      && isequal( gca0, PZG(1).plot_h{12}.ax_h )
      PZG(1).plot_h{12}.xlim = XLims;
      PZG(2).plot_h{12}.xlim = XLims;
      PZG(1).plot_h{12}.hndl.ax_xlim = XLims;
      PZG(2).plot_h{12}.hndl.ax_xlim = XLims;
      PZG(1).plot_h{12}.ylim = YLims;
      PZG(2).plot_h{12}.ylim = YLims;
      PZG(1).plot_h{12}.hndl.ax_ylim = YLims;
      PZG(2).plot_h{12}.hndl.ax_ylim = YLims;
    elseif ( M == 2 ) && isequal( gcf0, PZG(2).plot_h{13}.fig_h ) ...
      && isequal( gca0, PZG(2).plot_h{13}.ax_h )
      PZG(1).plot_h{13}.xlim = XLims;
      PZG(2).plot_h{13}.xlim = XLims;
      PZG(1).plot_h{13}.hndl.ax_xlim = XLims;
      PZG(2).plot_h{13}.hndl.ax_xlim = XLims;
      PZG(1).plot_h{13}.ylim = YLims;
      PZG(2).plot_h{13}.ylim = YLims;
      PZG(1).plot_h{13}.hndl.ax_ylim = YLims;
      PZG(2).plot_h{13}.hndl.ax_ylim = YLims;
    end
    if isappdata( gcf0,'hndl')
      hndl = getappdata( gcf0,'hndl');
      hndl.ax_xlim = XLims;
      hndl.ax_ylim = YLims;
      setappdata( gcf0,'hndl', hndl );
    end

    set(temp0(4,1),'Ydata', YLims )
    set(temp0(5,1),'Xdata', XLims )
    if strcmpi( Domain,'s')
      % Stretch the Ts and half-Ts lines across the visible x-axis.
      set(temp0([21;31],1),'Xdata', XLims )
    end

    if strcmpi( Domain,'s')
      pzg_grid( temp0, gcf0, gca0, 12, PZG(1).plot_h{12}.hndl );
    end
  end
  if PZG(hndl.dom_ndx).pzg_show_frf_computation ...
    &&( isequal( hndl.ploth_ndx, 12 ) ||isequal( hndl.ploth_ndx, 13 ) )
    updtpzln( Domain )
  end
end

set(gcf0,'Interruptible','On');
set(gca0,'Interruptible','On');

tempHX = pzg_fndo( M, 7,'Nyquist_Plot_Xaxis_Highlight');
if ~isempty(tempHX)
  set( tempHX,'Visible','On','Xdata', PZG(M).plot_h{7}.xlim )
end
tempHY = pzg_fndo( M, 7,'Nyquist_Plot_Yaxis_Highlight');
if ~isempty(tempHY)
  set( tempHY,'Visible','On','Ydata', PZG(M).plot_h{7}.ylim )
end

return

% LOCAL FUNCTION

function save_undo_info(DomainNdx)

  global PZG

  M = DomainNdx;
  if ~isreal(M) || ~isequal(numel(M),1) ...
    || (M<1) || (M>2) || ~isequal(round(M),M)
    return
  end

  undo_info.PoleLocs = PZG(M).PoleLocs;
  undo_info.ZeroLocs = PZG(M).ZeroLocs;
  undo_info.Gain = PZG(M).Gain;
  undo_info.Ts = PZG(M).Ts;
  undo_info.PureDelay = PZG(M).PureDelay;
  if isfield(PZG(M),'DCgain')
    undo_info.DCgain = PZG(M).DCgain;
  else
    undo_info.DCgain = [];
  end

  if ~isfield(PZG,'undo_info') || ~iscell(PZG(M).undo_info)
    PZG(M).undo_info = {};
  end
  if isempty(PZG(M).undo_info) ...
    ||~isequal( PZG(M).undo_info{end}, undo_info )
    PZG(M).undo_info{end+1} = undo_info;
    rloc_h = pzg_fndo( M, 9+M,'fig_h');
    if ~isempty(rloc_h)
      gaintxt_h = pzg_fndo( M, 9+M,'rlocuspl_gain_text');
      set( gaintxt_h,'backgroundcolor',[0.9 0.9 0.9],'string','');
      gainmark_h = pzg_fndo( M, 9+M,'rlocuspl_gain_marker');
      set( gainmark_h,'visible','off');
    end
  end

return

function local_service_request( ReqStr, gcf0 )
  if ~ishandle(gcf0) || ~strcmp( get(gcf0,'type'),'figure')
    return
  end

  global PZG
  
  if isappdata( gcf0,'hndl')
    hndl = getappdata( gcf0,'hndl');
  else
    hndl = [];
  end
  if isfield( hndl,'ax')
    gca0 = hndl.ax;
  else
    gca0 = get(gcf0,'currentaxes');
    for kgc = numel(gca0):-1:1
      if strcmpi( get(gca0(kgc),'tag'),'legend')
        gca0(kgc) = [];
      end
    end
  end
  
  if isfield( hndl,'dom_ndx')
    dom_ndx = hndl.dom_ndx;
    if dom_ndx == 1
      Domain = 's';
    else
      Domain = 'z';
    end
  else
    if isempty( strfind( get(gcf0,'name'),'iscrete') )
      Domain = 's';
      dom_ndx = 1;
    else
      Domain = 'z';
      dom_ndx = 2;
    end
  end
  if isfield( hndl,'ploth_ndx')
    fig_h_ndx = hndl.ploth_ndx;
  else
    fig_h_ndx = [];
    for k = 1:numel(PZG(1).plot_h)
      if ~isempty(PZG(dom_ndx).plot_h{k}) ...
        && isfield( PZG(dom_ndx).plot_h{k},'fig_h')
        if isequal( gcf0, PZG(dom_ndx).plot_h{k}.fig_h )
          fig_h_ndx = k;
          break
        end
      end
    end
  end
  
  CT_PZGUI = pzg_fndo( 1, 12,'fig_h');
  DT_PZGUI = pzg_fndo( 2, 13,'fig_h');
  ctlink = pzg_islink(1);
  if ~isempty(ctlink) && isequal( 1, ishandle(CT_PZGUI) )
    ctlink_cb_h = pzg_fndo( 1, 12,'LinkCheckbox');
    ctlinkmethod_h = pzg_fndo( 1, 12,'LinkMethod');
    if ctlink
      set( [ ctlink_cb_h; ctlinkmethod_h ],'backgroundcolor',[0 0.7 0]);
    else
      set( [ ctlink_cb_h; ctlinkmethod_h ], ...
          'backgroundcolor', get(CT_PZGUI,'color') );
    end
  end
  dtlink = pzg_islink(2);
  if ~isempty(dtlink) && isequal( 1, ishandle(DT_PZGUI) )
    dtlinkmethod_h = pzg_fndo( 2, 13,'LinkMethod');
    dtlink_cb_h = pzg_fndo( 2, 13,'LinkCheckbox');
    if dtlink
      set( [ dtlink_cb_h; dtlinkmethod_h ],'backgroundcolor',[0 0.7 0]);
    else
      set( [ dtlink_cb_h; dtlinkmethod_h ], ...
          'backgroundcolor', get(DT_PZGUI,'color') );
    end
  end
        
  switch lower(ReqStr)
    case 'open zoom'
      temp0 = get(gcf0,'UserData');
      if strcmpi( Domain,'s') ...
        && ( isequal( fig_h_ndx, 10 ) || isequal( fig_h_ndx, 12 ) )
        local_grids_and_hilites_off( PZG(1).plot_h{fig_h_ndx}.hndl )
      end
      if numel( get(temp0(4,1),'Xdata') ) == 2
        set(temp0(4,1),'Xdata',[0 0]);
      end
      if numel( get(temp0(5,1),'Ydata') ) == 2
        set(temp0(5,1),'Ydata',[0 0]);
      end
      
      if isequal( fig_h_ndx, 7 )
        tempHX = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Xaxis_Highlight');
        if ~isempty(tempHX)
          set( tempHX,'Visible','Off')
        end
        tempHY = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Yaxis_Highlight');
        if ~isempty(tempHY)
          set( tempHY,'Visible','Off')
        end
      else
        tempHX = [];
        tempHY = [];
      end
       
      % Turn off the x-axis and y-axis highlights.
      xhilite_h = pzg_fndo( dom_ndx, 11+dom_ndx,'PZmap_xaxis_highlight');
      yhilite_h = pzg_fndo( dom_ndx, 11+dom_ndx,'PZmap_yaxis_highlight');
      set( [xhilite_h;yhilite_h],'visible','off');
      
      set(gca0,'XLimMode','auto','YLimMode','auto')
      XLims = get( gca0,'XLim');
      YLims = get( gca0,'YLim');
      if strcmpi( Domain,'s')
        if numel(PZG(1).PoleLocs) > 20
          max_pz_y = ...
            max( 1, 1.07*max( imag( [PZG(1).PoleLocs;PZG(1).ZeroLocs] ) ) );
          YLims = [ -max_pz_y  max_pz_y ];
          min_pz_x = ...
            min( -0.02*max_pz_y, ...
                 1.07*min( real( [PZG(1).PoleLocs;PZG(1).ZeroLocs] ) ) );
          max_pz_x = ...
            max( 0.15*abs(min_pz_x), ...
                 1.07*max( real( [PZG(1).PoleLocs;PZG(1).ZeroLocs] ) ) );
          XLims = [ min_pz_x  max_pz_x ];
        else
          if XLims(1) < 0
            XLims(1) = 1.5*XLims(1);
          else
            XLims(1) = max( -1, -abs(XLims(1)) );
          end
          min_xlim2 = XLims(1)+abs(XLims(1))*19.5/16;
          if XLims(2) > min_xlim2
            XLims(2) = 1.5*XLims(2);
          else
            XLims(2) = min_xlim2;
          end
          YLims = 1.5*YLims;
        end
      else
        if XLims(1) > -1.1
          XLims(1) = -1.1;
        end
        if XLims(2) < 1.4
          XLims(2) = 1.4;
        end
        if YLims(1) > -1.1
          YLims(1) = -1.1;
        end
        if YLims(2) < 1.1
          YLims(2) = 1.1;
        end
      end
      set( gca0,'XLim', XLims,'YLim', YLims );
      set( xhilite_h,'xdata', XLims,'ydata',[0 0],'visible','on');
      set( yhilite_h,'xdata', [0 0],'ydata', YLims,'visible','on');

      if ~isempty(fig_h_ndx) && sum( fig_h_ndx == [10;11;12;13] )
        PZG(1).plot_h{fig_h_ndx}.xlim = XLims;
        PZG(2).plot_h{fig_h_ndx}.xlim = XLims;
        PZG(1).plot_h{fig_h_ndx}.ylim = YLims;
        PZG(2).plot_h{fig_h_ndx}.ylim = YLims;
        PZG(1).plot_h{fig_h_ndx}.hndl.ax_xlim = XLims;
        PZG(2).plot_h{fig_h_ndx}.hndl.ax_xlim = XLims;
        PZG(1).plot_h{fig_h_ndx}.hndl.ax_ylim = YLims;
        PZG(2).plot_h{fig_h_ndx}.hndl.ax_ylim = YLims;
      elseif ~isempty(fig_h_ndx)
        PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = XLims;
        PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = YLims;
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = XLims;
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = YLims;
      end
      if isappdata( gcf0,'hndl')
        hndl = getappdata( gcf0,'hndl');
        hndl.ax_xlim = XLims;
        hndl.ax_ylim = YLims;
        setappdata( gcf0,'hndl', hndl );
      end
      drawnow
      set(gca0,'XLimMode','manual','YLimMode','manual')
      if ~isempty(tempHX)
         set( tempHX,'Visible','On','Xdata', XLims )
      end
      if ~isempty(tempHY)
         set( tempHY,'Visible','On','Ydata', YLims )
      end

      if strcmpi( Domain,'s') ...
        &&( isequal( fig_h_ndx, 10 ) || isequal( fig_h_ndx, 12 ) )
        temp0 = ...
          pzg_grid( temp0,  ...
                   PZG(1).plot_h{fig_h_ndx}.fig_h, ...
                   PZG(1).plot_h{fig_h_ndx}.ax_h, ...
                   fig_h_ndx, PZG(1).plot_h{fig_h_ndx}.hndl );    
      end

      set(temp0(4,1),'ydata', YLims )
      set(temp0(5,1),'xdata', XLims )

      set( gcf0,'Pointer','arrow')
      
    otherwise
  end
  
  if PZG(hndl.dom_ndx).pzg_show_frf_computation ...
    &&( isequal( hndl.ploth_ndx, 12 ) ||isequal( hndl.ploth_ndx, 13 ) )
    updtpzln( Domain )
  end
return

function local_grids_and_hilites_off( hndl )
  if ~isstruct(hndl) || ~isfield( hndl,'Splane_constWn_semicirc')
    return
  end
  set( hndl.Splane_constWn_semicirc,'visible','off');
  set( hndl.Splane_constWn_semicirc_repeated,'visible','off');
  set( hndl.Splane_constZeta_lines,'visible','off');
  set( hndl.Splane_constZeta_lines_repeated,'visible','off');
  set( hndl.Wplane_constWn_lines,'visible','off');
  set( hndl.Wplane_constZeta_lines,'visible','off');
  set( hndl.PZmap_xaxis_highlight,'visible','off');
  set( hndl.PZmap_yaxis_highlight,'visible','off');
  set( hndl.Splane_halfTS_lines,'visible','off');
  set( hndl.Splane_fullTS_lines,'visible','off');
return
