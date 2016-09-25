function   pidfilt( Domain, DeleteAll, quiet )
% Creates and services the PID-controller design tool in PZGUI.

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
if isempty(PZG) && ~pzg_recovr
  return
end
evalin('base','global PZG')

GCBO = gcbo;
GCBF = gcbf;

pole2_multiplier = 10;

if ~nargin || isempty(Domain) || ~ischar(Domain)
  return
elseif ~isempty( strfind( Domain,'clear preview') )
  if strcmpi( Domain(1),'s')
    dom_ndx = 1;
  else
    dom_ndx = 2;
  end
  [ which_tool, toolfig_h ] = pzg_tools(dom_ndx);
  if which_tool(3) && ~isempty(toolfig_h)
    hndl = getappdata( toolfig_h,'hndl');
    local_clear_preview( dom_ndx, hndl );
  end
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
  PidFig = PZG(1).PID_fig;
elseif strcmpi( Domain(1),'z') ...
  ||( ( numel(Domain) > 12 )...
     && strcmpi( Domain(1:8),'discrete') )
  Domain = 'z';
  dom_ndx = 2;
  PidFig = PZG(2).PID_fig;
elseif strcmpi( Domain,'mouse motion')
  PidFig = GCBF;
  PidFigName = get( PidFig,'name');
  if strcmpi( PidFigName(1),'s')
    Domain = 's';
    dom_ndx = 1;
  else
    Domain = 'z';
    dom_ndx = 2;
  end
else
  return
end
if isempty(PidFig)
  PidFigName = [ Domain '-Domain PID Design GUI'];
  PidFig = findobj( allchild(0),'name', PidFigName );
  if numel(PidFig) > 1
    delete(PidFig)
    PidFig = [];
  end
else
  PidFigName = get( PidFig,'name');
end
if ~isempty(PidFig) && isequal( 1, ishandle(PidFig) ) ...
  && isappdata(PidFig,'hndl')
  PZG(dom_ndx).PID_fig = PidFig;
  hndl = getappdata( PidFig,'hndl');
else
  if ~isempty(PidFig)
    delete(PidFig)
    PidFig = [];
  end
  hndl = [];
end
if isempty(PidFig) ...
  ||( ( nargin == 2 ) && ~isequal( DeleteAll, 0 ) )
  prvw_h = pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'PID_Preview');
  if ~isempty(prvw_h)
    set( prvw_h,'visible','off')
  end
end

if ~isfield( PZG,'PID')
  PZG(1).PID = cell(7,1);
  PZG(2).PID = cell(7,1);
end
for k = 1:2
  if ~iscell(PZG(k).PID) || ~isequal( size(PZG(k).PID), [7 1] )
    PZG(k).PID = cell(7,1);
  end
  for kc = 1:7
    if ~isnumeric(PZG(k).PID{kc}) ...
      ||( numel(PZG(k).PID{kc}) > 1 ) ...
      ||( ~isreal(PZG(k).PID{kc}) && ( kc ~= 5 )  && ( kc ~= 6 ) )
      PZG(k).PID{kc} = [];
    end
  end
end

% Handle menu selection
slider_is_moving = 0;
menu_is_active = 0;
if isfield( hndl,'PID_slider') && ~isempty(gcbo) ...
  && strcmp( get(gcbo,'type'),'uicontrol') ...
  && strcmp( get(gcbo,'style'),'popupmenu') ...
  && ~isequal( Domain_arg,'mouse motion')
  menu_is_active = 1;
  menu_value = get(gcbo,'value');
  if ~isappdata(gcbo,'oldmenuvalue')
    setappdata( gcbo,'oldmenuvalue', menu_value );
    old_menu_value = menu_value;
  else
    old_menu_value = getappdata( gcbo,'oldmenuvalue');
  end
  if isequal( old_menu_value, menu_value )
    return
  end
  setappdata( gcbo,'oldmenuvalue', menu_value );
  if ~isappdata( hndl.PID_slider,'old_slider')
    old_slider_values = 0.5*ones(7,1);
    old_slider_values(end) = ( 1 - log10(3) ) / ( 3 - log10(3) );
    setappdata( hndl.PID_slider,'old_slider', old_slider_values )
  end
  old_slider_values = getappdata( hndl.PID_slider,'old_slider');
  if ~isnumeric(old_slider_values) || ( numel(old_slider_values) ~= 7 )
    old_slider_values = 0.5*ones(7,1);
    old_slider_values(end) = ( 1 - log10(3) ) / ( 3 - log10(3) );
    setappdata( hndl.PID_slider,'old_slider', old_slider_values )
  end
  set( hndl.PID_slider,'value', old_slider_values(menu_value) );
end

if ( nargin == 1 ) && ~menu_is_active ...
  && isequal( Domain_arg,'mouse motion') && ~isempty(gcbf)
  % See if slider has been adjusted.
  PidFig = gcbf;
  if ~isfield( hndl,'PID_slider_menu')
    return
  end
  slider_is_moving = 1;
  menu_value = get( hndl.PID_slider_menu,'value');
  slider_value = get( hndl.PID_slider,'value');
  if ~isappdata( hndl.PID_slider,'old_slider')
    old_slider_values = 0.5*ones(7,1);
    old_slider_values(end) = ( 1 - log10(3) ) / ( 3 - log10(3) );
    old_slider_values(menu_value) = slider_value;
    setappdata( hndl.PID_slider,'old_slider', old_slider_values )
    return
  else
    old_slider_values = getappdata( hndl.PID_slider,'old_slider');
    if ~isnumeric(old_slider_values) || ( numel(old_slider_values) ~= 7 )
      old_slider_values = 0.5*ones(7,1);
      old_slider_values(end) = ( 1 - log10(3) ) / ( 3 - log10(3) );
      setappdata( hndl.PID_slider,'old_slider', old_slider_values )
    end
  end
  gcbf_name = get(PidFig,'name');
  if strcmpi( gcbf_name,'s-Domain PID Design GUI')
    Domain = 's';
    dom_ndx = 1;
  elseif strcmpi( gcbf_name,'z-Domain PID Design GUI')
    Domain = 'z';
    dom_ndx = 2;
  else
    return
  end
  if dom_ndx == 1
    Ts = 0;
  else
    Ts = PZG(2).Ts;
    if Ts < 0
      Ts = 1;
    end
  end
  if isequal( slider_value, old_slider_values(menu_value) )
    if strcmpi( get( hndl.PID_slider,'visible'),'on')
      set( hndl.preview_pushbutton,'backgroundcolor', [0.5 1 0.5] );
    else
      set( hndl.preview_pushbutton,'backgroundcolor', 0.9412*[1 1 1] );
    end
    return
  else
    new_slider_values = old_slider_values;
    new_slider_values(menu_value) = slider_value;
    setappdata( hndl.PID_slider,'old_slider', new_slider_values )
  end
  pole2_multiplier = str2double( get(hndl.pole2_multiplier,'string') );
  if isempty(pole2_multiplier)
    pole2_multiplier = get( hndl.pole2_multiplier,'userdata');
    if isempty(pole2_multiplier) || ~isreal(pole2_multiplier)
      pole2_multiplier = 10;
    end
  end
  pole2_multiplier = max( 3, min( 1000, abs(pole2_multiplier) ) );
  set( hndl.pole2_multiplier,'string', num2str(pole2_multiplier,4) );
  set( hndl.pole2_multiplier,'userdata', pole2_multiplier );

  curr_Kp = str2double( get( hndl.PropGain,'string') );
  if isnan(curr_Kp) || isinf(curr_Kp) || ( curr_Kp <= 0 )
    curr_Kp = PZG(dom_ndx).PID{1};
    set( hndl.PropGain,'string', num2str(curr_Kp) );
  end
  curr_Ki = str2double( get( hndl.IntegGain,'string') );
  if isnan(curr_Ki) || isinf(curr_Ki) || ( curr_Ki <= 0 )
    curr_Ki = PZG(dom_ndx).PID{2};
    set( hndl.IntegGain,'string', num2str(curr_Ki) );
  end
  curr_Kd = str2double( get( hndl.DerivGain,'string') );
  if isnan(curr_Kd) || isinf(curr_Kd) || ( curr_Kd <= 0 )
    curr_Kd = PZG(dom_ndx).PID{3};
    set( hndl.DerivGain,'string', num2str(curr_Kd) );
  end
  curr_TFgain = str2double( get(hndl.Gain,'string') );
  if isnan(curr_TFgain) || isinf(curr_TFgain) || ( curr_TFgain <= 0 )
    curr_TFgain = PZG(dom_ndx).PID{4};
    set( hndl.Gain,'string', num2str(curr_TFgain) );
  end
  pzgPID = PZG(dom_ndx).PID;

  switch menu_value
    case 1  % Kp, proportional gain
      if isempty(curr_Kp)
        return
      end
      old_slider = old_slider_values(1);
      if old_slider == 0.5
        base_Kp = pzgPID{1};
        if isempty(base_Kp)
          base_Kp = curr_Kp;
        end
      else
        old_multiplier = 10^( 3*old_slider - 1.5 );
        base_Kp = curr_Kp / old_multiplier;
      end
      if slider_value == 0.5
        new_Kp = base_Kp;
      else
        new_multiplier = 10^( 3*slider_value - 1.5 );
        new_Kp = base_Kp * new_multiplier;
      end
      if isempty(new_Kp) || isnan(new_Kp) || isinf(new_Kp)
        new_Kp = [];
        set( hndl.IntegGain,'string','');
      else
        set( hndl.PropGain,'string', num2str(new_Kp) );
      end
      pzgPID{1} = new_Kp;
      
      [ pzgPID, error_str ] = ...
         local_pidgain2zpk( ...
           pzgPID, Ts, pole2_multiplier, slider_is_moving );
      if isempty(error_str)
        PZG(dom_ndx).PID = pzgPID;
        set( hndl.PropGain,'string', num2str(pzgPID{1},6) );
        if ~isequal( pzgPID{3}, PZG(dom_ndx).PID{3} )
          set( hndl.DerivGain,'string',num2str(pzgPID{3},6) );
          set( hndl.Gain,'string', num2str(pzgPID{3},6) );
          new_slider_values(3:4) = 0.5;
        end
        set( hndl.Gain,'string', num2str( pzgPID{4}, 6 ) );
        set( hndl.Zero1,'string', num2str( pzgPID{5}, 5 ) );
        set( hndl.Zero2,'string', num2str( pzgPID{6}, 5 ) );
        new_slider_values(4) = 0.5;
        if isreal(pzgPID{5})
          new_slider_values(5:6) = 0.5;
        else
          new_zero = pzgPID{5};
          if dom_ndx == 2
            new_zero = log(new_zero)/PZG(2).Ts;
          end
          slider_val = local_angle2slider( abs(angle(new_zero)) );
          if ~isempty(slider_val)
            new_slider_values(5:6) = slider_val;
          end
        end
        setappdata( hndl.PID_slider,'old_slider', new_slider_values )
        PZG(dom_ndx).PID = pzgPID;
      else
        set( hndl.PropGain,'string', num2str(PZG(dom_ndx).PID{1},6) );
        disp(error_str)
        return
      end
      
    case 2  % Ki, integral gain
      if isempty(curr_Ki)
        return
      end
      old_slider = old_slider_values(2);
      if old_slider == 0.5
        base_Ki = pzgPID{2};
        if isempty(base_Ki)
          base_Ki = curr_Ki;
        end
      else
        old_multiplier = 10^( 3*old_slider - 1.5 );
        base_Ki = curr_Ki / old_multiplier;
      end
      if slider_value == 0.5
        new_Ki = base_Ki;
      else
        new_multiplier = 10^( 3*slider_value - 1.5 );
        new_Ki = base_Ki * new_multiplier;
      end
      if isempty(new_Ki) || isnan(new_Ki) || isinf(new_Ki)
        set( hndl.IntegGain,'string','');
      else
        set( hndl.IntegGain,'string', num2str(new_Ki) );
      end
      pzgPID{2} = new_Ki;
      
      [ pzgPID, error_str ] = ...
         local_pidgain2zpk( ...
           pzgPID, Ts, pole2_multiplier, slider_is_moving );
      if isempty(error_str)
        if ~isequal( pzgPID{3}, PZG(dom_ndx).PID{3} )
          set( hndl.DerivGain,'string', num2str( pzgPID{3}, 6 ) );
          set( hndl.Gain,'string', num2str( pzgPID{3}, 6 ) );
          new_slider_values(3) = 0.5;
        end
        set( hndl.Gain,'string', num2str( pzgPID{4}, 6 ) );
        set( hndl.Zero1,'string', num2str( pzgPID{5}, 5 ) );
        set( hndl.Zero2,'string', num2str( pzgPID{6}, 5 ) );
        new_slider_values(4) = 0.5;
        if isreal(pzgPID{5})
          new_slider_values(5:6) = 0.5;
        else
          new_zero = pzgPID{5};
          if dom_ndx == 2
            new_zero = log(new_zero)/PZG(2).Ts;
          end
          slider_val = local_angle2slider( abs(angle(new_zero)) );
          if ~isempty(slider_val)
            new_slider_values(5:6) = slider_val;
          end
        end
        setappdata( hndl.PID_slider,'old_slider', new_slider_values )
        PZG(dom_ndx).PID = pzgPID;
      else
        set( hndl.IntegGain,'string', num2str(PZG(dom_ndx).PID{2},6) );
        disp(error_str)
        return
      end
      
    case 3  % Kd, derivative gain
      if isempty(curr_Kd)
        return
      end
      old_slider = old_slider_values(3);
      if old_slider == 0.5
        base_Kd = pzgPID{3};
        if isempty(base_Kd)
          base_Kd = curr_Kd;
        end
      else
        old_multiplier = 10^( 3*old_slider - 1.5 );
        base_Kd = curr_Kd / old_multiplier;
      end
      if slider_value == 0.5
        new_Kd = base_Kd;
      else
        new_multiplier = 10^( 3*slider_value - 1.5 );
        new_Kd = base_Kd * new_multiplier;
      end
      if isempty(new_Kd) || isnan(new_Kd) || isinf(new_Kd)
        set( hndl.DerivGain,'string','');
      else
        set( hndl.DerivGain,'string', num2str(new_Kd) );
      end
      pzgPID{3} = new_Kd;
      
      [ pzgPID, error_str ] = ...
         local_pidgain2zpk( ...
           pzgPID, Ts, pole2_multiplier, slider_is_moving );
      if isempty(error_str)
        set( hndl.Gain,'string', num2str( pzgPID{4}, 6 ) );
        set( hndl.Zero1,'string', num2str( pzgPID{5}, 5 ) );
        set( hndl.Zero2,'string', num2str( pzgPID{6}, 5 ) );
        new_slider_values(4) = 0.5;
        if isreal(pzgPID{5})
          new_slider_values(5:6) = 0.5;
        else
          new_zero = pzgPID{5};
          if dom_ndx == 2
            new_zero = log(new_zero)/PZG(2).Ts;
          end
          slider_val = local_angle2slider( abs(angle(new_zero)) );
          if ~isempty(slider_val)
            new_slider_values(5:6) = slider_val;
          end
        end
        setappdata( hndl.PID_slider,'old_slider', new_slider_values )
        PZG(dom_ndx).PID = pzgPID;
      else
        set( hndl.DerivGain,'string', num2str(PZG(dom_ndx).PID{3},6) );
        disp(error_str)
        return
      end
      
    case 4
      % Transfer function gain.
      if isempty(curr_TFgain)
        return
      end
      old_slider = old_slider_values(4);
      if old_slider == 0.5
        base_TFgain = curr_TFgain;
      else
        old_multiplier = 10^( 3*old_slider - 1.5 );
        base_TFgain = curr_TFgain / old_multiplier;
      end
      if slider_value == 0.5
        new_TFgain = base_TFgain;
      else
        new_multiplier = 10^( 3*slider_value - 1.5 );
        new_TFgain = base_TFgain * new_multiplier;
      end
      if isempty(new_TFgain) || isnan(new_TFgain) || isinf(new_TFgain)
        set( hndl.Gain,'string','');
      else
        set( hndl.Gain,'string', num2str(new_TFgain) );
      end
      pzgPID{4} = new_TFgain;

      [ pzgPID, error_str ] = ...
         local_zpk2pidgain( pzgPID, Ts, slider_is_moving );
      if isempty(error_str)
        if ~isequal( pzgPID{1}, PZG(dom_ndx).PID{1} )
          set( hndl.PropGain,'string', num2str( pzgPID{1}, 6 ) );
          new_slider_values(1) = 0.5;
        end
        if ~isequal( pzgPID{2}, PZG(dom_ndx).PID{2} )
          set( hndl.IntegGain,'string', num2str( pzgPID{2}, 6 ) );
          new_slider_values(2) = 0.5;
        end
        if ~isequal( pzgPID{3}, PZG(dom_ndx).PID{3} )
          set( hndl.DerivGain,'string', num2str( pzgPID{3}, 6 ) );
          new_slider_values(3) = 0.5;
        end
        PZG(dom_ndx).PID = pzgPID;
        setappdata( hndl.PID_slider,'old_slider', new_slider_values )
      else
        set( hndl.Gain,'string', num2str(PZG(dom_ndx).PID{4},6) );
        disp(error_str)
        return
      end

    case {5,6}
      old_slider = old_slider_values(menu_value);
      if menu_value == 5
        curr_zero = str2double( get( hndl.Zero1,'string') );
      else
        curr_zero = str2double( get( hndl.Zero2,'string') );
      end
      orig_zero = curr_zero;
      if isreal(curr_zero)
        if dom_ndx == 2
          curr_zero = log(curr_zero)/PZG(2).Ts;
        end
        if old_slider == 0.5
          base_zero = curr_zero;
          old_multiplier = 1; %#ok<NASGU>
        else
          old_multiplier = 10^( 3*old_slider - 1.5 );
          base_zero = curr_zero / old_multiplier;
        end
        new_multiplier = 10^( 3*slider_value - 1.5 );
        new_zero = base_zero * new_multiplier;
        if real(new_zero) > (-1e-5)
          new_zero = -1e-5;
        end
        if dom_ndx == 2
          new_zero = exp( new_zero * PZG(2).Ts );
        end
        if dom_ndx == 1
          new_multiplier = abs(new_zero)/abs(orig_zero); %#ok<NASGU>
        else
          new_multiplier = abs(1-new_zero)/abs(1-orig_zero); %#ok<NASGU>
        end
        if menu_value == 5
          pzgPID{5} = new_zero;
          set( hndl.Zero1,'string', num2str(new_zero) )
        else
          pzgPID{6} = new_zero;
          set( hndl.Zero2,'string', num2str(new_zero) )
        end
      else
        % Old slider value is irrelevant for non-real-valued zeros,
        % because slider is directly proportional to angle of the zero.
        % Also note that keeping pole magnitude constant, Kd is unchanged.
        if dom_ndx == 2
          curr_zero = log(curr_zero)/PZG(2).Ts;
        end
        slider_angle = local_slider2angle( slider_value );
        new_zero = abs(curr_zero) * exp( 1i*slider_angle );
        if real(new_zero) > (-1e-5)
          new_zero = (-1e-5) + 1i*abs(new_zero);
        end
        if dom_ndx == 2
          new_zero = exp( new_zero * PZG(2).Ts );
        end
        if isempty(new_zero) || isnan(new_zero) || isinf(new_zero)
          set( hndl.Zero1,'string','');
          set( hndl.Zero2,'string','');
        else
          set( hndl.Zero1,'string', num2str(new_zero) )
          set( hndl.Zero2,'string', num2str( conj(new_zero) ) );
        end
        pzgPID{5} = new_zero;
        pzgPID{6} = conj(new_zero);
        slider_val = local_angle2slider( abs(angle(new_zero)) );
        if ~isempty(slider_val)
          slider_value = slider_val;
        end
      end
      if ~isreal(new_zero)
        new_slider_values(5:6) = slider_value;
      end
      setappdata( hndl.PID_slider,'old_slider', new_slider_values )
      
      [ pzgPID, error_str ] = ...
          local_zpk2pidgain( ...
             pzgPID, Ts, pole2_multiplier, slider_is_moving );
      if isempty(error_str)
        PZG(dom_ndx).PID = pzgPID;
        set( hndl.PropGain,'string', num2str( pzgPID{1}, 6 ) );
        set( hndl.IntegGain,'string', num2str( pzgPID{2}, 6 ) );
        set( hndl.DerivGain,'string', num2str( pzgPID{3}, 6 ) );
        set( hndl.Gain,'string', num2str( pzgPID{4}, 6 ) );
        new_slider_values(1:4) = 0.5;
        setappdata( hndl.PID_slider,'old_slider', new_slider_values )
      else
        set( hndl.Zero1,'string', num2str(PZG(dom_ndx).PID{5},5) );
        set( hndl.Zero2,'string', num2str(PZG(dom_ndx).PID{6},5) );
        PZG(dom_ndx).PID{7} = ...
          -pole2_multiplier*max( abs(PZG(dom_ndx).PID{5}), ...
                                abs(PZG(dom_ndx).PID{6}) );
        disp(error_str)
        return
      end
      
    case 7  % Pole #2 multiple ( range is between +sqrt(10) and +1000 )
      new_mult = 10^( (3-log10(3))*slider_value + log10(3) );
      set( hndl.pole2_multiplier,'string', num2str(new_mult,4), ...
          'userdata', new_mult );
      new_mult = str2double( get( hndl.pole2_multiplier,'string') );
      pzgPID{7} = -new_mult * max( abs(pzgPID{5}), abs(pzgPID{6}) );
      PZG(dom_ndx).PID{7} = pzgPID{7};
      
    otherwise
      return
  end
end

if nargin < 2
  DeleteAll = 0;
end
if nargin < 3
  quiet = 0;
end

LdLgFig = PZG(dom_ndx).LDLG_fig;
GainFig = PZG(dom_ndx).Gain_fig;
if ~isempty(LdLgFig) && ( ( nargin < 2 ) || ~DeleteAll )
  questdlg_ans = ...
    questdlg({'The Lead-Lag design GUI must be closed before opening'; ...
              'the PID design GUI.'; ...
              ' '; ...
              'Do you want the Lead-Lag design GUI to be closed?'}, ...
              'Must Close Lead-Lag Design GUI', ...
              'Yes, close it','No, Leave it open','Yes, close it');
  if strcmpi( questdlg_ans,'No, Leave it open')
    return
  else
    close(LdLgFig)
  end
elseif ~isempty(GainFig) && ( ( nargin < 2 ) || ~DeleteAll )
  questdlg_ans = ...
    questdlg({'The Pure Gain design GUI must be closed before opening'; ...
              'the PID design GUI.'; ...
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
    pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'LDLG_Preview') ];
if ~isempty(blank_h)
  set( blank_h,'visible','off')
end

if isempty(GCBF) || ~isequal( GCBF, PidFig )
  quiet = 1;
end

%xSize = 0.350;
%ySize = 0.150;
hSize = 0.200;
vSize = 0.120;
xSpace = (1-4*hSize)/4;
Col1 = xSpace/2;
Col2 = 1.5*xSpace + hSize;
Col3 = 2.5*xSpace + 2*hSize;
Col4 = 3.5*xSpace + 3*hSize;

Row6 = 0.001;
%Row5 = Row6 + 1.01*vSize;
%Row4 = Row5 + vSize;

Row1 = 1 - 1.8*vSize;
Row2 = 1 - 2.8*vSize;

if DeleteAll
  prvw_line_h = pzg_fndo( dom_ndx, (1:14),'PID_Preview');
  if ~isempty(prvw_line_h)
    set( prvw_line_h,'visible','off')
  end
  design_line_h = pzg_fndo(dom_ndx, 6, 'CL_0dB_contour');
  if ~isempty(design_line_h)
    set(design_line_h,'visible','off');
  end
  design_text_h = pzg_fndo( dom_ndx, 6,'PID_text');
  if ~isempty(design_text_h)
    set(design_text_h,'visible','off');
  end
  if isequal( 1, ishandle(PidFig) )
    pid_ax_h = hndl.no_vis_axes;
    if ~isempty(pid_ax_h)
      set(pid_ax_h,'tag','no-vis axes','visible','off')
    end
  end
  return
end

mod_hndl = 0;

if isempty(PidFig)
  hndl = [];
  scr_size = get( 0,'screensize');
  PidFig = ...
    figure( ...
      'units','pixels', ...
      'position',[scr_size(3)/2 scr_size(4)/6 550 170], ...
      'menubar','none', ...
      'numbertitle','off', ...
      'integerhandle','off', ...
      'dockcontrols','off', ...
      'tag','PZGUI plot', ...
      'handlevisibility','callback', ...
      'deletefcn', ...
        ['global PZG,' ...
          'pidfilt(''' Domain 'clear preview'');' ...
          'PZG(' num2str(dom_ndx) ').PID_fig=[];'], ...
      'windowbuttonmotionfcn', ...
         [ mfilename '(''mouse motion'');']);
    
  PZG(dom_ndx).PID_fig = PidFig;
  set( PidFig,'Name', PidFigName,'units','normalized');
else
  hndl = getappdata( PidFig,'hndl');
end

if ~isfield( hndl,'no_vis_axes')
  mod_hndl = 1;
  hndl.no_vis_axes = ...
    axes('parent', PidFig,'visible','off','tag','invisible axes');
end

PropGainInit = [];
IntegGainInit = [];
DerivGainInit = [];
GainInit = [];
Zero1_Init = [];
Zero2_Init = [];
Pole1 = 0; %#ok<NASGU>
Pole2_Init = [];
for Xk = 1:numel( PZG(dom_ndx).PID )
  if Xk == 1
    PropGainInit = PZG(dom_ndx).PID{1};
  elseif Xk == 2
    IntegGainInit = PZG(dom_ndx).PID{2};
  elseif Xk == 3
    DerivGainInit = PZG(dom_ndx).PID{3};
  elseif Xk == 4
    GainInit = PZG(dom_ndx).PID{4};
  elseif Xk == 5
    Zero1_Init = PZG(dom_ndx).PID{5};
  elseif Xk == 6
    Zero2_Init = PZG(dom_ndx).PID{6};
  elseif Xk == 7
    Pole2_Init = PZG(dom_ndx).PID{7};
  end
end
Pole2 = Pole2_Init; %#ok<NASGU>

if ~isfield( hndl,'PropGainText')
  mod_hndl = 1;
  hndl.PropGainText = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col1 Row1 hSize 1.8*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string',{'Prop Gain';'K_p'}, ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','PropGainText');
end
if ~isfield( hndl,'PropGain')
  mod_hndl = 1;
  hndl.PropGain = ...
    uicontrol( PidFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col1 Row2 hSize vSize ], ...
      'string',num2str(PropGainInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','PropGain', ...
      'Callback','pidfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'IntegGainText')
  mod_hndl = 1;
  hndl.IntegGainText = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 Row1 hSize 1.8*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string',{'Integ Gain';'K_i'}, ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','IntegGainText');
end
if ~isfield( hndl,'IntegGain')
  mod_hndl = 1;
  hndl.IntegGain = ...
    uicontrol( PidFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col2 Row2 hSize vSize ], ...
      'string',num2str(IntegGainInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','IntegGain', ...
      'Callback','pidfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'DerivGainText')
  mod_hndl = 1;
  hndl.DerivGainText = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col3 Row1 hSize 1.8*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string',{'Deriv Gain';'K_d'}, ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','DerivGainText');
end
if ~isfield( hndl,'DerivGain')
  mod_hndl = 1;
  hndl.DerivGain = ...
    uicontrol( PidFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col3 Row2 hSize vSize ], ...
      'string',num2str(DerivGainInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','DerivGain', ...
      'Callback','pidfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'preview_pushbutton')
  mod_hndl = 1;
  hndl.preview_pushbutton = ...
    uicontrol( PidFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4 1-1.11*vSize hSize 1.1*vSize ], ...
      'string','Preview', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Preview', ...
      'tooltipstring','pre-view the effects of this PID compensator', ...
      'Callback', ...
        ['tempPRVcbo=gcbo;' ...
         'set(tempPRVcbo,''enable'',''off'');' ...
         'try,' ...
         'pidfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''PID Preview pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempPRVcbo,''enable'',''on'');' ...
         'clear tempPRVcbo'] );
end

if ~isfield( hndl,'GainText1')
  mod_hndl = 1;
  hndl.GainText1 = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col1 1.9*vSize hSize vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string','T.F. Gain', ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','GainText1');
end

if ~isfield( hndl,'Gain')
  mod_hndl = 1;
  hndl.Gain = ...
    uicontrol( PidFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col1 0.9*vSize hSize vSize ], ...
      'string',num2str(GainInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Gain', ...
      'Callback','pidfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'Zero1_Text1')
  mod_hndl = 1;
  hndl.Zero1_Text1 = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 1.8*vSize hSize 1.8*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string',{'Zero #1';'Location'}, ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','Zero1_Text1');
end
if isequal( dom_ndx, 1 ) ...
  && ~isfield( hndl,'Zero1_Text2')
  mod_hndl = 1;
  hndl.Zero1_Text2 = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 0.001 hSize 0.9*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string','(rad/s)', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','Zero1_Text2');
end
if ~isfield( hndl,'Zero1')
  mod_hndl = 1;
  hndl.Zero1 = ...
    uicontrol( PidFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col2 0.9*vSize hSize vSize ], ...
      'string',num2str(Zero1_Init), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Zero1', ...
      'Callback','pidfilt(get(gcbf,''Name''))');
end
if ~isfield( hndl,'Zero2_Text1')
  mod_hndl = 1;
  hndl.Zero2_Text1 = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col3 1.8*vSize hSize 1.8*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string',{'Zero #2';'Location'}, ...
      'fontweight','bold', ...
      'fontsize', 11, ...
      'tag','Zero2_Text1');
end
if isequal( dom_ndx, 1 ) ...
  && ~isfield( hndl,'Zero2_Text2')
  mod_hndl = 1;
  hndl.Zero2_Text2 = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col3 0.001 hSize 0.9*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string','(rad/s)', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tag','Zero2_Text2');
end
if ~isfield( hndl,'Zero2')
  mod_hndl = 1;
  hndl.Zero2 = ...
    uicontrol( PidFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col3 0.9*vSize hSize vSize ], ...
      'string',num2str(Zero2_Init), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Zero2', ...
      'Callback','pidfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'Pole2_Text1')
  mod_hndl = 1;
  hndl.Pole2_Text1 = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col4 2.5*vSize hSize 1.5*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string',{'Pole #2';'Multiplier'}, ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'tooltipstring','PID has 2 zeros, so it needs 2 poles', ... 
      'tag','Pole2_Text1');
  if dom_ndx == 2
    set( hndl.Pole2_Text1, ...
        'string',{'Pole #2';'is at z = 0.'}, ...
        'position',[ Col4 vSize hSize 2*vSize ]);
  end
end

if ~isfield( hndl,'Pole2_Text2')
  mod_hndl = 1;
  hndl.Pole2_Text2 = ...
    uicontrol( PidFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col4 Row6 hSize 1.5*vSize ], ...
      'backgroundcolor', get(PidFig,'color'), ...
      'string',{'(how far to the left';'  of the two zeros)'}, ...
      'fontweight','bold', ...
      'fontsize', 8, ...
      'tooltipstring','PID has 2 zeros, so it needs 2 poles', ... 
      'tag','Pole2_Text2');
end
if dom_ndx == 2
  set( hndl.Pole2_Text2,'visible','off','enable','off')
end

if ~isfield( hndl,'pole2_multiplier')
  mod_hndl = 1;
  hndl.pole2_multiplier = ...
    uicontrol( PidFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col4+hSize/4 1.5*vSize hSize/2 vSize ], ...
      'string',num2str(pole2_multiplier), ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'userdata', pole2_multiplier, ...
      'tooltipstring','PID has 2 zeros, so it needs 2 poles', ... 
      'tag','pole2_multiplier', ...
      'Callback','pidfilt(get(gcbf,''Name''))');
end
if dom_ndx == 2
  set( hndl.pole2_multiplier,'visible','off','enable','off')
end

if ~isfield( hndl,'clear_preview_pushbutton')
  mod_hndl = 1;
  hndl.clear_preview_pushbutton = ...
    uicontrol( PidFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4-0.02 1-2.25*vSize hSize+0.04 vSize ], ...
      'string','clear preview', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'visible','off', ...
      'tag','clear preview', ...
      'Callback', ...
        ['tempCLRcbo=gcbo;' ...
         'set(tempCLRcbo,''enable'',''off'');' ...
         'try,' ...
         'pidfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''PID Clear Preview pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempCLRcbo,''enable'',''on'');' ...
         'clear tempCLRcbo'] );
end

if ~isfield( hndl,'apply_pushbutton')
  mod_hndl = 1;
  hndl.apply_pushbutton = ...
    uicontrol( PidFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4 1-3.8*vSize hSize 1.1*vSize ], ...
      'string','Apply', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Apply', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'try,' ...
         'pidfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''PID Apply pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
end

if ~isfield( hndl,'PID_slider')
  mod_hndl = 1;
  hndl.PID_slider = ...
    uicontrol( PidFig,'style','slider', ...
      'units','normalized', ...
      'position',[ 0.201 3.7*vSize 0.55 vSize ], ...
      'value', 0.5, ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'backgroundcolor',[0.5 1 0.5], ...
      'tag','PID slider', ...
      'visible','off', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'set(tempAPPcbo,''enable'',''off'');' ...
         'try,' ...
         'pidfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''pid slider'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
end

if ~isfield( hndl,'PID_slider_menu')
  mod_hndl = 1;
  init_menu_value = 1;
  menu_str = {'Kp prop gain';'Ki integ gain';'Kd deriv gain'; ...
              'T.F.Gain';'Zero #1';'Zero #2';'2nd pole mult'};
  if dom_ndx == 2
    menu_str = menu_str(1:6);
  end
  hndl.PID_slider_menu = ...
    uicontrol( PidFig,'style','popupmenu', ...
      'units','normalized', ...
      'position',[ 0.001 3.8*vSize 0.2 vSize ], ...
      'string', menu_str, ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'backgroundcolor',[0.5 1 0.5], ...
      'value', init_menu_value, ...
      'tag','PID slider menu', ...
      'visible','off', ...
      'tooltipstring','menu selects which parameter the slider adjusts', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'set(tempAPPcbo,''enable'',''off'');' ...
         'try,' ...
         'pidfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''pid slider pop-up menu'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
  setappdata( hndl.PID_slider_menu,'oldmenuvalue', init_menu_value );
end

if mod_hndl
  setappdata( PidFig,'hndl', hndl );
end

set( hndl.no_vis_axes,'visible','off');

if isempty(GCBO) && isempty(Domain_arg)
  return
elseif ~strcmp( get( GCBF,'Name'), PidFigName ) ...
  && ~strcmp( Domain_arg, PidFigName )
  figure(PidFig)
  return
end

if isappdata( hndl.PID_slider,'old_slider')
  old_slider_values = getappdata( hndl.PID_slider,'old_slider');
  if ~isnumeric(old_slider_values) ...
    || ~isequal( numel(old_slider_values), 7 ) ...
    ||( min(old_slider_values) < 0 ) || ( max(old_slider_values) > 1 ) ...
    || any(isnan(old_slider_values))
    old_slider_values = 0.5*ones(7,1);
    old_slider_values(end) = ( 1 - log10(3) ) / ( 3 - log10(3) );
    setappdata( hndl.PID_slider,'old_slider', old_slider_values );
  end
else
  old_slider_values = 0.5*ones(7,1);
  old_slider_values(end) = ( 1 - log10(3) ) / ( 3 - log10(3) );
  setappdata( hndl.PID_slider,'old_slider', old_slider_values );
end

if ~isfield( hndl,'pole2_multiplier')
  hndl.pole2_multiplier = [];
end
if ~isempty(hndl.pole2_multiplier)
  % Get old entry.
  old_mult_entry = get( hndl.pole2_multiplier,'userdata');  
  mult_entry = str2double( get(hndl.pole2_multiplier,'string') );
  if isempty(mult_entry) || isnan(mult_entry) || isinf(mult_entry)
    mult_entry = old_mult_entry;
    set( hndl.pole2_multiplier, ...
        'string', num2str(old_mult_entry,4), ...
        'userdata', old_mult_entry );
  end
  if numel(mult_entry) == 1
    if mult_entry < 3
      if isequal( 0, slider_is_moving )
        errdlg_h = ...
          errordlg({'The multiplier for the second PID pole must'; ...
                    'be a number no smaller than three.'; ...
                    ' '; ...
                    'Substituting ''3'' for the entry.'; ...
                    ' ';'    Click "OK" to continue ...';' '}, ...
                   'Multiplier is Too Small','modal');
        uiwait(errdlg_h)
      end
      pole2_multiplier = 3;
      set( hndl.pole2_multiplier,'string','3','userdata', 3 );
      if isequal( get(hndl.PID_slider_menu,'value'), 7 )
        set( hndl.PID_slider,'value', 0 );
      end
      if isappdata( hndl.PID_slider,'old_slider')
        old_slider_values = getappdata( hndl.PID_slider,'old_slider');
        if ~isnumeric(old_slider_values) ...
          || ~isequal( numel(old_slider_values), 7 )
          old_slider_values = 0.5*ones(7,1);
        end
        old_slider_values(end) = 0;
        setappdata( hndl.PID_slider,'old_slider', old_slider_values );
      end
    elseif mult_entry > 1000
      if isequal( 0, slider_is_moving )
        errdlg_h = ...
          errordlg({'The multiplier for the second PID pole must'; ...
                    'be a number no greater than 1000.'; ...
                    ' '; ...
                    'Substituting ''1000'' for the entry.'; ...
                    ' ';'    Click "OK" to continue ...';' '}, ...
                   'Multiplier is Too Large','modal');
        uiwait(errdlg_h)
      end
      pole2_multiplier = 1000;
      set( hndl.pole2_multiplier,'string','1000','userdata', 1000 );
      if isequal( get(hndl.PID_slider_menu,'value'), 7 )
        set( hndl.PID_slider,'value', 1 );
      end
      if isappdata( hndl.PID_slider,'old_slider')
        old_slider_values = getappdata( hndl.PID_slider,'old_slider');
        if ~isnumeric(old_slider_values) ...
          || ~isequal( numel(old_slider_values), 7 )
          old_slider_values = 0.5*ones(7,1);
        end
        old_slider_values(end) = 1;
        setappdata( hndl.PID_slider,'old_slider', old_slider_values );
      end
    else
      pole2_multiplier = mult_entry;
    end
  else
    if isequal( 0, slider_is_moving )
      errdlg_h = ...
        errordlg({'Unable to parse the text entry.'; ...
                  ' '; ...
                  'Substituting nominal value ''10'' for the entry.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'Multiplier is Unrecognized','modal');
      uiwait(errdlg_h)
    end
    set( hndl.pole2_multiplier,'string','10','userdata', 10 );
    old_slider_values(end) = ( 1 - log10(3) ) / ( 3 - log10(3) );
    setappdata( hndl.PID_slider,'old_slider', old_slider_values );
    pole2_multiplier = 10;
  end
  if isequal( gcbo, hndl.pole2_multiplier ) && isappdata( hndl.PID_slider,'old_slider')
    old_slider_values = getappdata( hndl.PID_slider,'old_slider');
    if numel(old_slider_values) >= 7
      old_slider_values(7) = ...
        ( log10(pole2_multiplier) - log10(3) ) / ( 3 - log10(3) );
      if isequal( get( hndl.PID_slider_menu,'value'), 7 )
        set( hndl.PID_slider,'value', old_slider_values(7) );
      end
      setappdata( hndl.PID_slider,'old_slider', old_slider_values )
    end
  end
end

GCBOtag = get(GCBO,'Tag');
if strcmpi( GCBOtag,'PID slider menu')
  % User has selected a different parameter for slider adjustment.
  if ~isappdata( hndl.PID_slider,'old_slider')
    return
  end
  old_slider_values = getappdata( hndl.PID_slider,'old_slider');
  if ~isnumeric(old_slider_values) ...
    || ~isequal( numel(old_slider_values), 7 )
    return
  end
  menu_value = get( hndl.PID_slider_menu,'value');
  set( hndl.PID_slider,'value', old_slider_values(menu_value) );
  return
end
if strcmpi( GCBOtag,'preview')
  set( GCBO,'backgroundcolor',[0.5 1 0.5]);
  set( hndl.PID_slider,'visible','on','backgroundcolor',[0.5 1 0.5])
  set( hndl.PID_slider_menu,'visible','on','backgroundcolor',[0.5 1 0.5])
  set( hndl.clear_preview_pushbutton,'visible','on')
end

TagNdx = 0;
if strcmp( GCBOtag,'PropGain')
  TagNdx = 1;
elseif strcmp( GCBOtag,'IntegGain')
  TagNdx = 2;
elseif strcmp( GCBOtag,'DerivGain')
  TagNdx = 3;
elseif strcmp( GCBOtag,'Gain')
  TagNdx = 4;
elseif strcmp( GCBOtag,'Zero1')
  TagNdx = 5;
elseif strcmp( GCBOtag,'Zero2')
  TagNdx = 6;
elseif strcmp( GCBOtag,'pole2_multiplier')
  TagNdx = 7;
end
if TagNdx
  temp = str2double( get( GCBO,'string') );
  if isinf(temp) || isnan(temp)
    temp = [];
    if TagNdx < 7
      temp = PZG(dom_ndx).PID{TagNdx};
    elseif TagNdx == 7
      old_multiplier = get( hndl.pole2_multiplier,'userdata');
      if ~isempty(old_multiplier) && isreal(old_multiplier) ...
        && ( old_multiplier >= 3 )
        temp = old_multiplier;
        set( hndl.pole2_multiplier,'string', num2str(temp,6) );
      end
    end
  end
  if ( TagNdx >= 1 ) && ( TagNdx <= 4 ) ...
    && ( numel(temp) == 1 )
    % Gains must be reasonably positive.
    temp = abs(temp);
    if temp < 1e-10
      temp = [];
    end
    if isappdata( hndl.PID_slider,'old_slider')
      old_slider_values = getappdata( hndl.PID_slider,'old_slider');
      if numel(old_slider_values) == 7
        old_slider_values(min(TagNdx,3)) = 0.5;
        old_slider_values(4) = 0.5;
        old_slider_values(5) = 0.5;
        setappdata( hndl.PID_slider,'old_slider', old_slider_values )
        if isequal( get( hndl.PID_slider_menu,'value'), TagNdx ) ...
          || isequal( get( hndl.PID_slider_menu,'value'), 4 )
          set( hndl.PID_slider,'value', 0.5 );
        end
      end
    end
  end
  if ( TagNdx == 5 ) || ( TagNdx == 6 )
    if dom_ndx == 1
      % Continuous-time:  in the negative half plane.
      temp = -abs(real(temp))+1i*abs(imag(temp));
      if abs(temp) < -1e-5
        % Don't allow a zero to cancel the integrator pole.
        temp = [];
      end
    else
      % Discrete-time:  on pos real axis, inside the unit circle.
      % temp = abs(temp);
      if abs(temp) > 1
        temp = 1/temp;
      end
      if abs(1-temp) < 1e-7
        % Don't allow a zero to cancel the integrator pole.
        temp = [];
      end
    end
    if isempty(temp)
      temp = PZG(dom_ndx).PID{TagNdx};
    end
    PZG(dom_ndx).PID{TagNdx} = temp;
    if TagNdx == 5
      set( hndl.Zero1,'string', num2str(temp,5) )
      if ~isreal(temp)
        PZG(dom_ndx).PID{6} = conj(temp);
        set( hndl.Zero2,'string', num2str(conj(temp),5) )
        old_slider_values(6) = old_slider_values(5);
      else
        old_slider_values(5:6) = 0.5;
      end
    else
      set( hndl.Zero2,'string', num2str(temp,5) )
      if ~isreal(temp)
        PZG(dom_ndx).PID{5} = conj(temp);
        set( hndl.Zero1,'string', num2str(conj(temp),5) )
        old_slider_values(5) = old_slider_values(6);
      else
        old_slider_values(5:6) = 0.5;
      end
    end
    
    if isappdata( hndl.PID_slider,'old_slider')
      old_slider_values = getappdata( hndl.PID_slider,'old_slider');
      if numel(old_slider_values) == 7
        old_slider_values(TagNdx) = 0.5;
        if ~isreal(temp)
          new_slider_value = local_angle2slider( angle(temp) );
          old_slider_values(5:6) = new_slider_value;
        end
        old_slider_values(1) = 0.5;
        old_slider_values(2) = 0.5;
        setappdata( hndl.PID_slider,'old_slider', old_slider_values )
        set( hndl.PID_slider,'value', ...
             old_slider_values(get( hndl.PID_slider_menu,'value')) );
      end
    end
  end
  set( GCBO,'string', num2str(temp) );
  if ~strcmp( get( GCBO,'style'),'checkbox')
    if ~isempty(temp) && ~isinf(temp) && ~isnan(temp)
      set( GCBO,'string', num2str(temp) );
    else
      set( GCBO,'string','')
    end
  end
  
  if ~isempty(temp) && ~isinf(temp) && ~isnan(temp)
    if TagNdx <= 4
      PZG(dom_ndx).PID{TagNdx} = temp;
    elseif TagNdx <= 6
      if isreal(temp)
        if TagNdx == 5
          Zero1 = temp;
          if ~isreal(Zero1)
            Zero2 = conj(Zero1);
          else
            Zero2 = real( str2double( get(hndl.Zero2,'string') ) );
            if isinf(Zero2) || isnan(Zero2)
              Zero2 = [];
            end
          end
        else
          Zero2 = temp;
          if ~isreal(Zero2)
            Zero1 = conj(Zero2);
          else
            Zero1 = real( str2double( get(hndl.Zero1,'string') ) );
            if isinf(Zero1) || isnan(Zero1)
              Zero1 = [];
            end
          end
        end
        set( hndl.Zero1,'string', num2str(Zero1,5) );
        set( hndl.Zero2,'string', num2str(Zero2,5) );
      else
        Zero1 = temp;
        PZG(dom_ndx).PID{5} = Zero1;
        Zero2 = conj(temp);
        PZG(dom_ndx).PID{6} = Zero2;
      end
      set( hndl.Zero1,'string', num2str(Zero1,5) );
      set( hndl.Zero2,'string', num2str(Zero2,5) );
    else
      temp = min( 1000, max( 3, abs(temp) ) );
      set( hndl.pole2_multiplier,'string', num2str(temp),'userdata', temp );
      pole2_multiplier = temp;
      pole2 = ...
        -temp*max( abs(PZG(dom_ndx).PID{5}), abs(PZG(dom_ndx).PID{6}) );
      PZG(dom_ndx).PID{7} = pole2;
    end
  end
  
  if TagNdx < 4
    % Entered Kp, Ki, or Kd data, so recompute the zeros.
    PropGain = str2double( get( hndl.PropGain,'string') );
    if isinf(PropGain) || isnan(PropGain)
      PropGain = PZG(dom_ndx).PID{1};
      set( hndl.PropGain,'string', num2str(PropGain,8) )
    end
    IntegGain = str2double( get( hndl.IntegGain,'string') );
    if isinf(IntegGain) || isnan(IntegGain)
      IntegGain = PZG(dom_ndx).PID{2};
      set( hndl.IntegGain,'string', num2str(IntegGain,8) )
    end
    DerivGain = str2double( get( hndl.DerivGain,'string') );
    if isinf(DerivGain) || isnan(DerivGain)
      DerivGain = PZG(dom_ndx).PID{3};
      set( hndl.DerivGain,'string', num2str(DerivGain,8) )
    end
    pole2_multiplier = str2double( get( hndl.pole2_multiplier,'string') );
    if isinf(pole2_multiplier) || isnan(pole2_multiplier)
      if ~isempty(PZG(dom_ndx).PID{5}) ...
        && ~isempty(PZG(dom_ndx).PID{5})
        abs_zero = ...
          max( abs(PZG(dom_ndx).PID{5}), abs(PZG(dom_ndx).PID{6}) );
        pole2_multiplier = max( 3, abs(PZG(dom_ndx).PID{7})/abs_zero );
      else
        pole2_multiplier = 10;
      end
      set( hndl.pole2_multiplier,'string', num2str(pole2_multiplier,8), ...
          'userdata', pole2_multiplier )
    end
    
    if isempty(PropGain) || isempty(IntegGain) || isempty(DerivGain) ...
      || isnan(PropGain) || isnan(IntegGain) || isnan(DerivGain) ...
      || isinf(PropGain) || isinf(IntegGain) || isinf(DerivGain)
      set( hndl.Gain,'string','');
      set( hndl.Zero1,'string','');
      set( hndl.Zero2,'string','');
      local_clear_preview( dom_ndx, hndl )
      return
    end
    
    if ~isfield( PZG(dom_ndx),'PID') ...
      ||~iscell( PZG(dom_ndx).PID ) ...
      ||( numel(PZG(dom_ndx).PID) ~= 7 )
      PZG(dom_ndx).PID = cell(7,1);
    end
    PZG(dom_ndx).PID{1} = PropGain;
    PZG(dom_ndx).PID{2} = IntegGain;
    PZG(dom_ndx).PID{3} = DerivGain;
    if dom_ndx == 1
      Ts = 0;
    else
      Ts = PZG(2).Ts;
      if Ts < 0
        Ts = 1;
      end
    end
    [ PID_out, error_str ] = ...
       local_pidgain2zpk( PZG(dom_ndx).PID, Ts, ...
                          pole2_multiplier, slider_is_moving );
    if ~isempty(error_str)
      local_clear_preview( dom_ndx, hndl )
      return
    end
    PZG(dom_ndx).PID = PID_out;
    old_slider_values(TagNdx) = 0.5;
    old_slider_values(4:6) = 0.5;
    if ~isreal(PID_out{5})
      new_zero = PID_out{5};
      if dom_ndx == 2
        new_zero = log(new_zero)/PZG(2).Ts;
      end
      slider_val = local_angle2slider( abs(angle(new_zero)) );
      old_slider_values(5:6) = slider_val;
    end
    setappdata( hndl.PID_slider,'old_slider', old_slider_values );
    set( hndl.PID_slider,'value', ...
        old_slider_values( get(hndl.PID_slider_menu,'value') ) );
  else
    % Entered zero1/zero2/gain data
    Gain = str2num( get( hndl.Gain,'string') ); %#ok<ST2NM>
    Zero1 = str2num( get( hndl.Zero1,'string') ); %#ok<ST2NM>
    Zero2 = str2num( get( hndl.Zero2,'string') ); %#ok<ST2NM>
    if isequal( hndl.Zero1, gcbo )
      if ~isreal(Zero1)
        Zero2 = conj(Zero1);
        set( hndl.Zero1,'string', num2str(Zero1,5) )
        set( hndl.Zero2,'string', num2str(Zero2,5) )
      elseif ~isreal(Zero2)
        Zero2 = real(Zero2);
        if isnan(Zero2)
          set( hndl.Zero2,'string','')
        else
          set( hndl.Zero2,'string', num2str(Zero2,5) )
        end
      end
    elseif isequal( hndl.Zero2, gcbo )
      if ~isreal(Zero2)
        Zero1 = conj(Zero2);
        set( hndl.Zero1,'string', num2str(Zero1,5) )
        set( hndl.Zero2,'string', num2str(Zero2,5) )
      elseif ~isreal(Zero1)
        Zero1 = real(Zero1);
        if isnan(Zero1)
          set( hndl.Zero1,'string','')
        else
          set( hndl.Zero1,'string', num2str(Zero1,5) )
        end
      end
    end
    
    if isempty(Gain) || isempty(Zero1) || isempty(Zero2) ...
      || isnan(Gain) || isnan(Zero1) || isnan(Zero2)
      local_clear_preview( dom_ndx, hndl )
      return
    end
    
    if dom_ndx == 1
      Ts = 0;
      Pole2 = -pole2_multiplier * max(abs([Zero1;Zero2]));
    else
      Ts = PZG(2).Ts;
      if Ts < 0
        Ts = 1;
      end
      Pole2 = 0;
    end
    PZG(dom_ndx).PID{4} = Gain;
    PZG(dom_ndx).PID{5} = Zero1;
    PZG(dom_ndx).PID{6} = Zero2;
    if dom_ndx == 1
      PZG(dom_ndx).PID{7} = Pole2;
    else
      PZG(dom_ndx).PID{7} = 0;
    end
    [ PID_out, error_str ] = ...
          local_zpk2pidgain( ...
             PZG(dom_ndx).PID, Ts, pole2_multiplier, slider_is_moving );
    if ~isempty(error_str)
      local_clear_preview( dom_ndx, hndl )
      return
    end
    PZG(dom_ndx).PID = PID_out;
    old_slider_values(TagNdx) = 0.5;
    old_slider_values(1:2) = 0.5;
    if TagNdx == 4
      old_slider_values(3) = 0.5;
    end
    if ~isreal(PID_out{5})
      new_zero = PID_out{5};
      if dom_ndx == 2
        new_zero = log(new_zero)/PZG(2).Ts;
      end
      slider_val = local_angle2slider( abs(angle(new_zero)) );
      old_slider_values(5:6) = slider_val;
    end
    setappdata( hndl.PID_slider,'old_slider', old_slider_values );
    set( hndl.PID_slider,'value', ...
         old_slider_values( get(hndl.PID_slider_menu,'value') ) );
  end
  
  set( hndl.PropGain,'string', num2str(PZG(dom_ndx).PID{1},9) )
  set( hndl.IntegGain,'string', num2str(PZG(dom_ndx).PID{2},8) )
  set( hndl.DerivGain,'string', num2str(PZG(dom_ndx).PID{3},8) )
  set( hndl.Gain,'string', num2str(PZG(dom_ndx).PID{4},9) )
  if isnan(PZG(dom_ndx).PID{5})
    set( hndl.Zero1,'string','')
  else
    set( hndl.Zero1,'string', num2str(PZG(dom_ndx).PID{5},5) )
  end
  if isnan(PZG(dom_ndx).PID{6})
    set( hndl.Zero2,'string','')
  else
    set( hndl.Zero2,'string', num2str(PZG(dom_ndx).PID{6},5) )
  end
end

% Create or update preview whenever preview lines already exist,
% or the user has pushed the "preview" pushbutton.
preview_on = 0;
if strcmp( get(hndl.PID_slider,'visible'),'on')
  preview_on = 1;
end

if strcmpi( GCBOtag,'Preview') ...
  ||( preview_on ...
     && ~strcmpi( GCBOtag,'clear preview') ...
     && ~strcmpi( GCBOtag,'Apply') )

  % Compute and display the bode.
  Gain = real( str2num( get( hndl.Gain,'string') ) ); %#ok<ST2NM>
  if dom_ndx == 1
    Pole1 = 0;
  else
    Pole1 = 1;
  end
  Zero1 = str2num( get( hndl.Zero1,'string') ); %#ok<ST2NM>
  if dom_ndx == 1
    Zero1 = -abs( real(Zero1) ) + 1i*abs(imag(Zero1)); 
  else
    if abs(Zero1) > 1
      Zero1 = 1/Zero1';
    end
    if abs(Zero1) > (1-1e-7)
      Zero1 = Zero1*(1-1e-7);
    end
  end
  if isreal(Zero1)
    Zero2 = str2num( get( hndl.Zero2,'string') ); %#ok<ST2NM>
    if dom_ndx == 1
      Zero2 = -abs( real(Zero2) ) + 1i*abs(imag(Zero2)); 
    else
      if abs(Zero2) > 1
        Zero2 = 1/Zero2';
      end
      if abs(Zero2) > (1-1e-7)
        Zero2 = Zero2*(1-1e-7);
      end
    end
    if ~isreal(Zero2)
      Zero1 = conj(Zero2);
    end
  else
    Zero2 = conj(Zero1);
  end
  if dom_ndx == 2
    Pole2 = 0;
  else
    Pole2 = -pole2_multiplier * max(abs(Zero1),abs(Zero2));
  end
  
  if isempty(Gain) || isempty(Zero1) || isempty(Zero2)
    local_clear_preview( dom_ndx, hndl )
    return
  end
  set(hndl.preview_pushbutton,'backgroundcolor', [0.5 1 0.5]);
  set( [hndl.PID_slider;hndl.PID_slider_menu],'visible','on');
  
  pid_zeros = [ Zero1; Zero2 ];
  pid_poles = [ Pole1; Pole2 ];
  if dom_ndx == 1
    if any( abs(pid_zeros) < 1e-10 )
      local_clear_preview( dom_ndx, hndl )
      return
    end
    pid_gain = Gain * abs(Pole2);
  else
    if any( abs(1-pid_zeros) < 1e-8 )
      local_clear_preview( dom_ndx, hndl )
      return
    end
    pid_gain = Gain;
  end
  
  Freqs = PZG(dom_ndx).BodeFreqs;
  CplxBode = pid_gain * ones(size(Freqs));
  if dom_ndx == 1
    for k = 1:2
      CplxBode = CplxBode ...
                 .* ( 1i*Freqs - pid_zeros(k) ) ...
                 ./ ( 1i*Freqs - pid_poles(k) );
    end
  else
    uc_pts = exp(1i*Freqs*PZG(2).Ts);
    for k = 1:2
      CplxBode = CplxBode ...
                 .* ( uc_pts - pid_zeros(k) ) ...
                 ./ ( uc_pts - pid_poles(k) );
    end
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
  delta_mp = max( delta_mag, delta_phs/10 );
  cum_delta_mp = cumsum( delta_mp );
  % Use "mod" to find indexes where cum sum jumps
  jumpsize = 7;
  LineNdx = [];
  numel_deltamag = numel(delta_mag);
  if isequal( dom_ndx, 2 )
    numel_deltamag = round( numel_deltamag/2.2 );
  end
  while numel(LineNdx) ...
        < max( min(100,numel_deltamag/8), numel_deltamag/1000 )
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
    nyqmap_h = findobj( NicholFig,'tag','show nyq mapping checkbox');
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
    LineH = pzg_fndo( dom_ndx, 6,'PID_Preview');
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
    if isequal( 3, numel(LineH) )
      set( LineH(1), ...
          'xdata', xdata(:), ...
          'ydata', ydata(:), ...
          'color','y', ...
          'linewidth', 0.5, ...
          'visible','on')
    else
      delete(LineH)
      PZG(dom_ndx).plot_h{6}.hndl.PID_Preview = ...
        plot( xdata(:), ydata(:), ...
           'color','y', ...
           'linewidth', 0.5, ...
           'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
           'tag',[Domain 'PID Preview'] );
    end
    xdata = BasePhs(:)+Phs(:);          
    ydata = PZG(dom_ndx).BodeMag(:) + Mag(:);          
    if dom_ndx == 2
      xdata = xdata(1:nyq_ndx);
      ydata = ydata(1:nyq_ndx);
    end
    if isequal( 3, numel(LineH) )
      set(  LineH(2), ...
          'xdata', xdata, ...
          'ydata', ydata, ...
          'color','m', ...
          'linewidth', 3, ...
          'visible','on');
      set(  LineH(3), ...
          'xdata', -xdata, ...
          'ydata', ydata, ...
          'color',[0.7 0.7 0.7], ...
          'linestyle','-', ...
          'linewidth', 2, ...
          'visible','on');
    else
      PZG(dom_ndx).plot_h{6}.hndl.PID_Preview(2) = ...
        plot( xdata, ydata, ...
          'color','m', ...
          'linewidth', 3, ...
          'tag',[Domain 'PID Preview'], ...
          'parent', PZG(dom_ndx).plot_h{6}.ax_h );
      PZG(dom_ndx).plot_h{6}.hndl.PID_Preview(3) = ...
        plot( -xdata, ydata, ...
          'color',[0.7 0.7 0.7], ...
          'linestyle','-', ...
          'linewidth', 2, ...
          'visible','off', ...
          'tag',[Domain 'PID Preview'], ...
          'parent', PZG(dom_ndx).plot_h{6}.ax_h );
      PZG(dom_ndx).plot_h{6}.hndl.PID_Preview = ...
        PZG(dom_ndx).plot_h{6}.hndl.PID_Preview(:);
    end
    if get( nyqmap_h,'value')
      set( PZG(dom_ndx).plot_h{6}.hndl.PID_Preview(3),'visible','on');
    else
      set( PZG(dom_ndx).plot_h{6}.hndl.PID_Preview(3),'visible','off');
    end
    if strcmp( get( PZG(dom_ndx).plot_h{6}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{6}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 6 );
    end
  end
  
  OLCplxBode = 10.^( ( PZG(dom_ndx).BodeMag+Mag)/20 ) ...
               .*exp( 1i*pi*(PZG(dom_ndx).BodePhs+Phs)/180 );
  
  % Impulse-response PFE (the TF)
  [ CLres, CLpoles, CLdirect ] = ...
      pzg_rsppfe( dom_ndx, [], [], 1, ...
                 'closed loop',[Domain 'PID'], 1 ); %#ok<NASGU,ASGLU>
  CLstable = 1;
  if dom_ndx == 1
    if any( real(CLpoles) >= 0 )
      CLstable = 0;
    end
  else
    if any( abs(CLpoles) >= 1 )
      CLstable = 0;
    end
  end
  if ~CLstable && ~quiet && isequal( 0, slider_is_moving )
    msgbox_h = ...
      msgbox( ...
       {'With this PID, the closed-loop system is unstable.'; ...
        ' ';'      Click "OK" to continue';' '}, ...
       'PZGUI Advisory','modal');
    uiwait( msgbox_h )
  end
  
  CLCplxBode = OLCplxBode ./(1+OLCplxBode);
  CLMag = 20*log10( abs( CLCplxBode ) );
  CLPhs = pzg_unwrap( PZG(dom_ndx).BodeFreqs, 180/pi*angle( CLCplxBode ), ...
                      dom_ndx,'close');
  CLMagFig = pzg_fndo( dom_ndx, 3,'fig_h');
  if ~isempty(CLMagFig)
    % Determine if log y-axis is currently selected.
    dB_checkbox_h = findobj( CLMagFig,'string','dB','type','uicontrol');
    if ~isempty(dB_checkbox_h)
      if ~get(dB_checkbox_h,'value')
        CLMag = 10.^(CLMag/20);
      end
    end
    plotFreqs = Freqs;
    hz_checkbox_h = findobj( CLMagFig,'string','Hz','type','uicontrol');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 3,'PID_Preview');
    if CLstable
      if ~isequal( numel(LineH), 1 )
        delete(LineH)
        PZG(dom_ndx).plot_h{3}.hndl.PID_Preview = ...
          plot( plotFreqs, CLMag,'m', ...
            'parent', PZG(dom_ndx).plot_h{3}.ax_h, ...
            'linewidth', 2, ...
            'tag',[Domain 'PID Preview']);
      else
        set( LineH, ...
          'xdata', plotFreqs, ...
          'ydata', CLMag, ...
          'visible','on')
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
    plotFreqs = Freqs;
    hz_checkbox_h = findobj( CLPhsFig,'string','Hz','type','uicontrol');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 4,'PID_Preview');
    if ~isequal( 1, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{4}.hndl.PID_Preview = ...
        plot( plotFreqs, CLPhs,'m', ...
          'parent', PZG(dom_ndx).plot_h{4}.ax_h, ...
          'tag',[Domain 'PID Preview'], ...
          'linewidth', 2 );
      if ~CLstable
        set( PZG(dom_ndx).plot_h{4}.hndl.PID_Preview,'visible','off');
      end
    else
      if CLstable
        set( LineH, ...
          'xdata', plotFreqs, ...
          'ydata', CLPhs, ...
          'visible','on');
      else
        set( LineH,'visible','off')
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
    dB_checkbox_h = findobj( OLMagFig,'string','dB');
    filtMag = 20*log10(abs(CplxBode));
    compMag = filtMag + PZG(dom_ndx).BodeMag;
    if ~isempty(dB_checkbox_h)
      if ~get(dB_checkbox_h,'value')
        filtMag = abs(CplxBode);
        compMag = filtMag .* 10.^(PZG(dom_ndx).BodeMag/20);
      end
    end
    plotFreqs = Freqs;
    hz_checkbox_h = findobj( OLMagFig,'string','Hz','type','uicontrol');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 1,'PID_Preview');
    if ~isequal( 2, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{1}.PID_Preview = ...
        plot( plotFreqs, filtMag, ...
           'linewidth', 2, ...
           'linestyle','--', ...
           'color','c', ...
           'parent', PZG(dom_ndx).plot_h{1}.ax_h, ...
           'tag',[Domain 'PID Preview'] );
      PZG(dom_ndx).plot_h{1}.PID_Preview(2) = ...
        plot( plotFreqs, compMag, ...
           'linewidth', 2, ...
           'color','m', ...
           'parent', PZG(dom_ndx).plot_h{1}.ax_h, ...
           'tag',[Domain 'PID Preview']);
    else
      set( LineH(1), ...
          'xdata', plotFreqs, ...
          'ydata', filtMag, ...
          'linewidth', 2, ...
          'linestyle','--', ...
          'color','c', ...
          'visible','on')
      set( LineH(2), ...
          'xdata', plotFreqs, ...
          'ydata', compMag, ...
          'linewidth', 2, ...
          'linestyle','-', ...
          'color','m', ...
          'visible','on')
    end
    if strcmp( get( PZG(dom_ndx).plot_h{1}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{1}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 1 );
    end
  end
  OLPhsFig = pzg_fndo( dom_ndx, 2,'fig_h');
  if ~isempty(OLPhsFig)
    plotFreqs = Freqs;
    hz_checkbox_h = findobj( OLPhsFig,'string','Hz','type','uicontrol');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    OLPhs_ydata = angle(CplxBode)*(180/pi) + BasePhs;
    % Determine whether to wrap or unwrap this result.
    unwrap_h = PZG(dom_ndx).plot_h{2}.hndl.UnwrapChkbox;
    if get( unwrap_h,'value')
      OLPhs_ydata = ...
        pzg_unwrap( plotFreqs, OLPhs_ydata, Domain, ...
                    [ PZG(dom_ndx).OLBodeName ' Phase'] );
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
    LineH = pzg_fndo( dom_ndx, 2,'PID_Preview');
    if ~isequal( 2, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{2}.hndl.PID_Preview = ...
        plot( plotFreqs, (180/pi)*angle(CplxBode), ...
           'color','c', ...
           'linewidth', 2, ...
           'linestyle','--', ...
           'parent', PZG(dom_ndx).plot_h{2}.ax_h, ...
           'tag',[Domain 'PID Preview'] );
      PZG(dom_ndx).plot_h{2}.hndl.PID_Preview(2) = ...
        plot( plotFreqs, OLPhs_ydata, ...
           'color','m', ...
           'linewidth', 2, ...
           'parent', PZG(dom_ndx).plot_h{2}.ax_h, ...
           'tag',[Domain 'PID Preview'] );
      PZG(dom_ndx).plot_h{2}.hndl.PID_Preview = ...
        PZG(dom_ndx).plot_h{2}.hndl.PID_Preview(:);
    else
      set( LineH(1), ...
          'xdata', plotFreqs, ...
          'ydata', (180/pi)*angle(CplxBode), ...
          'color','c', ...
          'linewidth', 2, ...
          'linestyle','--', ...
          'visible','on');
      set( LineH(2), ...
          'xdata', plotFreqs, ...
          'ydata', OLPhs_ydata, ...
          'color','m', ...
          'linewidth', 2, ...
          'linestyle','-', ...
          'visible','on');
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
    LineH = pzg_fndo( dom_ndx, 7,'PID_Preview');
    hyb_h = PZG(dom_ndx).plot_h{7}.hndl.rescale_checkbox;
    if isempty(hyb_h) || ~get( hyb_h,'value')
      if ~isequal( 2, numel(LineH) )
        delete(LineH)
        PZG(dom_ndx).plot_h{7}.hndl.PID_Preview = ...
          plot( line_ud.OLCplxBode, ...
             'linewidth', 3, ...
             'color',[0.7 0 0.7], ...
             'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
             'tag',[Domain 'PID Preview'], ...
             'userdata', line_ud );
        PZG(dom_ndx).plot_h{7}.hndl.PID_Preview(2) = ...
          plot( conj(line_ud.OLCplxBode), ...
             'linewidth', 2, ...
             'color',[0.7 0.7 0.7], ...
             'linestyle','-', ...
             'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
             'tag',[Domain 'PID Preview'], ...
             'userdata', line_ud );
        PZG(dom_ndx).plot_h{7}.hndl.PID_Preview = ...
          PZG(dom_ndx).plot_h{7}.hndl.PID_Preview(:);
      else
        set( LineH(1), ...
          'xdata', real(line_ud.OLCplxBode), ...
          'ydata', imag(line_ud.OLCplxBode), ...
          'linewidth', 3, ...
          'color',[0.7 0 0.7], ...
          'visible','on');
        set( LineH(2), ...
          'xdata', real(line_ud.OLCplxBode), ...
          'ydata', -imag(line_ud.OLCplxBode), ...
          'linewidth', 2, ...
          'color',[0.7 0.7 0.7], ...
          'linestyle','-', ...
          'visible','on');
      end
    else
      if ~isequal( 2, numel(LineH) )
        delete(LineH)
        PZG(dom_ndx).plot_h{7}.hndl.PID_Preview = ...
          plot( line_ud.scaled_OLCplxBode, ...
            'color',[0.7 0 0.7], ...
            'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
            'tag',[Domain 'PID Preview'], ...
            'userdata', line_ud, ...
            'linewidth', 3 );
        PZG(dom_ndx).plot_h{7}.hndl.PID_Preview(2) = ...
          plot( conj(line_ud.scaled_OLCplxBode), ...
            'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
            'color',[0.7 0.7 0.7], ...
            'linestyle','-', ...
            'tag',[Domain 'PID Preview'], ...
            'userdata', line_ud, ...
            'linewidth', 2 );
      else
        set( LineH(2),'xdata', real(line_ud.scaled_OLCplxBode), ...
          'ydata', imag(line_ud.scaled_OLCplxBode), ...
          'visible','on')
        set( LineH(1),'xdata', real(line_ud.scaled_OLCplxBode), ...
          'ydata', -imag(line_ud.scaled_OLCplxBode), ...
          'visible','on')
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{7}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{7}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 7 );
    end
  end
  
  OLRespFig = pzg_fndo( dom_ndx, 8,'fig_h');
  if ~isempty(OLRespFig)
    architec = 'open loop';
    incl_pade = 0;
    incl_prvw = 'sPID';
    if isequal( Domain,'z')
      incl_prvw = 'zPID';
    end
    resp_ax_h = PZG(dom_ndx).plot_h{8}.ax_h;
    resp_line_h = PZG(dom_ndx).plot_h{8}.hndl.pzgui_resppl_resp_line;
    time_vec = get( resp_line_h(1),'xdata');
    if time_vec(1) == 0
      log_t_vec = [ -Inf, log( time_vec(2:end) ) ];
    else
      log_t_vec = log( time_vec );
    end
    if numel(time_vec) > 2
      % Determine the input ZPK.
      input_type_h = PZG(dom_ndx).plot_h{8}.hndl.input_type_popupmenu;
      if ~isempty(input_type_h)
        input_type = get( input_type_h,'value');
      else
        input_type = 2;
      end
      freq_hz = 1;
      freq_ed_h = ...
        findobj( OLRespFig, ...
                'style','edit', ...
                'tag','visible for periodic only');
      if ~isempty(freq_ed_h)
        freq_hz = str2double( get( freq_ed_h,'string') );
      end
      
      [ input_zeros, input_poles, input_gain ] = ...
          pzg_inzpk( input_type, Domain, freq_hz );
      
      [ resp_res, resp_poles, resp_direct ] = ...
          pzg_rsppfe( ...
            dom_ndx, input_zeros, input_poles, input_gain, ...
            architec, incl_prvw, incl_pade );

      wb_h = -1;
      
      PID_time_resp = zeros(size(time_vec));
      if isequal( Domain,'s')
        if PZG(1).PureDelay == 0
          PID_time_resp(1) = resp_direct;
        else
          delay_ndx = pzg_gle( time_vec, PZG(1).PureDelay,'near');
          PID_time_resp(delay_ndx) = resp_direct;
        end
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
            PID_time_resp = PID_time_resp + this_term;
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
        if PZG(2).PureDelay == 0
          PID_time_resp(1) = resp_direct;
        else
          PID_time_resp(PZG(2).PureDelay+1) = resp_direct;
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
            PID_time_resp(2:end) = PID_time_resp(2:end) + this_term(1:end-1);
          end
          if ishandle(wb_h)
            waitbar( 0.95*k/numel(resp_poles), wb_h )
          end
        end
        if ishandle(wb_h)
          delete( wb_h )
        end
      end
      PID_time_resp = real(PID_time_resp(:));
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
          PID_time_resp(nr_delay_samples+1:end) = ...
            PID_time_resp(1:end-nr_delay_samples);
          PID_time_resp(1:nr_delay_samples) = 0;
        else
          time_vec(1:nr_delay_samples) = [];
          PID_time_resp(end-nr_delay_samples+1:end) = [];
        end
      end
      input_line_h = pzg_fndo( dom_ndx, 8,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      err_ydata = in_ydata(:) - PID_time_resp(:);
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
      OL_resp_prvw_h = pzg_fndo( dom_ndx, 8,'PID_Preview');
      if ~isequal( 2, numel(OL_resp_prvw_h) ) ... 
        || ~isequal( 2, sum( ishandle(OL_resp_prvw_h) ) )
        delete(OL_resp_prvw_h)
        OL_resp_prvw_h = ...
          plot( time_vec(:), PID_time_resp(:), ...
             'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
             'color',[ 1 0 1 ], ...
             'linewidth', 1.5, ...
             'linestyle','-', ...
             'tag',[Domain 'PID Preview']);
        OL_resp_prvw_h(2) = ...
          plot( time_vec(:), err_ydata(:), ...
            'color', err_color, ...
            'linewidth', 1.5, ...
            'linestyle','--', ...
            'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
            'visible', resp_err_vis, ...
            'tag',[Domain 'PID Preview']);
        PZG(dom_ndx).plot_h{8}.hndl.PID_Preview = OL_resp_prvw_h;
      else
        set( OL_resp_prvw_h(1), ...
          'xdata', time_vec(:), ...
          'ydata', PID_time_resp(:), ...
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

  CLRespFig = pzg_fndo( dom_ndx, 9,'fig_h');
  if ~isempty(CLRespFig)
    architec = 'closed loop';
    incl_pade = 1;
    incl_prvw = 'sPID';
    if isequal( Domain,'z')
      incl_prvw = 'zPID';
    end
    resp_ax_h = PZG(dom_ndx).plot_h{9}.ax_h;
    resp_line_h = PZG(dom_ndx).plot_h{9}.hndl.pzgui_resppl_resp_line;
    time_vec = get( resp_line_h(1),'xdata');
    if time_vec(1) == 0
      log_t_vec = [ -Inf, log( time_vec(2:end) ) ];
    else
      log_t_vec = log( time_vec );
    end
    if numel(time_vec) > 2
      % Determine the input ZPK.
      input_type_h = PZG(dom_ndx).plot_h{9}.hndl.input_type_popupmenu;
      if ~isempty(input_type_h)
        input_type = get( input_type_h,'value');
      else
        input_type = 2;
      end
      freq_hz = 1;
      freq_ed_h = pzg_fndo( dom_ndx, 9,'sinusoid_freq_hz_edit');
      if ~isempty(freq_ed_h)
        freq_hz = str2double( get( freq_ed_h,'string') );
      end
      
      [ input_zeros, input_poles, input_gain ] = ...
          pzg_inzpk( input_type, Domain, freq_hz );
      
      [ resp_res, resp_poles, resp_direct ] = ...
          pzg_rsppfe( ...
            dom_ndx, input_zeros, input_poles, input_gain, ...
            architec, incl_prvw, incl_pade );

      wb_h = -1;

      PID_time_resp = zeros(size(time_vec));
      PID_time_resp(1) = resp_direct;
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
            PID_time_resp = PID_time_resp + this_term;
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
            PID_time_resp(2:end) = PID_time_resp(2:end) + this_term(1:end-1);
          end
          if ishandle(wb_h)
            waitbar( 0.95*k/numel(resp_poles), wb_h )
          end
        end
        if ishandle(wb_h)
          delete( wb_h )
        end
      end
      PID_time_resp = real(PID_time_resp);
      input_line_h = pzg_fndo( dom_ndx, 9,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      err_ydata = in_ydata(:) - PID_time_resp(:);
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
      CL_resp_prvw_h = pzg_fndo( dom_ndx, 9,'PID_Preview');
      if ~isequal( 2, numel(CL_resp_prvw_h) ) ... 
        || ~isequal( 2, sum( ishandle(CL_resp_prvw_h) ) )
        delete(CL_resp_prvw_h)
        CL_resp_prvw_h = ...
          plot( time_vec(:), PID_time_resp(:), ...
             'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
             'color',[ 1 0 1 ], ...
             'linewidth', 1.5, ...
             'linestyle','-', ...
             'tag',[Domain 'PID Preview']);
        CL_resp_prvw_h(2) = ...
          plot( time_vec(:), err_ydata(:), ...
            'color', err_color, ...
            'linewidth', 1.5, ...
            'linestyle','--', ...
            'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
            'visible', resp_err_vis, ...
            'tag',[Domain 'PID Preview']);
        PZG(dom_ndx).plot_h{9}.hndl.PID_Preview = CL_resp_prvw_h;
      else
        set( CL_resp_prvw_h(1), ...
          'xdata', time_vec(:), ...
          'ydata', PID_time_resp(:), ...
          'visible','on')
        set( CL_resp_prvw_h(2), ...
          'xdata', time_vec(:), ...
          'ydata', err_ydata(:), ...
          'color', err_color, ...
          'visible', resp_err_vis )
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

  PZGFig_h = pzg_fndo( dom_ndx, 11+dom_ndx,'fig_h');
  if ~isempty(PZGFig_h)
    PZG_ax_h = PZG(dom_ndx).plot_h{11+dom_ndx}.ax_h;
    if sum( get(PZG_ax_h,'color') ) > 0.6
      this_gray = [0.4 0.4 0.4];
    else
      this_gray = [0.7 0.7 0.7];
    end
    LineH = pzg_fndo( dom_ndx, 11+dom_ndx,'PID_Preview');
    if ~isequal( 2, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{11+dom_ndx}.hndl.PID_Preview = ...
        plot( real([Pole1;Pole2]), imag([Pole1;Pole2]), ...
          'marker','x', ...
          'markersize', 14, ...
          'color', this_gray, ...
          'linewidth', 3, ...
          'linestyle','none', ...
          'tag',[Domain 'PID Preview'], ...
          'parent', PZG_ax_h );
      PZG(dom_ndx).plot_h{11+dom_ndx}.hndl.PID_Preview(2) = ...
        plot( real([Zero1;Zero2]), imag([Zero1;Zero2]), ...
          'marker','o', ...
          'markersize', 12, ...
          'color', this_gray, ...
          'linewidth', 3, ...
          'linestyle','none', ...
          'tag',[Domain 'PID Preview'], ...
          'parent', PZG_ax_h );
      PZG(dom_ndx).plot_h{11+dom_ndx}.hndl.PID_Preview = ...
        PZG(dom_ndx).plot_h{11+dom_ndx}.hndl.PID_Preview(:);
    else
      set( LineH(1), ...
        'xdata', real([Pole1;Pole2]), ...
        'ydata', imag([Pole1;Pole2]), ...
        'marker','x', ...
        'markersize', 14, ...
        'color', this_gray, ...
        'linewidth', 3, ...
        'linestyle','none', ...
        'visible','on')
      set( LineH(2), ...
        'xdata', real([Zero1;Zero2]), ...
        'ydata', imag([Zero1;Zero2]), ...
        'marker','o', ...
        'markersize', 12, ...
        'color', this_gray, ...
        'linewidth', 3, ...
        'linestyle','none', ...
        'visible','on');
    end
    if strcmp( get( PZG(dom_ndx).plot_h{11+dom_ndx}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{11+dom_ndx}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 11+dom_ndx );
    end
  end
  
  RtLocFig = pzg_fndo( dom_ndx, 9+dom_ndx,'fig_h');
  if ~isempty(RtLocFig)
    hi_nr_poles = 13;
    GAINS = [ logspace(-5,0,2000), logspace(0,5,2000), ...
              logspace(5,10,1000) ]';
    GAINS = unique(GAINS);
    % Construct the zpk model with the lead or lag filter included.
    Z = [ PZG(dom_ndx).ZeroLocs; Zero1; Zero2 ];
    P = [ PZG(dom_ndx).PoleLocs; Pole1; Pole2 ];
    K = PZG(dom_ndx).Gain * pid_gain;
    
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
    if ( numel( P ) > 1 ) && ( numel( P ) < hi_nr_poles )
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
      for k = 1:numel(brk_gains)
        brk_gains(k) = prod( abs( brk_pts(k)-P ) ) ...
                       /prod( abs( brk_pts(k)-Z ) ) / K;
      end
      GAINS = [ GAINS(:); brk_gains(:); 1 ];
      GAINS = sort( abs(GAINS) );
    end
    negGAINS = GAINS;
    GAINeq1_ndx = find( negGAINS == 1 );
    if ~isempty(GAINeq1_ndx)
      negGAINS(GAINeq1_ndx) = negGAINS(GAINeq1_ndx-1);
    end
    
    purejordan = 1;
    include_pade = 1;
    if dom_ndx == 1
      include_prvw = 'sPID';
    else
      include_prvw = 'zPID';
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
          rtloc_h = ...
            findobj( allchild(0), ...
                    'type','figure', ...
                    'name', PZG(dom_ndx).RootLocusName );
          delete(rtloc_h)
          dom_gui_h = ...
            findobj( allchild(0),'name', PZG(dom_ndx).PZGUIname );
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
    else
      this_gray = [0.8 0.8 0.8];
      marker_gray = [0.7 0.7 0.7];
      this_red = [1 0.6 0.6];
    end
    LineH = pzg_fndo( dom_ndx, 9+dom_ndx,'PID_Preview');
    if isequal( 7, numel(LineH) )
      set( LineH(1), ...
        'xdata', real(Loci(:)), ...
        'ydata', imag(Loci(:)), ...
        'color', this_gray, ...
        'linestyle','none', ...
        'marker','.', ...
        'markersize', 6, ...
        'linewidth', 2, ...
        'visible','on');
      set( LineH(2), ...
        'xdata', real([Pole1;Pole2]), ...
        'ydata', imag([Pole1;Pole2]), ...
        'marker','x', ...
        'color', marker_gray, ...
        'linewidth', 3, ...
        'linestyle','none', ...
        'markersize', 14, ...
        'visible','on');
      set( LineH(3), ...
        'xdata', real([Zero1;Zero2]), ...
        'ydata', imag([Zero1;Zero2]), ...
        'marker','o', ...
        'color', marker_gray, ...
        'linewidth', 3, ...
        'linestyle','none', ...
        'markersize', 12, ...
        'visible','on');
      set( LineH(4), ...
        'xdata', real(CLpoles), ...
        'ydata', imag(CLpoles), ...
        'marker','s', ...
        'color', marker_gray, ...
        'linewidth', 3, ...
        'linestyle','none', ...
        'markersize', 10, ...
        'visible','on');
      if isempty(asymptotes)
        set( LineH(5),'xdata',[],'ydata',[],'visible','off')
      else
        set( LineH(5), ...
            'xdata', real(asymptotes(:)), ...
            'ydata', imag(asymptotes(:)), ...
            'color', this_gray, ...
            'linewidth', 2, ...
            'linestyle','-.', ...
            'visible','on')
      end
      if isempty(neg_asymptotes)
        set( LineH(6),'xdata',[],'ydata',[],'visible','off')
      else
        set( LineH(6), ...
            'xdata', real(neg_asymptotes(:)), ...
            'ydata', imag(neg_asymptotes(:)), ...
            'color', this_red, ...
            'linewidth', 2, ...
            'linestyle','-.', ...
            'visible', negrloc_vis )
      end
      set( LineH(7), ...
        'xdata', real(negLoci(:)), ...
        'ydata', imag(negLoci(:)), ...
        'color', this_red, ...
        'linestyle','none', ...
        'marker','.', ...
        'markersize', 6, ...
        'linewidth', 2, ...
        'visible', negrloc_vis );
    else
      delete(LineH)
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview = ...
        plot( real(Loci(:)), imag(Loci(:)), ...
          'color', this_gray, ...
          'linestyle','none', ...
          'marker','.', ...
          'markersize', 6, ...
          'linewidth', 2, ...
          'tag',[Domain 'PID Preview'], ...
          'parent', rloc_ax_h );
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(2) = ...
        plot( real([Pole1;Pole2]), imag([Pole1;Pole2]), ...
          'marker','x', ...
          'color', marker_gray, ...
          'linewidth', 3, ...
          'linestyle','none', ...
          'markersize', 14, ...
          'tag',[Domain 'PID Preview'], ...
          'parent', rloc_ax_h );
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(3) = ...
        plot( real([Zero1;Zero2]), imag([Zero1;Zero2]), ...
          'marker','o', ...
          'color', marker_gray, ...
          'linewidth', 3, ...
          'linestyle','none', ...
          'markersize', 12, ...
          'tag',[Domain 'PID Preview'], ...
          'parent', rloc_ax_h );
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(4) = ...
        plot( real(CLpoles), imag(CLpoles), ...
          'marker','s', ...
          'color', marker_gray, ...
          'linewidth', 3, ...
          'linestyle','none', ...
          'markersize', 10, ...
          'tag',[Domain 'PID Preview'], ...
          'parent', rloc_ax_h );
      if ~isempty(asymptotes)
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(5) = ...
           plot( real(asymptotes(:)), imag(asymptotes(:)), ...
             'color', this_gray, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'parent', rloc_ax_h, ...
             'tag',[Domain 'PID Preview']);
      else
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(5) = ...
           plot( 0, 0, ...
             'color', this_gray, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'tag',[Domain 'PID Preview'], ...
             'parent', rloc_ax_h );
        set( PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(5), ...
            'xdata',[],'ydata',[],'visible','off')
      end
      if ~isempty(neg_asymptotes)
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(6) = ...
           plot( real(neg_asymptotes(:)), imag(neg_asymptotes(:)), ...
             'color', this_red, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'parent', rloc_ax_h, ...
             'visible', negrloc_vis, ...
             'tag',[Domain 'PID Preview'] );
      else
        PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(6) = ...
           plot( 0, 0, ...
             'color', this_red, ...
             'linewidth', 2, ...
             'linestyle','-.', ...
             'parent', rloc_ax_h, ...
             'visible', negrloc_vis, ...
             'tag',[Domain 'PID Preview'] );
        set( PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(6), ...
            'xdata', [],'ydata', [] )
      end
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.PID_Preview(7) = ...
        plot( real(negLoci(:)), imag(negLoci(:)), ...
          'color', this_red, ...
          'linestyle','none', ...
          'marker','.', ...
          'markersize', 6, ...
          'linewidth', 2, ...
          'tag',[Domain 'PID Preview'], ...
          'visible', negrloc_vis, ...
          'parent', rloc_ax_h );
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
    LineH = pzg_fndo( dom_ndx, 5,'PID_Preview');
    if ~isequal( 1, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{5}.hndl.PID_Preview = ...
        plot( plotFreqs, Sens,'m', ...
             'parent', get(SensFig,'currentaxes'), ...
             'tag',[Domain 'PID Preview'], ...
             'linewidth', 2 );
      if ~CLstable
        set( PZG(dom_ndx).plot_h{5}.hndl.PID_Preview,'visible','off')
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
  
elseif strcmp( GCBOtag,'Apply') && strcmpi( get(gcbo,'enable'),'on')
  % Add the compensator to the system in the PZGUI.
  set( gcbo,'enable','off')
  local_clear_preview( dom_ndx, hndl )

  Gain = str2num( get( hndl.Gain,'string') ); %#ok<ST2NM>
  if ~isequal( 1, numel(Gain) ) || isinf(Gain) || isnan(Gain)
    Gain = PZG(dom_ndx).PID{4};
    set( hndl.Gain,'string', num2str(Gain,5) );
  end
  Zero1 = str2num( get( hndl.Zero1,'string') ); %#ok<ST2NM>
  if ~isequal( 1, numel(Zero1) ) || isinf(Zero1) || isnan(Zero1)
    Zero1 = PZG(dom_ndx).PID{5};
    set( hndl.Zero1,'string', num2str(Zero1,5) );
  end
  Zero2 = str2num( get( hndl.Zero2,'string') ); %#ok<ST2NM>
  if ~isequal( 1, numel(Zero2) ) || isinf(Zero2) || isnan(Zero2)
    Zero2 = PZG(dom_ndx).PID{6};
    set( hndl.Zero2,'string', num2str(Zero2,5) );
  end
  if ( numel([Gain,Zero1,Zero2]) ~= 3 )
    if isequal( 0, slider_is_moving )
      errdlg_h = ...
        errordlg({'PID is not yet completely specified.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                  'Incompletely Specified PID','modal');
      uiwait(errdlg_h)
    end
    local_clear_preview( dom_ndx, hndl )
    return
  end
  PZG(dom_ndx).PID{4} = Gain;
  PZG(dom_ndx).PID{5} = Zero1;
  PZG(dom_ndx).PID{6} = Zero2;
  if dom_ndx == 1
    Ts = 0;
  else
    Ts = PZG(dom_ndx).Ts;
  end
  [ pzgPID, error_str ] = ...
      local_zpk2pidgain( ...
         PZG(dom_ndx).PID, Ts, pole2_multiplier, slider_is_moving );
  if ~isempty(error_str)
    local_clear_preview( dom_ndx, hndl )
    return
  end
  PZG(dom_ndx).PID = pzgPID;
  if dom_ndx == 1
    Pole1 = 0;
    Pole2 = pole2_multiplier * min( real([Zero1;Zero2]) );
    Gain = Gain*abs(Pole2);
  else
    Pole1 = 1;
    Pole2 = 0;
  end
  PZG(dom_ndx).PID{7} = Pole2;
  
  if ( numel( intersect( PZG(dom_ndx).PoleLocs, Pole1 ) ) >= 1 ) ...
    &&( numel( intersect( PZG(dom_ndx).PoleLocs, Pole2 ) ) >= 1 ) ...
    &&( numel( intersect( PZG(dom_ndx).ZeroLocs, Zero1 ) ) >= 1 ) ...
    &&( numel( intersect( PZG(dom_ndx).ZeroLocs, Zero2 ) ) >= 1 )
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
  PZG(dom_ndx).PoleLocs = [ Pole1; Pole2; PZG(dom_ndx).PoleLocs ];
  PZG(dom_ndx).ZeroLocs = [ Zero1; Zero2; PZG(dom_ndx).ZeroLocs ];
  if ~isnan(Gain) && ~isinf(Gain) && ( Gain ~= 0 )
    PZG(dom_ndx).Gain = PZG(dom_ndx).Gain * Gain;
  end
  PZG(dom_ndx).DCgain = []; % DC gain is now infinite, due to integrator.
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
    PZG(1).recompute_frf = 0;
    pzg_cntr(1);
    pzg_bodex(1);
    pzgui
    updatepl
  else
    PZG(2).recompute_frf = 0;
    pzg_cntr(2);
    pzg_bodex(2);
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
    msgbox({'The poles, zeros, and gain have'; ...
            'been applied into the main GUI.'; ...
            ' ';'   Click "OK" to continue ....';' '}, ...
           'Model Has Been Modified');
  msgbox_pos = get(msgbox_h,'position');
  msgbox_pos(3) = 1.5*msgbox_pos(3);
  set(msgbox_h,'position',msgbox_pos);
  
  set( gcbo,'enable','on')

elseif strcmp( GCBOtag,'clear preview')
  
  local_clear_preview( dom_ndx, hndl )
  
end

msgbox_h = findobj( allchild(0),'name','Model Has Been Modified');
if ~isempty(msgbox_h)
  if numel(msgbox_h) > 1
    delete(msgbox_h(2:end))
  end
  figure(msgbox_h(1))
end

if isequal( 1, ishandle(PidFig) )
  pid_ax_h = findobj(PidFig,'type','axes');
  if ~isempty(pid_ax_h)
    if numel(pid_ax_h) > 1
      delete(pid_ax_h(2:end))
      pid_ax_h = pid_ax_h(1);
    end
    set(pid_ax_h,'tag','no-vis axes','visible','off')
  end
end

return


% LOCAL FUNCTIONS

function [ PID, error_str ] = ...
           local_zpk2pidgain( PID, Ts, pole2_multiplier, slider_is_moving )
  % Computes Kp, Ki, and Kd from the two zero locations.
  error_str = '';
  if ( numel(PID) < 7 ) || ~iscell(PID)
    error_str = 'zpk2pid: ZPK is not correctly specified.';
    if isequal( 0, slider_is_moving )
      errdlg_h = ...
        errordlg({'zpk2pid: ZPK is not correctly specified.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'zpk2pid Function Error','modal');
      uiwait(errdlg_h)
    end
    return
  end
  
  Gain = PID{4};
  Zero1 = PID{5};
  Zero2 = PID{6};
  if Ts == 0
    % Continuous-time case.
    if ~isequal(numel(Gain),1) ...
      || ~isequal(numel(Zero1),1) || ~isequal(numel(Zero2),1) ...
      || ~real(Gain) || ~isnumeric(Zero1) || ~isnumeric(Zero2) ...
      || isnan(Gain) || isnan(Zero1) || isnan(Zero2) ...
      || isinf(Gain) || isinf(Zero1) || isinf(Zero2) ...
      ||( real(Zero1) >= -1e-5 ) || ( real(Zero2) >= -1e-5 ) ...
      ||( ( ~isreal(Zero1) || ~isreal(Zero2) ) ...
         &&( abs(Zero1-conj(Zero2)) > 1e-14 ) )
      local_clear_preview( 1, hndl )
      error_str = 'zpk2pid: PID is not correctly specified.';
      if isequal( slider_is_moving, 0 )
        errdlg_h = ...
          errordlg( ...
            {'zpk2pid: PID has a non-left-half plane zero,'; ...
             '         or non-real-valued zeros not conjugate paired,'; ...
             '         or negative gain, or some other irregularity.'; ...
             ' ';'    Click "OK" to continue ...';' '}, ...
            'zpk2pid Function Error','modal');
        uiwait(errdlg_h)
      end
      return
    elseif Gain <= 0
      local_clear_preview( 1, hndl )
      error_str = 'zpk2pid: PID has a non-positive gain factor.';
      if isequal( slider_is_moving, 0 )
        errdlg_h = ...
          errordlg({'zpk2pid: PID has a non-positive gain factor.'; ...
                    ' ';'    Click "OK" to continue ...';' '}, ...
                   'zpk2pid Function Error','modal');
        uiwait(errdlg_h)
      end
      return
    end
    NUM = Gain * real( poly([Zero1;Zero2]) );
    DerivGain = NUM(1);
    PropGain = NUM(2);
    IntegGain = NUM(3);
    PID{1} = PropGain;
    PID{2} = IntegGain;
    PID{3} = DerivGain;
    PID{7} = -pole2_multiplier * max( abs(PID{5}), abs(PID{6}) );
  else
    % Discrete-time case.
    if Ts < 0
      % Unspecified D-T sample period.
      Ts = 1;
    end
    if ~isequal(numel(Gain),1) ...
      || ~isequal(numel(Zero1),1) || ~isequal(numel(Zero2),1) ...
      || ~isreal(Gain) || ~isnumeric(Zero1) || ~isnumeric(Zero2) ...
      || isnan(Gain) || isnan(Zero1) || isnan(Zero2) ...
      || isinf(Gain) || isinf(Zero1) || isinf(Zero2) ...
      ||( isreal(Zero1) && ( Zero1 <= 0 ) ) ...
      ||( abs(Zero1) >= (1-1e-7) ) ...
      ||( isreal(Zero2) && ( Zero2 <= 0 ) ) ...
      ||( abs(Zero2) >= (1-1e-7) ) ...
      ||( ( ~isreal(Zero1) || ~isreal(Zero2) ) ...
         && abs( Zero1 - conj(Zero2) ) > 1e-14 )
      local_clear_preview( 2, hndl )
      error_str = 'zpk2pid: PID zeros are not correctly specified.';
      if isequal( slider_is_moving, 0 )
        errdlg_h = ...
          errordlg({'zpk2pid: PID has a zero outside the unit-circle,'; ...
                    '         or on the negative real axis,'; ...
                    '         or non-real-valued but not conjugate paired,'; ...
                    '         or some other irregularity.'; ...
                    ' ';'    Click "OK" to continue ...';' '}, ...
                   'zpk2pid Function Error','modal');
        uiwait(errdlg_h)
      end
      return
    elseif Gain <= 0
      local_clear_preview( 2, hndl )
      error_str = 'zpk2pid: PID has a non-positive gain factor.';
      if isequal( slider_is_moving, 0 )
        errdlg_h = ...
          errordlg({'zpk2pid: ZPK has a non-positive gain.'; ...
                    ' ';'    Click "OK" to continue ...';' '}, ...
                   'zpk2pid Function Error','modal');
        uiwait(errdlg_h)
      end
      return
    end
    NUM = Gain * real( poly([Zero1;Zero2]) );
    DerivGain = NUM(3) * Ts;
    PropGain = NUM(1) - NUM(3);
    IntegGain = sum( NUM )/Ts;
    PID{1} = PropGain;
    PID{2} = IntegGain;
    PID{3} = DerivGain;
    PID{7} = 0;
  end
  
return


function [ PID, error_str ] = ...
            local_pidgain2zpk( PID, Ts, pole2_multiplier, slider_is_moving )
  % Computes Zero1, Zero2, and Gain from Kp, Ki, and Kd.
  error_str = '';
  if ~iscell(PID) || ( numel(PID) < 7 )
    error_str = 'pid2zpk: Gains are not correctly specified.';
    if isequal( 0, slider_is_moving )
      errdlg_h = ...
        errordlg({'pid2zpk: Gains are not correctly specified.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'pid2zpk Function Error','modal');
      uiwait(errdlg_h)
    end
    return
  end
  
  Kp = PID{1};
  Ki = PID{2};
  Kd = PID{3};
  if ~isequal( 1, numel(Kp) ) ...
    ||~isequal( 1, numel(Ki) ) || ~isequal( 1, numel(Ki) ) ...
    ||~isreal(Kp) || ~isreal(Ki) || ~isreal(Kd) ...
    || isnan(Kp) || isnan(Ki) || isnan(Kd) ...
    || isinf(Kp) || isinf(Ki) || isinf(Kd) ...
    || ( Kp < 1e-12 ) || ( Ki < 1e-12 ) || ( Kd < 1e-12 )
    error_str = 'pidfilt: PID gains are not correctly specified.';
    if isequal( 0, slider_is_moving )
      errdlg_h = ...
        errordlg({'pidfilt: At least one PID gain is too small.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'pidfilt Function Error','modal');
      uiwait(errdlg_h)
    end
    return
  end
    
  if Ts == 0
    % Continuous-time case.
    NUM = [ Kd Kp Ki ];
    these_zeros = roots(NUM);
    if any(isnan(these_zeros)) || any(isinf(these_zeros))
      error_str = 'pidfilt: PID zeros could not be determined.';
      if isequal( 0, slider_is_moving )
        errdlg_h = ...
          errordlg( ...
            {'pidfilt: The zeros of the PID could not be determined.'; ...
             ' ';'    Click "OK" to continue ...';' '}, ...
            'pidfilt Function Error','modal');
        uiwait(errdlg_h)
      end
      return
    end
    PID{4} = Kd;
    PID{5} = these_zeros(1);
    PID{6} = these_zeros(2);
    PID{7} = -pole2_multiplier * max( abs(PID{5}),abs(PID{6}) );
    %disp(['Pole #2 multiplier = ' num2str(pole2_multiplier)])
  else
    % Discrete-time case.
    if Ts < 0
      % Unspecified D-T sample period.
      Ts = 1;
    end

    NUM = [ (Kp+Kd/Ts), (Ki*Ts-Kp-2*Kd/Ts), Kd/Ts ];
    these_zeros = roots(NUM);
    if any(isnan(these_zeros)) || any(isinf(these_zeros))
      error_str = 'pidfilt: PID zeros could not be determined.';
      if isequal( 0, slider_is_moving )
        errdlg_h = ...
          errordlg( ...
            {'pidfilt: The zeros of the PID could not be determined.'; ...
             ' ';'    Click "OK" to continue ...';' '}, ...
            'pidfilt Function Error','modal');
        uiwait(errdlg_h)
      end
      return
    end
    PID{4} = NUM(1);
    PID{5} = these_zeros(1);
    PID{6} = these_zeros(2);
    PID{7} = 0;
    if abs(PID{5}) > (1-1e-7)
      error_str = 'pidfilt: PID zeros would be outside of the unit circle.';
      if isequal( 0, slider_is_moving )
        errdlg_h = ...
          errordlg( ...
            {'pidfilt: The zeros of the PID could not be determined.'; ...
             ' ';'    Click "OK" to continue ...';' '}, ...
            'pidfilt Function Error','modal');
        uiwait(errdlg_h)
      end
      return
    end
  end
return


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
    || ~isequal( PZG(M).undo_info{end}, undo_info )
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

function local_clear_preview( dom_ndx, hndl )
  prev_h = pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9 11], 14 ],'PID_Preview');
  set( prev_h,'visible','off')
  if isfield( hndl,'preview_pushbutton')
    set( hndl.preview_pushbutton,'backgroundcolor', 0.9412*[1 1 1]);
  end
  if isfield( hndl,'clear_preview_pushbutton')
    set( hndl.clear_preview_pushbutton,'visible','off');
  end
  if isfield( hndl,'PID_slider_menu')
    set( hndl.PID_slider_menu,'visible','off');
  end
  if isfield( hndl,'PID_slider')
    set( hndl.PID_slider,'visible','off');
  end
  for k = [(1:9),dom_ndx+[9,11]]
    fig_h = pzg_fndo( dom_ndx, k,'fig_h');
    if isempty(fig_h)
      continue
    end
    pzg_lims( dom_ndx, k );
  end  
return

function slider_angle = local_slider2angle( slider_value )
  slider_angle = [];
  if ~nargin || ~isreal(slider_value) ...
    ||~isequal( 1, numel(slider_value) ) ...
    ||( slider_value < 0 ) || ( slider_value > 1 )
    return
  end
  mod_value = ( pi/2 - 2e-5 )*slider_value + 1e-5;
  slider_angle = pi - mod_value;
return

function slider_value = local_angle2slider( slider_angle )
  slider_value = [];
  if ~nargin || ~isreal(slider_angle) ...
    ||~isequal( 1, numel(slider_angle) ) ...
    ||( slider_angle < pi/2 ) || ( slider_angle > pi )
    return
  end
  mod_value = pi - abs(slider_angle);
  slider_value = ( mod_value - 1e-5 ) / ( pi/2 - 2e-5 );
  slider_value = max( 0, min( 1, slider_value ) );
return
