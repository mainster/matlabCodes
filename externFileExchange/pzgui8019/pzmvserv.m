function  Calls = pzmvserv( Domain, AddPZ, CallbackStr )
% Services the front-panel buttons and data-entry
% windows of the two PZGUI pole/zero map GUIs 
% (discrete-time and continuous-time)

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
global PZG PZMoving
Calls = 0;
noCalls = 0;
if isempty(PZG) && ~pzg_recovr 
  return
end
evalin('base','global PZG')

gcf0 = gcbf;
gco0 = gcbo;
if isempty(gco0)
  gco0 = gco;
end

if ~isempty(gco0) && ( ( nargin < 3 ) || ~ischar(CallbackStr) )
  CallbackStr = get(gco0,'Callback');
elseif nargin < 3
  CallbackStr = '';
end

if ~isempty(gcf0)
  temp0 = get(gcf0,'UserData');
end

if nargin < 1
  return
end
if ~ischar(Domain)
  return
end
if Domain(1) == 's'
  M = 1;
elseif Domain(1) == 'z'
  M = 2;
else
  return
end

CT_PZGUI = pzg_fndo( 1, 12,'fig_h');
DT_PZGUI = pzg_fndo( 2, 13,'fig_h');

if ~isempty(gcbo) && ~strcmp( get(gcbo,'type'),'figure')
  cb_str = get(gcbo,'callback');
  PZMoving = 0;
  if ~isempty( strfind( cb_str,'DeletePole') )
    % Don't allow deletion of a pole if that would result in
    % fewer poles than zeros.
    if isempty(PZG(M).PoleLocs)
      err_h = ...
        errordlg({'There is no pole to delete.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'No Pole is Defined','modal');
      uiwait(err_h)
      return
    end
    temp_ud = get( get(gcbo,'parent'),'userdata');
    if ( size(temp_ud,1) >= 7 ) && ( size(temp_ud,2) >= 2 ) ...
      && ishandle(temp_ud(7,2))
      selected_pole = get(temp_ud(7,2),'value');
    else
      return
    end
    bailout = 0;
    nr_zeros = numel(PZG(M).ZeroLocs);
    these_poles = PZG(M).PoleLocs;
    if nr_zeros >= numel(these_poles)
      bailout = 1;
    elseif ( nr_zeros > 0 ) && ( selected_pole > numel(these_poles) )
      % User wants to delete all poles, but there are zeros.
      bailout = 1;
    elseif numel(these_poles) == (nr_zeros+1)
      % OK to delete the pole provided it is real-valued.
      if ~isreal( these_poles(selected_pole) )
        bailout = 1;
      end
    end
    if bailout
      err_h = ...
        errordlg({'You cannot delete the selected pole(s) because'; ...
                  'that would result in fewer poles than zeros,'; ...
                  'which is not physically realistic.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'Cannot Delete the Pole(s)','modal');
      uiwait(err_h)
      return
    end
  elseif ~isempty( strfind( cb_str,'AddZero') )
    clear_string = 0;
    tempStr = get( temp0(12,2),'String');
    if isempty(tempStr)
      errdlg_h = ...
        errordlg( ...
          {'You must enter the locations where zeros are to be added.'; ...
           'Enter the information just below the "Add" button you clicked.'; ...
           ' '; ...
           'To specify the location (or locations), enter:'; ...
           '      one or more numeric values,'; ...
           ' OR'; ...
           '     a mathematical expression Matlab can evaluate,'; ...
           ' OR'; ...
           '     the name of a numeric variable in the Matlab workspace.'; ...
           ' ';'    Click "OK" to continue ...'}, ...
            'PZGUI Advisory','modal');
      uiwait(errdlg_h)
      return
    end
    % Don't allow addition of a zero if that would result in 
    % more zeros than poles.
    bailout = 0;
    nr_poles = numel(PZG(M).PoleLocs);
    existing_zeros = PZG(M).ZeroLocs;
    temp_ud = get( get(gcbo,'parent'),'userdata');
    if ( size(temp_ud,1) >= 12 ) && ( size(temp_ud,2) >= 2 ) ...
      && ishandle(temp_ud(12,2))
      zeroStr = get(temp_ud(12,2),'string');
      indicated_zero = str2num( zeroStr ); %#ok<ST2NM>
      if isempty(indicated_zero)
        indicated_zero = str2num( lower(zeroStr) ); %#ok<ST2NM>
      end
      if isempty(indicated_zero)
        % String did not convert directly to a number.
        % The text string entry might refer to a workplace variable.
        try
          zeroStr = strtrim(zeroStr);
          sp_ndx = strfind( zeroStr,' ');
          if ~isempty(sp_ndx) && ( sp_ndx(1) > 0 )
            zeroStr = zeroStr(1:sp_ndx(1)-1);
          end
          indicated_zero = evalin('base', zeroStr );
          indicated_zero = indicated_zero(:);
          clear_string = 0;
        catch %#ok<CTCH>
          indicated_zero = [];
        end
      end
      if isempty(indicated_zero) || ~isnumeric(indicated_zero) ...
        || any( isinf(indicated_zero) ) || any( isnan(indicated_zero) )
        errdlg_h = ...
          errordlg( ...
          {'Unable to parse the entry into a valid zero locations.'; ...
           ' ';'The zeros must be finite numbers.'; ...
           ' ';'You may enter either numeric values, or the'; ...
           'name of a numeric variable in the Matlab workspace.'; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'PZGUI Error','modal');
        uiwait(errdlg_h)
        return
      else
        indicated_zero = indicated_zero(:);
      end
      if ( numel(indicated_zero) == 1 ) && ~isreal(indicated_zero)
        indicated_zero = [ indicated_zero; conj(indicated_zero) ];
      elseif numel(indicated_zero) > 1
        % Make sure that all non-real-valued zeros are paired with
        % their complex-conjugates.
        for k = numel(indicated_zero):-1:1
          conj_ndxs = ...
            find( abs(indicated_zero-conj(indicated_zero(k))) ...
                   < 100*eps ); %#ok<EFIND>
          if isempty( conj_ndxs )
            indicated_zero = ...
              [ indicated_zero; conj(indicated_zero(k)) ]; %#ok<AGROW>
          end
        end
      end
      if ( numel(indicated_zero) + numel(existing_zeros) ) > nr_poles
        bailout = 1;
      end
    end
    if bailout
      err_h = ...
        errordlg({'You cannot add the indicated zero(s) because'; ...
                  'that would result in more zeros than poles,'; ...
                  'which is not physically realistic.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'Cannot Delete the Pole','modal');
      uiwait(err_h)
      return
    end
    if clear_string
      set( temp_ud(12,2),'string','')
    end
  end
end

if ~isempty( DT_PZGUI )
  tempDT = get(DT_PZGUI,'UserData');
  if ( isempty(gcf0) || ( DT_PZGUI ~= gcf0 ) ) ...
    && isempty( strfind( CallbackStr,'Erase') ) ...
    && isempty( strfind( CallbackStr,'Set TS') ) % ...
    % && isfield( PZG(1),'undo_info') && ~isempty(PZG(1).undo_info)
    %ct_undo_info = PZG(1).undo_info{end};
    if get(tempDT(14,2),'Value')
      set(tempDT(14,2),'Value',0);
      set(tempDT(14:15,2),'backgroundcolor', PZG(2).DefaultBackgroundColor);
      err_h = ...
        errordlg({'Turning off D-T >> C-T Link'; ...
                  ' '; ...
                  '    Click "OK" to continue ...';' '}, ...
                 'Link Status Alert','modal');
      uiwait(err_h)
      figure(CT_PZGUI);
    end
  end
end

if ~isempty( CT_PZGUI )
  tempCT = get(CT_PZGUI,'UserData');
  if ~isempty(gcf0) && ( CT_PZGUI ~= gcf0 ) ...
    &&( ~strcmp( get(gco0,'type'),'uicontrol') ...
       || isempty( strfind( get(gco0,'Callback'),'Erase') ) ) ...
    && isfield( PZG(2),'undo_info')
    if get(tempCT(14,2),'Value')
      % If this is an undo callback, see if the sample-period will change.
      if isempty( strfind( CallbackStr,'UNDO') ) ...
        && isempty( strfind( CallbackStr,'Set Gain') ) ...
        && isempty( strfind( CallbackStr,'% Add') ) ...
        && isempty( strfind( CallbackStr,'% Move') )
        delink = 0;
      else
        delink = 1;
      end
      if ~isempty(PZG(1).undo_info) 
        ct_undo_data = PZG(1).undo_info{end};
        if isstruct(ct_undo_data) ...
          && isfield( ct_undo_data,'PoleLocs') ...
          && isfield( ct_undo_data,'ZeroLocs') ...
          && isfield( ct_undo_data,'Gain') ...
          && isfield( ct_undo_data,'PureDelay') ...
          && isfield( ct_undo_data,'Ts')
          if ~isequal( ct_undo_data.Ts, PZG(2).Ts ) ...
            && isempty( strfind( CallbackStr,'UNDO') ) ...
            && isempty( strfind( CallbackStr,'REDO') ) ...
            && isempty( strfind( CallbackStr,'Set TS') ) ...
            && isempty( strfind( CallbackStr,'Erase') ) ...
            && isempty( strfind( CallbackStr,'mouse motion') )
            delink = 1;
          end
        end
      elseif ~isempty( strfind( get(gco0,'Callback'),'Set TS') ) ...
        && isempty( strfind( CallbackStr,'UNDO') ) ...
        && isempty( strfind( CallbackStr,'REDO') )
        delink = 0;
      else
        if ~isempty(PZG(2).undo_info)
          dt_undo_data = PZG(2).undo_info{end};
          if isstruct(dt_undo_data) ...
            && isfield( dt_undo_data,'PoleLocs') ...
            && isfield( dt_undo_data,'ZeroLocs') ...
            && isfield( dt_undo_data,'Gain') ...
            && isfield( dt_undo_data,'PureDelay') ...
            && isfield( dt_undo_data,'Ts')
            if ~isequal( dt_undo_data.Ts, ...
                         num2str( get(tempDT(13,2),'string') ) ) ...
              && isempty( strfind( CallbackStr,'UNDO') ) ...
              && isempty( strfind( CallbackStr,'REDO') )
              delink = 0;
            end
          end
        end
      end
       
      if delink
        % A model-change was made in the D-T GUI.
        % For any model-change EXCEPT a change of the sample-period,
        % de-link the D-T model from the C-T model.
        set(tempCT(14,2),'Value',0);
        set(tempCT(14:15,2),'backgroundcolor', PZG(1).DefaultBackgroundColor);
        err_h = ...
          errordlg({'Turning off C-T >> D-T Link'; ...
                    ' '; ...
                    '    Click "OK" to continue ...';' '}, ...
                   'Link Status Alert','modal');
        uiwait(err_h)
        figure(DT_PZGUI);
      else
        % The D-T model is linked from the C-T model.
        % The user changed the sample-period, but the change was made
        % in the D-T GUI.
        if ~isempty(gcbo) && ~isempty(strfind( CallbackStr,'UNDO')) ...
          && isfield(PZG(2),'undo_info') && ~isempty(PZG(2).undo_info)
          undo_info = PZG(2).undo_info{end};
          Ts = PZG(2).Ts;
          if ~isequal( Ts, undo_info.Ts )
            PZG(2).undo_info(end) = [];
            PZG(2).PoleLocs = undo_info.PoleLocs;
            PZG(2).ZeroLocs = undo_info.ZeroLocs;
            PZG(2).Gain = undo_info.Gain;
            PZG(2).Ts = undo_info.Ts;
            PZG(2).PureDelay = undo_info.PureDelay;
            PZG(2).DCgain = undo_info.DCgain;
            Ts = PZG(2).Ts;
            if ~isfield(PZG(2),'redo_info')
              PZG(2).redo_info = {};
            end
            PZG(2).redo_info{end+1} = undo_info;
          end
        else
          if ~isempty(gco0) && strcmp('uicontrol',get(gco0,'type'))
            Ts = str2double( get(gco0,'String') );
            if isempty(Ts) || isnan(Ts) || isinf(Ts) || ( Ts <= 0 )
              Ts = PZG(2).Ts;
            end
          else
            Ts = PZG(2).Ts;
          end
          if ( numel(Ts) ~= 1 ) || ~isreal(Ts) ...
            || ( Ts <= 0 ) || isinf(Ts) || isnan(Ts) ...
            || isequal( Ts, PZG(2).Ts )
            %Ts = PZG(2).Ts;
            set( tempDT(13,2),'String', pzg_efmt(PZG(2).Ts) );
            return
          elseif ~isequal( Ts, PZG(1).Ts )
            save_undo_info(1);
            save_undo_info(2);
            PZG(1).Ts = Ts;
            PZG(2).Ts = Ts;
            set( tempDT(13,2),'String', pzg_efmt(PZG(2).Ts) );
            set( tempCT(13,2),'String', pzg_efmt(PZG(2).Ts) );
          else
            return
          end
        end
        if ~isempty(gcbo) && ~isequal( get(gcbo,'string'),'Undo')
          msgbox_h = ...
            msgbox( ...
              {'The D-T model is being recomputed from the C-T model,'; ...
               'based on the new sample-period you entered,'; ...
               'because the "D-T Link" checkbox is selected.'; ...
               ' ';'      Click "OK" to continue.'}, ...
              'Recomputing D-T Model','modal');
          uiwait(msgbox_h)
        end
        PZG(1).Ts = Ts;
        PZG(2).Ts = Ts;
        if get( tempCT(14,2),'Value')
          PZG(1).recompute_frf = 0;
          pzg_cntr(1);
          pzg_bodex(1);
        end
        noCalls = 0;
        pzgui;
        updatepl
        pzg_grid;
      end
    end
  end
end

fixdc_h = pzg_fndo( M, M+11,'Fix_DC_checkbox');

if ~isempty( strfind( CallbackStr,'Erase') )
  PZG(1).pzg_show_frf_computation = 0;
  PZG(2).pzg_show_frf_computation = 0;
  box_h = ...
    [ pzg_fndo(1,[10;12],'pzgbox'); ...
      pzg_fndo(2,[11;13],'pzgbox') ];
  if ~isempty(box_h)
    set( box_h,'visible','off');
  end
  updtpzln('s');
  pzg_seltxt( 1, [], [], 0 )
  updtpzln('z');
  pzg_seltxt( 2, [], [], 0 )
  if isfield( PZG(1),'frcomp_fig') ...
    && ~isempty( PZG(1).frcomp_fig ) ...
    && isequal( 1, ishandle(PZG(1).frcomp_fig) )
    delete(PZG(1).frcomp_fig)
  end
  PZG(1).frcomp_fig = [];

  temp = [ pzg_fndo( (1:2), 6,'CL_0dB_contour'); ...
           pzg_fndo( (1:2), 6,'LeadLag_Text') ];
  if ~isempty(temp)
    set(temp,'visible','off')
  end
  temp = ...
    [ pzg_fndo( (1:2),(6:7),'implicit_freq_marker'); ...
      pzg_fndo( (1:2),(1:14),'Bode_selection_marker') ];
  if ~isempty(temp)
    set( temp,'visible','off');
  end
  
  tempRL = pzg_fndo( 1, 10,'fig_h');
  if ~isempty(tempRL)
     RLct_temp0 = get(tempRL,'UserData');
     if ( size(RLct_temp0,1) >= 6 ) && ( size(RLct_temp0,2) > 1 )
        for k = 1:6
          if ishandle(RLct_temp0(k,2)) && ~isempty(RLct_temp0(k,2)) ...
            && ~isequal( RLct_temp0(k,2), 0 ) ...
            && ~strcmp( get(RLct_temp0(k,2),'type'),'root') ...
            &&( ~isnumeric(RLct_temp0) || ( RLct_temp0(k,2) > 0 ) )
            set( RLct_temp0(k,2),'visible','off')
          end
        end
     end
  end
     
  tempRL = pzg_fndo( 2, 11,'fig_h');
  if ~isempty(tempRL)
    RLdt_temp0 = get(tempRL,'UserData');
    if ( size(RLdt_temp0,1) >= 6 ) && ( size(RLdt_temp0,2) > 1 )
      for k = 1:6
        if ~isempty(RLdt_temp0(k,2)) ...
          && isequal( 1, ishandle(RLdt_temp0(k,2)) ) ...
          &&( ~isnumeric(RLdt_temp0) || ( RLdt_temp0(k,2) > 0 ) ) ...
          && ~strcmp( get(RLdt_temp0(k,2),'type'),'root')
          set( RLdt_temp0(k,2),'visible','off')
        end
      end
    end
  end
   
  freqserv('deselect frequency');
   
  Calls = 1;
  return

elseif ~isempty( strfind( CallbackStr,'Set PureDelay') )
  temp = str2double( get(gco0,'String') );
  if numel(temp) == 1
    if temp >= 0
      if M == 1
        if ~isequal( PZG(M).PureDelay, temp )
          save_undo_info(M)
          PZG(M).recompute_frf = 1;
        end
        PZG(M).PureDelay = temp;
        set( gco0, 'String', pzg_efmt( PZG(M).PureDelay) );
      elseif round(temp) == temp
        if ~isequal( PZG(M).PureDelay, temp )
          save_undo_info(M)
          PZG(M).recompute_frf = 1;
        end
        PZG(M).PureDelay = temp;
        curr_tools = pzg_tools(M);
        if curr_tools(2)
          ldlgfilt('z-Domain Lead Lag Design GUI');
        end
        if curr_tools(3)
          ldlgfilt('z-Domain PID Design GUI');
        end
        set( gco0, 'String', pzg_efmt( PZG(M).PureDelay) );
      else
        errdlg_h = errordlg( ...
                 {'Delay must be integer # samples.'; ...
                  ' ';'    Click "OK" to continue ...'}, ...
                 'REQUIRES INTEGER DELAY','modal');
        uiwait(errdlg_h)
        set( gco0, 'String', pzg_efmt( PZG(M).PureDelay) );
        return
      end
    else
      errdlg_h = errordlg({'Negative delay is not allowed.'; ...
                           ' ';'    Click "OK" to continue ...'}, ...
               'REQUIRES NON-NEGATIVE DELAY','modal');
      uiwait(errdlg_h)
      set( gco0, 'String', pzg_efmt( PZG(M).PureDelay) );
      return
    end
    pzg_prvw(M);
  else
    set( gco0, 'String', pzg_efmt( PZG(M).PureDelay) );
    return
  end
  
elseif ~isempty( strfind( CallbackStr,'Set Gain') )
  gainStr = get(gco0,'String');
  temp = str2num(lower(gainStr)); %#ok<ST2NM>
  if isempty(temp)
    gainStr = strtrim(gainStr);
    sp_ndx = strfind( gainStr,' ');
    if ~isempty(sp_ndx)
      gainStr = gainStr(1:sp_ndx(1)-1);
    end
  end
  if isempty( temp ) && ~isempty(gainStr) ...
    && evalin('base',['exist(''' gainStr ''',''var'')'])
    evalin('base',['temp_pzgsg = ' gainStr ';'] )
    evalin('base','assignin(''caller'',''temp'', temp_pzgsg );')
    if ~isreal(temp)
      temp = [];
    end
  end
  if ( numel(temp) == 1 ) && isreal(temp) ...
    && ~isinf(temp) && ~isnan(temp) && ( temp ~= 0 )
    if ~isequal( PZG(M).Gain, temp )
      save_undo_info(M);
      PZG(M).recompute_frf = 1;
    end
    old_gain = PZG(M).Gain;
    new_gain = temp;
    PZG(M).Gain = temp;
    set( gco0,'String', pzg_efmt(PZG(M).Gain) );

    if ~isempty(fixdc_h) && get( fixdc_h,'value') ...
      && ~isempty(PZG(M).DCgain) ...
      && ~isnan(old_gain) && ~isinf(old_gain) && ( old_gain ~= 0 ) ...
      && ~isnan(new_gain) && ~isinf(new_gain) && ( new_gain ~= 0 )
      PZG(M).DCgain = PZG(M).DCgain / old_gain * new_gain;
    end
    
  else
    errdlg_h = ...
      errordlg( ...
      {'Unable to parse the entry into a valid gain value.'; ...
       ' '; ...
       'The gain must be a finite real-valued nonzero scalar number.'; ...
       ' ';'You may enter either a real scalar numeric value, or the'; ...
       ['name of a real-valued scalar numeric ' ...
        'variable in the Matlab workspace.']; ...
       ' ';'    Click "OK" to continue ...'}, ...
      'PZGUI Error','modal');
    uiwait(errdlg_h)
    set( gco0,'String', pzg_efmt(PZG(M).Gain) );
    return
  end

elseif ~isempty( strfind( CallbackStr,'Set TS') )
  set_ts_h = pzg_fndo( M, (12:13),'pzgui_Set_TS');
  if ~isempty(gco0) && any( set_ts_h == gco0 )
    Ts = str2num( get(gco0,'String') ); %#ok<ST2NM>
    if ( numel(Ts) ~= 1 ) || ~isreal(Ts) || ( Ts <= 0 ) ...
      || isinf(Ts) || isnan(Ts) ...
      || isequal( Ts, PZG(2).Ts )
      set( gco0,'String', pzg_efmt(PZG(2).Ts) );
      return
    end
    old_Ts = PZG(2).Ts;
    if old_Ts == Ts
      return
    end
    % Adjust the final time of any D-T time-response plots that are open.
    % If the plots are linked, don't make this adjustment.
    if ~pzg_islink(1) && ~pzg_islink(2)
      for ploth_ndx = 8:9
        if isempty(PZG(2).plot_h{ploth_ndx}) ...
          || ~isfield( PZG(2).plot_h{ploth_ndx},'fig_h')
          continue
        end
        respax_h = pzg_fndo( 2, ploth_ndx,'ax_h');
        maxtime_h = pzg_fndo( 2, ploth_ndx,'pzgui_resppl_max_tme_edit');
        ss_h = pzg_fndo( 2, ploth_ndx,'pzgui_resppl_steadystate_only_checkbox');
        finaltime = str2double( get(maxtime_h,'string') );
        new_finaltime = ( finaltime/old_Ts ) * Ts;
        set( maxtime_h,'string', num2str(new_finaltime) );
        % Determine if steady-state is being shown.
        if ~get(ss_h,'value') || strcmp( get(ss_h,'visible'),'off')
          ax_xlim = get( respax_h,'xlim');
          ax_xlim = ax_xlim / old_Ts * Ts;
          set( respax_h,'xlim', ax_xlim );
        else
          set( respax_h,'xlimmode','auto');
          ax_xlim = get( respax_h,'xlim');
        end
        PZG(2).plot_h{ploth_ndx}.xlim = ax_xlim;
        PZG(2).plot_h{ploth_ndx}.hndl.ax_xlim = ax_xlim;
        temp_hndl = getappdata( PZG(2).plot_h{ploth_ndx}.fig_h,'hndl');
        temp_hndl.ax_xlim = ax_xlim;
        setappdata( PZG(2).plot_h{ploth_ndx}.fig_h,'hndl', temp_hndl );
      end
    end
    
  else
    Ts = PZG(2).Ts;
  end
  if numel(Ts) == 1
    if ~isequal( Ts, PZG(2).Ts ) || ~isequal( Ts, PZG(1).Ts )
      save_undo_info(1)
      save_undo_info(2)
      set( gco0,'String', pzg_efmt(Ts) );
      PZG(1).Ts = Ts;
      PZG(2).Ts = Ts;
      if ~isempty(set_ts_h)
        set( set_ts_h,'String', pzg_efmt(Ts) );
      end
      
      linked = get( temp0(14,2),'value');
      pzg_cntr(2);
      pzg_bodex(2);
      PZG(2).recompute_frf = 0;
      if linked
        if isequal( gcbf, CT_PZGUI )
          updatepl;
          dpzgui;
          dupdatep;
        elseif isequal( gcbf, DT_PZGUI )
          dupdatep;
          pzgui;
          updatepl;
        end
      else
        if isfield(PZG(2),'plot_h') && iscell(PZG(2).plot_h)
          for k = 1:numel(PZG(2).plot_h)
            if ( k == 10 ) || ( k == 12 )
              % Don't test for existence of C-T p/z maps.
              continue
            end
            if ~isempty(PZG(2).plot_h{k}) ...
              && isstruct( PZG(2).plot_h{k} ) ...
              && isfield( PZG(2).plot_h{k},'fig_h') ...
              && isequal( 1, ishandle( PZG(2).plot_h{k}.fig_h ) )
              dpzgui;
              dupdatep
              break
            end
          end
        end
      end
      if ~isempty(CT_PZGUI)
        tempCT = get(CT_PZGUI,'UserData');
        pzg_grid( tempCT, CT_PZGUI, PZG(1).plot_h{12}.ax_h, 12 );
      end
      ctrloc_h = pzg_fndo( 1, 10,'fig_h');
      if ~isempty(ctrloc_h)
        temp0_10 = get( ctrloc_h,'userdata');
        pzg_grid( temp0_10, ctrloc_h, PZG(1).plot_h{10}.ax_h, 10 );
      end
      
      PZG(2).NyqSelNdx = [];
      freqserv('deselect frequency');
    else
      return
    end
    if Domain(1) == 'z'
      ldlgfilt('z', 1 );
      pidfilt('z', 1 );
    end
    DFreqs = pi/Ts;
    PZs = sort([PZG(2).PoleLocs;PZG(2).CLPoleLocs; ...
                PZG(2).ZeroLocs;PZG(2).CLZeroLocs] );
    if ~isempty( PZs )
      for Xk = numel(PZs):-1:1
        if PZs(Xk) == 0
          PZs(Xk) = [];
        end
      end
    end
    if ~isempty( PZs )
      z2sPZs = log( PZs ) / Ts;
      z2sFreqs = sort( abs(z2sPZs) );
      temp = 1;
      while temp == 1
        if z2sFreqs(1) < 1000 * eps
          z2sFreqs(1) = [];
        else
          temp = 0;
        end
        if isempty(z2sFreqs)
          DFreqs(2) = pi/2000/Ts;
          break
        else
          DFreqs(2) = z2sFreqs(1);
        end
      end
    else
      DFreqs(2) = pi/2000/Ts;
    end
    DFreqs(2) = min( DFreqs(2), DFreqs(1)/1e5 );
    LowEnd = floor( log10( DFreqs(2) ) ) + 0.001;
    LowEnd = min( LowEnd, log10( 2*pi*1e-5/Ts ) );
    HighEnd = log10( DFreqs(1) );
    if isempty(PZG(2).TFEFreqs) && isempty(PZG(2).BodeFreqs)
       PZG(2).BodeFreqs = logspace( LowEnd,HighEnd, 4000*ceil(HighEnd-LowEnd))';
       PZG(2).BodeFreqs = ...
         [ PZG(2).BodeFreqs; 2*pi/Ts-flipud(PZG(2).BodeFreqs); ...
           2*pi/Ts+PZG(2).BodeFreqs; 4*pi/Ts-flipud(PZG(2).BodeFreqs) ];
    else
      if size( PZG(2).TFEFreqs, 2 ) > size( PZG(2).TFEFreqs, 1 )
        PZG(2).TFEFreqs = PZG(2).TFEFreqs';
      end
      if isempty(PZG(2).BodeFreqs) && ~isempty(PZG(2).TFEFreqs)
        PZG(2).BodeFreqs = PZG(2).TFEFreqs;
      end
    end
    if numel(PZG(2).CLBodeFreqs) ~= numel(PZG(2).BodeFreqs)
      PZG(2).CLBodeFreqs = PZG(2).BodeFreqs;
    end
    if numel(PZG(2).BodeMag) ~= numel(PZG(2).BodeFreqs)
      PZG(M).recompute_frf = 1;
    end
    if numel(PZG(2).CLBodeMag) ~= numel(PZG(2).CLBodeFreqs)
      PZG(M).recompute_frf = 1;
    end
    if numel(PZG(2).BodePhs) ~= numel(PZG(2).BodeFreqs)
      PZG(M).recompute_frf = 1;
    end
    if numel(PZG(2).CLBodePhs) ~= numel(PZG(2).CLBodeFreqs)
      PZG(M).recompute_frf = 1;
    end
    
    TsStr = pzg_efmt(Ts);
    if ishandle(gco0) && any( set_ts_h == gco0 )
      set( gco0,'String',TsStr );
    end
    if ~isempty( DT_PZGUI )
      set( tempDT(13,2),'String',TsStr )
    end
    if ~isempty( CT_PZGUI )
      set( tempCT(13,2),'String',TsStr )
    end
    
    if ~isempty(CT_PZGUI)
      tempCT = get(CT_PZGUI,'UserData');
      pzg_grid( tempCT, CT_PZGUI, PZG(1).plot_h{12}.ax_h, 12 );
    end
    ctrloc_h = pzg_fndo( 1, 10,'fig_h');
    if ~isempty(ctrloc_h)
      temp0_10 = get( ctrloc_h,'userdata');
      pzg_grid( temp0_10, ctrloc_h, PZG(1).plot_h{10}.ax_h, 10 );
    end
  else
    set( gco0,'String', pzg_efmt(PZG(M).Ts) );
    return
  end

elseif ~isempty( strfind( CallbackStr,'DeletePole') )
  DPNdx = get( temp0(7,2),'Value' );
  if isempty(DPNdx) || ( DPNdx == 0 )
    set( temp0(7,2),'Value',1 );
    return
  end
  if isempty(PZG(M).PoleLocs)
    PZG(M).PoleLocs = [];    
    deleted_poles = [];
  elseif DPNdx > numel(PZG(M).PoleLocs)
    % Delete all poles.
    save_undo_info(M);
    deleted_poles = PZG(M).PoleLocs;
    PZG(M).PoleLocs = [];
    PZG(M).recompute_frf = 1;
  elseif imag( PZG(M).PoleLocs(DPNdx) ) == 0
    save_undo_info(M);
    deleted_poles = PZG(M).PoleLocs(DPNdx);
    PZG(M).PoleLocs(DPNdx) = [];
    PZG(M).recompute_frf = 1;
  else
    [temp,tempNdx] = ...
      max( abs(conj(PZG(M).PoleLocs(DPNdx)) - PZG(M).PoleLocs ) ...
          < 1e-14*abs(PZG(M).PoleLocs(DPNdx)) ); %#ok<ASGLU>
    deleted_poles = PZG(M).PoleLocs([DPNdx;tempNdx]);
    if tempNdx > DPNdx
      save_undo_info(M);
      PZG(M).PoleLocs(tempNdx) = [];
      PZG(M).PoleLocs(DPNdx) = [];
      PZG(M).recompute_frf = 1;
    else
      save_undo_info(M);
      PZG(M).PoleLocs(DPNdx) = [];
      PZG(M).PoleLocs(tempNdx) = [];
      PZG(M).recompute_frf = 1;
    end
  end
  
  if ~isempty(fixdc_h) && get( fixdc_h,'value')
    for k = 1:numel(deleted_poles)
      if ( M == 1 ) && ( abs(deleted_poles(k)) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain / abs(deleted_poles(k));
        if isreal(deleted_poles(k)) && ( deleted_poles(k) > 0 )
          PZG(M).Gain = -PZG(M).Gain;
        end
      elseif ( M == 2 ) && ( abs(deleted_poles(k)-1) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain / abs(deleted_poles(k)-1);
        if isreal(deleted_poles(k)) && ( deleted_poles(k) > 1 )
          PZG(M).Gain = -PZG(M).Gain;
        end
      end
    end
  end

  if isempty( PZG(M).PoleLocs )
    set( temp0(7,2),'Value',1,'String','ALL POLES');
  end
  
elseif ~isempty( strfind( CallbackStr,'DeleteZero') )
  if isempty(PZG(M).ZeroLocs)
    err_h = ...
      errordlg({'There is no zero to delete.'; ...
                ' ';'    Click "OK" to continue ...';' '}, ...
               'No Zero is Defined','modal');
    uiwait(err_h)
    return
  end
  DZNdx = get(temp0(8,2),'Value');
  if isempty(DZNdx) || ( DZNdx == 0 )
    set( temp0(8,2),'Value',1 );
    return
  end

  if isempty(PZG(M).ZeroLocs)
    PZG(M).ZeroLocs = [];
    deleted_zeros = [];
  elseif DZNdx > numel(PZG(M).ZeroLocs)
    % Delete all zeros.
    save_undo_info(M);
    deleted_zeros = PZG(M).ZeroLocs;
    PZG(M).ZeroLocs = [];
    PZG(M).recompute_frf = 1;
  elseif imag( PZG(M).ZeroLocs(DZNdx) ) == 0
    save_undo_info(M);
    deleted_zeros = PZG(M).ZeroLocs(DZNdx);
    PZG(M).ZeroLocs(DZNdx)=[];
    PZG(M).recompute_frf = 1;
  else
    [temp,tempNdx] = ...
      max( abs(conj(PZG(M).ZeroLocs(DZNdx)) - PZG(M).ZeroLocs ) ...
           < 1e-14*abs(PZG(M).ZeroLocs(DZNdx)) ); %#ok<ASGLU>
    deleted_zeros = PZG(M).ZeroLocs([DZNdx;tempNdx]);
    if tempNdx > DZNdx
      save_undo_info(M);
      PZG(M).ZeroLocs(tempNdx) = [];
      PZG(M).ZeroLocs(DZNdx) = [];
      PZG(M).recompute_frf = 1;
    else
      save_undo_info(M);
      PZG(M).ZeroLocs(DZNdx) = [];
      PZG(M).ZeroLocs(tempNdx) = [];
      PZG(M).recompute_frf = 1;
    end
  end

  if ~isempty(fixdc_h) && get( fixdc_h,'value')
    for k = 1:numel(deleted_zeros)
      if ( M == 1 ) && ( abs(deleted_zeros(k)) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain * abs(deleted_zeros(k));
      elseif ( M == 2 ) && ( abs(deleted_zeros(k)-1) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain * abs(deleted_zeros(k)-1);
      end
    end
  end
  
  if isempty( PZG(M).ZeroLocs )
    PZG(M).ZeroLocs = [];
    set( temp0(8,2),'Value',1,'String','ALL ZEROS');
  end

elseif ~isempty( strfind( CallbackStr,'AddPole') )
  tempStr = get( temp0(11,2),'String');
  if isempty(tempStr)
    errdlg_h = ...
      errordlg( ...
        {'You must specify where a pole is to be added.'; ...
         'Enter that information just below the "Add" button you clicked.'; ...
         ' '; ...
         'To specify the location (or locations), enter:'; ...
         '      one or more numerical values,'; ...
         ' OR'; ...
         '     a mathematical expression Matlab can evaluate,'; ...
         ' OR'; ...
         '     the name of a numeric variable in the Matlab workspace.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Advisory','modal');
    uiwait(errdlg_h)
    return
  end
  if ( ~isempty( strfind( tempStr,'+i') ) ...
      ||~isempty( strfind( tempStr,'-i') ) ...
      ||~isempty( strfind( tempStr,'+j') ) ...
      ||~isempty( strfind( tempStr,'-j') ) ) ...
    &&( ( tempStr(end) == 'i') ...
       ||( tempStr(end) == 'j') )
    if numel( tempStr ) == 1
      if isequal( tempStr,'i') || isequal( tempStr,'j')
        tempStr = '1i';
      end
    else
      tempStr = [ tempStr(1:end-1) '1i'];
    end
  end
  tempVal = str2num(tempStr); %#ok<ST2NM>
  if isempty(tempVal)
    tempVal = str2num(lower(tempStr)); %#ok<ST2NM>
  end
  if isempty(tempVal) && ~isempty(tempStr) ...
    && isempty( strfind(tempStr,'-') ) ...
    && isempty( strfind(tempStr,'+') )
    tempStr = strtrim(tempStr);
    sp_ndx = strfind(tempStr,' ');
    if ~isempty(sp_ndx) && ( sp_ndx(1) > 1 )
      tempStr = tempStr(1:sp_ndx(1)-1);
    end
    if evalin('base',['exist(''' tempStr ''',''var'')'])
      evalin('base',['temp_val = ' tempStr ';'] )
      evalin('base','assignin(''caller'',''tempVal'', temp_val );')
      evalin('base','clear temp_val')
    end
  end
  if isempty(tempVal) || ~isnumeric(tempVal) ...
    || any( isinf(tempVal(:)) ) || any( isnan(tempVal(:)) )
    errdlg_h = ...
      errordlg( ...
        {'Unable to interpret the text entry into valid pole locations.'; ...
         'Pole locations must be finite and numeric.'; ...
         ' '; ...
         'To specify the location (or locations), enter:'; ...
         '      one or more numeric values,'; ...
         ' OR'; ...
         '     a mathematical expression Matlab can evaluate,'; ...
         ' OR'; ...
         '     the name of a numeric variable in the Matlab workspace.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Input Error','modal');
    uiwait(errdlg_h)
    return
  end
  tempVal = tempVal(:);
  
  added_poles = [];
  if nargin == 1
    set( temp0(11,2),'String',tempStr );
    save_undo_info(M);
    PZG(M).recompute_frf = 1;
    if abs( imag(tempVal) ) <= abs( real(tempVal) )*100*eps
      PZG(M).PoleLocs = [ real(tempVal); PZG(M).PoleLocs ];
      added_poles = real(tempVal);
    elseif abs(imag(tempVal)) > 0
      PZG(M).PoleLocs = [ tempVal; conj(tempVal); PZG(M).PoleLocs ];
      added_poles = [ tempVal; conj(tempVal) ];
    end
    
    if numel(tempVal) == 1
      if M == 1
        if ( abs(real(tempVal)) < 1e-4 ) ...
          ||( abs(imag(tempVal)) < 1e-4 )
          if isreal(tempVal)
            set( temp0(11,2),'String',num2str(tempVal,10) );
          else
            set( temp0(11,2),'String',num2str(tempVal,9) );
          end
        else
          set( temp0(11,2),'String',num2str(tempVal,7) );
        end
      else
        if ( abs( -1 - tempVal ) < 1e-4 ) ...
          ||( abs( 1 - tempVal ) < 1e-4 )
          if isreal(tempVal)
            set( temp0(11,2),'String',num2str(tempVal,10) );
          else
            set( temp0(11,2),'String',num2str(tempVal,9) );
          end
        else
          set( temp0(11,2),'String',num2str(tempVal,7) );
        end
      end
    end
    
  elseif nargin == 2
    if isempty(tempVal)
      set( temp0(11,2),'String','')
    end
    if ischar(AddPZ)
      errdlg_h = ...
        errordlg({['The variable ' tempStr ...
          ' must be numerical, not a string.']; ...
          ' ';'    Click "OK" to continue ...'; ...
          ' ';'    Click "OK" to continue ...'}, ...
          'CAN ONLY PROCESS A NUMERICAL VECTOR','modal');
      uiwait(errdlg_h)
      return
    elseif ~isnumeric(AddPZ)
      errdlg_h = ...
        errordlg( ...
          {['The variable ''' tempStr ''' must be a numerical vector']; ...
           'in order to be processed into a set of pole locations.'; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'CAN ONLY PROCESS A NUMERICAL VECTOR','modal');
      uiwait(errdlg_h)
      return
    end
    if ( min(size(AddPZ)) ~= 1 )
      errdlg_h = ...
        errordlg({['The variable ''' tempStr ...
           ''' must be a row or column vector.']; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'CAN ONLY PROCESS A 1-D VECTOR','modal');
      uiwait(errdlg_h)
      return
    end
    for k = numel(AddPZ):-1:2
      this_pole = AddPZ(k);
      if ~isnan( this_pole) && ( imag(this_pole) ~= 0 )
        conjndx = ...
          find( abs( AddPZ(1:k-1)-conj(this_pole)) ...
               /max(1,abs(this_pole)) < 1e-14 );
        if ~isempty(conjndx)
          AddPZ(conjndx(1)) = NaN;
        end
      end
    end
    AddPZ( isnan(AddPZ) ) = [];
    
    tempVec = AddPZ;
    save_undo_info(M);
    added_poles = [];
    PZG(M).recompute_frf = 1;
    for Ck = 1:numel(tempVec)
      if abs( imag(AddPZ(Ck)) ) ...
        < max( abs( real(AddPZ(Ck)) )*100*eps, 100*eps )
        PZG(M).PoleLocs = [ real( AddPZ(Ck) ); PZG(M).PoleLocs ];
        added_poles(end+1) = real( AddPZ(Ck) ); %#ok<AGROW>
      elseif imag( AddPZ(Ck) ) > 0
        PZG(M).PoleLocs = [ AddPZ(Ck); conj(AddPZ(Ck)); PZG(M).PoleLocs ];
        added_poles(end+1) = AddPZ(Ck); %#ok<AGROW>
        added_poles(end+1) = conj(AddPZ(Ck)); %#ok<AGROW>
      elseif imag( AddPZ(Ck) ) < 0
        PZG(M).PoleLocs = [ conj(AddPZ(Ck)); AddPZ(Ck); PZG(M).PoleLocs ];
        added_poles(end+1) = conj(AddPZ(Ck)); %#ok<AGROW>
        added_poles(end+1) = AddPZ(Ck); %#ok<AGROW>
      end
    end
  else
    if ~isempty( strfind( tempStr,'+') ) ...
      ||~isempty( strfind( tempStr,'-') ) ...
      ||( tempStr(end) == 'i' ) || ( tempStr(end) == 'j' )
      errdlg_h = errordlg({['The numeric format is incorrect.' ...
                '  Example of correct format:  3+1i']; ...
                ' ';'    Click "OK" to continue ...'}, ...
                'CAN''T PARSE THE NUMBER','modal');
      uiwait(errdlg_h)
      return
    else
      errdlg_h = errordlg({['No variable named ' tempStr ' is'...
                ' defined in the MATLAB workspace.']; ...
                ' ';'    Click "OK" to continue ...'}, ...
                'UNDEFINED VARIABLE','modal');
      uiwait(errdlg_h)
      return
    end
  end
  
  if ~isempty(fixdc_h) && get( fixdc_h,'value')
    for k = 1:numel(added_poles)
      if ( M == 1 ) && ( abs(added_poles(k)) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain * abs(added_poles(k));
        if isreal(added_poles(k)) && ( added_poles(k) > 0 )
          PZG(M).Gain = -PZG(M).Gain;
        end
      elseif ( M == 2 ) && ( abs(added_poles(k)-1) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain * abs(added_poles(k)-1);
        if isreal(added_poles(k)) && ( added_poles(k) > 1 )
          PZG(M).Gain = -PZG(M).Gain;
        end
      end
    end
  end
  
elseif ~isempty( strfind( CallbackStr,'MovePole') )
  if isempty( PZG(M).PoleLocs )
    errdlg_h = ...
      errordlg( ...
        {'There are no poles currently defined in the model.'; ...
         ' '; ...
         'Use the "Add" button to define one or more poles.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Advisory','modal');
    uiwait(errdlg_h)
    return
  end
  tempStr = get( temp0(11,2),'String');
  if isempty( tempStr )
    errdlg_h = ...
      errordlg( ...
        {'You haven''t specified a location to move the selected pole.'; ...
         'Enter that information just below the "Move" button you clicked.'; ...
         ' ';'To specify the location, enter:'; ...
         '      a numerical value,'; ...
         ' OR'; ...
         '     a mathematical expression Matlab can evaluate,'; ...
         ' OR'; ...
         '     the name of a numeric variable in the Matlab workspace.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Advisory','modal');
    uiwait(errdlg_h)
    return
  end
  if ( ~isempty( strfind( lower(tempStr), '+i' ) ) ...
      ||~isempty( strfind( lower(tempStr), '-i' ) ) ...
      ||~isempty( strfind( lower(tempStr), '+j' ) ) ...
      ||~isempty( strfind( lower(tempStr), '-j' ) ) ) ...
    &&( ( lower(tempStr(end)) == 'i' ) ...
       ||( lower(tempStr(end)) == 'j' ) )
    if numel( tempStr ) == 1
      if ( lower(tempStr) == 'i' ) || ( lower(tempStr) == 'j' )
        tempStr = '1i';
      end
    else
      tempStr = [ tempStr(1:end-1) '1i'];
    end
  end
  if nargin == 2
    tempVal = AddPZ;
    if isnumeric(tempVal) && ~isempty(tempVal)
      tempVal = tempVal(1);
    else
      tempVal = [];
    end
    if ( numel(tempVal) ~= 1 ) || isinf(tempVal) || isnan(tempVal)
      errdlg_h = ...
        errordlg( ...
          {['Variable ''' tempStr ''' must be a finite numeric scalar,']; ...
           ['in order to use it as a ' ...
             'location to move the selected pole.']; ...
             ' ';'    Click "OK" to continue ...'}, ...
          'Error during pole move ...','modal');
      uiwait(errdlg_h)
      return
    end
  else
    tempVal = str2num(tempStr); %#ok<ST2NM>
    if isempty(tempVal)
      tempVal = str2num(lower(tempStr)); %#ok<ST2NM>
    end
    if isempty(tempVal) && ~isempty(tempStr) ...
      && isempty( strfind(tempStr,'-') ) ...
      && isempty( strfind(tempStr,'+') )
      if evalin('base',['exist(''' tempStr ''',''var'')'])
        evalin('base',['temp_val = ' tempStr ';'] )
        evalin('base','assignin(''caller'',''tempVal'', temp_val );')
        evalin('base','clear temp_val')
      %elseif evalin('base',['~isempty(' tempStr ')'])
      %  evalin('base',['temp_val = ' tempStr ';'] )
      %  evalin('base','assignin(''caller'',''tempVal'', temp_val );')
      %  evalin('base','clear temp_val')
      end
    else
      tempVal = str2num(lower(tempStr)); %#ok<ST2NM>
    end
  end
  if ~isequal( numel(tempVal), 1 ) || ~isnumeric(tempVal) ...
    || any( isinf(tempVal(:)) ) || any( isnan(tempVal(:)) )
    errdlg_h = ...
      errordlg( ...
        {'Unable to interpret the text entry into a valid pole'; ...
         'location.  The pole location must be finite and numeric.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Input Error','modal');
    uiwait(errdlg_h)
    return
  end
  if numel(tempVal) == 1
    set( temp0(11,2),'String',tempStr );
    % Determine which pole is selected.
    SelectNdx = get( temp0(7,2),'Value');
    if ( numel( PZG(M).PoleLocs ) == 1 ) ...
      ||( ( numel( PZG(M).PoleLocs ) == 2 ) ...
         && ~isreal(PZG(M).PoleLocs(1)) ...
         &&( abs( PZG(M).PoleLocs(2) - conj(PZG(M).PoleLocs(1) ) ) <1e-14 ) )
      set( temp0(7,2),'Value', 1 );
      SelectNdx = 1;
    end
    if SelectNdx > numel( PZG(M).PoleLocs )
      errdlg_h = ...
        errordlg( ...
          {'No individual pole is selected.'; ...
           ' ';'Poles may be moved only one-at-a-time,'; ...
           'or as a complex-conjugate pair.'; ...
           ' '; ...
           'From the menu just above the "Move" button you clicked,'; ...
           'select one of the poles in the list.'; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'Error during pole move ...','modal');
      uiwait(errdlg_h)
      return
    else
      if isreal( PZG(M).PoleLocs(SelectNdx) ) && isreal(tempVal)
        if ~isequal( PZG(M).PoleLocs(SelectNdx), tempVal )
          save_undo_info(M);
          PZG(M).recompute_frf = 1;
        end
        new_poles = tempVal;
        old_poles = PZG(M).PoleLocs(SelectNdx);
        PZG(M).PoleLocs(SelectNdx) = tempVal;
      elseif ~isreal( PZG(M).PoleLocs(SelectNdx) ) && ~isreal(tempVal)
        SelectNdx2 = ...
          find( PZG(M).PoleLocs == conj(PZG(M).PoleLocs(SelectNdx)) );
        if ~isempty(SelectNdx2)
          SelectNdx2 = SelectNdx2(1);
          if ~isequal( PZG(M).PoleLocs(SelectNdx2), tempVal ) ...
            &&~isequal( PZG(M).PoleLocs(SelectNdx2), conj(tempVal) )
            save_undo_info(M);
            PZG(M).recompute_frf = 1;
          end
          new_poles = [ tempVal; conj(tempVal) ];
          old_poles = ...
            [ PZG(M).PoleLocs(SelectNdx); PZG(M).PoleLocs(SelectNdx2) ];
          PZG(M).PoleLocs(SelectNdx) = tempVal;
          PZG(M).PoleLocs(SelectNdx2) = conj(tempVal);
        else
          errdlg_h = errordlg({'Can''t find complex conjugate pole.'; ...
                               ' ';'    Click "OK" to continue ...'}, ...
                              'Error during pole move ...','modal');
          uiwait(errdlg_h)
          return
        end
      elseif isreal(tempVal)
        errdlg_h = errordlg({'Can''t change complex pole to real pole.'; ...
                               ' ';'    Click "OK" to continue ...'}, ...
                            'Error during pole move ...','modal');
        uiwait(errdlg_h)
        return
      else
        errdlg_h = errordlg({'Can''t change real pole to complex pole.'; ...
                               ' ';'    Click "OK" to continue ...'}, ...
                            'Error during pole move ...','modal');
        uiwait(errdlg_h)
        return
      end
    end
    
    if ~isempty(fixdc_h) && get( fixdc_h,'value')
      for k = 1:numel(old_poles)
        if ( M == 1 ) && ( abs(old_poles(k)) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain / abs(old_poles(k));
        elseif ( M == 2 ) && ( abs(old_poles(k)-1) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain / abs(old_poles(k)-1);
        end
        if ( M == 1 ) && ( abs(new_poles(k)) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain * abs(new_poles(k));
        elseif ( M == 2 ) && ( abs(new_poles(k)-1) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain * abs(new_poles(k)-1);
        end
        if M == 1
          if isreal(old_poles(k)) && isreal(new_poles(k)) ...
            &&( ( ( old_poles(k) <= 0 ) && ( new_poles(k) > 0 ) ) ...
               ||( ( old_poles(k) > 0 ) && ( new_poles(k) <= 0 ) ) )
            PZG(M).Gain = -PZG(M).Gain;
          end
        else
          if isreal(old_poles(k)) && isreal(new_poles(k)) ...
            &&( ( ( old_poles(k) <= 1 ) && ( new_poles(k) > 1 ) ) ...
               ||( ( old_poles(k) > 1 ) && ( new_poles(k) <= 1 ) ) )
            PZG(M).Gain = -PZG(M).Gain;
          end
        end
      end
    end
    
    if M == 1
      if ( abs(real(tempVal)) < 1e-4 ) ...
        ||( abs(imag(tempVal)) < 1e-4 )
        if isreal(tempVal)
          set( temp0(11,2),'String',num2str(tempVal,10) );
        else
          set( temp0(11,2),'String',num2str(tempVal,9) );
        end
      else
        set( temp0(11,2),'String',num2str(tempVal,7) );
      end
    else
      if ( abs( -1 - tempVal ) < 1e-4 ) ...
        ||( abs( 1 - tempVal ) < 1e-4 )
        if isreal(tempVal)
          set( temp0(11,2),'String',num2str(tempVal,10) );
        else
          set( temp0(11,2),'String',num2str(tempVal,9) );
        end
      else
        set( temp0(11,2),'String',num2str(tempVal,7) );
      end
    end
  else
    if ~isempty( strfind( tempStr, '+' ) ) ...
      ||~isempty( strfind( tempStr, '-' ) ) ...
      || ( tempStr(end) == 'i' ) || ( tempStr(end) == 'j' )
      errdlg_h = errordlg({['The numeric format is incorrect.' ...
        '  Example of correct format:  3+1i']; ...
                               ' ';'    Click "OK" to continue ...'}, ...
        'CAN''T PARSE THE NUMBER','modal');
      uiwait(errdlg_h)
      return
    else
      errdlg_h = errordlg({['No variable named ' tempStr ' is'...
           ' defined in the MATLAB workspace.']; ...
                               ' ';'    Click "OK" to continue ...'}, ...
           'UNDEFINED VARIABLE','modal');
      uiwait(errdlg_h)
      return
    end
  end
   
elseif ~isempty( strfind( CallbackStr,'AddZero') )
  if numel(PZG(M).ZeroLocs) >= numel(PZG(M).PoleLocs)
    errdlg_h = errordlg({'There would be more zeros than poles.'; ...
                               ' ';'    Click "OK" to continue ...'}, ...
       'NOT ADDING THE ZERO','modal');
    uiwait(errdlg_h)
    return
  end
  %tempStr = get( temp0(12,2),'String');
  if isempty(tempStr) ...
    &&( ( nargin < 2 ) || isempty(AddPZ) )
    errdlg_h = ...
      errordlg( ...
        {'You must specify where a zero is to be added.'; ...
         'Enter that information just below the "Add" button you clicked.'; ...
         ' ';'To specify the location (or locations), enter:'; ...
         '      one or more numerical values,'; ...
         ' OR'; ...
         '     a mathematical expression Matlab can evaluate,'; ...
         ' OR'; ...
         '     the name of a numeric variable in the Matlab workspace.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Advisory','modal');
    uiwait(errdlg_h)
    return
  end
  if ( ~isempty( strfind( tempStr, '+i' ) ) ...
      ||~isempty( strfind( tempStr, '-i' ) ) ...
      ||~isempty( strfind( tempStr, '+j' ) ) ...
      ||~isempty( strfind( tempStr, '-j' ) ) ) ...
     &&( ( tempStr(end) == 'i' ) ...
        ||( tempStr(end) == 'j' ) )
    if numel( tempStr ) == 1
      if ( tempStr == 'i' ) || ( tempStr == 'j' )
        tempStr = '1i';
      end
    else
      tempStr = [ tempStr(1:end-1) '1i'];
    end
  end
  tempVal = str2num(tempStr); %#ok<ST2NM>
  if isempty(tempVal)
    tempVal = str2num(lower(tempStr)); %#ok<ST2NM>
  end
  added_zeros = [];
  if nargin == 1
    %tempVal = str2num(tempStr); %#ok<ST2NM>
    if isempty(tempVal) && ~isempty(tempStr) ...
      && isempty( strfind(tempStr,'-') ) ...
      && isempty( strfind(tempStr,'+') )
      tempStr = strtrim(tempStr);
      sp_ndx = strfind(tempStr,' ');
      if ~isempty(sp_ndx) && ( sp_ndx(1) > 1 )
        tempStr = tempStr(1:sp_ndx(1)-1);
      end
      if evalin('base',['exist(''' tempStr ''',''var'')'])
        evalin('base',['temp_val = ' tempStr ';'] )
        evalin('base','assignin(''caller'',''tempVal'', temp_val );')
        evalin('base','clear temp_val')
        % elseif evalin('base',['~isempty(' tempStr ')'])
        %   evalin('base',['temp_val = ' tempStr ';'] )
        %   evalin('base','assignin(''caller'',''tempVal'', temp_val );')
        %   evalin('base','clear temp_val')
      end
    end
    if isempty(tempVal) || ~isnumeric(tempVal) ...
      || any( isinf(tempVal(:)) ) || any( isnan(tempVal(:)) )
      errdlg_h = ...
        errordlg( ...
          {'Unable to interpret the text entry into valid zero'; ...
           'locations.  Zero locations must be finite and numeric.'; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'PZGUI Input Error','modal');
      uiwait(errdlg_h)
      return
    end
    tempVal = tempVal(:);
    
    set( temp0(12,2),'String',tempStr );
    if abs( imag(tempVal) ) <= abs( real(tempVal) )*100*eps
      save_undo_info(M);
      PZG(M).recompute_frf = 1;
      tempVal = real( tempVal );
      PZG(M).ZeroLocs = [ tempVal; PZG(M).ZeroLocs ];
      added_zeros = tempVal;
    elseif abs(imag(tempVal)) > 0
      save_undo_info(M);
      PZG(M).recompute_frf = 1;
      PZG(M).ZeroLocs = [ tempVal; conj(tempVal); PZG(M).ZeroLocs ];
      added_zeros = [ tempVal; conj(tempVal) ];
    end
    if numel(tempVal) == 1
      if M == 1
        if ( abs(real(tempVal)) < 1e-4 ) ...
          ||( abs(imag(tempVal)) < 1e-4 )
          if isreal(tempVal)
            set( temp0(12,2),'String',num2str(tempVal,10) );
          else
            set( temp0(12,2),'String',num2str(tempVal,9) );
          end
        else
          set( temp0(12,2),'String',num2str(tempVal,7) );
        end
      else
        if ( abs( -1 - tempVal ) < 1e-4 ) ...
          ||( abs( 1 - tempVal ) < 1e-4 )
          if isreal(tempVal)
            set( temp0(12,2),'String',num2str(tempVal,10) );
          else
            set( temp0(12,2),'String',num2str(tempVal,9) );
          end
        else
          set( temp0(12,2),'String',num2str(tempVal,7) );
        end
      end
    end
  elseif nargin == 2
    if ischar(AddPZ)
      errdlg_h = errordlg({['The variable ''' tempStr ...
        ''' must be numerical, not string.']; ...
        ' ';'    Click "OK" to continue ...'}, ...
        'CAN ONLY PROCESS A NUMERICAL VECTOR','modal');
      uiwait(errdlg_h)
      return
    elseif ~isnumeric(AddPZ)
      errdlg_h = ...
        errordlg( ...
          {['The variable ''' tempStr ''' must be a numerical vector']; ...
           'in order to be processed into a set of zero locations.'; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'CAN ONLY PROCESS A NUMERICAL VECTOR','modal');
      uiwait(errdlg_h)
      return
    end
    if ( min(size(AddPZ)) ~= 1 )
      errdlg_h = errordlg({['The variable ''' tempStr ...
        ''' must be a row or column vector.']; ...
        ' ';'    Click "OK" to continue ...'}, ...
        'CAN ONLY PROCESS A 1-D VECTOR','modal');
      uiwait(errdlg_h)
      return
    end
    save_undo_info(M);
    PZG(M).recompute_frf = 1;
    for k = numel(AddPZ):-1:2
      this_zero = AddPZ(k);
      if ~isnan( this_zero) && ( imag(this_zero) ~= 0 )
        conjndx = ...
          find( abs( AddPZ(1:k-1)-conj(this_zero)) ...
               /max(1,abs(this_zero)) < 1e-14 );
        if ~isempty(conjndx)
          AddPZ(conjndx(1)) = NaN;
        end
      end
    end
    AddPZ( isnan(AddPZ) ) = [];
    nr_zeros = numel(PZG(M).ZeroLocs) ...
              + numel(AddPZ) + sum( imag(AddPZ)~= 0 );
    if nr_zeros > numel(PZG(M).PoleLocs)
      err_h = ...
        errordlg({'You cannot add the specified zero(s) because'; ...
                  'that would result in more zeros than poles,'; ...
                  'which is not physically realistic.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'Cannot Add Specified Zero(s)','modal');
      uiwait(err_h)
      return
    end
    
    tempVec = AddPZ;
    for Ck = 1:numel(tempVec)
      if abs( imag(tempVec(Ck)) ) ...
         < max( abs( real(tempVec(Ck)) )*100*eps, ...
          100*eps)
        PZG(M).ZeroLocs = [ real(tempVec(Ck)); PZG(M).ZeroLocs ];
        added_zeros(end+1) = real(tempVec(Ck)); %#ok<AGROW>
      elseif imag( tempVec(Ck) ) > 0
        PZG(M).ZeroLocs = ...
          [ tempVec(Ck); conj(tempVec(Ck)); PZG(M).ZeroLocs ];
        added_zeros(end+1) = tempVec(Ck); %#ok<AGROW>
        added_zeros(end+1) = conj(tempVec(Ck)); %#ok<AGROW>
      elseif imag( tempVec(Ck) ) < 0
        PZG(M).ZeroLocs = ...
          [ conj(tempVec(Ck)); tempVec(Ck); PZG(M).ZeroLocs ];
        added_zeros(end+1) = conj(tempVec(Ck)); %#ok<AGROW>
        added_zeros(end+1) = tempVec(Ck); %#ok<AGROW>
      end
    end
  else
    if ~isempty( strfind( tempStr, '+' ) ) ...
      ||~isempty( strfind( tempStr, '-' ) ) ...
      || ( tempStr(end) == 'i' ) || ( tempStr(end) == 'j' )
      errdlg_h = errordlg({['The numeric format is incorrect.' ...
                '  Example of correct format:  3+1i']; ...
        ' ';'    Click "OK" to continue ...'}, ...
                'CAN''T PARSE THE NUMBER','modal');
      uiwait(errdlg_h)
      return
    else
      errdlg_h = errordlg({['No variable named ' tempStr ' is'...
                '  defined in the MATLAB workspace.']; ...
                ' ';'    Click "OK" to continue ...'}, ...
                'UNDEFINED VARIABLE','modal');
      uiwait(errdlg_h)
      return
    end
  end
  
  if ~isempty(fixdc_h) && get( fixdc_h,'value')
    for k = 1:numel(added_zeros)
      if ( M == 1 ) && ( abs(added_zeros(k)) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain / abs(added_zeros(k));
        if isreal(added_zeros(k)) && ( added_zeros(k) > 0 )
          PZG(M).Gain = -PZG(M).Gain;
        end
      elseif ( M == 2 ) && ( abs(added_zeros(k)-1) > 1e-12 )
        PZG(M).Gain = PZG(M).Gain / abs(added_zeros(k)-1);
        if isreal(added_zeros(k)) && ( added_zeros(k) > 1 )
          PZG(M).Gain = -PZG(M).Gain;
        end
      end
    end
  end

elseif ~isempty( strfind( CallbackStr,'MoveZero') )
  if isempty( PZG(M).ZeroLocs )
    errdlg_h = ...
      errordlg( ...
        {'There are no zeros currently defined in the model.'; ...
         ' '; ...
         'You can use the "Add" button to define a zero.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Advisory','modal');
    uiwait(errdlg_h)
    return
  end
  tempStr = get( temp0(12,2),'String');
  if isempty( tempStr )
    errdlg_h = ...
      errordlg( ...
        {'You haven''t specified a location to move the selected zero.'; ...
         'Enter that information just below the "Move" button you clicked.'; ...
         ' ';'To specify the location, enter:'; ...
         '      a numerical value,'; ...
         ' OR'; ...
         '     a mathematical expression Matlab can evaluate,'; ...
         ' OR'; ...
         '     the name of a numeric variable in the Matlab workspace.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Advisory','modal');
    uiwait(errdlg_h)
    return
  end
  if ( ~isempty( strfind( lower(tempStr), '+i' ) ) ...
      ||~isempty( strfind( lower(tempStr), '-i' ) ) ...
      ||~isempty( strfind( lower(tempStr), '+j' ) ) ...
      ||~isempty( strfind( lower(tempStr), '-j' ) ) ) ...
    &&( ( lower(tempStr(end)) == 'i' ) ...
       ||( lower(tempStr(end)) == 'j' ) )
    if numel( tempStr ) == 1
      if ( lower(tempStr) == 'i' ) || ( lower(tempStr) == 'j' )
        tempStr = '1i';
      end
    else
      tempStr = [ tempStr(1:end-1) '1i'];
    end
  end
  if nargin == 2
    tempVal = AddPZ;
    if isnumeric(tempVal) && ~isempty(tempVal)
      tempVal = tempVal(1);
    else
      tempVal = [];
    end
    if ( numel(tempVal) ~= 1 ) || isinf(tempVal) || isnan(tempVal)
      errdlg_h = ...
        errordlg( ...
          {['Variable ''' tempStr ''' must be finite numeric scalar,']; ...
           ['in order to use it as a ' ...
             'location to move the selected zero.']; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'Error during zero move ...','modal');
      uiwait(errdlg_h)
      return
    end
  else
    tempVal = str2num(tempStr); %#ok<ST2NM>
    if isempty(tempVal) && ~isempty(tempStr) ...
      && isempty( strfind(tempStr,'-') ) ...
      && isempty( strfind(tempStr,'+') )
      if evalin('base',['exist(''' tempStr ''',''var'')'])
        evalin('base',['temp_val = ' tempStr ';'] )
        evalin('base','assignin(''caller'',''tempVal'', temp_val );')
        evalin('base','clear temp_val')
        %elseif evalin('base',['~isempty(' tempStr ')'])
        %  evalin('base',['temp_val = ' tempStr ';'] )
        %  evalin('base','assignin(''caller'',''tempVal'', temp_val );')
        %  evalin('base','clear temp_val')
      end
    else
      tempVal = str2num(lower(tempStr)); %#ok<ST2NM>
    end
  end
  if ~isequal( numel(tempVal), 1 ) || ~isnumeric(tempVal) ...
    || any( isinf(tempVal(:)) ) || any( isnan(tempVal(:)) )
    errdlg_h = ...
      errordlg( ...
        {'Unable to interpret the text entry into a valid zero'; ...
         'location.  The zero location must be finite and numeric.'; ...
         ' ';'    Click "OK" to continue ...'}, ...
        'PZGUI Input Error','modal');
    uiwait(errdlg_h)
    return
  end
  if numel(tempVal) == 1
    set( temp0(12,2),'String',tempStr );
    % Determine which zero is selected.
    SelectNdx = get( temp0(8,2),'Value');
    if ( numel( PZG(M).ZeroLocs ) == 1 ) ...
      ||( ( numel( PZG(M).ZeroLocs ) == 2 ) ...
         && ~isreal(PZG(M).ZeroLocs(1)) ...
         &&( abs( PZG(M).ZeroLocs(2) - conj(PZG(M).ZeroLocs(1) ) ) <1e-14 ) )
      set( temp0(8,2),'Value', 1 );
      SelectNdx = 1;
    end
    if SelectNdx > numel( PZG(M).ZeroLocs )
      errdlg_h = ...
        errordlg( ...
          {'No individual zero is selected.'; ...
           ' ';'Zeros may be moved only one-at-a-time,'; ...
           'or as a complex-conjugate pair.'; ...
           ' '; ...
           'From the menu just above the "Move" button you clicked,'; ...
           'select one of the zeros in the list.'; ...
           ' ';'    Click "OK" to continue ...'}, ...
          'Error during zero move ...','modal');
      uiwait(errdlg_h)
      return
    else
      if isreal( PZG(M).ZeroLocs(SelectNdx) ) && isreal( tempVal )
        if ~isequal(PZG(M).ZeroLocs(SelectNdx), tempVal)
          save_undo_info(M);
          PZG(M).recompute_frf = 1;
        end
        new_zeros = tempVal;
        old_zeros = PZG(M).ZeroLocs(SelectNdx);
        PZG(M).ZeroLocs(SelectNdx) = tempVal;
      elseif ~isreal( PZG(M).ZeroLocs(SelectNdx) ) && ~isreal( tempVal )
        SelectNdx2 = ...
          find( PZG(M).ZeroLocs == conj(PZG(M).ZeroLocs(SelectNdx)) );
        if ~isequal(PZG(M).ZeroLocs(SelectNdx2), tempVal ) ...
          &&~isequal(PZG(M).ZeroLocs(SelectNdx2), conj(tempVal) )
          save_undo_info(M);
          PZG(M).recompute_frf = 1;
        end
        if ~isempty(SelectNdx2)
          SelectNdx2 = SelectNdx2(1);
          new_zeros = [ tempVal; conj(tempVal) ];
          old_zeros = ...
            [ PZG(M).ZeroLocs(SelectNdx); PZG(M).ZeroLocs(SelectNdx2) ];
          PZG(M).ZeroLocs(SelectNdx) = tempVal;
          PZG(M).ZeroLocs(SelectNdx2) = conj(tempVal);
        else
          errdlg_h = errordlg({'Can''t find complex conjugate zero.'; ...
                    ' ';'    Click "OK" to continue ...'}, ...
                   'Error during zero move ...','modal');
          uiwait(errdlg_h)
          return
        end
      elseif isreal(tempVal)
        errdlg_h = errordlg({'Can''t change complex zero to real zero.'; ...
                  ' ';'    Click "OK" to continue ...'}, ...
                 'Error during zero move ...','modal');
        uiwait(errdlg_h)
        return
      else
        errdlg_h = errordlg({'Can''t change real zero to complex zero.'; ...
                  ' ';'    Click "OK" to continue ...'}, ...
                 'Error during zero move ...','modal');
        uiwait(errdlg_h)
        return
      end
    end
    
    if ~isempty(fixdc_h) && get( fixdc_h,'value')
      for k = 1:numel(old_zeros)
        if ( M == 1 ) && ( abs(old_zeros(k)) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain * abs(old_zeros(k));
        elseif ( M == 2 ) && ( abs(old_zeros(k)-1) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain * abs(old_zeros(k)-1);
        end
        if ( M == 1 ) && ( abs(new_zeros(k)) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain / abs(new_zeros(k));
        elseif ( M == 2 ) && ( abs(new_zeros(k)-1) > 1e-12 )
          PZG(M).Gain = PZG(M).Gain / abs(new_zeros(k)-1);
        end
        if M == 1
          if isreal(old_zeros(k)) && isreal(new_zeros(k)) ...
            &&( ( ( old_zeros(k) <= 0 ) && ( new_zeros(k) > 0 ) ) ...
               ||( ( old_zeros(k) > 0 ) && ( new_zeros(k) <= 0 ) ) )
            PZG(M).Gain = -PZG(M).Gain;
          end
        else
          if isreal(old_zeros(k)) && isreal(new_zeros(k)) ...
            &&( ( ( old_zeros(k) <= 1 ) && ( new_zeros(k) > 1 ) ) ...
               ||( ( old_zeros(k) > 1 ) && ( new_zeros(k) <= 1 ) ) )
            PZG(M).Gain = -PZG(M).Gain;
          end
        end
      end
    end
    
    if M == 1
      if ( abs(real(tempVal)) < 1e-4 ) ...
        ||( abs(imag(tempVal)) < 1e-4 )
        if isreal(tempVal)
          set( temp0(12,2),'String',num2str(tempVal,10) );
        else
          set( temp0(12,2),'String',num2str(tempVal,9) );
        end
      else
        set( temp0(12,2),'String',num2str(tempVal,7) );
      end
    else
      if ( abs( -1 - tempVal ) < 1e-4 ) ...
        ||( abs( 1 - tempVal ) < 1e-4 )
        if isreal(tempVal)
          set( temp0(12,2),'String',num2str(tempVal,10) );
        else
          set( temp0(12,2),'String',num2str(tempVal,9) );
        end
      else
        set( temp0(12,2),'String',num2str(tempVal,7) );
      end
    end
  else
    if ~isempty( strfind( tempStr, '+' ) ) ...
      ||~isempty( strfind( tempStr, '-' ) ) ...
      ||( tempStr(end) == 'i' ) || ( tempStr(end) == 'j' )
      errdlg_h = errordlg({['The numeric format is incorrect.' ...
                '  Example of correct format:  3+1i']; ...
                 ' ';'    Click "OK" to continue ...'}, ...
                'CAN''T PARSE THE NUMBER','modal');
      uiwait(errdlg_h)
      return
    else
      errdlg_h = ...
        errordlg( ...
          {['No variable named ' tempStr ' is'...
                '  defined in the MATLAB workspace.']; ...
           ' ';'   Click "OK" to continue.'}, ...
                'UNDEFINED VARIABLE','modal');
      uiwait(errdlg_h)
      return
    end
  end
  
elseif ~isempty( strfind( CallbackStr,'UNDO') )
  if ~isfield( PZG,'undo_info') ...
    || isempty( PZG(M).undo_info )
    undo_h = pzg_fndo( M, M+11,'pzgui_UNDO_pushbutton');
    if ~isempty(undo_h)
      set( undo_h,'enable','off');
    end
    PZG(M).undo_info = {};
    return
  elseif ~isstruct(PZG(M).undo_info{end}) ...
        ||~isfield(PZG(M).undo_info{end},'ZeroLocs') ...
        ||~isfield(PZG(M).undo_info{end},'PoleLocs') ...
        ||~isfield(PZG(M).undo_info{end},'Gain') ...
        ||~isfield(PZG(M).undo_info{end},'DCgain') ...
        ||~isfield(PZG(M).undo_info{end},'Ts') ...
        ||~isfield(PZG(M).undo_info{end},'PureDelay')
    errdlg_h = errordlg({'The "undo" information is incomplete.'; ...
              'Removing the incomplete information.'; ...
              ' ';'    Click "OK" to continue ...'}, ...
             'Cannot Undo','modal');
    uiwait(errdlg_h)
    PZG(M).undo_info(end) = [];
    return
  elseif ( numel(PZG(M).undo_info{end}.Gain) ~= 1 ) ...
        ||( numel(PZG(M).undo_info{end}.DCgain) > 1 ) ...
        ||( numel(PZG(M).undo_info{end}.Ts) ~= 1 ) ...
        ||( numel(PZG(M).undo_info{end}.PureDelay) ~= 1 ) ...
        ||~isreal(PZG(M).undo_info{end}.Gain) ...
        ||~isreal(PZG(M).undo_info{end}.DCgain) ...
        ||~isreal(PZG(M).undo_info{end}.Ts) ...
        ||~isreal(PZG(M).undo_info{end}.PureDelay) ...
        ||( PZG(M).undo_info{end}.Ts < 0 ) ...
        ||( PZG(M).undo_info{end}.PureDelay < 0 ) ...
        ||( numel(PZG(M).undo_info{end}.PoleLocs) ...
           <numel(PZG(M).undo_info{end}.ZeroLocs) )
    errdlg_h = errordlg({'The "undo" information is corrupted.'; ...
              'Removing the corrupt information.'; ...
               ' ';'    Click "OK" to continue ...'}, ...
             'Cannot Undo','modal');
    uiwait(errdlg_h)
    PZG(M).undo_info(end) = [];
    if isempty(PZG(M).undo_info)
      undo_h = pzg_fndo( M, M+11,'pzgui_UNDO_pushbutton');
      set( undo_h,'enable','off');
    end
    return
  end
  % If execution makes it to here, there is valid "undo" information.
  if ~isfield( PZG(M),'redo_info') || ~iscell(PZG(M).redo_info)
    PZG(M).redo_info = {};
  end
  redo_info = [];
  redo_info.ZeroLocs = PZG(M).ZeroLocs;
  redo_info.PoleLocs = PZG(M).PoleLocs;
  redo_info.Gain = PZG(M).Gain;
  redo_info.Ts = PZG(M).Ts;
  redo_info.PureDelay = PZG(M).PureDelay;
  redo_info.DCgain = PZG(M).DCgain;
  
  PZG(M).ZeroLocs = PZG(M).undo_info{end}.ZeroLocs(:);
  PZG(M).PoleLocs = PZG(M).undo_info{end}.PoleLocs(:);
  PZG(M).Gain = PZG(M).undo_info{end}.Gain;
  if ~isequal( PZG(2).Ts, PZG(M).undo_info{end}.Ts )
    PZG(1).Ts = PZG(M).undo_info{end}.Ts;
    PZG(2).Ts = PZG(M).undo_info{end}.Ts;
    freqserv('deselect frequency');
    pzg_grid;
    noCalls = 0;
  end
  PZG(M).PureDelay = PZG(M).undo_info{end}.PureDelay;
  PZG(M).DCgain = PZG(M).undo_info{end}.DCgain;
  PZG(M).recompute_frf = 1;
  
  if isempty(PZG(M).redo_info) ...
    ||~isequal( PZG(M).redo_info{end}, redo_info )
    PZG(M).redo_info{end+1} = redo_info;
  end
  PZG(M).undo_info(end) = [];
  
  if get( temp0(14,2),'value')
    % The "Link" checkbox is selected,
    % so specify that the link should be updated.
    Calls = 1;                                 %#ok<NASGU>
    noCalls = 0;
  end
  
elseif ~isempty( strfind( CallbackStr,'REDO') )
  if ~isfield( PZG,'redo_info') || isempty( PZG(M).redo_info )
    errdlg_h = errordlg({'There is no "redo" information.'; ...
                ' ';'    Click "OK" to continue ...'}, ...
             'Nothing to Re-Do','modal');
    uiwait(errdlg_h)
    PZG(M).undo_info = {};
    return
  elseif ~isstruct(PZG(M).redo_info{end}) ...
        ||~isfield(PZG(M).redo_info{end},'ZeroLocs') ...
        ||~isfield(PZG(M).redo_info{end},'PoleLocs') ...
        ||~isfield(PZG(M).redo_info{end},'Gain') ...
        ||~isfield(PZG(M).redo_info{end},'DCgain') ...
        ||~isfield(PZG(M).redo_info{end},'Ts') ...
        ||~isfield(PZG(M).redo_info{end},'PureDelay')
    errdlg_h = errordlg({'The "Redo" information is incomplete.'; ...
              'Removing the incomplete information.'; ...
              ' ';'    Click "OK" to continue ...'}, ...
             'Cannot Undo','modal');
    uiwait(errdlg_h)
    PZG(M).redo_info(end) = [];
    return
  elseif ( numel(PZG(M).redo_info{end}.Gain) ~= 1 ) ...
        ||( numel(PZG(M).redo_info{end}.DCgain) > 1 ) ...
        ||( numel(PZG(M).redo_info{end}.Ts) ~= 1 ) ...
        ||( numel(PZG(M).redo_info{end}.PureDelay) ~= 1 ) ...
        ||~isreal(PZG(M).redo_info{end}.Gain) ...
        ||~isreal(PZG(M).redo_info{end}.DCgain) ...
        ||~isreal(PZG(M).redo_info{end}.Ts) ...
        ||~isreal(PZG(M).redo_info{end}.PureDelay) ...
        ||( PZG(M).redo_info{end}.Ts < 0 ) ...
        ||( PZG(M).redo_info{end}.PureDelay < 0 ) ...
        ||( numel(PZG(M).redo_info{end}.PoleLocs) ...
           <numel(PZG(M).redo_info{end}.ZeroLocs) )
    errdlg_h = errordlg({'The "Redo" information is corrupted.'; ...
              'Removing the corrupt information.'; ...
               ' ';'    Click "OK" to continue ...'}, ...
             'Cannot Undo','modal');
    uiwait(errdlg_h)
    PZG(M).redo_info(end) = [];
    return
  end
  
  % If execution makes it to here, there is valid "Re-do" information.
  if ~isfield( PZG(M),'undo_info') || ~iscell(PZG(M).undo_info)
    PZG(M).undo_info = {};
  end
  undo_info = [];
  undo_info.ZeroLocs = PZG(M).ZeroLocs;
  undo_info.PoleLocs = PZG(M).PoleLocs;
  undo_info.Gain = PZG(M).Gain;
  undo_info.Ts = PZG(M).Ts;
  undo_info.PureDelay = PZG(M).PureDelay;
  undo_info.DCgain = PZG(M).DCgain;
  
  PZG(M).ZeroLocs = PZG(M).redo_info{end}.ZeroLocs(:);
  PZG(M).PoleLocs = PZG(M).redo_info{end}.PoleLocs(:);
  PZG(M).Gain = PZG(M).redo_info{end}.Gain;
  if ~isequal( PZG(2).Ts, PZG(M).redo_info{end}.Ts )
    PZG(1).Ts = PZG(M).redo_info{end}.Ts;
    PZG(2).Ts = PZG(M).redo_info{end}.Ts;
    freqserv('deselect frequency');
    pzg_grid;
    noCalls = 0;
  end
  PZG(M).PureDelay = PZG(M).redo_info{end}.PureDelay;
  PZG(M).DCgain = PZG(M).redo_info{end}.DCgain;
  PZG(M).recompute_frf = 1;
  
  if isempty(PZG(M).undo_info) ...
    ||~isequal( PZG(M).undo_info{end}, undo_info )
    PZG(M).undo_info{end+1} = undo_info;
  end
  PZG(M).redo_info(end) = [];
end

pzg_unre;

Calls = ~noCalls;

if isempty(PZG(M).BodeFreqs)
  gui_h = findobj( allchild(0),'name', PZG(M).PZGUIname );
  if M == 1
    if PZG(1).recompute_frf
      PZG(1).recompute_frf = 0;
      pzg_cntr(1);
      pzg_bodex(1);
    end
    pzgui
    updatepl
    if ~isempty(gui_h)
      link_h = findobj( gui_h,'string','D-T Link by:');
      if isequal( get( link_h,'value'), 1 )
        PZG(2).recompute_frf = 0;
        pzg_cntr(2);
        pzg_bodex(2);
        dpzgui;
        dupdatep
      end
    end
  else
    if PZG(2).recompute_frf
      PZG(2).recompute_frf = 0;
      pzg_cntr(2);
      pzg_bodex(2);
    end
    dpzgui;
    dupdatep
    if ~isempty(gui_h)
      link_h = findobj( gui_h,'string','C-T Link by:');
      if isequal( get( link_h,'value'), 1 )
        PZG(1).recompute_frf = 0;
        pzg_cntr(1);
        pzg_bodex(1);
        pzgui;
        updatepl
      end
    end
  end
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
  if isempty( PZG(M).undo_info ) ...
    ||~isequal( PZG(M).undo_info{end}, undo_info )
    do_save = 1;
    if ~isempty(gcbo) ...
      && strcmp( get(gcbo,'type'),'uicontrol') ...
      && isequal( get(gcbo,'string'),'Undo')
      if ( ( M == 1 ) && strcmpi( get(gcbo,'tag'),'pzgui UNDO pushbutton') ) ...
        ||( ( M == 2 ) && strcmpi( get(gcbo,'tag'),'dpzgui UNDO pushbutton') )
        do_save = 0;
      end
    end
    if do_save
      PZG(M).undo_info{end+1} = undo_info;
      rloc_h = pzg_fndo( M, 9+M,'fig_h');
      if ~isempty(rloc_h)
        gaintxt_h = pzg_fndo( M, 9+M,'rlocuspl_gain_text');
        set( gaintxt_h,'backgroundcolor',[0.9 0.9 0.9],'string','');
        gainmark_h = pzg_fndo( M, 9+M,'rlocuspl_gain_marker');
        set( gainmark_h,'visible','off');
      end
    end
  end

return
