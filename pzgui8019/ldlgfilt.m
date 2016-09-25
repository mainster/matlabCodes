function   ldlgfilt( Domain, DeleteAll, quiet )
% Creates and services the lead-lag design tool in PZGUI.

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
%                                     pzg_sclpt.m      zmintcpt.m 
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
if isempty(PZG) && ~pzg_recovr
  return
end
evalin('base','global PZG')

GCBO = gcbo;
GCBF = gcbf;

if ~nargin || isempty(Domain) || ~ischar(Domain)
  return
end

if ~isfield( PZG,'Gain_fig')
  PZG(1).Gain_fig = [];
  PZG(2).Gain_fig = [];
end
if ~isfield( PZG,'LDLG_fig')
  PZG(1).LDLG_fig = [];
  PZG(2).LDLG_fig = [];
end
if ~isfield( PZG,'PID_fig')
  PZG(1).PID_fig = [];
  PZG(2).PID_fig = [];
end

% Make root-locus parameter-K variation lines invisible.
nonvis_h = ...
  [ pzg_fndo( (1:2),(1:9),'parameter_K_effect_line'); ...
    pzg_fndo( (1:2),(1:9),'parameter_K_effect_prvw_line') ];
if ~isempty(nonvis_h)
  set(nonvis_h,'visible','off');
end

Domain_arg = Domain;
if strcmpi( Domain(1),'s') ...
  ||( ( numel(Domain) > 12 )...
     && strcmpi( Domain(1:10),'continuous') )
  Domain = 's';
  dom_ndx = 1;
  LdLgFig = PZG(1).LDLG_fig;
elseif strcmpi( Domain(1),'z') ...
  ||( ( numel(Domain) > 12 )...
     && strcmpi( Domain(1:8),'discrete') )
  Domain = 'z';
  dom_ndx = 2;
  LdLgFig = PZG(2).LDLG_fig;
elseif strcmpi( Domain,'mouse motion')
  LdLgFig = GCBF;
  LdLgFigName = get( LdLgFig,'name');
  if strcmpi( LdLgFigName(1),'s')
    Domain = 's';
    dom_ndx = 1;
  else
    Domain = 'z';
    dom_ndx = 2;
  end
else
  return
end
if isempty(LdLgFig)
  LdLgFigName = [ Domain '-Domain Lead Lag Design GUI'];
  LdLgFig = findobj( allchild(0),'name', LdLgFigName );
  if numel(LdLgFig) > 1
    delete(LdLgFig)
    LdLgFig = [];
  end
else
  LdLgFigName = get( LdLgFig,'name');
end
if ~isempty(LdLgFig) && isequal( 1, ishandle(LdLgFig) ) ...
  && isappdata(LdLgFig,'hndl')
  PZG(dom_ndx).LDLG_fig = LdLgFig;
  hndl = getappdata(LdLgFig,'hndl');
else
  if ~isempty(LdLgFig)
    delete(LdLgFig)
    LdLgFig = [];
  end
  hndl = [];
end
if isempty(LdLgFig) ...
  ||( ( nargin == 2 ) && ~isequal( DeleteAll, 0 ) )
  prvw_h = pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'LDLG_Preview');
  if ~isempty(prvw_h)
    set( prvw_h(ishandle(prvw_h)),'visible','off')
  end
end

% Enforce validity of lead-lag data.
if ~isfield( PZG,'LeadLag')
  PZG(1).LeadLag = cell(7,1);
  PZG(1).LeadLag{4} = 1;
  PZG(1).LeadLag{7} = 0;
  PZG(2).LeadLag = cell(7,1);
  PZG(2).LeadLag{4} = 1;
  PZG(2).LeadLag{7} = 0;
end
for k = 1:2
  if ~iscell(PZG(k).LeadLag) || ~isequal( size(PZG(k).LeadLag), [7 1] )
    PZG(k).LeadLag = cell(7,1);
    PZG(k).LeadLag{4} = 1;
    PZG(k).LeadLag{7} = 0;
  end
  for kc = 1:7
    if ~isreal(PZG(k).LeadLag{kc}) ...
      ||( numel(PZG(k).LeadLag{kc}) > 1 )
      PZG(k).LeadLag{kc} = [];
      if kc == 4
        PZG(k).LeadLag{kc} = 1;
      elseif kc == 7
        PZG(k).LeadLag{kc} = 0;
      end
    end
  end
end

if isempty(gcbo)
  gcbo_tag = '';
else
  gcbo_tag = get(gcbo,'tag');
end
if isfield( hndl,'leadlag_slider')
  slider_h = hndl.leadlag_slider;
else
  slider_h = [];
end
slider_is_moving = 0;
menu_is_active = 0;
if isequal( gcbf, LdLgFig ) ...
  && isfield( hndl,'leadlag_slider') && ~isempty(gcbo) ...
  && strcmp( get(gcbo,'type'),'uicontrol') ...
  && strcmp( get(gcbo,'style'),'popupmenu') ...
  && ~isequal( Domain_arg,'mouse motion')
  menu_is_active = 1;
  menu_value = get( gcbo,'value');
  if ~isappdata( gcbo,'oldmenuvalue')
    setappdata( gcbo,'oldmenuvalue', menu_value );
    old_menu_value = menu_value;
  else
    old_menu_value = getappdata( gcbo,'oldmenuvalue');
  end
  if isequal( old_menu_value, menu_value )
    return
  end
  setappdata( gcbo,'oldmenuvalue', menu_value );
  if ~isappdata( slider_h,'old_slider')
    old_slider_values = 0.5*ones(5,1);
    setappdata( slider_h,'old_slider', old_slider_values )
  end
  old_slider_values = getappdata( slider_h,'old_slider');
  if ~isnumeric(old_slider_values) || ( numel(old_slider_values) ~= 5 )
    old_slider_values = 0.5*ones(5,1);
    setappdata( slider_h,'old_slider', old_slider_values )
  end
  set( slider_h,'value', old_slider_values(menu_value) );
end

if ( nargin == 1 ) && ~menu_is_active && ~isempty(hndl) ...
  && ( isequal( Domain_arg,'mouse motion') ...
      || strcmp( gcbo_tag,'leadlag slider') )...
  && ~isempty(GCBF)
  % See if slider has been adjusted.
  menu_value = get( hndl.leadlag_slider_menu,'value');
  slider_is_moving = 1;
  slider_value = get( slider_h,'value');
  if ~isappdata( slider_h,'old_slider')
    old_slider_values = 0.5*ones(5,1);
    old_slider_values(menu_value) = slider_value;
    setappdata( slider_h,'old_slider', old_slider_values )
    return
  else
    old_slider_values = getappdata( slider_h,'old_slider');
    if ~isnumeric(old_slider_values) || ( numel(old_slider_values) ~= 5 )
      old_slider_values = 0.5*ones(5,1);
      setappdata( slider_h,'old_slider', old_slider_values )
    end
  end
  if isequal( slider_value, old_slider_values(menu_value) )
    return
  else
    new_slider_values = old_slider_values;
    new_slider_values(menu_value) = slider_value;
    setappdata( slider_h,'old_slider', new_slider_values )
  end
  
  switch menu_value
    case 1  % extreme phase      
      new_maxphs = 179*slider_value - 89.5;
      set( hndl.MaxPhs_edit,'string', num2str(new_maxphs) );
      PZG(dom_ndx).LeadLag{1} = new_maxphs;
      
      ldlg_parms_out = parms2zpk( PZG(dom_ndx).LeadLag, dom_ndx );
      if iscell(ldlg_parms_out) && isequal( numel(ldlg_parms_out), 7 )
        PZG(dom_ndx).LeadLag{3} = ldlg_parms_out{3};
        for k = 4:6
          if ~isequal( PZG(dom_ndx).LeadLag{k}, ldlg_parms_out{k} )
            PZG(dom_ndx).LeadLag{k} = ldlg_parms_out{k};
            new_slider_values(k-1) = 0.5;
            setappdata( slider_h,'old_slider', new_slider_values );
          end
        end
      end
      set( hndl.GainCross_edit,'string', num2str( PZG(dom_ndx).LeadLag{3},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{3} );
      set( hndl.Gain_edit,'string', num2str( PZG(dom_ndx).LeadLag{4},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{4} );
      set( hndl.Pole_edit,'string', num2str( PZG(dom_ndx).LeadLag{5},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{5} );
      set( hndl.Zero_edit,'string', num2str( PZG(dom_ndx).LeadLag{6},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{6} );
      
    case 2  % center frequency
      curr_ctrfreq = str2double( get( hndl.PhsCtr_edit,'string') );
      old_slider = old_slider_values(2);
      if old_slider == 0.5
        base_ctrfreq = PZG(dom_ndx).LeadLag{2};
        if isempty(base_ctrfreq)
          base_ctrfreq = curr_ctrfreq;
        end
      else
        old_multiplier = 10^( 3*old_slider - 1.5 );
        base_ctrfreq = curr_ctrfreq / old_multiplier;
      end
      if slider_value == 0.5
        new_ctrfreq = base_ctrfreq;
      else
        new_multiplier = 10^( 3*slider_value - 1.5 );
        new_ctrfreq = base_ctrfreq * new_multiplier;
      end
      set( hndl.PhsCtr_edit,'string', num2str(new_ctrfreq) );
      
      PZG(dom_ndx).LeadLag{2} = new_ctrfreq;
      ldlg_parms_out = parms2zpk( PZG(dom_ndx).LeadLag, dom_ndx );
      if iscell(ldlg_parms_out) && isequal( numel(ldlg_parms_out), 7 )
        PZG(dom_ndx).LeadLag{3} = ldlg_parms_out{3};
        for k = 4:6
          if ~isequal( PZG(dom_ndx).LeadLag{k}, ldlg_parms_out{k} )
            PZG(dom_ndx).LeadLag{k} = ldlg_parms_out{k};
            new_slider_values(k-1) = 0.5;
            setappdata( slider_h,'old_slider', new_slider_values );
          end
        end
      end
      set( hndl.GainCross_edit,'string', num2str( PZG(dom_ndx).LeadLag{3},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{3} );
      set( hndl.Gain_edit,'string', num2str( PZG(dom_ndx).LeadLag{4},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{4} );
      set( hndl.Pole_edit,'string', num2str( PZG(dom_ndx).LeadLag{5},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{5} );
      set( hndl.Zero_edit,'string', num2str( PZG(dom_ndx).LeadLag{6},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{6} );      
            
    case 3  % gain
      set( hndl.dcgain_eq_1_checkbox,'value', 0 );
      PZG(dom_ndx).LeadLag{7} = 0;
      curr_gain = str2double( get( hndl.Gain_edit,'string') );
      old_slider = old_slider_values(3);
      if old_slider == 0.5
        base_gain = PZG(dom_ndx).LeadLag{4};
        if isempty(base_gain)
          base_gain = curr_gain;
        end
      elseif old_slider < 0.5
        old_slider = max( 1e-6, old_slider );
        base_gain = curr_gain / sqrt(2*old_slider);
      else
        base_gain = curr_gain / ( 1 + (20*(old_slider-0.5))^2 );
      end
      if slider_value == 0.5
        new_gain = base_gain;
      elseif slider_value < 0.5
        slider_value = max( 1e-6, slider_value );
        new_gain = base_gain * sqrt(2*slider_value);
      else
        new_gain = base_gain * ( 1 + (20*(slider_value-0.5))^2 );
      end
      set( hndl.Gain_edit,'string', num2str(new_gain,6) );
      curr_gain = str2double( get(hndl.Gain_edit,'string') );
      new_gain = curr_gain;
      PZG(dom_ndx).LeadLag{4} = new_gain;
      
      ldlg_parms_out = zpk2parms( PZG(dom_ndx).LeadLag, dom_ndx );
      if iscell(ldlg_parms_out) && isequal( numel(ldlg_parms_out), 7 )
        PZG(dom_ndx).LeadLag{3} = ldlg_parms_out{3};
        for k = 1:2
          if ~isequal( PZG(dom_ndx).LeadLag{k}, ldlg_parms_out{k} )
            PZG(dom_ndx).LeadLag{k} = ldlg_parms_out{k};
            new_slider_values(k) = 0.5;
            setappdata( slider_h,'old_slider', new_slider_values );
          end
        end
      end
      set( hndl.MaxPhs_edit,'string', num2str( PZG(dom_ndx).LeadLag{1},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{1} );
      set( hndl.PhsCtr_edit,'string', num2str( PZG(dom_ndx).LeadLag{2},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{2} );      
      set( hndl.GainCross_edit,'string', num2str( PZG(dom_ndx).LeadLag{3},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{3} );
      
    case 4  % pole location
      PoleLoc = str2double( get(hndl.Pole_edit,'string') );
      if isequal( dom_ndx, 1 )
        old_slider = old_slider_values(4);
        if old_slider == 0.5
          base_pole = PZG(dom_ndx).LeadLag{5};
          if isempty(base_pole)
            base_pole = PoleLoc;
          end
        elseif old_slider < 0.5
          old_slider = max( 1e-9, old_slider );
          base_pole = PoleLoc / sqrt(2*old_slider);
        else
          base_pole = PoleLoc / ( 1 + (20*(old_slider-0.5))^2 );
        end
        if slider_value == 0.5
          new_pole = base_pole;
        elseif slider_value < 0.5
          slider_value = max( 1e-9, slider_value );
          new_pole = base_pole * sqrt(2*slider_value);
        else
          new_pole = base_pole * ( 1 + (20*(slider_value-0.5))^2 );
        end
      else
        if slider_value < 1e-6
          slider_value = 1e-6;
          new_slider_values(4) = 1e-6;
          setappdata( slider_h,'old_slider', new_slider_values );
          set( slider_h,'value', 1e-6 );
        elseif slider_value > (1-1e-6)
          if PZG(dom_ndx).LeadLag{6} > (1-1e-6)
            PZG(dom_ndx).LeadLag{6} = 0.999;
            set( hndl.Zero_edit,'string','0.999');
            new_slider_values(5) = 0.999;
            setappdata( slider_h,'old_slider', new_slider_values );
          end
        end
        new_pole = slider_value;
      end
      set( hndl.Pole_edit,'string', num2str(new_pole) );
      PZG(dom_ndx).LeadLag{5} = new_pole;
      
      ldlg_parms_out = zpk2parms( PZG(dom_ndx).LeadLag, dom_ndx );
      if iscell(ldlg_parms_out) && isequal( numel(ldlg_parms_out), 7 )
        PZG(dom_ndx).LeadLag{3} = ldlg_parms_out{3};
        for k = 1:2
          if ~isequal( PZG(dom_ndx).LeadLag{k}, ldlg_parms_out{k} )
            PZG(dom_ndx).LeadLag{k} = ldlg_parms_out{k};
            new_slider_values(k) = 0.5;
            setappdata( slider_h,'old_slider', new_slider_values );
          end
        end
        PZG(dom_ndx).LeadLag{3} = ldlg_parms_out{3};
        if ~isequal( PZG(dom_ndx).LeadLag{4}, ldlg_parms_out{4} )
          PZG(dom_ndx).LeadLag{4} = ldlg_parms_out{4};
          new_slider_values(3) = 0.5;
          setappdata( slider_h,'old_slider', new_slider_values );
        end
      end
      set( hndl.MaxPhs_edit,'string', num2str( PZG(dom_ndx).LeadLag{1},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{1} );
      set( hndl.PhsCtr_edit,'string', num2str( PZG(dom_ndx).LeadLag{2},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{2} );      
      set( hndl.GainCross_edit,'string', num2str( PZG(dom_ndx).LeadLag{3},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{3} );
      set( hndl.Gain_edit,'string', num2str( PZG(dom_ndx).LeadLag{4},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{4} );   
         
    case 5  % zero location
      ZeroLoc = str2double( get(hndl.Zero_edit,'string') );
      if isequal( dom_ndx, 1 )
        old_slider = old_slider_values(5);
        if old_slider == 0.5
          base_zero = PZG(dom_ndx).LeadLag{6};
          if isempty(base_zero)
            base_zero = ZeroLoc;
          end
        elseif old_slider < 0.5
          old_slider = max( 1e-9, old_slider );
          base_zero = ZeroLoc / (2*old_slider);
        else
          base_zero = ZeroLoc / ( 1 + (20*(old_slider-0.5)) );
        end
        if slider_value == 0.5
          new_zero = base_zero;
        elseif slider_value < 0.5
          new_zero = base_zero * (2*slider_value);
        else
          new_zero = base_zero * ( 1 + (20*(slider_value-0.5)) );
        end
      else
        if slider_value < 1e-6
          slider_value = 1e-6;
          new_slider_values(5) = 1e-6;
          setappdata( slider_h,'old_slider', new_slider_values );
          set( slider_h,'value', 1e-6 );
        elseif slider_value > (1-1e-6)
          if PZG(dom_ndx).LeadLag{5} > (1-1e-6)
            PZG(dom_ndx).LeadLag{5} = 0.999;
            set( hndl.Pole_edit,'string','0.999');
            new_slider_values(4) = 0.999;
            setappdata( slider_h,'old_slider', new_slider_values );
          end
        end
        new_zero = slider_value;
      end
      
      set( hndl.Zero_edit,'string', num2str(new_zero) );
      PZG(dom_ndx).LeadLag{6} = new_zero;
      
      ldlg_parms_out = zpk2parms( PZG(dom_ndx).LeadLag, dom_ndx );
      if iscell(ldlg_parms_out) && isequal( numel(ldlg_parms_out), 7 )
        PZG(dom_ndx).LeadLag{3} = ldlg_parms_out{3};
        for k = 1:2
          if ~isequal( PZG(dom_ndx).LeadLag{k}, ldlg_parms_out{k} )
            PZG(dom_ndx).LeadLag{k} = ldlg_parms_out{k};
            new_slider_values(k) = 0.5;
            setappdata( slider_h,'old_slider', new_slider_values );
          end
        end
        PZG(dom_ndx).LeadLag{3} = ldlg_parms_out{3};
        if ~isequal( PZG(dom_ndx).LeadLag{4}, ldlg_parms_out{4} )
          PZG(dom_ndx).LeadLag{4} = ldlg_parms_out{4};
          new_slider_values(3) = 0.5;
          setappdata( slider_h,'old_slider', new_slider_values );
        end
      end
      set( hndl.MaxPhs_edit,'string', num2str( PZG(dom_ndx).LeadLag{1},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{1} );
      set( hndl.PhsCtr_edit,'string', num2str( PZG(dom_ndx).LeadLag{2},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{2} );      
      set( hndl.GainCross_edit,'string', num2str( PZG(dom_ndx).LeadLag{3},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{3} );   
      set( hndl.Gain_edit,'string', num2str( PZG(dom_ndx).LeadLag{4},6 ), ...
           'userdata', PZG(dom_ndx).LeadLag{4} );   
            
    otherwise
  end
  local_refresh_entries( Domain, LdLgFig )
end

if nargin < 2
  DeleteAll = 0;
end
if nargin < 3
  quiet = 0;
end

PidFig = PZG(dom_ndx).PID_fig;
GainFig = PZG(dom_ndx).Gain_fig;
if ~isempty(PidFig) && ( ( nargin < 1 ) || ~DeleteAll )
  questdlg_ans = ...
    questdlg({'The PID design GUI must be closed before opening'; ...
              'the lead-lag design GUI.'; ...
              ' '; ...
              'Do you want the PID design GUI to be closed?'}, ...
              'Must Close PID Design GUI', ...
              'Yes, close it','No, Leave it open','Yes, close it');
  if strcmpi( questdlg_ans,'No, Leave it open')
    return
  else
    close(PidFig)
  end
elseif ~isempty(GainFig) && ( ( nargin < 2 ) || ~DeleteAll )
  questdlg_ans = ...
    questdlg({'The Pure Gain design GUI must be closed before opening'; ...
              'the lead-lag design GUI.'; ...
              ' '; ...
              'Do you want the Pure Gain design GUI to be closed?'}, ...
              'Must Close Pure Gain Design GUI', ...
              'Yes, close it','No, Leave it open','Yes, close it');
  if strcmpi( questdlg_ans,'No, Leave it open')
    return
  else
    close(GainFig)
  end
end
blank_h = ...
  [ pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'Gain_Preview'); ...
    pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'PID_Preview') ];
if ~isempty(blank_h)
  set( blank_h,'visible','off')
end

if isempty(GCBF) || ~strcmp( get(GCBF,'name'), LdLgFigName )
  quiet = 1;
end

%xSize = 600;
%ySize = 180;
hSize = 1/5;
vSize = 0.12;
xSpace = (1-4*hSize)/4;
%ySpace = (1-6*vSize)/2;
Col1 = xSpace/2;
Col2 = 1.5*xSpace + hSize;
Col3 = 2.5*xSpace + 2*hSize;
Col4 = 3.5*xSpace + 3*hSize;
Row1 = 1 - vSize;
Row2 = 1 - 2*vSize;
Row3 = 1 - 3*vSize;
Row4 = 0.001 + 2*vSize;
Row5 = 0.001 + vSize;
Row6 = 0.001;

if DeleteAll
  local_clear_preview( dom_ndx )
  if isfield(hndl,'no_vis_axes')
    set( hndl.no_vis_axes,'visible','off');
  end
  return
end

mod_hndl = 0;

if isempty(LdLgFig)
  scr_size = get( 0,'screensize');
  LdLgFig = ...
    figure('menubar','none', ...
       'units','pixels', ...
       'position',[scr_size(3)/2 scr_size(4)/6 510 150], ...
       'numbertitle','off', ...
       'integerhandle','off', ...
       'tag','PZGUI plot', ...
       'handlevisibility','callback', ...
       'windowbuttonmotionfcn', ...
         [ mfilename '(''mouse motion'');'], ...
       'deletefcn', ...
         ['global PZG,' ...
          'ldlgfilt(get(gcbf,''name''),1);' ...
          'PZG(' num2str(dom_ndx) ').LDLG_fig=[];']);
  hndl = [];
            
  PZG(dom_ndx).LDLG_fig = LdLgFig;
  set( LdLgFig,'Name', LdLgFigName,'units','normalized');
  hndl.no_vis_axes = ...
    axes('parent', LdLgFig,'tag','no-vis axes','visible','off');
else
  set( hndl.no_vis_axes,'visible','off');
end

MaxPhsInit = PZG(dom_ndx).LeadLag{1};
PhsCtrInit = PZG(dom_ndx).LeadLag{2};
GainCrossInit = PZG(dom_ndx).LeadLag{3};
GainInit = PZG(dom_ndx).LeadLag{4};
PoleInit = PZG(dom_ndx).LeadLag{5};
ZeroInit = PZG(dom_ndx).LeadLag{6};
if isempty(GainInit)
  GainInit = 1;
  PZG(dom_ndx).LeadLag{4} = 1;
end

if ~isfield( hndl,'MaxPhsText1')
  mod_hndl = 1;
  hndl.MaxPhsText1 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col1-0.01 Row1 hSize+0.02 vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','Extreme Phase', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','MaxPhsText1');
end
if ~isfield( hndl,'MaxPhsText2')
  mod_hndl = 1;
  hndl.MaxPhsText2 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col1 Row3 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','(degrees)', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','MaxPhsText2');
end
if ~isfield( hndl,'MaxPhs_edit')
  mod_hndl = 1;
  hndl.MaxPhs_edit = ...
    uicontrol( LdLgFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col1 Row2 hSize vSize ], ...
      'string',num2str(MaxPhsInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','MaxPhs', ...
      'Callback','ldlgfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'PhsCtrText1')
  mod_hndl = 1;
  hndl.PhsCtrText1 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 Row1 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','Center Freq', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','PhsCtrText1');
end
if ~isfield( hndl,'PhsCtrText2')
  mod_hndl = 1;
  hndl.PhsCtrText2 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 Row3 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','(rad/s)', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','PhsCtrText2');
end
if ~isfield( hndl,'PhsCtr_edit')
  mod_hndl = 1;
  hndl.PhsCtr_edit = ...
    uicontrol( LdLgFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col2 Row2 hSize vSize ], ...
      'string',num2str(PhsCtrInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','PhsCtr', ...
      'Callback','ldlgfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'GainCrossText1')
  mod_hndl = 1;
  hndl.GainCrossText1 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col3 Row1 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','Gain Crossover', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tooltipstring', ...
        'if no crossover, gain is above (or below) unity at all frequencies', ...
      'tag','GainCrossText1');
end
if ~isfield( hndl,'GainCrossText2')
  mod_hndl = 1;
  hndl.GainCrossText2 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col3 Row3 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','(rad/s)', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tooltipstring', ...
        'if no crossover, gain is above (or below) unity at all frequencies', ...
      'tag','GainCrossText2');
end
if ~isfield( hndl,'GainCross_edit')
  mod_hndl = 1;
  hndl.GainCross_edit = ...
    uicontrol( LdLgFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col3 Row2 hSize vSize ], ...
      'string',num2str(GainCrossInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','GainCross', ...
      'tooltipstring', ...
        'if no crossover, gain is above (or below) unity at all frequencies', ...
      'Callback','ldlgfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'preview_pushbutton')
  mod_hndl = 1;
  hndl.preview_pushbutton = ...
    uicontrol( LdLgFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4 (0.8*Row1+0.2*Row2) hSize 1.1*vSize ], ...
      'string','Preview', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Preview', ...
      'tooltipstring','pre-view the effects of this compensator', ...
      'Callback', ...
        ['tempPRVcbo=gcbo;' ...
         'set(tempPRVcbo,''enable'',''off'');' ...
         'try,' ...
         'ldlgfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''lead-lag Preview pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempPRVcbo,''enable'',''on'');' ...
         'clear tempPRVcbo'] );
end

if ~isfield( hndl,'GainText1')
  mod_hndl = 1;
  hndl.GainText1 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col1 Row4 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','Gain', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','GainText1');
end
if ~isfield( hndl,'GainText2')
  mod_hndl = 1;
  hndl.GainText2 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col1 Row6 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','GainText2');
end
if ~isfield( hndl,'Gain_edit')
  mod_hndl = 1;
  hndl.Gain_edit = ...
    uicontrol( LdLgFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col1 Row5 hSize vSize ], ...
      'string',num2str(GainInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Gain', ...
      'Callback','ldlgfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'PoleText1')
  mod_hndl = 1;
  hndl.PoleText1 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 Row4 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','Pole Location', ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','PoleText1');
end
if ~isfield( hndl,'PoleText2')
  mod_hndl = 1;
  hndl.PoleText2 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 Row6 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','(rad/s)', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','PoleText2');
end
if ~isfield( hndl,'Pole_edit')
  mod_hndl = 1;
  hndl.Pole_edit = ...
    uicontrol( LdLgFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col2 Row5 hSize vSize ], ...
      'string',num2str(PoleInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Pole', ...
      'Callback','ldlgfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'ZeroText1')
  mod_hndl = 1;
  hndl.ZeroText1 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col3 Row4 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','Zero Location', ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','ZeroText1');
end
if ~isfield( hndl,'ZeroText2')
  mod_hndl = 1;
  hndl.ZeroText2 = ...
    uicontrol( LdLgFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col3 Row6 hSize vSize ], ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'string','(rad/s)', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','ZeroText2');
end
if ~isfield( hndl,'Zero_edit')
  mod_hndl = 1;
  hndl.Zero_edit = ...
    uicontrol( LdLgFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col3 Row5 hSize vSize ], ...
      'string',num2str(ZeroInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Zero', ...
      'Callback','ldlgfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'dcgain_eq_1_checkbox')
  mod_hndl = 1;
  hndl.dcgain_eq_1_checkbox = ...
    uicontrol( LdLgFig,'style','checkbox', ...
      'units','normalized', ...
      'position',[ 0.05*Col3+0.95*Col4 Row6 hSize vSize ], ...
      'value', 0, ...
      'string','DCgain = 1', ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'backgroundcolor', get(LdLgFig,'color'), ...
      'tag','dcgain = 1 checkbox', ...
      'Callback', ...
        ['global PZG,' ...
         'if~isempty(strfind(get(gcbf,''name''),''s-Domain'')),' ...
           'PZG(1).LeadLag{7}=get(gcbo,''value'');' ...
         'else,' ...
           'PZG(2).LeadLag{7}=get(gcbo,''value'');' ...
         'end,' ...
         'ldlgfilt(get(gcbf,''Name''))']);
end

if ~isfield( hndl,'clear_preview_pushbutton')
  mod_hndl = 1;
  hndl.clear_preview_pushbutton = ...
    uicontrol( LdLgFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4 (0.6*Row2+0.4*Row3) 1.05*hSize vSize ], ...
      'string','clear preview', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','clear preview', ...
      'Callback', ...
        ['tempCLRcbo=gcbo;' ...
         'set(tempCLRcbo,''enable'',''off'');' ...
         'try,' ...
         'ldlgfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''lead-lag Clear Preview pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempCLRcbo,''enable'',''on'');' ...
         'clear tempCLRcbo'] );
end

if ~isfield( hndl,'apply_pushbutton')
  mod_hndl = 1;
  hndl.apply_pushbutton = ...
    uicontrol( LdLgFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4+0.2*hSize 3*vSize 0.8*hSize 1.2*vSize ], ...
      'string','Apply', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Apply', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'try,' ...
         'ldlgfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''lead-lag Apply pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
end

if ~isfield( hndl,'leadlag_slider')
  mod_hndl = 1;
  hndl.leadlag_slider = ...
    uicontrol( LdLgFig,'style','slider', ...
      'units','normalized', ...
      'position',[ 0.201 3.7*vSize 0.55 vSize ], ...
      'value', 0.5, ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'backgroundcolor',[0.5 1 0.5], ...
      'tag','leadlag slider', ...
      'visible','off', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'set(tempAPPcbo,''enable'',''off'');' ...
         'try,' ...
         'ldlgfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''lead-lag slider'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
end

if ~isfield( hndl,'leadlag_slider_menu')
  mod_hndl = 1;
  init_menu_value = 3;
  hndl.leadlag_slider_menu = ...
    uicontrol( LdLgFig,'style','popupmenu', ...
      'units','normalized', ...
      'position',[ 0.001 3.8*vSize 0.2 vSize ], ...
      'string',...
        {'extreme phase';'center freq';'gain';'pole loc';'zero loc'}, ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'backgroundcolor',[0.5 1 0.5], ...
      'value', init_menu_value, ...
      'tag','leadlag slider menu', ...
      'visible','off', ...
      'tooltipstring','menu selects which parameter the slider adjusts', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'set(tempAPPcbo,''enable'',''off'');' ...
         'try,' ...
         'ldlgfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''lead-lag slider pop-up menu'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
  setappdata( hndl.leadlag_slider_menu,'oldmenuvalue', init_menu_value );
end

if mod_hndl
  setappdata( LdLgFig,'hndl', hndl );
end

set( hndl.no_vis_axes,'visible','off');

if isempty(GCBO) && isempty(Domain_arg)
  return
elseif ~strcmp( get( GCBF,'Name'), LdLgFigName ) ...
  && ~strcmp( Domain_arg, LdLgFigName )
  figure(LdLgFig)
  return
end

% Do not allow phase above 89.5 degrees, or below -89.5 degrees.
% That's no longer a phase-lead or phase-lag filter, because
% it becomes either an integrator pole, or a differentiator zero.
max_allowed_phs = 89.5; 

hndl.MaxPhs_edit = findobj(LdLgFig,'tag','MaxPhs');
hndl.PhsCtr_edit = findobj(LdLgFig,'tag','PhsCtr');
hndl.GainCross_edit = findobj(LdLgFig,'tag','GainCross');
hndl.Gain_edit = findobj(LdLgFig,'tag','Gain');
hndl.Pole_edit = findobj(LdLgFig,'tag','Pole');
hndl.Zero_edit = findobj(LdLgFig,'tag','Zero');
H_Menu = findobj(LdLgFig,'tag','leadlag slider menu');
H_Slider = findobj(LdLgFig,'tag','leadlag slider');
H_Preview = findobj(LdLgFig,'tag','Preview');

unity_dcgain = 0; %#ok<NASGU>
hndl.dcgain_eq_1_checkbox = findobj(LdLgFig,'tag','dcgain = 1 checkbox');
if ~isempty(hndl.dcgain_eq_1_checkbox)
  unity_dcgain = get( hndl.dcgain_eq_1_checkbox,'value');
  pole_loc = str2double( get(hndl.Pole_edit,'string') );
  zero_loc = str2double( get(hndl.Zero_edit,'string') );
  if ( ( dom_ndx == 1 ) && ( pole_loc > -1e-5 ) ) ...
    ||( ( dom_ndx == 2 ) && ( pole_loc > 1-1e-6 ) ) ...
    ||( ( dom_ndx == 1 ) && ( zero_loc > -1e-5 ) ) ...
    ||( ( dom_ndx == 2 ) && ( zero_loc > 1-1e-6 ) )
    unity_dcgain = 0;
    set( hndl.dcgain_eq_1_checkbox,'value', 0,'visible','off');
    PZG(dom_ndx).LeadLag{7} = 0;
  else
    set( hndl.dcgain_eq_1_checkbox,'visible','on');
    if isequal( PZG(dom_ndx).LeadLag{7}, 0 ) ...
      ||isequal( PZG(dom_ndx).LeadLag{7}, 1 )
      set( hndl.dcgain_eq_1_checkbox,'value', PZG(dom_ndx).LeadLag{7} );
    end
  end
  if unity_dcgain 
    if isempty( get( hndl.Gain_edit,'string') )
      set( hndl.Gain_edit,'string', num2str( PZG(dom_ndx).LeadLag{4},6) );
    end
  end
end

GCBOtag = get(GCBO,'Tag');

if strcmpi( GCBOtag,'leadlag slider menu')
  % User has selected a different parameter for slider adjustment.
  if ~isappdata( H_Slider,'old_slider')
    return
  end
  old_slider_values = getappdata( H_Slider,'old_slider');
  if ~isnumeric(old_slider_values) ...
    || ~isequal( numel(old_slider_values), 4 )
    return
  end
  menu_value = get( H_Menu,'value');
  set( H_Slider,'value', old_slider_values(menu_value) );
  return
end

TagNdx = 0;
if isappdata( H_Slider,'old_slider')
  old_slider_values = getappdata( H_Slider,'old_slider');
  if ~isnumeric(old_slider_values) ...
    || ~isequal( numel(old_slider_values), 5 )
    setappdata( H_Slider,'old_slider', 0.5*ones(5,1) );
    old_slider_values = 0.5*ones(5,1);
  end
else
  setappdata( H_Slider,'old_slider', 0.5*ones(5,1) );
  old_slider_values = 0.5*ones(5,1);
end
menu_value = get( H_Menu,'value');
if strcmp( GCBOtag,'MaxPhs')
  TagNdx = 1;
  maxphs = str2double( get( hndl.MaxPhs_edit,'string') );
  if isempty(maxphs)
    maxphs = PZG(dom_ndx).LeadLag{1};
  end
  maxphs = max( -89.5, min( 89.5, maxphs ) );
  PZG(dom_ndx).LeadLag{1} = maxphs;
  old_slider_values(1) = maxphs/179 + 0.5;
  old_slider_values(3:5) = 0.5;
  setappdata( H_Slider,'old_slider', old_slider_values );
  set( H_Slider,'value', old_slider_values(menu_value) );
elseif strcmp( GCBOtag,'PhsCtr')
  TagNdx = 2;
  phsctr = str2double( get( hndl.PhsCtr_edit,'string') );
  if isempty(phsctr)
    phsctr = PZG(dom_ndx).LeadLag{2};
  end
  phsctr = abs(phsctr);
  PZG(dom_ndx).LeadLag{2} = phsctr;
  set( hndl.PhsCtr_edit,'string', num2str( phsctr, 6 ) );
  old_slider_values(2:5) = 0.5;
  setappdata( H_Slider,'old_slider', old_slider_values );
  set( H_Slider,'value', old_slider_values(menu_value) );  
elseif strcmp( GCBOtag,'GainCross')
  TagNdx = 3;
  old_slider_values(3) = 0.5;
  setappdata( H_Slider,'old_slider', old_slider_values );
  set( H_Slider,'value', old_slider_values(menu_value) );  
elseif strcmp( GCBOtag,'Gain')
  TagNdx = 4;
  old_slider_values(3) = 0.5;
  setappdata( H_Slider,'old_slider', old_slider_values );
  set( H_Slider,'value', old_slider_values(menu_value) );  
elseif strcmp( GCBOtag,'Pole')
  TagNdx = 5;
  old_slider_values(1:2) = 0.5;
  old_slider_values(4) = 0.5;
  setappdata( H_Slider,'old_slider', old_slider_values );
  set( H_Slider,'value', old_slider_values(menu_value) );  
elseif strcmp( GCBOtag,'Zero')
  TagNdx = 6;
  old_slider_values(5) = 0.5;
  old_slider_values(2) = 0.5;
  setappdata( H_Slider,'old_slider', old_slider_values );
  if isequal( get( H_Menu,'value'), 5 ) ...
    ||isequal( get( H_Menu,'value'), 2 )
    set( H_Slider,'value', 0.5 );
  end
elseif strcmp( GCBOtag,'dcgain = 1 checkbox')
  TagNdx = 7;
  PZG(dom_ndx).LeadLag{7} = get( gcbo,'value');
end
if TagNdx
  temp = str2double( get( GCBO,'string') );
  if isinf(temp) || isnan(temp)
    temp = [];
  end
  if ( TagNdx == 1 ) && ( numel(temp) == 1 )
    temp = max( min( temp, max_allowed_phs ), -max_allowed_phs );
  end
  if isempty(temp)
    temp = PZG(dom_ndx).LeadLag{TagNdx};
  else
    temp = real( temp(1) );
  end
  
  if ( TagNdx == 2 ) || ( TagNdx == 3 )
    temp = abs(temp);
    if dom_ndx == 2
      % Discrete-Time:  
      % Limit frequency entries to between 0 and Nyquist freq.
      if isinf(temp)
        temp = pi/PZG(2).Ts;
      end
      if temp > 2*pi/PZG(2).Ts
        temp = mod( temp, 2*pi/PZG(2).Ts );
      end
      if temp > pi/PZG(2).Ts
        temp = abs( temp - 2*pi/PZG(2).Ts );
      end
    end
  end
  if TagNdx == 4
    temp = abs(temp);
  end
  if TagNdx > 4
    if dom_ndx == 1
      % Continuous-time:  on the negative real axis.
      temp = -abs(temp);
    else
      % Discrete-time:  on pos real axis, inside the unit circle.
      temp = abs(temp);
      if temp > 1
        temp = 1/temp;
      end
      if abs(1-temp) < 1e-7
        % Make a near-integrator into an integrator.
        % Likewise for differentiators.
        temp = 1;
      end
    end
  end
  if ~strcmp( get( GCBO,'style'),'checkbox')
    if ~isempty(temp) && ~isinf(temp) && ~isnan(temp)
      set( GCBO,'string', num2str(temp) );
      PZG(dom_ndx).LeadLag{TagNdx} = temp;
    else
      set( GCBO,'string','')
      PZG(dom_ndx).LeadLag{TagNdx} = [];
    end
  end
  
  if TagNdx < 4
    % Entered phs/ctr/crossover data
    MaxPhs = str2double( get( hndl.MaxPhs_edit,'string') );
    if isempty(MaxPhs) || isnan(MaxPhs) || ~isreal(MaxPhs) ...
      ||( MaxPhs < -90 ) || ( MaxPhs > 90 )
      MaxPhs = PZG(dom_ndx).LeadLag{1};
      set( hndl.MaxPhs_edit,'string', num2str(MaxPhs,6) )
    end
    PhsCtr = abs( str2double( get( hndl.PhsCtr_edit,'string') ) );
    if isempty(PhsCtr) || isnan(PhsCtr) || ~isreal(PhsCtr) ...
      ||( PhsCtr < 0 ) ...
      ||( ( dom_ndx == 2 ) && ( PhsCtr > pi/PZG(2).Ts ) )
      PhsCtr = PZG(dom_ndx).LeadLag{2};
      set( hndl.MaxPhs_edit,'string', num2str(PhsCtr,6) )
    end
    GainCross = abs( str2double( get( hndl.GainCross_edit,'string') ) );
    if ~isempty(GainCross)
      if isnan(GainCross) || ~isreal(GainCross) ...
        ||( GainCross < 0 ) ...
        ||( ( dom_ndx == 2 ) && ( GainCross > pi/PZG(2).Ts ) )
        GainCross = PZG(dom_ndx).LeadLag{3};
        set( hndl.GainCross_edit,'string', num2str(GainCross,6) )
      end
    end
    if ~isempty(PhsCtr) && ( PhsCtr < 1e-3 )
      PhsCtr = 1e-3;
    end
    if isempty(MaxPhs) || isempty(PhsCtr)
      set( hndl.MaxPhs_edit,'string', num2str(MaxPhs,6) );
      set( hndl.PhsCtr_edit,'string', num2str(PhsCtr,6) );
      local_clear_preview( dom_ndx )
      return
    end
    
    PZG(dom_ndx).LeadLag{1} = MaxPhs;
    PZG(dom_ndx).LeadLag{2} = PhsCtr;
    PZG(dom_ndx).LeadLag{3} = GainCross;
    ldlg_parms_in = PZG(dom_ndx).LeadLag;
    ldlg_parms_out = parms2zpk( ldlg_parms_in, dom_ndx );
    
    Gain = ldlg_parms_out{4};
    set( hndl.Gain_edit,'string', num2str( Gain, 6 ) );
    PZG(dom_ndx).LeadLag{4} = Gain;
    Pole = ldlg_parms_out{5};
    set( hndl.Pole_edit,'string', num2str( Pole, 6 ) );
    PZG(dom_ndx).LeadLag{5} = Pole;
    Zero = ldlg_parms_out{6};
    set( hndl.Zero_edit,'string', num2str( Zero, 6 ) );
    PZG(dom_ndx).LeadLag{6} = Zero;
    old_slider_values(3:5) = 0.5;
    set( H_Slider,'value', old_slider_values(menu_value) );
    setappdata( H_Slider,'old_slider', old_slider_values );

  else
    % Entered pole/zero/gain data
    Gain = str2double( lower(get( hndl.Gain_edit,'string')) );
    if ( numel(Gain) ~= 1 ) || ~isreal(Gain) ...
      || isinf(Gain) || isnan(Gain) || ( Gain < 0 )
      Gain = PZG(dom_ndx).LeadLag{4};
      if isempty(Gain)
        set( hndl.Gain_edit,'string','');
        local_clear_preview( dom_ndx )
        return
      end
    end
    if dom_ndx == 1
      Pole = str2double( get( hndl.Pole_edit,'string') );
      if ( numel(Pole) ~= 1 ) || ~isreal(Pole) ...
        || isinf(Pole) || isnan(Pole) || ( Pole > 0 )
        Pole = PZG(dom_ndx).LeadLag{5};
      end
      Zero = str2double( get( hndl.Zero_edit,'string') );
      if ( numel(Zero) ~= 1 ) || ~isreal(Zero) ...
        || isinf(Zero) || isnan(Zero) || ( Zero > 0 )
        Zero = PZG(dom_ndx).LeadLag{6};
      end
      Pole = -abs(Pole);
      Zero = -abs(Zero);
    else
      Pole = str2double( get( hndl.Pole_edit,'string') );
      if ( numel(Pole) ~= 1 ) || ~isreal(Pole) ...
        || isinf(Pole) || isnan(Pole) || ( Pole > 1 ) || ( Pole < 1e-6 )
        Pole = PZG(dom_ndx).LeadLag{5};
      end
      Zero = str2double( get( hndl.Zero_edit,'string') );
      if ( numel(Zero) ~= 1 ) || ~isreal(Zero) ...
        || isinf(Zero) || isnan(Zero) || ( Zero > 1 ) || ( Zero < 1e-6 )
        Zero = PZG(dom_ndx).LeadLag{6};
      end
      Pole = max( 1e-6, min( 1, abs(Pole) ) );
      Zero = max( 1e-6, min( 1, abs(Zero) ) );
    end
    set( hndl.Gain_edit,'string', num2str(Gain,6) );
    set( hndl.Pole_edit,'string', num2str(Pole,6) );
    set( hndl.Zero_edit,'string', num2str(Zero,6) );
    
    PZG(dom_ndx).LeadLag{4} = Gain;
    PZG(dom_ndx).LeadLag{5} = Pole;
    PZG(dom_ndx).LeadLag{6} = Zero;
    ldlg_parms_in = PZG(dom_ndx).LeadLag;
    ldlg_parms_out = zpk2parms( ldlg_parms_in, dom_ndx );
    
    MaxPhs = ldlg_parms_out{1};
    set( hndl.MaxPhs_edit,'string', num2str( MaxPhs, 6 ) );
    PZG(dom_ndx).LeadLag{1} = MaxPhs;
    PhsCtr = ldlg_parms_out{2};
    set( hndl.PhsCtr_edit,'string', num2str( PhsCtr, 6 ) );
    PZG(dom_ndx).LeadLag{2} = PhsCtr;
    GainCross = ldlg_parms_out{3};
    set( hndl.GainCross_edit,'string', num2str( GainCross, 6 ) );
    PZG(dom_ndx).LeadLag{3} = GainCross;
    old_slider_values(1:2) = 0.5;
    set( H_Slider,'value', old_slider_values(menu_value) );
    setappdata( H_Slider,'old_slider', old_slider_values );
    if ~isequal( PZG(dom_ndx).LeadLag{4}, ldlg_parms_out{4} )
      Gain = ldlg_parms_out{4};
      set( hndl.Gain_edit,'string', num2str( Gain, 6 ) );
      PZG(dom_ndx).LeadLag{4} = Gain;
      old_slider_values(3) = 0.5;
      set( H_Slider,'value', old_slider_values(menu_value) );
      setappdata( H_Slider,'old_slider', old_slider_values );
    end
  end
end

% Create or update preview whenever preview lines already exist,
% or the user has pushed the "preview" pushbutton.
preview_on = 0;
if strcmp( get(hndl.leadlag_slider,'visible'),'on')
  preview_on = 1;
end

if strcmpi( GCBOtag,'Preview') ...
  ||( preview_on ...
     && ~strcmpi( GCBOtag,'clear preview') ...
     && ~strcmpi( GCBOtag,'Apply') )
  % Compute and display the bode.
  Gain = real( str2num( get( hndl.Gain_edit,'string') ) ); %#ok<ST2NM>
  Pole = real( str2num( get( hndl.Pole_edit,'string') ) ); %#ok<ST2NM>
  if dom_ndx == 1
    Pole = -abs( str2num( get( hndl.Pole_edit,'string') ) ); %#ok<ST2NM>
  end
  Zero = str2num( get( hndl.Zero_edit,'string') ); %#ok<ST2NM>
  if isempty(Gain) || isempty(Pole) || isempty(Zero)
    set(H_Preview,'backgroundcolor',0.9412*[1 1 1]);
    set([H_Slider;H_Menu;hndl.clear_preview_pushbutton],'visible','off');
    if isequal( 0, slider_is_moving )
      errdlg_h = ...
        errordlg({'Pole/Zero/Gain not fully specified.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'Filter Preview Error','modal');
      uiwait(errdlg_h)
    end
    return
  elseif ~isreal(Gain) || ~isreal(Zero)
    set(H_Preview,'backgroundcolor',0.9412*[1 1 1]);
    set([H_Slider;H_Menu;hndl.clear_preview_pushbutton],'visible','off');
    errordlg('Pole, zero, and gain must be real-valued.', ...
             'Filter Preview Error')
    return
  end
  set(H_Preview,'backgroundcolor', [0.5 1 0.5]);
  set([H_Slider;H_Menu;hndl.clear_preview_pushbutton],'visible','on');
  if dom_ndx == 1
    sPole = Pole;
    sZero = Zero;
    sGain = Gain;
  else
    low_freq = pi/PZG(2).Ts/1000;
    low_freq_uc = exp(1i*low_freq);
    low_freq_gain = Gain*abs( (low_freq_uc-Zero)/(low_freq_uc-Pole) );
    sPole = log(Pole)/PZG(2).Ts;
    sZero = log(Zero)/PZG(2).Ts;
    sGain = abs( low_freq_gain*(1i*low_freq-sPole)/(1i*low_freq-sZero) );
  end
  Freqs = PZG(dom_ndx).BodeFreqs;
  if dom_ndx == 1
    CplxBode = sGain*( 1i*Freqs - sZero )./( 1i*Freqs - sPole );
  else
    uc_pts = exp(1i*Freqs*PZG(2).Ts);
    CplxBode = Gain*( uc_pts - Zero )./( uc_pts - Pole );
  end
  Mag = 20*log10(abs(CplxBode));
  Phs = 180*angle(CplxBode)/pi;
  
  BasePhs = PZG(dom_ndx).BodePhs;
  nyq_ndx = numel(BasePhs);
  if dom_ndx == 2
    nyq_ndx = pzg_gle( PZG(2).BodeFreqs, pi/PZG(2).Ts,'<=');
    fs_ndx = pzg_gle( PZG(2).BodeFreqs, 2*pi/PZG(2).Ts,'<=');
  end
  
  % Compute the delta phase and delta magnitude.
  delta_mag = ...
    max( abs(diff(PZG(dom_ndx).BodeMag)), abs(diff(Mag)) );
  delta_phs = ...
    max( abs(diff(PZG(dom_ndx).BodePhs)), abs(diff(Phs)) );
  delta_mp = max( delta_mag, delta_phs/5 );
  cum_delta_mp = cumsum( delta_mp );
  % Use "mod" to find indexes where cumulative sum jumps
  jumpsize = 2.5;
  LineNdx = [];
  numel_deltamag = numel(delta_mag);
  if isequal( dom_ndx, 2 )
    numel_deltamag = round( numel_deltamag/2.2 );
  end
  while numel(LineNdx) ...
        < max( min(100,numel_deltamag/8), numel_deltamag/500 )
    mod_cum_delta_mp = mod( cum_delta_mp, jumpsize );
    LineNdx = ...
      1 + find( mod_cum_delta_mp(2:end) < mod_cum_delta_mp(1:end-1) );
    if dom_ndx == 2
      delNdx = find( PZG(2).BodeFreqs(LineNdx) > pi/PZG(2).Ts );
      if ~isempty(delNdx)
        LineNdx(delNdx) = [];
      end
    end
    jumpsize = jumpsize/2;
  end
  while numel(LineNdx) ...
        > max( min(500,numel_deltamag/2), numel_deltamag/10 )
    jumpsize = jumpsize*2;
    mod_cum_delta_mp = mod( cum_delta_mp, jumpsize );
    LineNdx = ...
      1 + find( mod_cum_delta_mp(2:end) < mod_cum_delta_mp(1:end-1) );
    if dom_ndx == 2
      delNdx = find( PZG(2).BodeFreqs(LineNdx) > pi/PZG(2).Ts );
      if ~isempty(delNdx)
        LineNdx(delNdx) = [];
      end
    end
  end
  
  LineMag = Mag(LineNdx);
  LinePhs = Phs(LineNdx);
  NicholFig = pzg_fndo( dom_ndx, 6,'fig_h');
  if ~isempty(NicholFig)
    if isappdata(NicholFig,'hndl')
      Nich_hndl = getappdata( NicholFig,'hndl');
    else
      Nich_hndl = [];
    end
    if isfield( Nich_hndl,'show_nyq_mapping_checkbox') ...
      && isequal( 1, ishandle(Nich_hndl.show_nyq_mapping_checkbox) )
      nyqmap_h = Nich_hndl.show_nyq_mapping_checkbox;
    else
      nyqmap_h = findobj( NicholFig,'tag','show nyq mapping checkbox');
      Nich_hndl.show_nyq_mapping_checkbox = nyqmap_h;
    end
    if ( dom_ndx == 2 ) 
      if get( nyqmap_h,'value')
        LineNdx = LineNdx( LineNdx <= fs_ndx );
        LineMag = Mag(LineNdx);
        LinePhs = Phs(LineNdx);
      else
        LineNdx = LineNdx( LineNdx <= nyq_ndx );
        LineMag = Mag(LineNdx);
        LinePhs = Phs(LineNdx);
      end
    end
    if size(BasePhs,1) == 1
      xdata = [ BasePhs(LineNdx); ...
                BasePhs(LineNdx)+LinePhs(:)' ];          
    else
      xdata = [  BasePhs(LineNdx)'; ...
               ( BasePhs(LineNdx)+LinePhs(:) )' ];
    end
    if size(PZG(dom_ndx).BodeMag,1) == 1
      ydata = [ PZG(dom_ndx).BodeMag(LineNdx); ...
                PZG(dom_ndx).BodeMag(LineNdx)+LineMag(:)' ];          
    else
      ydata = [  PZG(dom_ndx).BodeMag(LineNdx)'; ...
               ( PZG(dom_ndx).BodeMag(LineNdx)+LineMag(:) )' ];          
    end
    xdata = [ xdata; NaN*ones(1,size(xdata,2)) ];
    ydata = [ ydata; NaN*ones(1,size(ydata,2)) ];
    ldlgprvw_h = pzg_fndo( dom_ndx, 6,'LDLG_Preview');
    if ~isequal( 3, numel(ldlgprvw_h) ) ...
      || ~isequal( 3, sum(ishandle(ldlgprvw_h)) )
      delete(ldlgprvw_h)
      ldlgprvw_h = [];
      PZG(dom_ndx).plot_h{6}.hndl.LDLG_Preview = ...
        plot( xdata(:), ydata(:), ...
          'color','y', ...
          'linewidth', 0.5, ...
          'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
          'tag',[Domain 'LDLG Preview'] );
    else
      set( ldlgprvw_h(1), ...
          'xdata', xdata(:),'ydata', ydata(:), ...
          'color','y', ...
          'linewidth', 0.5, ...
          'visible','on');
    end
    xdata = BasePhs(:)+Phs(:);          
    ydata = PZG(dom_ndx).BodeMag(:) + Mag(:);          
    if dom_ndx == 2
      xdata = xdata(1:nyq_ndx);
      ydata = ydata(1:nyq_ndx);
    end
    if ~isequal( 3, numel(ldlgprvw_h) )
      PZG(dom_ndx).plot_h{6}.hndl.LDLG_Preview(2) = ...
        plot( xdata, ydata, ...
             'color','m', ...
             'linewidth', 3, ...
             'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
             'tag',[Domain 'LDLG Preview'] );
      PZG(dom_ndx).plot_h{6}.hndl.LDLG_Preview(3) = ...
        plot( -xdata, ydata, ...
             'color',[0.7 0.7 0.7], ...
             'linestyle','-', ...
             'linewidth', 2, ...
             'visible','off', ...
             'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
             'tag',[Domain 'LDLG Preview'] );
      ldlgprvw_h = PZG(dom_ndx).plot_h{6}.hndl.LDLG_Preview;
    else
      set( ldlgprvw_h(2), ...
          'xdata', xdata,'ydata', ydata,'color','m','visible','on');
      set( ldlgprvw_h(3), ...
          'xdata', -xdata,'ydata', ydata,'color', [0.7 0.7 0.7] );
    end
    if get( nyqmap_h,'value')
      set( ldlgprvw_h(3),'visible','on');
    else
      set( ldlgprvw_h(3),'visible','off');
    end
    if strcmp( get( PZG(dom_ndx).plot_h{6}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{6}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 6 );
    end
  end
  
  OLCplxBode = 10.^( ( PZG(dom_ndx).BodeMag + Mag )/20 ) ...
               .*exp( (1i*pi/180)*( PZG(dom_ndx).BodePhs + Phs ) );
  
  % Impulse-response PFE (the TF)
  [ CLres, CLpoles, CLdirect ] = ...
      pzg_rsppfe( dom_ndx, [], [], 1, ...
                 'closed loop',[Domain 'LDLG'], 1 ); %#ok<NASGU,ASGLU>
  CLstable = 1;
  if dom_ndx == 1
    if any( real(CLpoles) >= -1e-14 )
      CLstable = 0;
    end
  else
    if any( abs(CLpoles) >= (1-1e-10) )
      CLstable = 0;
    end
  end
  if ~CLstable && ~quiet
    if dom_ndx == 1
      if abs(Pole) < abs(Zero)
        msg_str = ' Lag-Filter';
      else
        msg_str = ' Lead-Filter';
      end
    else
      if abs(Pole) > abs(Zero)
        msg_str = ' Lag-Filter';
      else
        msg_str = ' Lead-Filter';
      end
    end
    if isequal( 0, slider_is_moving )
      msgbox_h = ...
        msgbox( ...
         {['With this' msg_str ', the closed-loop system is unstable.']; ...
          ' ';'      Click "OK" to continue';' '}, ...
         'PZGUI Advisory','modal');
      uiwait( msgbox_h )
    end
  end
  CLCplxBode = OLCplxBode ./(1+OLCplxBode);
  CLMag = 20*log10( abs( CLCplxBode ) );
  CLMagFig = pzg_fndo( dom_ndx, 3,'fig_h');
  if ~isempty(CLMagFig)
    % Determine if log y-axis is currently selected.
    dB_checkbox_h = PZG(dom_ndx).plot_h{3}.hndl.BodeDBChkbox;
    if isempty(dB_checkbox_h)
      if ~PZG(dom_ndx).plot_h{3}.dB_cb
        CLMag = 10.^(CLMag/20);
      end
    else
      if ~get(dB_checkbox_h,'value')
        CLMag = 10.^(CLMag/20);
      end
    end
    plotFreqs = Freqs;
    hz_checkbox_h = pzg_fndo( dom_ndx, 3,'BodeHZChkbox');
    if isempty(hz_checkbox_h)
      if PZG(dom_ndx).plot_h{3}.Hz_cb
        plotFreqs = plotFreqs/2/pi;
      end
    else
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 3,'LDLG_Preview');
    if CLstable
      if ~isequal( numel(LineH), 1 )
        delete(LineH)
        PZG(dom_ndx).plot_h{3}.hndl.LDLG_Preview = ...
          plot( plotFreqs, CLMag,'m', ...
             'linewidth', 2, ...
             'parent', PZG(dom_ndx).plot_h{3}.ax_h, ...
             'tag',[Domain 'LDLG Preview']);
      else
        set( LineH,'xdata', plotFreqs,'ydata', CLMag,'visible','on')
      end
    elseif ~isempty(LineH)
      set( LineH,'visible','off')
    end
    if strcmp( get( PZG(dom_ndx).plot_h{3}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{3}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 3 );
    end
  end
  
  CLPhsFig = pzg_fndo( dom_ndx, 4,'fig_h');
  if ~isempty(CLPhsFig)
    unwrap_h = PZG(dom_ndx).plot_h{4}.hndl.UnwrapChkbox;
    if isempty(unwrap_h) || ~get( unwrap_h(1),'value')
      CLPhs = 180/pi*angle( CLCplxBode );
    else
      CLPhs = ...
        pzg_unwrap( PZG(dom_ndx).BodeFreqs, 180/pi*angle( CLCplxBode ), ...
                    dom_ndx,'close');
    end
    plotFreqs = Freqs;
    hz_checkbox_h = pzg_fndo( dom_ndx, 4,'BodeHZChkbox');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 4,'LDLG_Preview');
    if CLstable
      if ~isequal( 1, numel(LineH) )
        delete(LineH)
        PZG(dom_ndx).plot_h{4}.hndl.LDLG_Preview = ...
          plot( plotFreqs, CLPhs,'m', ...
             'parent', PZG(dom_ndx).plot_h{4}.ax_h, ...
             'tag',[Domain 'LDLG Preview'], ...
             'linewidth', 2 );
      else
        set( LineH,'xdata', plotFreqs,'ydata', CLPhs,'visible','on')
      end
    else
      if ~isempty(LineH)
        PZG(dom_ndx).plot_h{4}.hndl.LDLG_Preview = LineH;
        set( LineH,'visible','off')
      else
        PZG(dom_ndx).plot_h{4}.hndl.LDLG_Preview = [];
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{4}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{4}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 4 );
    end
  end
  
  OLMagFig = pzg_fndo( dom_ndx, 1,'fig_h');
  if ~isempty(OLMagFig)
    % Determine if log y-axis is currently selected.
    dB_checkbox_h = PZG(dom_ndx).plot_h{1}.hndl.BodeDBChkbox;
    filtMag = 20*log10(abs(CplxBode));
    compMag = filtMag + PZG(dom_ndx).BodeMag;
    if ~isempty(dB_checkbox_h)
      if ~get(dB_checkbox_h,'value')
        filtMag = abs(CplxBode);
        compMag = filtMag .* 10.^(PZG(dom_ndx).BodeMag/20);
      end
    end
    plotFreqs = Freqs;
    hz_checkbox_h = PZG(dom_ndx).plot_h{1}.hndl.BodeHZChkbox;
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 1,'LDLG_Preview');
    if ~isequal( 2, numel(LineH) ) || ~isequal( 2, sum(ishandle(LineH)) )
      delete(LineH)
      PZG(dom_ndx).plot_h{1}.hndl.LDLG_Preview = ...
        plot( plotFreqs, filtMag,'c', ...
           'linestyle','--', ...
           'parent', PZG(dom_ndx).plot_h{1}.ax_h, ...
           'tag',[Domain 'LDLG Preview'], ...
           'linewidth', 2 );
      PZG(dom_ndx).plot_h{1}.hndl.LDLG_Preview(2) = ...
        plot( plotFreqs, compMag,'m', ...
           'parent', PZG(dom_ndx).plot_h{1}.ax_h, ...
           'tag',[Domain 'LDLG Preview'], ...
           'linewidth', 2 );
    else
      set( LineH(1),'xdata', plotFreqs,'ydata', filtMag,'visible','on')
      set( LineH(2),'xdata', plotFreqs,'ydata', compMag,'visible','on')
    end
    if strcmp( get( PZG(dom_ndx).plot_h{1}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{1}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 1 );
    end
  end
  OLPhsFig = pzg_fndo( dom_ndx, 2,'fig_h');
  if ~isempty(OLPhsFig)
    plotFreqs = Freqs;
    hz_checkbox_h = PZG(dom_ndx).plot_h{2}.hndl.BodeHZChkbox;
    if isempty(hz_checkbox_h) || get(hz_checkbox_h,'value')
      plotFreqs = plotFreqs/2/pi;
    end
    OLPhs_ydata = angle(CplxBode)*(180/pi) + BasePhs;
    % Determine whether to wrap or unwrap this result.
    unwrap_h = pzg_fndo( dom_ndx, 2,'UnwrapChkbox');
    if get( unwrap_h,'value')
      OLPhs_ydata = ...
        pzg_unwrap( plotFreqs, OLPhs_ydata, Domain, ...
                    [ PZG(dom_ndx).OLBodeName ' Phase'] );
      if dom_ndx == 2
        % "Fold" the phase data at multiples of the Nyquist freq.
        this_freq = PZG(2).BodeFreqs;
        gle_ndx = pzg_gle( this_freq, pi/PZG(2).Ts,'<');
        if numel(this_freq) == 4*gle_ndx
          basic_phs = OLPhs_ydata(1:gle_ndx);
          OLPhs_ydata = [ basic_phs, -fliplr(basic_phs) ];
          OLPhs_ydata = [ OLPhs_ydata, OLPhs_ydata ]; 
        end
      end
    else
      hi_ndxs = find( OLPhs_ydata > 180 );
      while ~isempty(hi_ndxs)
        OLPhs_ydata(hi_ndxs) = OLPhs_ydata(hi_ndxs) - 360;
        hi_ndxs = find( OLPhs_ydata > 180 );
      end
      lo_ndxs = find( OLPhs_ydata < -180 );
      while ~isempty(lo_ndxs)
        OLPhs_ydata(lo_ndxs) = OLPhs_ydata(lo_ndxs) + 360;
        lo_ndxs = find( OLPhs_ydata < -180 );
      end
    end
    
    LineH = pzg_fndo( dom_ndx, 2,'LDLG_Preview');
    if ~isequal( 2, numel(LineH) ) || ~isequal( 2, sum(ishandle(LineH)) )
      delete(LineH)
      PZG(dom_ndx).plot_h{2}.hndl.LDLG_Preview = ...
        plot( plotFreqs, (180/pi)*angle(CplxBode),'c', ...
           'linestyle','--', ...
           'parent', PZG(dom_ndx).plot_h{2}.ax_h, ...
           'tag',[Domain 'LDLG Preview'], ...
           'linewidth', 2 );
      PZG(dom_ndx).plot_h{2}.hndl.LDLG_Preview(2) = ...
        plot( plotFreqs, OLPhs_ydata,'m', ...
           'parent', PZG(dom_ndx).plot_h{2}.ax_h, ...
           'tag',[Domain 'LDLG Preview'], ...
           'linewidth', 2 );
    else
      set( LineH(1), ...
          'xdata', plotFreqs, ...
          'ydata', (180/pi)*angle(CplxBode), ...
          'visible','on')
      set( LineH(2), ...
          'xdata', plotFreqs, ...
          'ydata', OLPhs_ydata, ...
          'visible','on')
    end
    if strcmp( get( PZG(dom_ndx).plot_h{2}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{2}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 2 );
    end
  end
  
  NyqFig = pzg_fndo( dom_ndx, 7,'fig_h');
  if ~isempty(NyqFig)
    % Determine the scaled Nyquist-plot data.
    if dom_ndx == 1
      line_ud.OLCplxBode = OLCplxBode;
      line_ud.scaled_OLCplxBode = pzg_sclpt( OLCplxBode );
    else
      line_ud.OLCplxBode = OLCplxBode(1:nyq_ndx);
      line_ud.scaled_OLCplxBode = pzg_sclpt( OLCplxBode(1:nyq_ndx) );
    end
    
    hyb_h = pzg_fndo( dom_ndx, 7,'rescale_checkbox');
    LineH = pzg_fndo( dom_ndx, 7,'LDLG_Preview');
    if isempty(hyb_h) || ~get( hyb_h,'value')
      if ~isequal( 2, numel(LineH) ) || ~isequal( 2, sum(ishandle(LineH)) )
        delete(LineH)
        LineH = ...
          plot( line_ud.OLCplxBode, ...
            'color',[0.7 0 0.7], ...
            'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
            'tag',[Domain 'LDLG Preview'], ...
            'userdata', line_ud, ...
            'linewidth', 2 );
        LineH(end+1) = ...
          plot( conj(line_ud.OLCplxBode), ...
            'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
            'color',[0.7 0.7 0.7], ...
            'linestyle','-', ...
            'tag',[Domain 'LDLG Preview'], ...
            'userdata', line_ud, ...
            'linewidth', 2 );
        PZG(dom_ndx).plot_h{7}.hndl.LDLG_Preview = LineH;
      else
        set( LineH(1),'xdata', real(line_ud.OLCplxBode), ...
            'ydata', imag(line_ud.OLCplxBode), ...
            'userdata', line_ud, ...
            'visible','on')
        set( LineH(2),'xdata', real(line_ud.OLCplxBode), ...
            'ydata', -imag(line_ud.OLCplxBode), ...
            'userdata', line_ud, ...
            'visible','on')
      end
    else
      if ~isequal( 2, numel(LineH) ) || ~isequal( 2, sum(ishandle(LineH)) )
        delete(LineH)
        LineH = ...
          plot( line_ud.scaled_OLCplxBode, ...
            'color',[0.7 0 0.7], ...
            'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
            'tag',[Domain 'LDLG Preview'], ...
            'userdata', line_ud, ...
            'linewidth', 2 );
        LineH(end+1) = ...
          plot( conj(line_ud.scaled_OLCplxBode), ...
            'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
            'color',[0.7 0.7 0.7], ...
            'linestyle','-', ...
            'tag',[Domain 'LDLG Preview'], ...
            'userdata', line_ud, ...
            'linewidth', 2 );
        PZG(dom_ndx).plot_h{7}.hndl.LDLG_Preview = LineH;
      else
        set( LineH(1),'xdata', real(line_ud.scaled_OLCplxBode), ...
            'ydata', imag(line_ud.scaled_OLCplxBode), ...
            'visible','on')
        set( LineH(2),'xdata', real(line_ud.scaled_OLCplxBode), ...
            'ydata', -imag(line_ud.scaled_OLCplxBode), ...
            'visible','on')
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{7}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{7}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 7 );
    end
  end
  
  CLRespFig = pzg_fndo( dom_ndx, 9,'fig_h');
  if ~isempty(CLRespFig)
    architec = 'closed loop';
    incl_pade = 1;
    incl_prvw = 'sLDLG';
    if isequal( Domain,'z')
      incl_prvw = 'zLDLG';
    end
    resp_line_h = pzg_fndo( dom_ndx, 9,'pzgui_resppl_resp_line');
    time_vec = get( resp_line_h(1),'xdata');
    if time_vec(1) == 0
      log_t_vec = [ -Inf, log( time_vec(2:end) ) ];
    else
      log_t_vec = log( time_vec );
    end
    if numel(time_vec) > 2
      % Determine the input ZPK.
      input_type_h = pzg_fndo( dom_ndx, 9,'input_type_popupmenu');
      if ~isempty(input_type_h)
        input_type = get( input_type_h,'value');
      else
        input_type = 2;
      end
      freq_hz = 1;
      freq_ed_h = pzg_fndo( dom_ndx, 9,'visible_for_periodic_only');
      for kf = 1:numel(freq_ed_h)
        if ~isempty( str2double( get( freq_ed_h(kf),'string') ) )
          freq_hz = str2double( get( freq_ed_h(kf),'string') );
          break
        end
      end
      
      [ input_zeros, input_poles, input_gain ] = ...
          pzg_inzpk( input_type, Domain, freq_hz );
      
      [ resp_res, resp_poles, resp_direct ] = ...
          pzg_rsppfe( ...
            dom_ndx, input_zeros, input_poles, input_gain, ...
            architec, incl_prvw, incl_pade );
          
      wb_h = -1;
      
      LDLG_time_resp = zeros(size(time_vec));
      LDLG_time_resp(1) = resp_direct;
      if isequal( Domain,'s')
        prev_pole = inf;
        rep_nr = 1;
        for k = 1:numel(resp_poles)
          pp = resp_poles(k);
          if abs( pp - prev_pole ) < 1e-12
            rep_nr = rep_nr + 1;
          else
            rep_nr = 1;
            prev_pole = pp;
          end
          if ~isequal( resp_res(k), 0 )
            this_term = resp_res(k) * exp( pp * time_vec );
            if rep_nr > 1
              multiplier = exp( (rep_nr-1) * log_t_vec )/factorial(rep_nr-1);
              this_term = this_term .* multiplier;
            end
            LDLG_time_resp = LDLG_time_resp + this_term;
          end
          if ishandle(wb_h)
            waitbar( 0.95*k/numel(resp_poles), wb_h )
          end
        end
        if ishandle(wb_h)
          delete( wb_h )
        end
      else
        if diff(time_vec(1:2)) ~= 1
          N_vec = round( time_vec / PZG(2).Ts );
        else
          N_vec = round(time_vec);
        end
        sim_ts = PZG(2).Ts;
        prev_pole = inf;
        rep_nr = 1;
        for k = 1:numel(resp_poles)
          pp = resp_poles(k);
          if abs( pp - prev_pole ) < 1e-12
            rep_nr = rep_nr + 1;
          else
            rep_nr = 1;
            prev_pole = pp;
          end
          if ~isequal( resp_res(k), 0 )
            if isempty(input_poles)
              if pp ~= 0
                this_term = resp_res(k) * exp( log(pp) * N_vec );
              else
                this_term = zeros(size(N_vec));
                this_term(1) = resp_res(k);
              end
            else
              if pp ~= 0
                this_term = ...
                  resp_res(k) * exp( log(pp) * N_vec );
              else
                this_term = zeros(size(N_vec));
                this_term(1) = resp_res(k);
              end
            end
            if rep_nr > 1
              multiplier = ...
                exp( (rep_nr-1) * log_t_vec )...
                / factorial(rep_nr-1) / sim_ts^(rep_nr-1);
              if pp ~= 0
                this_term = this_term .* multiplier;
              else
                this_term(rep_nr:end-1) = ...
                  this_term(1:end-rep_nr) .* multiplier(rep_nr:end-1);
                this_term(1:rep_nr-1) = 0;
              end
            end
            % Note constant numerator translates to one unit-delay.
            LDLG_time_resp(2:end) = LDLG_time_resp(2:end) + this_term(1:end-1);
          end
          
          if ishandle(wb_h)
            waitbar( 0.95*k/numel(resp_poles), wb_h )
          end
        end
        if ishandle(wb_h)
          delete( wb_h )
        end
      end
      LDLG_time_resp = real(LDLG_time_resp);
      input_line_h = pzg_fndo( dom_ndx, 9,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      err_ydata = in_ydata(:) - LDLG_time_resp(:);
      this_bgcolor = get( PZG(dom_ndx).plot_h{9}.ax_h,'color');
      if max( this_bgcolor ) < 0.5
        err_color = [0.6 1 1];
      else
        err_color = [0 0.5 0.5];
      end
      if get( pzg_fndo( dom_ndx, 9,'show_io_difference'),'value')
        resp_err_vis = 'on';
      else
        resp_err_vis = 'off';
      end
      CL_resp_prvw_h = pzg_fndo( dom_ndx, 9,'LDLG_Preview');
      if ~isequal( 2, numel(CL_resp_prvw_h) ) ... 
        || ~isequal( 2, sum( ishandle(CL_resp_prvw_h) ) )
        delete(CL_resp_prvw_h)
        CL_resp_prvw_h = ...
          plot( time_vec(:), LDLG_time_resp(:), ...
             'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
             'color',[ 1 0 1 ], ...
             'linewidth', 1.5, ...
             'linestyle','-', ...
             'tag',[Domain 'LDLG Preview']);
        CL_resp_prvw_h(2) = ...
          plot( time_vec(:), err_ydata(:), ...
            'color', err_color, ...
            'linewidth', 1.5, ...
            'linestyle','--', ...
            'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
            'visible', resp_err_vis, ...
            'tag',[Domain 'LDLG Preview']);
        PZG(dom_ndx).plot_h{9}.hndl.LDLG_Preview = CL_resp_prvw_h;
      else
        set( CL_resp_prvw_h(1), ...
          'xdata', time_vec(:), ...
          'ydata', LDLG_time_resp(:), ...
          'visible','on')
        set( CL_resp_prvw_h(2), ...
          'xdata', time_vec(:), ...
          'ydata', err_ydata(:), ...
          'color', err_color, ...
          'visible','on')
      end
      if input_type == 1
        set( CL_resp_prvw_h(2),'xdata',[],'ydata',[],'visible','off');
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{9}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{9}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 9 );
    end
  end
  
  OLRespFig = pzg_fndo( dom_ndx, 8,'fig_h');
  if ~isempty(OLRespFig)
    architec = 'open loop';
    incl_pade = 0;
    incl_prvw = 'sLDLG';
    if isequal( Domain,'z')
      incl_prvw = 'zLDLG';
    end
    resp_line_h = pzg_fndo( dom_ndx, 8,'pzgui_resppl_resp_line');
    time_vec = get( resp_line_h(1),'xdata');
    if time_vec(1) == 0
      log_t_vec = [ -Inf, log( time_vec(2:end) ) ];
    else
      log_t_vec = log( time_vec );
    end
    if numel(time_vec) > 2
      % Determine the input ZPK.
      input_type_h = pzg_fndo( dom_ndx, 8,'input_type_popupmenu');
      if ~isempty(input_type_h)
        input_type = get( input_type_h,'value');
      else
        input_type = 2;
      end
      freq_hz = 1;
      freq_ed_h = pzg_fndo( dom_ndx, 8,'visible_for_periodic_only');
      for kf = 1:numel(freq_ed_h)
        if ~isempty( str2double( get( freq_ed_h(kf),'string') ) )
          freq_hz = str2double( get( freq_ed_h(kf),'string') );
          break
        end
      end
      
      [ input_zeros, input_poles, input_gain ] = ...
          pzg_inzpk( input_type, Domain, freq_hz );
      
      [ resp_res, resp_poles, resp_direct ] = ...
          pzg_rsppfe( ...
            dom_ndx, input_zeros, input_poles, input_gain, ...
            architec, incl_prvw, incl_pade );

      direct_resp = zeros(size(time_vec));
      if isequal( Domain,'s')
        if PZG(1).PureDelay == 0
          direct_resp(1) = resp_direct;
        else
          delay_ndx = pzg_gle( time_vec, PZG(1).PureDelay,'near');
          direct_resp(delay_ndx) = resp_direct;
        end
        LDLG_time_resp = direct_resp;
        prev_pole = inf;
        rep_nr = 1;
        for k = 1:numel(resp_poles)
          pp = resp_poles(k);
          if abs( pp - prev_pole ) < 1e-12
            rep_nr = rep_nr + 1;
          else
            rep_nr = 1;
            prev_pole = pp;
          end
          if ~isequal( resp_res(k), 0 )
            this_term = resp_res(k) * exp( pp * time_vec );
            if rep_nr > 1
              multiplier = exp( (rep_nr-1) * log_t_vec )/factorial(rep_nr-1);
              this_term = this_term .* multiplier;
            end
            LDLG_time_resp = LDLG_time_resp + this_term;
          end
        end
      else
        if diff(time_vec(1:2)) ~= 1
          N_vec = round( time_vec / PZG(2).Ts );
        else
          N_vec = round(time_vec);
        end
        if PZG(2).PureDelay == 0
          direct_resp(1) = resp_direct;
        else
          direct_resp(PZG(2).PureDelay+1) = resp_direct;
        end
        LDLG_time_resp = direct_resp;
        sim_ts = PZG(2).Ts;
        prev_pole = inf;
        rep_nr = 1;
        for k = 1:numel(resp_poles)
          pp = resp_poles(k);
          if abs( pp - prev_pole ) < 1e-12
            rep_nr = rep_nr + 1;
          else
            rep_nr = 1;
            prev_pole = pp;
          end
          if ~isequal( resp_res(k), 0 )
            if isempty(input_poles)
              if pp ~= 0
                this_term = resp_res(k) * exp( log(pp) * N_vec );
              else
                this_term = zeros(size(N_vec));
                this_term(1) = resp_res(k);
              end
            else
              if pp ~= 0
                this_term = resp_res(k) * exp( log(pp) * N_vec );
              else
                this_term = zeros(size(N_vec));
                this_term(1) = resp_res(k);
              end
            end
            if rep_nr > 1
              multiplier = ...
                exp( (rep_nr-1) * log_t_vec )...
                / factorial(rep_nr-1) / sim_ts^(rep_nr-1);
              if pp ~= 0
                this_term = this_term .* multiplier;
              else
                this_term(rep_nr:end-1) = ...
                  this_term(1:end-rep_nr) .* multiplier(rep_nr:end-1);
                this_term(1:rep_nr-1) = 0;
              end
            end
            % Note constant numerator translates to one unit-delay.
            LDLG_time_resp(2:end) = LDLG_time_resp(2:end) + this_term(1:end-1);
          end
        end
      end
      LDLG_time_resp = real(LDLG_time_resp(:));
      sim_ts = diff( time_vec(1:2) );
      nr_delay_samples = 0;
      if PZG(dom_ndx).PureDelay > 0
        if strcmpi( Domain,'s')
          nr_delay_samples = round( PZG(1).PureDelay / sim_ts );
        else
          nr_delay_samples = PZG(2).PureDelay;
        end
      end
      % Impose nonzero delay.
      if ( nr_delay_samples > 0 ) && ( nr_delay_samples < numel(time_vec) )
        if ( time_vec(1) == 0 )
          LDLG_time_resp(nr_delay_samples+1:end) = ...
            LDLG_time_resp(1:end-nr_delay_samples);
          LDLG_time_resp(1:nr_delay_samples) = 0;
        else
          time_vec(1:nr_delay_samples) = [];
          LDLG_time_resp(end-nr_delay_samples+1:end) = [];
        end
      end
      input_line_h = pzg_fndo( dom_ndx, 8,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      err_ydata = in_ydata(:) - LDLG_time_resp(:);
      this_bgcolor = get( PZG(dom_ndx).plot_h{8}.ax_h,'color');
      if max( this_bgcolor ) < 0.5
        err_color = [0.6 1 1];
      else
        err_color = [0 0.5 0.5];
      end
      if get( pzg_fndo( dom_ndx, 8,'show_io_difference'),'value')
        resp_err_vis = 'on';
      else
        resp_err_vis = 'off';
      end
      OL_resp_prvw_h = pzg_fndo( dom_ndx, 8,'LDLG_Preview');
      if ~isequal( 2, numel(OL_resp_prvw_h) ) ... 
        || ~isequal( 2, sum( ishandle(OL_resp_prvw_h) ) )
        delete(OL_resp_prvw_h)
        OL_resp_prvw_h = ...
          plot( time_vec(:), LDLG_time_resp(:), ...
             'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
             'color',[ 1 0 1 ], ...
             'linewidth', 1.5, ...
             'linestyle','-', ...
             'tag',[Domain 'LDLG Preview']);
        OL_resp_prvw_h(2) = ...
          plot( time_vec(:), err_ydata(:), ...
            'color', err_color, ...
            'linewidth', 1.5, ...
            'linestyle','--', ...
            'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
            'visible', resp_err_vis, ...
            'tag',[Domain 'LDLG Preview']);
        PZG(dom_ndx).plot_h{8}.hndl.LDLG_Preview = OL_resp_prvw_h;
      else
        set( OL_resp_prvw_h(1), ...
          'xdata', time_vec(:), ...
          'ydata', LDLG_time_resp(:), ...
          'visible','on')
        set( OL_resp_prvw_h(2), ...
          'xdata', time_vec(:), ...
          'ydata', err_ydata(:), ...
          'color', err_color, ...
          'visible', resp_err_vis )
      end
      if input_type == 1
        set( OL_resp_prvw_h(2),'xdata',[],'ydata',[],'visible','off');
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{8}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{8}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 8 );
    end
  end

  PZGFig_h = pzg_fndo( dom_ndx, 11+dom_ndx,'fig_h');
  if ~isempty(PZGFig_h)
    PZG_ax_h = PZG(dom_ndx).plot_h{11+dom_ndx}.ax_h;
    if strcmpi( PZG(dom_ndx).DefaultBackgroundColor,'k')
      this_gray = [0.7 0.7 0.7];
    else
      this_gray = [0.4 0.4 0.4];
    end
    LineH = pzg_fndo( dom_ndx, 11+dom_ndx,'LDLG_Preview');
    if ~isequal( 2, numel(LineH) ) || ~isequal( 2, sum(ishandle(LineH)) )
      delete(LineH)
      LineH = ...
        plot( real(Pole), imag(Pole),'x', ...
           'color', this_gray, ...
           'linewidth', 3, ...
           'linestyle','none', ...
           'markersize', 14, ...
           'tag',[Domain 'LDLG Preview'], ...
           'parent', PZG_ax_h );
      LineH(2) = ...
        plot( real(Zero), imag(Zero),'o', ...
           'color', this_gray, ...
           'linewidth', 3, ...
           'linestyle','none', ...
           'markersize', 12, ...
           'tag',[Domain 'LDLG Preview'], ...
           'parent', PZG_ax_h );
      PZG(dom_ndx).plot_h{11+dom_ndx}.hndl.LDLG_Preview = LineH;
    else
      set( LineH(1), ...
          'xdata', real(Pole), ...
          'ydata', imag(Pole), ...
          'visible','on')
      set( LineH(2), ...
          'xdata', real(Zero), ...
          'ydata', imag(Zero), ...
          'visible','on')
    end
    if strcmp( get( PZG(dom_ndx).plot_h{11+dom_ndx}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{11+dom_ndx}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 11+dom_ndx );
    end
  end
  
  RtLocFig = pzg_fndo( dom_ndx, 9+dom_ndx,'fig_h');
  if ~isempty(RtLocFig)
    hi_nr_poles = 13;
    % Get the gains currently used in the root locus plot.
    GAINS = [ logspace(-5,0,2000), logspace(0,5,2000), ...
              logspace(5,10,1000) ]';
    % Construct the zpk model with the lead or lag filter included.
    Z = [ PZG(dom_ndx).ZeroLocs; Zero ];
    P = [ PZG(dom_ndx).PoleLocs; Pole ];
    K = PZG(dom_ndx).Gain * Gain;
    
    % Include any delay poles and zeros.
    if Domain == 's'
      if PZG(1).PureDelay > 0
        P = [ P; PZG(1).pade.P ];
        Z = [ Z; PZG(1).pade.Z ];
      end
    else
      if PZG(2).PureDelay > 0
        P = [ P; zeros(PZG(2).PureDelay,1) ];
      end
    end
    
    % Include gains for break-in and break-out points.
    if ( numel( P ) > 1 ) && ( numel( P ) <= hi_nr_poles )
      DEN = poly( P );
      NUM = poly( Z );
      if isempty( Z )
        subNUM = [];
      elseif numel( Z ) == 1
        subNUM = {DEN};
      else
        subNUM = cell(size(Z));
        for k = 1:numel(subNUM)
          subzero = Z;
          subzero(k) = [];
          subNUM{k} = conv( DEN, poly( subzero ) );
        end
      end
      subDEN = cell(size(P));
      for k = 1:numel(subDEN)
        subpole = P;
        subpole(k) = [];
        subDEN{k} = conv( NUM, poly( subpole ) );
      end
      full_poly = zeros(size(subDEN{1}));
      for k = 1:numel(subNUM)
        full_poly = full_poly - subNUM{k};
      end
      for k = 1:numel(subDEN)
         full_poly = full_poly + subDEN{k};
      end
      brk_pts = roots( full_poly );
      brk_gains = zeros( size(brk_pts) );
      for k = numel(brk_gains):-1:1
        if any( P == brk_pts(k) ) ...
          ||any( Z == brk_pts(k) )
          brk_pts(k) = [];
          brk_gains(k) = [];
        end
        brk_gains(k) = prod( abs( brk_pts(k)-P ) ) ...
                       /prod( abs( brk_pts(k)-Z ) ) / K;
      end
      GAINS = [ GAINS(:); brk_gains(:); 1 ];
      if sign(GAINS(2)) <= 0
        GAINS = -1 * sort( abs(GAINS) );
      else
        GAINS = sort( abs(GAINS) );
      end
    end
    negGAINS = GAINS;
    GAINeq1_ndx = find( negGAINS == 1 );
    if ~isempty(GAINeq1_ndx)
      negGAINS(GAINeq1_ndx) = negGAINS(GAINeq1_ndx-1);
    end
    
    purejordan = 1;
    include_pade = 1;
    if dom_ndx == 1
      include_prvw = 'sLDLG';
    else
      include_prvw = 'zLDLG';
    end
    modalss = ...
      pzg_moda( dom_ndx, purejordan, include_pade, include_prvw, [], 1 );
    
    if size( modalss.a, 1 ) < numel(P)
      % Remove canceling poles and zeros.
      for k = numel(P):-1:1
        cncl_ndx = find( abs( Z - P(k) ) < 1e-12 );
        if ~isempty(cncl_ndx)
          P(k) = [];
          Z(cncl_ndx(1)) = [];
        end
      end
    end
    
    if ~isempty(modalss) && ( numel( P ) > hi_nr_poles )
      % Weed out some of the gain factors.
      min_nr_gains = max( 65, ceil( 20000/numel(P) ) );
      pref_nr_gains = max( min_nr_gains, round( 1e7 / size(modalss.a,1)^2 ) );
      while numel(GAINS) > pref_nr_gains
        GAINS = GAINS(1:2:end);
      end
      if GAINS(1) ~= 0
        GAINS = [ 0; GAINS ];
      end
      negGAINS = GAINS;
      GAINeq1_ndx = find( negGAINS == 1 );
      if ~isempty(GAINeq1_ndx)
        negGAINS(GAINeq1_ndx) = negGAINS(GAINeq1_ndx-1);
      end
      
      ver_nr = version;
      if strcmp( ver_nr(1),'6')
        wb_text = 'Computing Root Locus (to cancel, close this window)';
      else
        if dom_ndx == 1
          wb_text = {'Computing Continuous-Time Root Locus'; ...
                          ' ';' ';'(to cancel, close this window)'};
        else
          wb_text = {'Computing Discrete-Time Root Locus'; ...
                          ' ';' ';'(to cancel, close this window)'};
        end
      end
      wb_h = waitbar( max(0.01, 1/numel(GAINS) ), wb_text, ...
                     'name','D-T Root-Locus Computation Progress');
      wb_ax_h = get( wb_h,'currentaxes');
      wb_text_h = get(wb_ax_h,'title');
      if numel(P) < 120
        est_skip = 12;
      elseif numel(P) < 240
        est_skip = 6;
      else
        est_skip = 3;
      end
      Loci = zeros( numel(GAINS), size(modalss.a,1) );
      Loci(1,:) = P(:).';
      negLoci = Loci;
      
      AA = modalss.a;
      BC = modalss.b * modalss.c;
      DD = modalss.d;
      
      CLpoles = eig( AA-BC/(DD+1) );

      tic
      for k = 2:numel(GAINS)
        if ~isequal( 1, ishandle(RtLocFig) )
          break
        end
        Loci(k,:) = ( eig( AA-BC/(DD+1/GAINS(k)) ) ).';
        negLoci(k,:) = ( eig( AA-BC/(DD-1/negGAINS(k)) ) ).';
        
        if ~ishandle(wb_h)
          % User has canceled the root-locus computation
          % by deleting the waitbar figure.
          % Close the root-locus plot, which would otherwise be stale.
          rtloc_h = pzg_fndo( dom_ndx, 9+dom_ndx,'fig_h');
          delete(rtloc_h)
          dom_gui_h = pzg_fndo( dom_ndx, 11+dom+ndx,'fig_h');
          if ~isempty(dom_gui_h)
            temp0 = get(dom_gui_h,'userdata');
            set( temp0(10,2),'value', 0 )
          end
          return
        elseif ( k > 4 ) && ( ( est_skip == 1 ) || ~mod( k, est_skip ) )
          elap_time = toc;
          perloop_time = elap_time/k;
          remtime_est = ( numel(GAINS) - (k-1) )*perloop_time;
          if k < 10
            remtime_est = max( 1, ( 1+(11-k)/10 ) ) * remtime_est;
          end
          if remtime_est > 60
            remtime_text = ...
              ['Estimated time remaining:  ' ...
               num2str(remtime_est/60, 3 ) ' minutes.'];
          else
            remtime_text = ...
              ['Estimated time remaining:  ' ...
               num2str(round(remtime_est)) ' seconds.'];
          end
          if strcmp(ver_nr(1),'6')
            wb_text = [ remtime_text '(close, to cancel)'];
          else
            wb_text{2} = remtime_text;
          end
          if ishandle( wb_h )
            set( wb_text_h,'string', wb_text );
            waitbar( max( 0.01, 0.95*k/numel(GAINS) ), wb_h )
          else
            delete( RtLocFig )
          end
        end
      end
      if ishandle( wb_h )
        delete(wb_h)
      end

    elseif ~isempty(modalss)
      Loci = rlocus( modalss, GAINS );
      negLoci = rlocus( modalss, -negGAINS );
      if size(Loci,1) == size(modalss.a,1)
        Loci = Loci.';
        negLoci = negLoci.';
      end
    else
      % Use unfactored polynomials in "gnarly" cases (not as accurate).
      OLnum = K * poly( Z );
      OLden = poly(P);
      Loci = rlocus( OLnum, OLden, GAINS );
      negLoci = rlocus( OLnum, OLden, -negGAINS );
    end
    
    % Determine negative root-locus visibility.
    negrloc_cb_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_show_neg_root_loci');
    if isempty(negrloc_cb_h) || ~get(negrloc_cb_h,'value')
      negrloc_vis = 'off';
    else
      negrloc_vis = 'on';
    end
    
    % Compute the asymptotes.
    asymptotes = [];
    neg_asymptotes = [];
    nr_asymp = numel(P) - numel(Z);
    if nr_asymp > 1
      % Compute the asymptotes.
      asymp_angles = zeros(nr_asymp,1);
      del_angle = 2*pi / nr_asymp;
      if mod(nr_asymp,2)
        % Odd number of asymptotes.
        asymp_angles(1) = pi;
        for k = 2:nr_asymp
          asymp_angles(k) = pi - (k-1)*del_angle;
        end
      else
        asymp_angles(1) = -pi+del_angle/2;
        for k = 2:nr_asymp
          asymp_angles(k) = -pi+del_angle/2 + (k-1)*del_angle;
        end    
      end
      if Gain < 0
        asymp_angles = asymp_angles + del_angle/2;
      end
      if nr_asymp == 1
        if Gain > 0
          asymp_intersect = min( real([P(:);Z(:)]) ); 
        else
          asymp_intersect = max( real([P(:);Z(:)]) ); 
        end
      else  
        asymp_intersect = ( sum(P) - sum(Z) ) / nr_asymp;
      end
      min_real_loci = min( real( Loci(:) ) );
      max_real_loci = max( real( Loci(:) ) );
      max_imag_loci = max( abs(imag(Loci(:))) );
      asymptotes = zeros( 1000, nr_asymp );
      for k = 1:nr_asymp
        this_angle = angle( exp(1i*asymp_angles(k)) );
        if abs(this_angle) == pi
          max_value = abs(min_real_loci);
        elseif abs(this_angle) > pi/2
          max_value = 2*max( max_imag_loci, abs(min_real_loci) );
        elseif abs(this_angle) == pi/2
          max_value = 2*max_imag_loci;
        elseif abs(this_angle) > 0
          max_value = 2*max( max_imag_loci, abs(max_real_loci) );
        else
          max_value = 2*abs(max_real_loci);
        end
        asymptotes(:,k) = asymp_intersect + ...
          ( cos(this_angle) + 1i*sin(this_angle) ) ...
          *linspace( 0, max_value, size(asymptotes,1) )';
      end
      asymptotes = [ asymptotes; NaN*ones(1,size(asymptotes,2)) ];
      neg_asymptotes = asymp_intersect - ( asymptotes - asymp_intersect );
    end

    rloc_ax_h = PZG(dom_ndx).plot_h{9+dom_ndx}.ax_h;
    if sum( get(rloc_ax_h,'color') ) > 0.6
      this_gray = [0.4 0.4 0.4];
      marker_gray = [0.5 0.5 0.5];
      this_red = [1 0.3 0.3];
      % hi_contrast = [ 0 0 0 ];
    else
      this_gray = [0.8 0.8 0.8];
      marker_gray = [0.7 0.7 0.7];
      this_red = [1 0.6 0.6];
      % hi_contrast = [ 1 1 1 ];
    end

    ldlg_prev_h = pzg_fndo( dom_ndx, 9+dom_ndx,'LDLG_Preview');
    if numel(ldlg_prev_h) ~= 7
      delete(ldlg_prev_h)
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview = ...
        plot( real(Loci(:)), imag(Loci(:)), ...
           'color', this_gray, ...
           'linestyle','none', ...
           'marker','.', ...
           'markersize', 6, ...
           'linewidth', 2, ...
           'parent', rloc_ax_h, ...
           'tag',[Domain 'LDLG Preview'] );
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(2) = ...
        plot( real(Pole), imag(Pole),'x', ...
           'color', marker_gray, ...
           'linewidth', 3, ...
           'linestyle','none', ...
           'markersize', 14, ...
           'parent', rloc_ax_h, ...
           'tag',[Domain 'LDLG Preview'] );
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(3) = ...
        plot( real(Zero), imag(Zero),'o', ...
           'color', marker_gray, ...
           'linewidth', 3, ...
           'linestyle','none', ...
           'markersize', 12, ...
           'parent', rloc_ax_h, ...
           'tag',[Domain 'LDLG Preview'] );
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(4) = ...
        plot( real(CLpoles), imag(CLpoles),'s', ...
           'color', marker_gray, ...
           'linewidth', 3, ...
           'linestyle','none', ...
           'markersize', 12, ...
           'parent', rloc_ax_h, ...
           'tag',[Domain 'LDLG Preview'] );
      if ~isempty(asymptotes)
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(5) = ...
          plot( real(asymptotes(:)), imag(asymptotes(:)), ...
             'color', this_gray, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'parent', rloc_ax_h, ...
             'tag',[Domain 'LDLG Preview'] );
      else
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(5) = ...
          plot( 0, 0, ...
             'color', this_gray, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'visible','off', ...
             'parent', rloc_ax_h, ...
             'tag',[Domain 'LDLG Preview'] );
      end
      if ~isempty(neg_asymptotes)
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(6) = ...
           plot( real(neg_asymptotes(:)), imag(neg_asymptotes(:)), ...
             'color', this_red, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'parent', rloc_ax_h, ...
             'visible', negrloc_vis, ...
             'tag',[Domain 'LDLG Preview'] );
      else
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(6) = ...
           plot( 0, 0, ...
             'color', this_red, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'parent', rloc_ax_h, ...
             'visible', negrloc_vis, ...
             'tag',[Domain 'LDLG Preview'] );
        set( PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(6), ...
            'xdata', [],'ydata', [] )
      end
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.LDLG_Preview(7) = ...
        plot( real(negLoci(:)), imag(negLoci(:)), ...
          'color', this_red, ...
          'linestyle','none', ...
          'marker','.', ...
          'markersize', 6, ...
          'linewidth', 2, ...
          'tag',[Domain 'LDLG Preview'], ...
          'visible', negrloc_vis, ...
          'parent', rloc_ax_h );
    else
      set( ldlg_prev_h(1), ...
          'xdata', real(Loci(:)), ...
          'ydata', imag(Loci(:)), ...
          'color', this_gray, ...
          'visible','on');
      set( ldlg_prev_h(2), ...
          'xdata', real(Pole), ...
          'ydata', imag(Pole), ...
          'color', marker_gray, ...
          'visible','on');
      set( ldlg_prev_h(3), ...
          'xdata', real(Zero), ...
          'ydata', imag(Zero), ...
          'color', marker_gray, ...
          'visible','on');
      set( ldlg_prev_h(4), ...
          'xdata', real(CLpoles), ...
          'ydata', imag(CLpoles), ...
          'color', marker_gray, ...
          'visible','on');
      if ~isempty(asymptotes)
        set( ldlg_prev_h(5), ...
          'xdata', real(asymptotes(:)), ...
          'ydata', imag(asymptotes(:)), ...
          'color', this_gray, ...
          'visible','on');
      else
        set( ldlg_prev_h(5), ...
          'xdata', [], ...
          'ydata', [], ...
          'color', this_gray, ...
          'visible','off');
      end
      if isempty(neg_asymptotes)
        set( ldlg_prev_h(6),'xdata',[],'ydata',[],'visible','off')
      else
        set( ldlg_prev_h(6), ...
            'xdata', real(neg_asymptotes(:)), ...
            'ydata', imag(neg_asymptotes(:)), ...
            'color', this_red, ...
            'linewidth', 1, ...
            'linestyle','-.', ...
            'visible', negrloc_vis )
      end
      set( ldlg_prev_h(7), ...
        'xdata', real(negLoci(:)), ...
        'ydata', imag(negLoci(:)), ...
        'color', this_red, ...
        'linestyle','none', ...
        'marker','.', ...
        'markersize', 6, ...
        'linewidth', 1, ...
        'visible', negrloc_vis );
    end
      
    if strcmp( get( PZG(dom_ndx).plot_h{9+dom_ndx}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{9+dom_ndx}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 9+dom_ndx );
    end
  end
  
  SensFig = pzg_fndo( dom_ndx, 5,'fig_h');
  if ~isempty(SensFig)
    Sens = 20*log10( abs( 1./(1+OLCplxBode) ) );
    plotFreqs = Freqs;
    hz_checkbox_h = findobj( SensFig,'string','Hz','type','uicontrol');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 5,'LDLG_Preview');
    if ~isequal( 1, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{5}.hndl.LDLG_Preview = ...
        plot( plotFreqs, Sens,'m', ...
             'parent', PZG(dom_ndx).plot_h{5}.ax_h, ...
             'tag',[Domain 'LDLG Preview'], ...
             'linewidth', 2 );
      if ~CLstable
        set( PZG(dom_ndx).plot_h{5}.hndl.LDLG_Preview,'visible','off');
      end
    else
      if CLstable
        set( LineH,'xdata', plotFreqs,'ydata', Sens,'visible','on')
      else
        set( LineH,'visible','off')
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{5}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{5}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 5 );
    end
  end

elseif strcmpi( GCBOtag,'Apply') && strcmpi( get(gcbo,'enable'),'on')
  % Add the compensator to the system in the PZGUI.
  local_clear_preview( dom_ndx )
  set( gcbo,'enable','off')

  Gain = str2num( get( hndl.Gain_edit,'string') ); %#ok<ST2NM>
  if dom_ndx == 1
    Pole = -abs( str2num( get( hndl.Pole_edit,'string') ) ); %#ok<ST2NM>
  else
    Pole = real( str2num( get( hndl.Pole_edit,'string') ) ); %#ok<ST2NM>
    if abs(Pole) > 1
      Pole = 1/Pole;
    end
  end
  Zero = str2num( get( hndl.Zero_edit,'string') ); %#ok<ST2NM>
  if isempty(Gain) || isempty(Pole) || isempty(Zero)
    errordlg('Pole/Zero/Gain not fully specified.', ...
             'Filter Build Error')
    return
  elseif ~isreal(Gain) || ~isreal(Zero)
    errordlg('Pole, zero, and gain must be real-valued.', ...
             'Filter Preview Error')
    return
  end
  
  if ( numel( intersect( PZG(dom_ndx).PoleLocs, Pole ) ) == numel(Pole) ) ...
    &&( numel( intersect( PZG(dom_ndx).ZeroLocs, Zero ) ) == numel(Zero) )
    questdlg_str = ...
      questdlg( ...
        {'The indicated filter design has already been added.'; ...
         ' ';
         'Did you intend to add it once again?'; ...
         ' '}, ...
         'Add the Filter Design Again???', ...
         'Yes, add it again','No, cancel','No, cancel');
    if ~strcmpi( questdlg_str,'Yes, add it again')
      return
    end
  end
  
  save_undo_info(dom_ndx);
  
  waitmsg_h = ...
    msgbox({'Please wait while the poles, zeros, and gain have'; ...
            ' and gain are applied into the main GUI ...';' '}, ...
           'Please Wait ...');
  PZG(dom_ndx).PoleLocs = [ Pole; PZG(dom_ndx).PoleLocs ];
  PZG(dom_ndx).ZeroLocs = [ Zero; PZG(dom_ndx).ZeroLocs ];
  if ~isnan(Gain) && ~isinf(Gain) && ( Gain ~= 0 )
    PZG(dom_ndx).Gain = PZG(dom_ndx).Gain * Gain;
  end
  PZG(dom_ndx).recompute_frf = 1;
  
  % Turn off "Fix DC"
  if dom_ndx == 1
    fixdc_h = ...
      findobj( allchild(0),'type','uicontrol','tag','C-T Fix DC checkbox');
  else
    fixdc_h = ...
      findobj( allchild(0),'type','uicontrol','tag','D-T Fix DC checkbox');
  end
  if ~isempty(fixdc_h)
    set( fixdc_h,'value', 0 )
  end
  
  if strcmp( Domain,'s')
    if PZG(1).recompute_frf
      PZG(1).recompute_frf = 0;
      pzg_cntr(1);
      pzg_bodex(1);
    end
    pzgui
    updatepl
  else
    if PZG(2).recompute_frf
      PZG(2).recompute_frf = 0;
      pzg_cntr(2);
      pzg_bodex(2);
    end
    dpzgui
    dupdatep
  end
  
  % If the two GUI's are linked, update the other one.
  if dom_ndx == 1
    linked_from = pzg_islink(1);
    linked_to = pzg_islink(2);
    other_link_cb_h = pzg_fndo( 2, 13,'LinkCheckbox');
    other_link_method_h = pzg_fndo( 2, 13,'LinkMethod');
  else
    linked_from = pzg_islink(2);
    linked_to = pzg_islink(1);
    other_link_cb_h = pzg_fndo( 1, 12,'LinkCheckbox');
    other_link_method_h = pzg_fndo( 1, 12,'LinkMethod');
  end
  if linked_to
    set( other_link_cb_h,'value', 0 )
    if strcmpi( PZG(dom_ndx).DefaultBackgroundColor,'k')
      set([other_link_cb_h;other_link_method_h], ...
          'backgroundcolor',[0 0 0]);
    else
      set([other_link_cb_h;other_link_method_h], ...
          'backgroundcolor',[1 1 1]);
    end
    if isequal( 0, slider_is_moving )
      if dom_ndx == 1
        msgbox_h = ...
          msgbox( ...
            {'Link from the discrete-time GUI has been turned off.'; ...
             ' ';'     Click "OK" to continue.'}, ...
            'Disconnected S-Plane from Z-Plane');
      else
        msgbox_h = ...
          msgbox( ...
            {'Link from the continuous-time GUI has been turned off.'; ...
             ' ';'     Click "OK" to continue.'}, ...
            'Disconnected Z-Plane from S-Plane');
      end
      uiwait(msgbox_h)
    end
  end
  if linked_from
    if dom_ndx == 1
      PZG(2).recompute_frf = 0;
      pzg_cntr(2);
      pzg_bodex(2);
      dpzgui
      dupdatep
    else
      PZG(1).recompute_frf = 0;
      pzg_cntr(1);
      pzg_bodex(1);
      pzgui
      updatepl
    end
  end
  
  if ishandle(waitmsg_h)
    delete(waitmsg_h)
  end
  
  msgbox_h = ...
    msgbox({'The pole, zero, and gain have'; ...
            'been applied into the main GUI.'; ...
            ' ';'   Click "OK" to continue ....';' '}, ...
           'Model Has Been Modified');
  msgbox_pos = get(msgbox_h,'position');
  msgbox_pos(3) = 1.5*msgbox_pos(3);
  set(msgbox_h,'position',msgbox_pos);
  
  if isequal( 1, ishandle(msgbox_h) )
    if isequal( 0, slider_is_moving )
      uiwait(msgbox_h)
    else
      delete(msgbox_h)
    end
  end
  
  set( gcbo,'enable','on')
  
elseif strcmp( GCBOtag,'clear preview')
  % Clear the preview.
  local_clear_preview( dom_ndx )
end

msgbox_h = findobj( allchild(0),'name','Model Has Been Modified');
if ~isempty(msgbox_h)
  if numel(msgbox_h) > 1
    delete(msgbox_h(2:end))
  end
  figure(msgbox_h(1))
end

if isequal( 1, ishandle(LdLgFig) )
  ldlg_ax_h = findobj(LdLgFig,'type','axes');
  if numel(ldlg_ax_h) > 1
    delete(ldlg_ax_h(2:end))
  end
  if ~isempty(ldlg_ax_h)
    set(ldlg_ax_h(1),'tag','no-vis axes','visible','off');
  end
end

drawnow

return


% LOCAL FUNCTION

function save_undo_info(dom_ndx)

  global PZG

  M = dom_ndx;
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

function local_refresh_entries( Domain, LdLgFig )
  
  global PZG
  
  hndl = getappdata(LdLgFig,'hndl');
  if isempty(LdLgFig) || isempty(hndl)
    return
  end
  
  if strcmp(Domain,'s')
    dom_ndx = 1;
  else
    dom_ndx = 2;
  end
  MaxPhs = str2double( get( hndl.MaxPhs_edit,'string') );
  if ~isempty(MaxPhs) && ~isinf(MaxPhs) && ~isnan(MaxPhs)
    MaxPhs = max( -90, min( 90, MaxPhs ) );
    set( hndl.MaxPhs_edit,'string', num2str(MaxPhs) );
    PZG(dom_ndx).LeadLag{1} = MaxPhs;
  else
    set( hndl.MaxPhs_edit,'string','');
    PZG(dom_ndx).LeadLag{1} = [];
  end
  PhsCtr = str2double( get( hndl.PhsCtr_edit,'string') );
  if ~isempty(MaxPhs) && ~isinf(MaxPhs) && ~isnan(MaxPhs)
    PhsCtr = abs(PhsCtr);
    set( hndl.PhsCtr_edit,'string', num2str(PhsCtr) );
    PZG(dom_ndx).LeadLag{2} = PhsCtr;
  else
    set( hndl.PhsCtr_edit,'string','');
    PZG(dom_ndx).LeadLag{2} = [];
  end
  GainCross = str2double( get( hndl.GainCross_edit,'string') );
  if ~isempty(GainCross) && ~isinf(GainCross) && ~isnan(GainCross)
    GainCross = abs(GainCross);
    set( hndl.GainCross_edit,'string', num2str(GainCross) );
    PZG(dom_ndx).LeadLag{3} = str2double( get( hndl.GainCross_edit,'string') );
  else
    set( hndl.GainCross_edit,'string','');
    PZG(dom_ndx).LeadLag{3} = [];
  end
  Gain = str2double( get( hndl.Gain_edit,'string') );
  if ~isempty(Gain) && ~isinf(Gain) && ~isnan(Gain)
    Gain = abs(Gain);
    set( hndl.Gain_edit,'string', num2str(Gain) );
    PZG(dom_ndx).LeadLag{4} = Gain;
  else
    set( hndl.Gain_edit,'string','');
    PZG(dom_ndx).LeadLag{4} = [];
  end
  Pole = str2double( get( hndl.Pole_edit,'string') );
  if ~isempty(Pole) && ~isinf(Pole) && ~isnan(Pole)
    if dom_ndx == 1
      Pole = -abs(Pole);
    else
      Pole = min( 1, abs(Pole) );
    end
    set( hndl.Pole_edit,'string', num2str(Pole) );
    PZG(dom_ndx).LeadLag{5} = Pole;
  else
    set( hndl.Pole_edit,'string','');
    PZG(dom_ndx).LeadLag{5} = [];
  end
  Zero = str2double( get( hndl.Zero_edit,'string') );
  if ~isempty(Zero) && ~isinf(Zero) && ~isnan(Zero)
    if dom_ndx == 1
      Zero = -abs(Zero);
    else
      Zero = min( 1, abs(Zero) );
    end
    set( hndl.Zero_edit,'string', num2str(Zero) );
    PZG(dom_ndx).LeadLag{6} = Zero;
  else
    set( hndl.Zero_edit,'string','');
    PZG(dom_ndx).LeadLag{6} = [];
  end
return

function local_clear_preview( dom_ndx )
  global PZG
  prev_h = pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'LDLG_Preview');
  set(prev_h,'visible','off')
  LdLgFig = PZG(dom_ndx).LDLG_fig;
  if ~isempty(LdLgFig)
    hndl = getappdata( LdLgFig,'hndl');
    if isfield( hndl,'preview_pushbutton')
      set( hndl.preview_pushbutton,'backgroundcolor', 0.9412*[1 1 1]);
    end
    if isfield( hndl,'clear_preview_pushbutton')
      set( hndl.clear_preview_pushbutton,'visible','off');
    end
    if isfield( hndl,'leadlag_slider_menu')
      set( hndl.leadlag_slider_menu,'visible','off');
    end
    if isfield( hndl,'leadlag_slider')
      set( hndl.leadlag_slider,'visible','off');
    end
    design_line_h = pzg_fndo( dom_ndx, 6,'CL_0dB_contour');
    if ~isempty(design_line_h)
      set(design_line_h,'visible','off');
    end
    design_text_h = pzg_fndo( dom_ndx, 6,'LeadLag_Text');
    if ~isempty(design_text_h)
      set(design_text_h,'visible','off');
    end
  end
  for k = [(1:9),dom_ndx+[9,11]]
    fig_h = pzg_fndo( dom_ndx, k,'fig_h');
    if isempty(fig_h)
      continue
    end
    pzg_lims( dom_ndx, k );
  end
return

function ldlg_parms_out = zpk2parms( ldlg_parms_in, dom_ndx )
  global PZG
  
  ldlg_parms_out = [];
  if ~nargin || ~iscell(ldlg_parms_in) ...
    || ( numel(ldlg_parms_in) < 7 )
    return
  end
  ldlg_parms_out = ldlg_parms_in;
  if ( nargin < 2 ) ...
    || ( ~isequal( dom_ndx, 1 ) && ~isequal( dom_ndx, 2 ) )
    return
  end

  K = ldlg_parms_in{4};
  P = ldlg_parms_in{5};
  Z = ldlg_parms_in{6};

  if ~isequal(1,numel(K)) || ~isequal(1,numel(P)) || ~isequal(1,numel(Z)) ...
    || ~isreal(K) || ~isreal(Z) || ~isreal(P) ...
    || ( K <= 0 )
    return
  end
  if isequal( dom_ndx, 1 ) 
    if ( Z > 0 ) || ( P > 0 )
      % Continuous-time pole or zero is in the right-half of the s-plane.
      return
    end
  elseif ( Z < 0 ) || ( Z > 1 ) || ( P < 0 ) || ( P > 1 )
    % Discrete-time pole or zero is not in the range [ 0, 1 ].
    return
  end

  if isequal( dom_ndx, 1 )
    % Continuous-time formulas
    % Frequency at which extreme phase occurs
    w_xtrm = sqrt(P*Z);
    ldlg_parms_out{2} = w_xtrm;
    % Extreme phase:
    if abs( P - Z ) < 1e-9
      ldlg_parms_out{1} = 0;
    elseif ( P == 0 ) && ( Z == 0 )
      ldlg_parms_out{1} = 0;
    elseif P == 0
      ldlg_parms_out{1} = -90;
    elseif Z == 0
      ldlg_parms_out{1} = 90;
    else
      ldlg_parms_out{1} = ...
        ( angle( 1i*w_xtrm - Z ) - angle( 1i*w_xtrm - P ) )*180/pi;
    end
    % Unity-gain-crossover frequency.
    if K ~= 1
      sqrt_arg = (P^2-K^2*Z^2) / (K^2-1);
      if sqrt_arg >= 0
        ldlg_parms_out{3} = sqrt( sqrt_arg );
      else
        ldlg_parms_out{3} = [];
      end
    else
      ldlg_parms_out{3} = [];
    end
    if ldlg_parms_in{7}
      % The "unity dc-gain checkbox is checked "on".
      if ( abs(P) < 1e-10 ) || ( abs(Z) < 1e-10 )
        ldlg_parms_out{7} = 0;
        set( hndl.dcgain_eq_1_checkbox,'value', 0 );
      else
        new_K = P/Z;
        ldlg_parms_out{4} = new_K;
        ldlg_parms_out{3} = [];
      end
    end
  else
    % Discrete-time formulas
    % Extreme phase:
    if abs( P - Z ) < 1e-9
      ldlg_parms_out{1} = 0;
    elseif P == 1
      ldlg_parms_out{1} = -90;
    elseif Z == 1
      ldlg_parms_out{1} = 90;
    else
      ldlg_parms_out{1} = ...
        ( atan( sqrt( (1-P^2)/(1-Z^2) )/P ) ...
          -atan( sqrt( (1-Z^2)/(1-P^2) )/Z ) )*180/pi;
    end
    % Frequency at which extreme phase occurs
    ldlg_parms_out{2} = acos( (Z+P)/(1+Z*P) )/PZG(2).Ts;
    % Unity-gain-crossover frequency.
    acos_arg = ( K^2*(1+Z^2) - (1+P^2) )/( 2*(K^2*Z-P) );
    if ( acos_arg >= -1 ) && ( acos_arg <= 1 )
      ldlg_parms_out{3} = acos( acos_arg )/PZG(2).Ts;
    else
      ldlg_parms_out{3} = [];
    end
    if ldlg_parms_in{7}
      % The "unity dc-gain checkbox is checked "on".
      if ( abs( P - 1 ) < 1e-10 ) || ( abs( Z - 1 ) < 1e-10 )
        ldlg_parms_out{7} = 0;
        set( hndl.dcgain_eq_1_checkbox,'value', 0 );
      else
        new_K = (1-P)/(1-Z);
        ldlg_parms_out{4} = new_K;
        ldlg_parms_out{3} = [];
      end
    end
  end
  if isequal(P,Z)
    ldlg_parms_out{3} = [];
  end
  if ldlg_parms_in{7}
    % Compute DC gain.
    if dom_ndx == 1
      if ~isequal( ldlg_parms_out{5}, 0 ) ...
        && ~isequal( ldlg_parms_out{6}, 0 )
        unity_dcgain = abs( ldlg_parms_out{5} / ldlg_parms_out{6} );
        ldlg_parms_out{4} = unity_dcgain;
        ldlg_parms_out{3} = [];
      else
        ldlg_parms_out{7} = 0;
      end
    else
      if ~isequal( ldlg_parms_out{5}, 1 ) ...
        && ~isequal( ldlg_parms_out{6}, 1 )
        unity_dcgain = abs( ( 1 - ldlg_parms_out{5} ) ...
                       /( 1 - ldlg_parms_out{6} ) );
        ldlg_parms_out{4} = unity_dcgain;
        ldlg_parms_out{3} = [];
      else
        ldlg_parms_out{7} = 0;
      end
    end
  end
return


function ldlg_parms_out = parms2zpk( ldlg_parms_in, dom_ndx )
  
  global PZG
  
  ldlg_parms_out = [];
  if ~nargin || ~iscell(ldlg_parms_in) ...
    || ( numel(ldlg_parms_in) < 7 )
    return
  end
  ldlg_parms_out = ldlg_parms_in;
  if ( nargin < 2 ) ...
    || ( ~isequal( dom_ndx, 1 ) && ~isequal( dom_ndx, 2 ) )
    return
  end

  xtrm_phs = ldlg_parms_in{1};
  w_xtrm = ldlg_parms_in{2};
  w_xover = ldlg_parms_in{3};
  K = ldlg_parms_in{4};
  
  if ~isequal(1,numel(xtrm_phs)) || ~isequal(1,numel(w_xtrm)) ...
    ||( ~isequal(1,numel(K)) && ~isequal(1,numel(w_xover)) ) ...
    || ~isreal(xtrm_phs) || ~isreal(w_xtrm) ...
    ||( isequal(1,numel(K)) &&( ( K <= 0 ) || ~isreal(K) ) )
    return
  end
  
  if isequal( dom_ndx, 1 )
    % Continuous-time formulas
    if xtrm_phs < -89.8
      P = 0;
      Z = ldlg_parms_in{6};
      if isempty(Z)
        w_xover = ldlg_parms_in{3};
        if ~isempty(w_xover)
          Z = -w_xover;
        else
          Z = -1;
        end
      end
    elseif xtrm_phs > 89.8
      Z = 0;
      P = ldlg_parms_in{5};
      if isempty(P)
        w_xover = ldlg_parms_in{3};
        if ~isempty(w_xover)
          P = -w_xover;
        else
          P = -1;
        end
      end
    elseif abs(xtrm_phs) < 1e-6
      P = ldlg_parms_in{5};
      Z = ldlg_parms_in{6};
      if isempty(P) && isempty(Z)
        P = -1;
        Z = -1;
      elseif isempty(P)
        P = Z;
      elseif isempty(Z)
        Z = P;
      else
        P = -sqrt( P*Z );
        Z = P;
      end
    else
      z_and_p = roots( [ 1 2*w_xtrm*tan(xtrm_phs/180*pi) -w_xtrm^2 ] );
      if xtrm_phs < 0
        P = -min(abs(z_and_p));
        Z = -max(abs(z_and_p));
      else
        Z = -min(abs(z_and_p));
        P = -max(abs(z_and_p));
      end
    end
    ldlg_parms_out{5} = P;
    ldlg_parms_out{6} = Z;
    if isequal(P,Z)
      ldlg_parms_out{3} = [];
    end
    if ~isequal(1,numel(w_xover))
      % Unity-gain-crossover frequency.
      if K ~= 1
        sqrt_arg = (P^2-K^2*Z^2) / (K^2-1);
        if sqrt_arg >= 0
          ldlg_parms_out{3} = sqrt( sqrt_arg );
        else
          ldlg_parms_out{3} = [];
        end
      else
        ldlg_parms_out{3} = [];
      end
    else
      % Find the gain at the specified crossover frequency,
      % and if it isn't equal to one, change the value of K.
      w_xover_gain = abs( 1i*w_xover - Z ) / abs( 1i*w_xover - P );
      K = 1/w_xover_gain;
      ldlg_parms_out{4} = K;
    end
    if ldlg_parms_in{7}
      % The "unity dc-gain checkbox is checked "on".
      if ( abs(P) < 1e-10 ) || ( abs(Z) < 1e-10 )
        ldlg_parms_out{7} = 0;
        dc_cb_h = findobj( allchild(0),'string','DCgain = 1');
        for kk = 1:numel(dc_cb_h)
          if ~isempty( strfind( ...
                get(get(dc_cb_h(kk),'parent'),'name'),'s-Dom') )
            set( dc_cb_h(kk),'value', 0 );
          end
        end
      else
        new_K = P/Z;
        ldlg_parms_out{4} = new_K;
        ldlg_parms_out{3} = [];
      end
    end
  else
    % Discrete-time formulas
    if xtrm_phs < -89.8
      P = 1;
      Z = ldlg_parms_in{6};
      if isempty(Z)
        w_xover = ldlg_parms_in{3};
        if ~isempty(w_xover)
          Z = exp( -w_xover*PZG(2).Ts );
        else
          Z = 0.9;
        end
      end
    elseif xtrm_phs > 89.8
      Z = 1;
      P = ldlg_parms_in{5};
      if isempty(P)
        w_xover = ldlg_parms_in{3};
        if ~isempty(w_xover)
          P = exp( -w_xover*PZG(2).Ts );
        else
          P = 0.9;
        end
      end
    elseif abs(xtrm_phs) < 1e-6
      P = ldlg_parms_in{5};
      Z = ldlg_parms_in{6};
      if isempty(P) && isempty(Z)
        P = 0.9;
        Z = 0.9;
      elseif isempty(P)
        P = Z;
      elseif isempty(Z)
        Z = P;
      else
        P = ( P + Z )/2;
        Z = P;
      end
    else
      % Compute Z and P from the extreme phase and phase-center-freq.
      xtrm_phs_diff = inf;
      use_this_xtrm_phs = xtrm_phs;
      max_loop_nr = 10;
      loop_nr = 0;
      while ( abs(xtrm_phs_diff) > 0.05 ) && ( loop_nr < max_loop_nr )
        loop_nr = loop_nr + 1;
        s_plane_z_and_p = ...
          roots( [ 1 2*w_xtrm*tan(xtrm_phs/180*pi) -w_xtrm^2 ] );
        if xtrm_phs < 0
          sP = -min(abs(s_plane_z_and_p));
          sZ = -max(abs(s_plane_z_and_p));
        else
          sZ = -min(abs(s_plane_z_and_p));
          sP = -max(abs(s_plane_z_and_p));
        end
        P = exp( sP*PZG(2).Ts );
        Z = exp( sZ*PZG(2).Ts );
        z_xtrm_phs = ...
          ( atan( sqrt( (1-P^2)/(1-Z^2) )/P ) ...
            -atan( sqrt( (1-Z^2)/(1-P^2) )/Z ) )*180/pi;
        xtrm_phs_diff = abs(z_xtrm_phs) - abs(xtrm_phs);
        if xtrm_phs_diff > 0.05;
          use_this_xtrm_phs = use_this_xtrm_phs - 0.02;
        elseif xtrm_phs_diff < -0.05
          use_this_xtrm_phs = use_this_xtrm_phs + 0.02;
        end
      end
    end
    ldlg_parms_out{5} = P;
    ldlg_parms_out{6} = Z;
    
    K = ldlg_parms_out{4};
    
    if ~isequal( 1, numel(w_xover) )
      % Compute the unity-gain-crossover frequency.
      acos_arg = ( K^2*(1+Z^2) - (1+P^2) )/( 2*(K^2*Z-P) );
      if ( acos_arg >= -1 ) && ( acos_arg <= 1 )
        ldlg_parms_out{3} = acos( acos_arg )/PZG(2).Ts;
      else
        ldlg_parms_out{3} = [];
      end
    else
      % Find the gain at the specified crossover frequency,
      % and if it isn't equal to one, change the value of K.
      w_xover_gain = ...
        abs( exp(1i*w_xover*PZG(2).Ts) - Z ) ...
        /abs( exp(1i*w_xover*PZG(2).Ts) - P );
      K = 1/w_xover_gain;
      ldlg_parms_out{4} = K;
    end
    if ldlg_parms_in{7}
      % The "unity dc-gain checkbox is checked "on".
      if ( abs(P-1) < 1e-10 ) || ( abs(Z-1) < 1e-10 )
        ldlg_parms_out{7} = 0;
        dc_cb_h = findobj( allchild(0),'string','DCgain = 1');
        for kk = 1:numel(dc_cb_h)
          if ~isempty( strfind( ...
                get(get(dc_cb_h(kk),'parent'),'name'),'z-Dom') )
            set( dc_cb_h(kk),'value', 0 );
          end
        end
      else
        if ( P ~= 1 ) && ( Z ~= 1 ) 
          new_K = (1-P)/(1-Z);
          ldlg_parms_out{4} = new_K;
          ldlg_parms_out{3} = [];
        end
      end
    end
    if isequal(P,Z)
      ldlg_parms_out{3} = [];
    end
  end
  if ldlg_parms_in{7}
    % Compute DC gain.
    if dom_ndx == 1
      if ~isequal( ldlg_parms_out{5}, 0 ) ...
        && ~isequal( ldlg_parms_out{6}, 0 )
        unity_dcgain = abs( ldlg_parms_out{5} / ldlg_parms_out{6} );
        ldlg_parms_out{4} = unity_dcgain;
        ldlg_parms_out{3} = [];
      else
        ldlg_parms_out{7} = 0;
      end
    else
      if ~isequal( ldlg_parms_out{5}, 1 ) ...
        && ~isequal( ldlg_parms_out{6}, 1 )
        unity_dcgain = abs( ( 1 - ldlg_parms_out{5} ) ...
                       /( 1 - ldlg_parms_out{6} ) );
        ldlg_parms_out{4} = unity_dcgain;
        ldlg_parms_out{3} = [];
      else
        ldlg_parms_out{7} = 0;
      end
    end
  end
return
