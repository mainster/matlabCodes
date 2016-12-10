function  updatepl( FromDUPDATE )
% Updates continuous-time plots after zpk model is modified.
% Coordinates maintenance of the various PZGUI continuous-time
% frequency-domain, S-plane, and time-response plots.

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

pzg_bkup

temppzmove_h = ...
  [ pzg_fndo( (1:2),(1:14),'pzmove_temporary_line'); ...
    pzg_fndo( (1:2),(8:9),'pzmove_temporary_forc_line'); ...
    pzg_fndo( (1:2),(8:9),'pzmove_temporary_natl_line') ];
if ~isempty(temppzmove_h)
  set(temppzmove_h(ishandle(temppzmove_h)),'visible','off')
end

if ~isempty(gcbo) && isequal( get(gcbo,'type'),'uicontrol')
  if ~isempty( strfind( get(gcbo,'callback'),'Erase') )
    return
  end
end

dupdatep_called = 0;

prev_msg_h = findobj( allchild(0),'name','CALCULATING');
if isempty(prev_msg_h)
  try
    MsgHndl = ...
      msgbox({'Computation may take a minute.   Please wait ...'}, ...
             {'CALCULATING'});
    if isequal( 1, ishandle(MsgHndl) )
      temp = findobj(MsgHndl,'Tag','OKButton');
      if ~isempty(temp)
        delete(temp(1))
      end
    end
  catch
    MsgHndl = [];
  end
else
  MsgHndl = prev_msg_h(1);
  if numel(prev_msg_h) > 1
    delete(prev_msg_h(2:end))
  end
end

CT_PZGUI = pzg_fndo( 1, 12,'fig_h');
DT_PZGUI = pzg_fndo( 2, 13,'fig_h');

if isempty(CT_PZGUI)
  return
end

if nargin < 1
  FromDUPDATE = 0;
end

% Update the contour information.
if ~isequal( PZG(1).recompute_frf, 0 ) ...
  || ~isfield( PZG(1),'cntr_data') ...
  || isempty( PZG(1).cntr_data ) ...
  ||~isstruct( PZG(1).cntr_data ) ...
  ||~isfield( PZG(1).cntr_data,'contour_freq')
  PZG(1).recompute_frf = 0;
  pzg_cntr(1);
  pzg_bodex(1);
  pzgui
end
evalin('base','clear PZMoving');

tempUD = get( CT_PZGUI,'UserData' );

if numel(PZG(1).ZeroLocs) > numel(PZG(1).PoleLocs)
  errdlg_h = ...
    errordlg({'The system has more zeros than poles.'; ...
              'This is a physically un-realizeable system'; ...
              ' (i.e., non-real-time).'; ...
              ' ';'    Click "OK" to continue ...';' '}, ...
             'The Plots are NOT Being Updated','modal');
  uiwait(errdlg_h)
  return
end

if ~isempty(DT_PZGUI)
  % Is the D-T link checked?
  if pzg_islink(1)
    % Uncheck the D-T map's link to C-T:
    linkcb_h = pzg_fndo( 2, 13,'LinkCheckbox');
    set( linkcb_h,'Value',0 );
    % Make the bode comp lines invisible.
    temp = ...
      [ pzg_fndo( 2, 13,'bode_comp_pole_lines'); ...
        pzg_fndo( 2, 13,'bode_comp_zero_lines'); ...
        pzg_fndo( 2, 13,'bode_comp_pole_text'); ...
        pzg_fndo( 2, 13,'bode_comp_zero_text'); ...
        pzg_fndo( 2, 13,'bode_comp_freq_text') ];
    if ~isempty(temp)
      set(temp,'visible','off')
    end
  end
end

ScrSize=get(0,'ScreenSize');

if get( tempUD(2,2),'Value') == 1
  if ScrSize(3) > 1024
    ScrPos = [10 700 335 280];
  elseif ScrSize(3) > 800;
    ScrPos = [10 520 270 210];
  else
    ScrPos = [10 410 220 160];
  end
  bodepl( PZG(1).BodeFreqs, PZG(1).BodeMag, PZG(1).BodePhs, ...
          PZG(1).OLBodeName, PZG(1).FrqSelNdx, ...
          PZG(1).OLBodeName, ScrPos, ...
          ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
           'catch,pzg_err(''''button down'''');' ...
           'end,clear tempfs;']);
  curr_tools = pzg_tools(1);
  if any( curr_tools )
    if ( ~isempty(gcbf) && isequal(gcbf,gcbo) ) ...
      ||( ~isempty(gcbo) && strcmp( get(gcbo,'type'),'uicontrol') ...
         && ~isempty( strfind( get(gcbo,'callback'),'unwrap checkbox') ) )
      olphs_fig_h = pzg_fndo( 1, 2,'fig_h');
      if ~isempty(olphs_fig_h)
        this_unwrap_cb = pzg_fndo( 1, 2,'UnwrapChkbox');
        unwrap_value = get( this_unwrap_cb,'value');
        if curr_tools(1)
          pid_ldlg_h = pzg_fndo( 1, 2,'Gain_Preview');
        elseif curr_tools(2)
          pid_ldlg_h = pzg_fndo( 1, 2,'LDLG_Preview');
        else
          pid_ldlg_h = pzg_fndo( 1, 2,'PID_Preview');
        end
        for k = 1:numel(pid_ldlg_h)
          this_phase = (pi/180) * get( pid_ldlg_h(k),'ydata');
          if unwrap_value
            new_phase = (180/pi) * unwrap( this_phase );
          else
            new_phase = (180/pi) * angle( exp(1i*this_phase) );
          end
          set( pid_ldlg_h(k),'ydata', new_phase );
        end
      end
    end
  end
end
if get( tempUD(3,2),'Value') == 1
  if ScrSize(3) > 1024
    ScrPos = [350 700 335 280];
  elseif ScrSize(3) > 800;
    ScrPos = [275 520 270 210];
  else
    ScrPos = [235 410 220 160];
  end
  bodepl(PZG(1).CLBodeFreqs,PZG(1).CLBodeMag,PZG(1).CLBodePhs, ...
     PZG(1).CLBodeName,PZG(1).FrqSelNdx, ...
     PZG(1).CLBodeName,ScrPos, ...
     ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
      'catch,pzg_err(''''button down'''');' ...
      'end,clear tempfs;']);
  curr_tools = pzg_tools(1);
  if any( curr_tools )
    if ( ~isempty(gcbf) && isequal(gcbf,gcbo) ) ...
      ||( ~isempty(gcbo) && strcmp( get(gcbo,'type'),'uicontrol') ...
         && ~isempty( strfind( get(gcbo,'callback'),'unwrap checkbox') ) )
      clphs_fig_h = pzg_fndo( 1, 4,'fig_h');
      if ~isempty(clphs_fig_h)
        this_unwrap_cb = pzg_fndo( 1, 4,'UnwrapChkbox');
        unwrap_value = get( this_unwrap_cb,'value');
        if curr_tools(1)
          pid_ldlg_h = pzg_fndo( 1, 2,'Gain_Preview');
        elseif curr_tools(2)
          pid_ldlg_h = pzg_fndo( 1, 2,'LDLG_Preview');
        else
          pid_ldlg_h = pzg_fndo( 1, 2,'PID_Preview');
        end
        for k = 1:numel(pid_ldlg_h)
          this_phase = (pi/180) * get( pid_ldlg_h(k),'ydata');
          if unwrap_value
            new_phase = (180/pi) * unwrap( this_phase );
          else
            new_phase = (180/pi) * angle( exp(1i*this_phase) );
          end
          set( pid_ldlg_h(k),'ydata', new_phase );
        end
      end
    end
  end
end

ol_mag_h = pzg_fndo( 1, 1,'fig_h');
if ~isempty(ol_mag_h)
  tfemag_h = pzg_fndo( 1, 1,'TFE_Mag_line');
  tfedelmag_h = pzg_fndo( 1, 1,'TFE_Delta_Mag_line');
  vis_chkbox_h = pzg_fndo( 1, 1,'TFE_data_visibility_checkbox');
  delta_vis_chkbox_h = pzg_fndo( 1, 1,'TFE_delta_visibility_checkbox');
  if ~isempty(PZG(1).TFEFreqs) ...
    &&~isempty(PZG(1).TFEMag) ...
    &&( numel(PZG(1).TFEMag) == numel(PZG(1).TFEFreqs) )
  
    bode_frf = 10.^(PZG(1).BodeMag(:)/20) .* exp(1i*PZG(1).BodePhs(:)*(pi/180));
    tfe_frf = 10.^(PZG(1).TFEMag(:)/20) .* exp(1i*PZG(1).TFEPhs(:)*(pi/180));
    delta_frf = bode_frf - tfe_frf;
    delta_frf_mag_dB = 20*log10(abs(delta_frf));
    
    ol_mag_ax_h = pzg_fndo( 1, 1,'ax_h');
    % Determine Hz or rad/s
    hz_chkbox_h = pzg_fndo( 1, 1,'BodeHZChkbox');
    x_data = PZG(1).TFEFreqs;
    if get( hz_chkbox_h,'value')
      x_data = x_data/2/pi;
    end      
    if isempty(vis_chkbox_h)
      PZG(1).plot_h{1}.hndl.TFE_data_visibility_checkbox = ...
        uicontrol( ol_mag_h,'style','checkbox', ...
          'units','normalized', ...
          'position',[0.69 0.001 0.149 0.05], ...
          'string','Show TFE', ...
          'value', 1, ...
          'backgroundcolor',[0 0.7 0], ...
          'tag','TFE data visibility checkbox', ...
          'callback','updatepl');
      % hndl
      data_vis = 1;
    else
      set( vis_chkbox_h,'visible','on');
      data_vis = get( vis_chkbox_h,'value');
    end
    if isempty(delta_vis_chkbox_h)
      PZG(1).plot_h{1}.hndl.TFE_delta_visibility_checkbox = ...
        uicontrol( ol_mag_h,'style','checkbox', ...
          'units','normalized', ...
          'position',[0.85 0.001 0.149 0.05], ...
          'string','Show Diff', ...
          'value', 0, ...
          'backgroundcolor',[0 0.7 0], ...
          'tag','TFE delta visibility checkbox', ...
          'callback','updatepl');
      delta_vis = 0;
    else
      set( delta_vis_chkbox_h,'visible','on');
      delta_vis = get( delta_vis_chkbox_h,'value');
    end
    if data_vis
      if isempty(tfemag_h)
        PZG(1).plot_h{1}.hndl.TFE_Mag_line = ...
          plot( x_data, PZG(1).TFEMag, ...
            'color','g', ...
            'linewidth', 1.5, ...
            'parent', ol_mag_ax_h, ...
            'tag','TFE Mag line');
      else
        set( tfemag_h, ...
          'xdata', x_data, ...
          'ydata', PZG(1).TFEMag, ...
          'color','g', ...
          'linestyle','-', ...
          'linewidth', 1.5, ...
          'visible','on');
      end
    else
      set( tfemag_h,'visible','off');
    end
    if delta_vis && isequal( PZG(1).BodeFreqs(:), PZG(1).TFEFreqs(:) )
      delta_frf = bode_frf - tfe_frf; %#ok<NASGU>
      if isempty(tfedelmag_h)
        PZG(1).plot_h{1}.hndl.TFE_Delta_Mag_line = ...
          plot( x_data(:), delta_frf_mag_dB, ...
            'color','g', ...
            'linestyle',':', ...
            'linewidth', 2, ...
            'parent', ol_mag_ax_h, ...
            'tag','TFE Delta Mag line');
      else
        set( tfedelmag_h, ...
          'xdata', x_data(:), ...
          'ydata', delta_frf_mag_dB, ...
          'color','g', ...
          'linestyle',':', ...
          'linewidth', 2, ...
          'visible','on');
      end
    else
      set( tfedelmag_h,'visible','off');
    end
  else
    if ~isempty(vis_chkbox_h)
      set( vis_chkbox_h,'visible','off');
    end
    if ~isempty(delta_vis_chkbox_h)
      set( delta_vis_chkbox_h,'visible','off','value', 0 );
    end
    if ~isempty( tfemag_h )
      set( tfemag_h,'visible','off');
    end
    if ~isempty( tfedelmag_h )
      set( tfedelmag_h,'visible','off');
    end
  end
end

ol_phs_h = pzg_fndo( 1, 2,'fig_h');
if ~isempty(ol_phs_h)
  uw_h = pzg_fndo( 1, 2,'UnwrapChkbox');
  tfephs_h = pzg_fndo( 1, 2,'TFE_Phs_line');
  tfedelphs_h = pzg_fndo( 1, 2,'TFE_Delta_Phs_line');
  vis_chkbox_h = pzg_fndo( 1, 2,'TFE_data_visibility_checkbox');
  delta_vis_chkbox_h = pzg_fndo( 1, 2,'TFE_delta_visibility_checkbox');
  if ~isempty(PZG(1).TFEFreqs) ...
    &&~isempty(PZG(1).TFEPhs) ...
    &&( numel(PZG(1).TFEPhs) == numel(PZG(1).TFEFreqs) )
  
    bode_frf = 10.^(PZG(1).BodeMag(:)/20) .* exp(1i*PZG(1).BodePhs(:)*(pi/180));
    tfe_frf = 10.^(PZG(1).TFEMag(:)/20) .* exp(1i*PZG(1).TFEPhs(:)*(pi/180));
    delta_frf = bode_frf - tfe_frf; %#ok<NASGU>
    
    ol_phs_ax_h = pzg_fndo( 1, 2,'ax_h');
    % Determine Hz or rad/s
    hz_chkbox_h = pzg_fndo( 1, 2,'BodeHZChkbox');
    if isempty(vis_chkbox_h)
      PZG(1).plot_h{2}.hndl.TFE_data_visibility_checkbox = ...
        uicontrol( ol_phs_h,'style','checkbox', ...
          'units','normalized', ...
          'position',[0.69 0.001 0.149 0.05], ...
          'string','Show TFE', ...
          'value', 1, ...
          'backgroundcolor',[0 0.7 0], ...
          'tag','TFE data visibility checkbox', ...
          'callback','updatepl');
      data_vis = 1;
    else
      set( vis_chkbox_h,'visible','on');
      data_vis = get( vis_chkbox_h,'value');
    end
    if isempty(delta_vis_chkbox_h)
      PZG(1).plot_h{2}.hndl.TFE_delta_visibility_checkbox = ...
        uicontrol( ol_phs_h,'style','checkbox', ...
                'units','normalized', ...
                'position',[0.85 0.001 0.149 0.05], ...
                'string','Show Diff', ...
                'value', 0, ...
                'backgroundcolor',[0 0.7 0], ...
                'tag','TFE delta visibility checkbox', ...
                'callback','updatepl');
      delta_vis = 0;
    else
      set( delta_vis_chkbox_h,'visible','on');
      delta_vis = get( delta_vis_chkbox_h,'value');
    end
    tfe_phs = PZG(1).TFEPhs(:);
    if data_vis
      x_data = PZG(1).TFEFreqs(:);
      if get( hz_chkbox_h,'value')
        x_data = x_data/2/pi;
      end
      % Unwrap or wrap.
      if isequal( get(uw_h,'value'), 0 )
        tfe_phs = (180/pi) * angle( exp( (1i*pi/180)*tfe_phs ) );
      else
        tfe_phs = (180/pi) * unwrap( (pi/180) * tfe_phs );
      end
      if isempty(tfephs_h)
        PZG(1).plot_h{2}.hndl.TFE_Phs_line = ...
          plot( x_data, tfe_phs, ...
            'color','g', ...
            'linewidth', 2, ...
            'parent', ol_phs_ax_h, ...
            'tag','TFE Phs line');
      else
        set( tfephs_h, ...
          'xdata', x_data, ...
          'ydata', tfe_phs, ...
          'color','g', ...
          'linestyle','-', ...
          'linewidth', 2, ...
          'visible','on');
      end
    else
      set( tfephs_h,'visible','off');
    end
    if delta_vis && isequal( PZG(1).BodeFreqs(:), PZG(1).TFEFreqs(:) )
      bode_phs = pzg_unwrap( PZG(1).BodeFreqs, PZG(1).BodePhs(:), 1,'open');
      if isequal( get(uw_h,'value'), 0 )
        bode_phs = (180/pi) * angle( exp( (1i*pi/180)*bode_phs ) );
      end
      phs_err = bode_phs - tfe_phs;
      phs_err = (180/pi) * angle( exp( (1i*pi/180)*phs_err ) );
      % Put all deltas within +/- 360.
      posdelta_ndx = find( phs_err > 0 );
      phs_err(posdelta_ndx) = mod( phs_err(posdelta_ndx), 360 );
      negdelta_ndx = find( phs_err < 0 );
      phs_err(negdelta_ndx) = mod( phs_err(negdelta_ndx), -360 );
      % Put all deltas within +/- 180;
      posdelta_ndx = find( phs_err > 180 );
      phs_err(posdelta_ndx) = phs_err(posdelta_ndx) - 360;
      negdelta_ndx = find( phs_err < -180 );
      phs_err(negdelta_ndx) = phs_err(negdelta_ndx) + 360;
      if isempty( tfedelphs_h )
        PZG(1).plot_h{2}.hndl.TFE_Delta_Phs_line = ...
          plot( x_data(:), phs_err, ...
            'color','g', ...
            'linestyle',':', ...
            'linewidth', 2, ...
            'parent', ol_phs_ax_h, ...
            'tag','TFE Delta Phs line');
      else
        set( tfedelphs_h, ...
          'xdata', x_data(:), ...
          'ydata', phs_err, ...
          'color','g', ...
          'linestyle',':', ...
          'linewidth', 2, ...
          'visible','on');
      end
    elseif ~isempty(tfedelphs_h)
      set( tfedelphs_h,'visible','off');
    end
  else
    if ~isempty(vis_chkbox_h)
      set( vis_chkbox_h,'visible','off');
    end
    if ~isempty(delta_vis_chkbox_h)
      set( delta_vis_chkbox_h,'visible','off','value', 0 );
    end
    if ~isempty( tfephs_h )
      set( tfephs_h,'visible','off');
    end
    if ~isempty( tfedelphs_h )
      set( tfedelphs_h,'visible','off');
    end
  end
  this_unwrap_cb = pzg_fndo( 1, 2,'UnwrapChkbox');
  unwrap_value = get( this_unwrap_cb,'value');
  bode_y_data = PZG(1).BodePhs;
  if ~unwrap_value
    bode_y_data = (180/pi) * angle( exp( (1i*pi/180)*bode_y_data ) );
  end
  set( PZG(1).plot_h{2}.hndl.Bode_Line,'ydata', bode_y_data );
end

cl_phs_h = pzg_fndo( 1, 4,'fig_h');
if ~isempty(cl_phs_h)
  bode_y_data = PZG(1).CLBodePhs;
  this_unwrap_cb = pzg_fndo( 1, 4,'UnwrapChkbox');
  unwrap_value = get( this_unwrap_cb,'value');
  if ~unwrap_value
    bode_y_data = (180/pi) * angle( exp( (1i*pi/180)*bode_y_data ) );
  end
  set( PZG(1).plot_h{4}.hndl.Bode_Line,'ydata', bode_y_data );
end

tempCB = pzg_fndo( 1, 12,'Sensitivity_checkbox');
if ~isempty(tempCB)
  tempCB = tempCB(1);
  if get( tempCB,'Value') == 1
    if ScrSize(3) > 1024
      ScrPos = [300 20 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [250 20 300 250];
    else
      ScrPos = [200 20 240 200];
    end
    sensplot( PZG(1).CLBodeFreqs, ...
              PZG(1).CLBodeMag, ...
              PZG(1).CLBodePhs, ...
              PZG(1).SensPlotName, ...
              PZG(1).FrqSelNdx, ...
              PZG(1).SensPlotName,...
              ScrPos, ...
              ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
               'catch,pzg_err(''''button down'''');' ...
               'end,clear tempfs;']);
  end
end

if ( ~isempty(gcbf) && isequal( gcbf, gcbo ) ) ...
   ||( ~isempty(gcbo) && strcmp( get(gcbo,'type'),'uimenu') ) ...
   ||( ~isempty(gcbo) ...
      && strcmp( get(gcbo,'type'),'uicontrol') ...
      && isempty( strfind( get(gcbo,'callback'),'unwrap checkbox') ) ...
      && isempty( strfind( get(gcbo,'callback'),'Log checkbox') ) ...
      && isempty( strfind( get(gcbo,'callback'),'Hz checkbox') ) ...
      && ~strcmpi( get(gcbo,'tag'),'C-T OLbode checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T CLbode checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T Nichols checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T Nyquist checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T OLresp checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T CLresp checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T RtLoc checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T Sensitivity checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'C-T Fix DC checkbox') ...
      && ~strcmpi( get(gcbo,'tag'),'pzgui Link Checkbox') )
  if get( tempUD(4,2),'Value') == 1
    if ScrSize(3) > 1024
      ScrPos = [10 20 450 320];
    elseif ScrSize(3) > 800;
      ScrPos = [10 20 360 250];
    else
      ScrPos = [10 20 280 200];
    end
    nicholpl(PZG(1).BodeFreqs, PZG(1).BodeMag, PZG(1).BodePhs, ...
           PZG(1).NicholsName,PZG(1).FrqSelNdx, ...
           PZG(1).NicholsName,ScrPos, ...
           ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
            'catch,pzg_err(''''button down'''');' ...
            'end,clear tempfs;']);
  end
    
  contourpl('refresh plot', 1 );

  if get( tempUD(5,2),'Value') == 1
    if ScrSize(3) > 1024
      ScrPos = [495 20 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [380 20 300 250];
    else
      ScrPos = [300 20 240 200];
    end
    tempXLim = [];
    tempYLim = [];
    tempF = pzg_fndo( 1, 8,'fig_h');
    if ~isempty(tempF)
      tempA = pzg_fndo( 1, 8,'ax_h');
      if ~isempty(tempA)
        tempXLim = get(tempA,'xlim');
        tempYLim = get(tempA,'ylim');
      end
    end
    resppl( PZG(1).N,PZG(1).D,PZG(1).Gain, ...
            PZG(1).OLTimeRespName, ...
            PZG(1).OLTimeRespName, ...
            's',1,ScrPos );
    if ~isempty(tempXLim) && ~isempty(tempYLim)
      set( tempA,'xlim', tempXLim,'ylim', tempYLim )
      PZG(1).plot_h{8}.xlim = tempXLim;
      PZG(1).plot_h{8}.ylim = tempYLim;
      PZG(1).plot_h{8}.hndl.ax_xlim = tempXLim;
      PZG(1).plot_h{8}.hndl.ax_.ylim = tempYLim;
    end
  end
  
  if get( tempUD(6,2),'Value') == 1
    if ScrSize(3) > 1024
      ScrPos = [900 20 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [700 20 300 250];
    else
      ScrPos = [550 20 240 200];
    end
    tempXLim = [];
    tempYLim = [];
    tempF = pzg_fndo( 1, 9,'fig_h');
    if ~isempty(tempF)
      tempA = pzg_fndo( 1, 9,'ax_h');
      if ~isempty(tempA)
        tempXLim = get(tempA,'xlim');
        tempYLim = get(tempA,'ylim');
      end
    end
    resppl( PZG(1).N, PZG(1).Dc, PZG(1).CLGain, ...
           PZG(1).CLTimeRespName, ...
           PZG(1).CLTimeRespName, ...
           's',1,ScrPos );
    if ~isempty(tempXLim)
      set( tempA,'xlim', tempXLim,'ylim', tempYLim )
      PZG(1).plot_h{9}.xlim = tempXLim;
      PZG(1).plot_h{9}.ylim = tempYLim;
      PZG(1).plot_h{9}.hndl.ax_xlim = tempXLim;
      PZG(1).plot_h{9}.hndl.ax_.ylim = tempYLim;
    end
  end
  
  tempCB = pzg_fndo( 1, 12,'Nyquist_checkbox');
  if ~isempty(tempCB)
    tempCB = tempCB(1);
    if get( tempCB,'Value') == 1
      if ScrSize(3) > 1024
        ScrPos = [200 20 375 320];
      elseif ScrSize(3) > 800;
        ScrPos = [150 20 300 250];
      else
        ScrPos = [100 20 240 200];
      end
      nyqistpl(PZG(1).BodeFreqs, PZG(1).BodeMag, PZG(1).BodePhs, ...
                PZG(1).ZeroLocs, PZG(1).PoleLocs, PZG(1).Gain, ...
                 PZG(1).NyquistName, PZG(1).FrqSelNdx, ...
                 PZG(1).NyquistName, ScrPos, ...
                 ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
                  'catch,pzg_err(''''button down'''');' ...
                  'end,clear tempfs;']);
      
      nyq_ax_h = pzg_fndo( 1, 7,'pzg_nyquist_plot_axes');
      nyqplot_h = pzg_fndo( 1, 7,'Nyquist_Plot');
      nyqplot_data = ...
        get( nyqplot_h,'xdata') + 1i*get( nyqplot_h,'ydata');
      plot_max_mag = max( abs(nyqplot_data) );
      actual_max_mag = max( abs(PZG(1).cntr_data.contour_mapping) );
      if ( actual_max_mag > 20 ) ...
        && ( plot_max_mag > 0.99*actual_max_mag ) ...
        && strcmpi( get(nyq_ax_h,'xlimmode'),'auto') ...
        && strcmpi( get(nyq_ax_h,'ylimmode'),'auto')
        hyb_h = pzg_fndo( 1, 7,'rescale_checkbox');
        if ~isempty(hyb_h)
          set( hyb_h,'value', 1 )
          nyqistpl('hybrid scaling');
        end
      end
    end
  end
  
  if get( tempUD(10,2),'Value') == 1
    Callback = ['global PZG;' ...
                'temp0=get(gcbf,''UserData'');' ...
                'temp=str2num( get(temp0(numel(temp0)-2),''String'') );' ...
                'if numel(temp)==1;'...
                  'PZG(1).Gain=temp;' ...
                  'pzgui;' ...
                  'updatepl;' ...
                'end;' ...
                'temp=pzg_fndo(2,13,''fig_h'');' ...
                'if ~isempty(temp);' ...
                  'temp=get(temp,''''UserData'''');' ...
                  'set(temp(14,2),''''Value'''',0);' ...
                'end;' ...
                'clear temp temp0'];
    if ScrSize(3) > 1024
      ScrPos = [485 20 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [370 20 300 250];
    else
      ScrPos = [290 20 240 200];
    end
    rlocuspl( 1, 1, PZG(1).Gain, ...
              PZG(1).RootLocusName, ...
              [],'s', PZG(1).RootLocusName, ...
              ScrPos,'global PZG;rlocuspl(PZG(1).Gain);pzg_ptr;', ...
              Callback );
  end
end

% Update the "pure delay" edit window in main p/z gui
puredelay_h = pzg_fndo( 1, 12,'PZGUI_pure_delay');
if ~isempty(puredelay_h)
  set( puredelay_h,'string', pzg_efmt( PZG(1).PureDelay ) );
end

bodedchkbox = 0;
if ~isempty(gcbo) && strcmpi( get(gcbo,'type'),'uicontrol') ...
  && strcmpi( get(gcbo,'style'),'checkbox') ...
  &&( strcmpi( get(gcbo,'string'),'db') ...
     ||strcmpi( get(gcbo,'string'),'hz') ...
     ||strcmpi( get(gcbo,'string'),'log') ...
     ||strcmpi( get(gcbo,'string'),'unwrap') )
  bodedchkbox = 1;
end


if get(tempUD(14,2),'Value') && ~isequal( 1, bodedchkbox )
  tempVal = get(tempUD(15,2),'Value');
  % Copy over the DC gain, if "Fix DC" is checked.
  DT_DCgain_chkbox_h = pzg_fndo( 1, 13,'Fix_DC_checkbox');
  DCgain_chkbox_h = pzg_fndo( 1, 12,'Fix_DC_checkbox');
  if isequal(1,ishandle(DCgain_chkbox_h)) ...
    && get( DCgain_chkbox_h,'value')
    PZG(2).DCgain = PZG(1).DCgain;
    if isequal(1,ishandle(DT_DCgain_chkbox_h))
      set( DT_DCgain_chkbox_h,'value', 1 )
    end
  elseif isequal(1,ishandle(DT_DCgain_chkbox_h))
    set( DT_DCgain_chkbox_h,'value', 0 )
  end
  
  if tempVal == 1
    % Compute direct conversion of s-plane poles and zeros to z-plane
    % Save the current model in "undo" data.
    undo_info = [];
    undo_info.PoleLocs = PZG(2).PoleLocs;
    undo_info.ZeroLocs = PZG(2).ZeroLocs;
    undo_info.Gain = PZG(2).Gain;
    undo_info.Ts = PZG(2).Ts;
    undo_info.PureDelay = PZG(2).PureDelay;
    undo_info.DCgain = PZG(2).DCgain;
    
    if ~isfield(PZG(2),'undo_info') || ~iscell(PZG(2).undo_info)
      PZG(2).undo_info = {};
    end
    if ~isfield(PZG(2),'undo_info') || ~iscell(PZG(2).undo_info)
      PZG(2).undo_info = {};
    end
    if isempty(PZG(2).undo_info) ...
      ||~isequal( PZG(2).undo_info{end}, undo_info )
      if isempty(gcbo) ...
        || ~strcmp( get(gcbo,'type'),'uicontrol') ...
        || ~isequal(get(gcbo,'string'),'Undo')
        PZG(2).undo_info{end+1} = undo_info;
      end
    end
      
    if ~isempty(PZG(1).ZeroLocs)
      PZG(2).ZeroLocs = exp(PZG(1).ZeroLocs*PZG(1).Ts);
    else
      PZG(2).ZeroLocs = [];
    end
    PZG(2).N = [];
    if ~isempty(PZG(1).PoleLocs)
      PZG(2).PoleLocs = exp(PZG(1).PoleLocs*PZG(1).Ts);
    else
      PZG(2).PoleLocs = [];
    end
    PZG(2).D = [];
    
    if PZG(1).PureDelay > 0
      PZG(2).PureDelay = round( PZG(1).PureDelay / PZG(2).Ts );
    else
      PZG(2).PureDelay = 0;
    end
    
    pndxs = find( abs(PZG(1).PoleLocs) > 1e-10 );
    zndxs = find( abs(PZG(1).ZeroLocs) > 1e-10 );
    nz_ndxs = [ pndxs; zndxs ];
    if isempty( nz_ndxs )
      gain_freq = pi/PZG(2).Ts / 10;
    else
      if ~isempty(pndxs)
        min_pfreq = min( abs( PZG(1).PoleLocs(pndxs) ) )/PZG(2).Ts;
      else
        min_pfreq = pi/PZG(2).Ts;
      end
      if ~isempty(zndxs)
        min_zfreq = min( abs( PZG(1).ZeroLocs(zndxs) ) )/PZG(2).Ts;
      else
        min_zfreq = pi/PZG(2).Ts;
      end
      gain_freq = max( 1e-5, min( min_zfreq, min_pfreq ) )/10;
      gain_freq = min( gain_freq, pi/PZG(2).Ts / 10 );
    end
    ct_gain_at_gf = ...
      exp( log(PZG(1).Gain) ...
           + sum( log( 1i*gain_freq - PZG(1).ZeroLocs ) ) ...
           - sum( log( 1i*gain_freq - PZG(1).PoleLocs ) ) );
    
    gain_uc_pt = exp( 1i * gain_freq * PZG(2).Ts );
    PZG(2).Gain = PZG(1).Gain;
    dt_gain_at_gf = ...
      exp( log(PZG(2).Gain) ...
           + sum( log( gain_uc_pt-PZG(2).ZeroLocs ) ) ...
           - sum( log( gain_uc_pt-PZG(2).PoleLocs ) ) );
    if ~isnan(ct_gain_at_gf) && ~isinf(ct_gain_at_gf) ...
      && ( ct_gain_at_gf ~= 0 ) ...
      &&~isnan(dt_gain_at_gf) && ~isinf(dt_gain_at_gf) ...
      && ( dt_gain_at_gf ~= 0 )
      PZG(2).Gain = PZG(2).Gain * abs( ct_gain_at_gf / dt_gain_at_gf );
    end
    
  elseif tempVal == 2
    % Compute the ZOH-equivalent D-T model.
    % Remove any canceling (or nearly-canceling) pole/zero pairs.
    Z_ct = PZG(1).ZeroLocs;
    P_ct = PZG(1).PoleLocs;
    K_ct = PZG(1).Gain;
    for k = numel(P_ct):-1:1
      pk_dt = exp( P_ct(k)*PZG(1).Ts );
      Z_dt = exp( Z_ct*PZG(1).Ts );
      if any( abs(Z_dt-pk_dt) < 1e-7);
        [ dist, del_ndx ] = min( abs( Z_dt - pk_dt ) ); %#ok<ASGLU>
        P_ct(k) = [];
        Z_ct(del_ndx) = [];
      end
    end
    
    if ~isempty(P_ct)
      if any( imag(P_ct) >= pi/PZG(1).Ts )
        max_freq_hz = max(imag(P_ct))/2/pi;
        max_ts = 0.5/max_freq_hz;
        ans_str = ...
          questdlg( ...
            {'The D-T sample period, "Ts", is too long for this model.'; ...
             ' '; ...
             'There will be aliasing of the pole and/or zero'; ...
             'locations, unless the sample period is reduced.'; ...
             ' '; ...
             'The maximum allowable sample period to avoid aliasing'; ...
             ['in the C-T to D-T conversion is ' num2str(max_ts) ...
              ' seconds.']; ...
             ' '; ...
             'Do you want to proceed with the D-T link?';' '}, ...
            'Sample Period is Too Short', ...
            'Yes, Proceed','No, Cancel D-T Link','No, Cancel D-T Link');
        if ~strcmp( ans_str,'Yes, Proceed')
          if isequal( gcbo, tempUD(14,2) )
            parent_h = gcbf;
            set( gcbo,'value', 0, ...
                'backgroundcolor', get( parent_h,'color') );
          elseif ishandle(tempUD(14,2))
            parent_h = get(tempUD(14,2),'parent');
            set( tempUD(14,2),'value', 0, ...'
                'backgroundcolor', get( parent_h,'color') );
          end
          more_tempUD = get( parent_h,'userdata');
          set( more_tempUD(15,2),'backgroundcolor', get( parent_h,'color') );
          if ishandle(MsgHndl)
            close(MsgHndl)
          end
          return
        end
      end
      
      % NOTE: ZOH conversion rounds delay to nearest multiple
      % of the sample period.  Do the rounding in advance of the
      % conversion, to avoid warnings that are issued otherwise.
      rounded_delay = round(PZG(1).PureDelay/PZG(1).Ts);
      
      % Save the current model in "undo" data.
      undo_info = [];
      undo_info.PoleLocs = PZG(2).PoleLocs;
      undo_info.ZeroLocs = PZG(2).ZeroLocs;
      undo_info.Gain = PZG(2).Gain;
      undo_info.Ts = PZG(2).Ts;
      undo_info.PureDelay = PZG(2).PureDelay;
      undo_info.DCgain = PZG(2).DCgain;
      if ~isempty(gcbo) && strcmp( get(gcbo,'type'),'uicontrol') ...
        && ~isempty( strfind( get(gcbo,'callback'),'Set TS') ) ...
        && ~FromDUPDATE && ~isempty(PZG(1).undo_info)
        ct_undo_info = PZG(1).undo_info{end};
        if isstruct(ct_undo_info) && isfield( ct_undo_info,'Ts')
          undo_info.Ts = ct_undo_info.Ts;
        end
      end
      
      if ~isfield(PZG(2),'undo_info') || ~iscell(PZG(2).undo_info)
        PZG(2).undo_info = {};
      end
      if ~isfield(PZG(2),'undo_info') || ~iscell(PZG(2).undo_info)
        PZG(2).undo_info = {};
      end
      if isempty(PZG(2).undo_info) ...
        ||~isequal( PZG(2).undo_info{end}, undo_info )
        if isempty(gcbo) ...
          || ~strcmp( get(gcbo,'type'),'uicontrol') ...
          || ~strcmp( get(gcbo,'style'),'pushbutton') ...
          || ~strcmp(get(gcbo,'string'),'Undo')
          PZG(2).undo_info{end+1} = undo_info;
        end
      end
      
      quiet = 1;
      ss_mdl_ct = pzg_moda( 1, 1, 0, 0,'', quiet );
      if ~isempty( ss_mdl_ct )
        if isempty(ss_mdl_ct.a)
          ss_mdl_dt = ss_mdl_ct;
          ss_mdl_dt.ts = PZG(2).Ts;
        else
          % Add integrator pole for ZOH-equivalent.
          ABs = [ ss_mdl_ct.a        ss_mdl_ct.b; ...
                  zeros(size(ss_mdl_ct.c))   0  ];
          expABs = expm( ABs * PZG(2).Ts );
          % Compare C-T C matrix to discretized output matrix (with integrator).
          norm_ratio = norm(ss_mdl_ct.c)/norm(expABs(1:end-1,end));
          CDadjust = 1/norm_ratio;
          zzz = tzero( expABs(1:end-1,1:end-1), expABs(1:end-1,end), ...
                       CDadjust*ss_mdl_ct.c, CDadjust*ss_mdl_ct.d );
          ppp = exp( PZG(1).PoleLocs * PZG(2).Ts );
          
          compfreq_ctpt = 1i*1e-6*pi/PZG(2).Ts;
          while any( abs( PZG(1).PoleLocs - compfreq_ctpt ) < 1e-10 ) ...
            || any( abs( PZG(1).ZeroLocs - compfreq_ctpt ) < 1e-10 )
            compfreq_ctpt = 0.95*compfreq_ctpt;
          end
          compfreq_dtpt = exp( compfreq_ctpt*PZG(2).Ts );

          kkk = 1;
          dt_compgain = kkk;
          for kzp = 1:numel(ppp)
            dt_compgain = dt_compgain / ( compfreq_dtpt - ppp(kzp) );
            if numel(zzz) >= kzp
              dt_compgain = dt_compgain * ( compfreq_dtpt - zzz(kzp) );
            end
          end
          
          ct_compgain = PZG(1).Gain;
          for kzp = 1:numel(PZG(1).PoleLocs)
            ct_compgain = ...
              ct_compgain / ( compfreq_ctpt - PZG(1).PoleLocs(kzp) );
            if numel(PZG(1).ZeroLocs) >= kzp
              ct_compgain = ...
                ct_compgain * ( compfreq_ctpt - PZG(1).ZeroLocs(kzp) );
            end
          end
          
          kkk = real( kkk * ct_compgain / dt_compgain );
        end
      else
        zzz = [];
        ppp = [];
        kkk = [];
      end      
      if isempty(zzz) && isempty(ppp) && isempty(kkk)
        % Use the "fallback" method.
        try
          zpk_mdl = zpk( Z_ct, P_ct, K_ct,'inputdelay', PZG(1).PureDelay );
          zpk_mdl_dt = c2d( zpk_mdl, PZG(1).Ts,'zoh');

        catch  %#ok<CTCH>
          if ~isempty(gcbo) && strcmpi('checkbox', get(gcbo,'style') )
            set(gcbo,'value', 0 )
          end
          wait_h = findobj( allchild(0),'name','CALCULATING');
          delete(wait_h)
          PZG(2).undo_info(end) = [];
          % Unlink the models.
          linkcb_h = pzg_fndo( 1, 12,'LinkCheckbox');
          if ~isempty(linkcb_h)
            set( linkcb_h,'value', 0, ...
                'backgroundcolor', get( get(linkcb_h,'parent'),'color') );
            linkmenu_h = pzg_fndo( 1, 12,'LinkMethod');
            if ~isempty(linkmenu_h)
              set( linkmenu_h, ...
                  'backgroundcolor', get( get(linkmenu_h,'parent'),'color') );
            end
          end
        
          temp = lasterror; %#ok<LERR>
          errdlg_h = ...
            errordlg({'Matlab function "C2D" unable to execute.'; ...
                      ' '; temp.message; ...
                      ' ';'    Click "OK" to continue ...';' '}, ...
                     'Error Calling "C2D"','modal');
          uiwait(errdlg_h)
          return
        end
        disp('pzgui:  ZOH-equivalent conversion may have accuracy issues.')
        PZG(2).ZeroLocs = zpk_mdl_dt.z{1};
        PZG(2).PoleLocs = zpk_mdl_dt.p{1};
        PZG(2).Gain = zpk_mdl_dt.k;
      else
        [ tempz, sortndx ] = sort( -abs( angle(zzz) ) ); %#ok<ASGLU>
        zzz = zzz(sortndx);
        PZG(2).ZeroLocs = zzz;
        PZG(2).PoleLocs = ppp;
        PZG(2).Gain = kkk;
      end
      PZG(2).PureDelay = rounded_delay;
      
      % Replace very-LF zeros by their direct c2d mappings
      vLF = 1e-4*2*pi/PZG(2).Ts;
      vLF_ct_zeros = PZG(1).ZeroLocs( abs(PZG(1).ZeroLocs) < vLF );
      vlf_esT_zeros = exp( vLF_ct_zeros * PZG(2).Ts );
      d2c_z = log(PZG(2).ZeroLocs)/PZG(2).Ts;
      dtz_freqs = abs(d2c_z);
      [ temp, sortndx ] = sort(dtz_freqs);   %#ok<ASGLU>
      dt_vlf_ndxs = sortndx(1:numel(vlf_esT_zeros));
      vlf_dt_zeros = PZG(2).ZeroLocs(dt_vlf_ndxs);
      if ~mod( sum( imag(vlf_dt_zeros) ~= 0 ), 2 )
        PZG(2).ZeroLocs(dt_vlf_ndxs) = vlf_esT_zeros;
      end
      
      % Equalize the number of non-minimum-phase zeros in large models.
      if numel(PZG(1).PoleLocs) > 20
        ct_nmp_ndx = ...
          find( ( real(PZG(1).ZeroLocs) > 0 ) & imag(PZG(1).ZeroLocs) ~= 0 );
        dt_nmp_ndx = ...
          find( ( abs(PZG(2).ZeroLocs) > 1 ) & imag(PZG(2).ZeroLocs) ~= 0 );
        if ~isempty(ct_nmp_ndx) && ( numel(dt_nmp_ndx) > numel(ct_nmp_ndx) )
          ct_nmp_zeros = PZG(1).ZeroLocs(ct_nmp_ndx);
          [ ct_nmp_freqs, sortndx ] = sort( abs(imag(ct_nmp_zeros)) );
          ct_nmp_ndx = ct_nmp_ndx(sortndx);
          dt_nmp_zeros = PZG(2).ZeroLocs(dt_nmp_ndx);
          [ dt_nmp_freqs, sortndx ] = ...
              sort( abs(angle(dt_nmp_zeros))/PZG(2).Ts );
          dt_nmp_ndx = dt_nmp_ndx(sortndx);
          % Eliminate DT NMP zeros nearest CT NMP zeros
          for knm = numel(ct_nmp_freqs):-1:1
            [ delfreq, closest_ndx ] = ...
                min( abs( ct_nmp_freqs(knm) - dt_nmp_freqs ) ); %#ok<ASGLU>
            dt_nmp_freqs(closest_ndx) = [];
            dt_nmp_ndx(closest_ndx) = [];
            ct_nmp_freqs(knm) = [];
            ct_nmp_ndx(knm) = [];
          end
          for knm = 1:numel(dt_nmp_ndx)
            PZG(2).Gain = ...
              PZG(2).Gain ...
              *abs(1-PZG(2).ZeroLocs(dt_nmp_ndx(knm))) ...
              /abs(1-1/PZG(2).ZeroLocs(dt_nmp_ndx(knm)));
            PZG(2).ZeroLocs(dt_nmp_ndx(knm)) = ...
              conj( 1/PZG(2).ZeroLocs(dt_nmp_ndx(knm)) );
          end
        end
      end
      
      % Equalize the number of integrator poles.
      if sum( PZG(1).PoleLocs == 0 )
        nr_s_integ_poles = sum( abs(PZG(1).PoleLocs) < 1e-10 );
        z_integ_ndxs = find( abs( PZG(2).PoleLocs - 1 ) < 1e-10 );
        if numel(z_integ_ndxs) == nr_s_integ_poles
          % If every selected pole is either real-valued or part of a pair:
          if ~mod( sum( imag(PZG(2).PoleLocs(z_integ_ndxs)) ~= 0 ), 2 )
            PZG(2).PoleLocs(z_integ_ndxs(1:nr_s_integ_poles)) = 1;
          end
        end
      end
      
      compfreq_ctpt = 1i*1e-6*pi/PZG(2).Ts;
      while any( abs( PZG(1).PoleLocs - compfreq_ctpt ) < 1e-10 ) ...
        || any( abs( PZG(1).ZeroLocs - compfreq_ctpt ) < 1e-10 )
        compfreq_ctpt = 0.95*compfreq_ctpt;
      end
      compfreq_dtpt = exp( compfreq_ctpt*PZG(2).Ts );

      kkk = PZG(2).Gain;
      dt_compgain = kkk;
      for kzp = 1:numel(ppp)
        dt_compgain = dt_compgain / abs( compfreq_dtpt - ppp(kzp) );
        if numel(zzz) >= kzp
          dt_compgain = dt_compgain * abs( compfreq_dtpt - zzz(kzp) );
        end
      end

      ct_compgain = PZG(1).Gain;
      for kzp = 1:numel(PZG(1).PoleLocs)
        ct_compgain = ...
          ct_compgain / abs( compfreq_ctpt - PZG(1).PoleLocs(kzp) );
        if numel(PZG(1).ZeroLocs) >= kzp
          ct_compgain = ...
            ct_compgain * abs( compfreq_ctpt - PZG(1).ZeroLocs(kzp) );
        end
      end

      kkk = kkk * ct_compgain / dt_compgain; %#ok<NASGU>
          
      PZG(2).N = [];
      PZG(2).D = [];
    else
      PZG(2).ZeroLocs = [];
      PZG(2).PoleLocs = [];
      PZG(2).Gain = PZG(1).Gain;
      PZG(2).N = [];
      PZG(2).D = [];
    end
    pzg_cntr(2);
    pzg_bodex(2);
    if ~dupdatep_called
      dupdatep(1);
      dupdatep_called = 1;
    end
  else
    % Compute the D-T model via bilinear transformation.
    % Remove any canceling (or nearly-canceling) pole/zero pairs.
    Z_ct = PZG(1).ZeroLocs;
    P_ct = PZG(1).PoleLocs;
    K_ct = PZG(1).Gain;
    for k = numel(P_ct):-1:1
      pk_dt = exp( P_ct(k)*PZG(1).Ts );
      Z_dt = exp( Z_ct*PZG(1).Ts );
      if any( abs(Z_dt-pk_dt) < 1e-7);
        [ dist, del_ndx ] = min( abs( Z_dt - pk_dt ) ); %#ok<ASGLU>
        P_ct(k) = [];
        Z_ct(del_ndx) = [];
      end
    end
    
    % NOTE: Tustin conversion rounds delay to nearest multiple
    % of the sample period.  Do the rounding in advance of the
    % conversion, to avoid warnings that are issued otherwise.
    rounded_delay = ...
      round(PZG(1).PureDelay/PZG(1).Ts) * PZG(1).Ts;
    
    % Check that the frequencies for FRF plotting include at least the 
    % same region as the DT frequencies.
    if ~isempty(PZG(2).BodeFreqs) ...
      &&( ( PZG(2).BodeFreqs(end) < PZG(1).BodeFreqs(end) ) ...
         ||( PZG(2).BodeFreqs(1) > PZG(1).BodeFreqs(1) ) )
      PZG(2).recompute_frf = 1;
    end
    
    % Save the current model in "undo" data.
    undo_info = [];
    undo_info.PoleLocs = PZG(2).PoleLocs;
    undo_info.ZeroLocs = PZG(2).ZeroLocs;
    undo_info.Gain = PZG(2).Gain;
    undo_info.Ts = PZG(2).Ts;
    undo_info.PureDelay = PZG(2).PureDelay;
    undo_info.DCgain = PZG(2).DCgain;
    if strcmp( get(gcbo,'type'),'uicontrol') ...
      && ~isempty( strfind( get(gcbo,'callback'),'Set TS') ) ...
      && ~FromDUPDATE && ~isempty(PZG(1).undo_info)
      ct_undo_info = PZG(1).undo_info{end};
      if isstruct(ct_undo_info) && isfield( ct_undo_info,'Ts')
        undo_info.Ts = ct_undo_info.Ts;
      end
    end
    
    if ~isfield(PZG(2),'undo_info') || ~iscell(PZG(2).undo_info)
      PZG(2).undo_info = {};
    end
    if isempty(PZG(2).undo_info) ...
      ||~isequal( PZG(2).undo_info{end}, undo_info )
      if isempty(gcbo) ...
        || ~strcmp( get(gcbo,'type'),'uicontrol') ...
        || ~strcmp( get(gcbo,'style'),'pushbutton') ...
        || ~strcmp(get(gcbo,'string'),'Undo')
        PZG(2).undo_info{end+1} = undo_info;
      end
    end
    PZG(2).recompute_frf = 1;
    
    PZG(2).PureDelay = rounded_delay;
    
    quiet = 1;
    ss_mdl_dt = pzg_moda( 2, 0, 0, 0,'tustin', quiet );
    if ~isempty( ss_mdl_dt )
      [ zzz, ppp, kkk ] = ...
          ss2zp( ss_mdl_dt.a, ss_mdl_dt.b, ss_mdl_dt.c, ss_mdl_dt.d, 1 );
        
      nr_diff_zeros = sum( abs(PZG(1).ZeroLocs) < 1e-10 );
      if nr_diff_zeros > 0
        % Map the same number of zeros to s = 0.
        [ temp_mags, sortndx ] = sort( abs( zzz - 1 ) ); %#ok<ASGLU>
        zzz( sortndx(1:nr_diff_zeros) ) = 1;
      end
    else
      zzz = [];
      ppp = [];
      kkk = [];
    end
    if isempty(zzz) && isempty(ppp) && isempty(kkk)
      % Use the "fallback" method.
      try
        zpk_mdl = zpk( Z_ct, P_ct, K_ct,'inputdelay', rounded_delay );
        zpk_mdl_dt = c2d( zpk_mdl, PZG(1).Ts,'tustin');
      catch  %#ok<CTCH>
        if ~isempty(gcbo) && strcmpi('checkbox', get(gcbo,'style') )
          set(gcbo,'value', 0 )
        end
        wait_h = findobj( allchild(0),'name','CALCULATING');
        close(wait_h)
        temp = lasterror; %#ok<LERR>
        errdlg_h = ...
          errordlg({'Matlab function "C2D" unable to execute.'; ...
                    ' '; temp.message; ...
                    ' ';'    Click "OK" to continue ...';' '}, ...
                   'Error Calling "C2D"','modal');
        uiwait(errdlg_h)
        return
      end
      disp('pzgui:  bilinear transformation may have accuracy issues.')
      PZG(2).ZeroLocs = zpk_mdl_dt.z{1};
      PZG(2).PoleLocs = zpk_mdl_dt.p{1};
      PZG(2).Gain = zpk_mdl_dt.k;
    else
      PZG(2).ZeroLocs = zzz;
      PZG(2).PoleLocs = ppp;
      PZG(2).Gain = kkk;
    end
    
    % Update the dpzgui "Gain" window.
    gain_h = pzg_fndo( 2, 13,'zpk_gain_entry_window');
    set( gain_h,'string', pzg_efmt( kkk ) );
    
    % Remove zeros that are essentially infinite.
    for Ck = numel(PZG(2).ZeroLocs):-1:1
      if isreal(PZG(2).ZeroLocs(Ck)) && ( abs(PZG(2).ZeroLocs(Ck)) > 1e10 )
        if real(PZG(2).ZeroLocs(Ck)) > 1e9
          PZG(2).Gain = -PZG(2).Gain;
        end
        PZG(2).ZeroLocs(Ck)=[];
       end
    end        
    PZG(2).N = [];
    PZG(2).D = [];
    pzg_cntr(2);
    pzg_bodex(2);
    if ~dupdatep_called
      dupdatep(1);
      dupdatep_called = 1;
    end
  end
  delay_h = pzg_fndo( 2, 13,'PZGUI_pure_delay');
  if ~isempty(delay_h)
    set( delay_h,'string', pzg_efmt(PZG(2).PureDelay) );
  end

  for Ck = 1:numel(PZG(2).PoleLocs)
    if abs(1-PZG(2).PoleLocs(Ck)) < 1e-11
      PZG(2).PoleLocs(Ck) = 1;
    end
  end

  if isempty(PZG(1).PoleLocs)
    if isempty(PZG(1).ZeroLocs)
      temp = 0;
    elseif ~sum(PZG(1).ZeroLocs==0)
      temp = 0;
    else
      temp = PZG(1).BodeFreqs(1);
    end
  elseif isempty(PZG(1).ZeroLocs)
    if isempty(PZG(1).PoleLocs)
      temp = 0;
    elseif ~sum(PZG(1).PoleLocs==0)
      temp = 0;
    else
      temp = PZG(1).BodeFreqs(1);
    end
  elseif ~sum(PZG(1).PoleLocs==0) ...
       &&~sum(PZG(1).ZeroLocs==0)
    temp = 0;
  else
    temp = PZG(1).BodeFreqs(1);
  end
  s_temp = temp; %#ok<NASGU>
  
  clear i
  z_temp = exp(1i*temp*PZG(1).Ts);
  tempGain = ...
    PZG(2).Gain * 10^( sum( log10(abs(z_temp-PZG(2).ZeroLocs) ) ) ...
                      -sum( log10(abs(z_temp-PZG(2).PoleLocs) ) ) );

  if tempVal==3
    s_temp = 1i*2*imag(z_temp)/(PZG(1).Ts*(1+real(z_temp)));
  else
    s_temp = log(z_temp)/PZG(1).Ts;
  end
  tempSGain = abs(PZG(1).Gain) ...
    * 10^( sum( log10(abs(s_temp-PZG(1).ZeroLocs) ) ) ...
          -sum( log10(abs(s_temp-PZG(1).PoleLocs) ) ) );
        
  gain_adjust = ( tempSGain/tempGain )/PZG(1).Ts;          %#ok<NASGU>
  %PZG(2).Gain = PZG(2).Gain * gain_adjust;
  
  if ~isempty( DT_PZGUI ) && ~FromDUPDATE
    tempUDT = get( DT_PZGUI,'UserData' );
    set( tempUDT(1,2),'String', pzg_efmt(PZG(2).Gain,6) )
    set( tempUDT(14,2),'Value',0 )
    if get(tempUD(14,2),'Value') ...
      && tempUD(11,1) && tempUDT(11,1)
      tempX = zeros( numel( get(tempUD(11,1),'Xdata') ), 6 );
      tempY = zeros(size(tempX));
      for Dk=1:6
        tempX(:,Dk) = get(tempUD(Dk+10,1),'Xdata')';
        tempY(:,Dk) = get(tempUD(Dk+10,1),'Ydata')';
      end
      if get(tempUD(15,2),'Value')==3
        temp = 2 - (tempX+1i*tempY)*PZG(1).Ts;
        if sum(abs(temp)<eps)>0
          Ndx = flipud( sort(temp==0) ); %#ok<FLPST>
          for Ck = 1:numel(Ndx)
            if Ndx(Ck)>1
              temp(Ndx(Ck)) = temp(Ndx(Ck-1))/10;
            else
              temp(1) = temp(2)/10;
            end
          end
        end
        tempZ = (2+(tempX+1i*tempY)*PZG(1).Ts)./temp;
      else
        tempZ = exp((tempX+1i*tempY)*PZG(1).Ts);
      end
      tempX = real(tempZ);
      tempY = imag(tempZ);
      for Ck = 1:6
        set( tempUDT(Ck+10,1), ...
            'XData',tempX(:,Ck), ...
            'YData',tempY(:,Ck) );
      end
    end
  end
  
  if ~isempty(gcbf) && ~isempty(gcbo) ...
    && isequal( get(gcbf,'name'),'Continuous-Time P/Z Map G.U.I.') ...
    && isequal( get(gcbo,'type'),'uicontrol') ...
    && isequal( get(gcbo,'string'),'D-T Link by:') ...
    && isequal( get(gcbo,'value'), 1 )
    % The D-T link has just been activated.
    
    which_tool = pzg_tools(2);
    if any(which_tool)
      if isfield( PZG(2),'Gain_fig') && ishandle(PZG(2).Gain_fig)
        if ~isempty(PZG(2).Gain_fig)
          close(PZG(2).Gain_fig)
        end
      end
      if isfield( PZG(2),'LDLG_fig') && ishandle(PZG(2).LDLG_fig)
        if ~isempty(PZG(2).LDLG_fig)
          close(PZG(2).LDLG_fig)
        end
      end
      if isfield( PZG(2),'PID_fig')
        if ~isempty(PZG(2).PID_fig) && ishandle(PZG(2).PID_fig)
          close(PZG(2).PID_fig)
        end
      end
    end
    
    % Link Lead-Lag design, if available.
    if isfield(PZG(1),'LeadLag') ...
      && iscell(PZG(1).LeadLag) ...
      &&( numel(PZG(1).LeadLag) == 6 )
      % Get C-T system.
      Gain = PZG(1).LeadLag{4};
      Pole = PZG(1).LeadLag{5};
      Zero = PZG(1).LeadLag{6};
      if ~isempty(Pole) && ~isempty(Zero) && ~isempty(Gain) ...
        && isreal(Pole) && isreal(Zero) && isreal(Gain) ...
        && ~isinf(Pole) && ~isinf(Zero) && ~isinf(Gain) ...
        && ~isnan(Pole) && ~isnan(Zero) && ~isnan(Gain) ...
        && ( Pole < 0 ) && ( Zero < 0 ) && ( Gain > 0 ) ...
        && ( max(abs([Pole,Zero])) < pi/2/PZG(2).Ts )
        DCgain = Gain*Zero/Pole;
      
        zPole = ( 2 + Pole * PZG(2).Ts ) / ( 2 - Pole * PZG(2).Ts );
        zZero = ( 2 + Zero * PZG(2).Ts ) / ( 2 - Zero * PZG(2).Ts );
        zGain = DCgain * (1-zPole) / (1-zZero);
        
        nyqGain = zGain*(-1-zZero)/(-1-zPole);
        
        testAngle = logspace( log10(pi*1e-6), log10(pi), 600000 )';
        testPts = exp(1i*testAngle);
        testFrf = zGain*(testPts-zZero)./(testPts-zPole);

        if nyqGain > DCgain
          crossNdx = sum( abs(testFrf) <= 1 );
          [ temp, extrmPhsNdx ] = max( angle(testFrf) ); %#ok<ASGLU>
        else
          crossNdx = sum( abs(testFrf) >= 1 );
          [ temp, extrmPhsNdx ] = min( angle(testFrf) ); %#ok<ASGLU>
        end
        zCtrFrq = testAngle(extrmPhsNdx)/PZG(2).Ts;
        zExtrmPhs = 180/pi * angle( testFrf(extrmPhsNdx) );
        if ( crossNdx < 1 ) || ( crossNdx == numel(testPts) )
          zGainCross = [];
        else
          zGainCross = testAngle(crossNdx)/PZG(2).Ts;
        end
        clear testAngle testPts testFrf
        
        PZG(2).LeadLag = cell(6,1);
        PZG(2).LeadLag{1} = zExtrmPhs;
        PZG(2).LeadLag{2} = zCtrFrq;
        PZG(2).LeadLag{3} = zGainCross;
        PZG(2).LeadLag{4} = zGain;
        PZG(2).LeadLag{5} = zPole;
        PZG(2).LeadLag{6} = zZero;
      end
    end
    
    % Link PID design, if available and if necessary.
    if isfield(PZG(1),'PID') ...
      && iscell(PZG(1).PID) ...
      &&( numel(PZG(1).PID) == 7 )
      % Get C-T system.
      Gain = PZG(1).PID{4};
      Zero1 = PZG(1).PID{5};
      Zero2 = PZG(1).PID{6};
      Pole2 = PZG(1).PID{7};
      if ~isempty(Gain) && ~isempty(Zero1) ...
        && ~isempty(Zero2) && ~isempty(Pole2) ...
        && ( real(Zero1) < 0 ) && ( real(Zero2) < 0 ) ...
        && isreal(Pole2) && ( real(Pole2) < 0 ) ...
        &&( ( isreal(Zero1) && isreal(Zero2) ) ...
           ||( abs( Zero1 - conj(Zero2) ) < 1e-14 ) )
        lf_jw = 1i*abs(min(real([Zero1,Zero2])))/100;
        lf_jw_mag = abs( Gain*(lf_jw-Zero1)*(lf_jw-Zero2)/lf_jw );

        zZero1 = ( 2 + Zero1 * PZG(2).Ts ) / ( 2 - Zero1 * PZG(2).Ts );
        zZero2 = ( 2 + Zero2 * PZG(2).Ts ) / ( 2 - Zero2 * PZG(2).Ts );
        
        lf_uc = exp(lf_jw*PZG(2).Ts);
        lf_uc_mag_wo_gainfactor = ...
          abs( (lf_uc-zZero1)*(lf_uc-zZero2)/(lf_uc-1) );
        zGain =  lf_jw_mag/ lf_uc_mag_wo_gainfactor;

        NUM = zGain * real(poly([zZero1,zZero2]));
        DerivGain = NUM(3) * PZG(2).Ts;
        PropGain = NUM(1) - NUM(3);
        IntegGain = sum(NUM) / PZG(2).Ts;
        
        PZG(2).PID = cell(7,1);
        PZG(2).PID{1} = PropGain;
        PZG(2).PID{2} = IntegGain;
        PZG(2).PID{3} = DerivGain;
        PZG(2).PID{4} = zGain;
        PZG(2).PID{5} = zZero1;
        PZG(2).PID{6} = zZero2;
        PZG(2).PID{7} = 0;
      end
    end
    
    DT_PZGUI = pzg_fndo( 2, 13,'fig_h');
    if ~isempty(DT_PZGUI)
      dtFixDC_checkbox_h = pzg_fndo( 2, 13,'Fix_DC_checkbox');
      if ~isempty(dtFixDC_checkbox_h)
        set( dtFixDC_checkbox_h,'value', 0 );
      end
    end
  end
  
  PZG(2).recompute_frf = 0;
  if ~dupdatep_called
    pzg_cntr(2);
    pzg_bodex(2);
  end
  dpzgui
  if ~dupdatep_called
    dupdatep(1);
    dupdatep_called = 1;  %#ok<NASGU>
  end
  
  if strcmpi( get( gcbo,'tag'),'pzgui Link Checkbox') ...
    && isequal( 1, get(gcbo,'value') )
    pzg_onoff(0);
    msgbox_h = ...
      msgbox( ...
        {'The D-T model is now linked to the C-T model.'; ...
         ' '; ...
         'Changes made in the C-T model will be'; ...
         'automatically propagated to the D-T model.'; ...
         ' ';'    Click "OK" to continue.'}, ...
        'pzgui Advisory','modal');
    uiwait(msgbox_h)
  end
end

nrp_h = pzg_fndo( 1, 12,'CT_number_of_poles');
if ~isempty(nrp_h)
  nr_poles = numel(PZG(1).PoleLocs);
  nr_poles_str = [ num2str(nr_poles) ' POLES'];
  if nr_poles == 0
    nr_poles_str = 'NO POLES';
  elseif nr_poles == 1
    nr_poles_str = '1 POLE';
  end
  set( nrp_h,'string', nr_poles_str );
end
nrz_h = pzg_fndo( 1, 12,'CT_number_of_zeros');
if ~isempty(nrz_h)
  nr_zeros = numel(PZG(1).ZeroLocs);
  nr_zeros_str = [ num2str(nr_zeros) ' ZEROS'];
  if nr_zeros == 0
    nr_zeros_str = 'NO ZEROS';
  elseif nr_zeros == 1
    nr_zeros_str = '1 ZERO';
  end
  set( nrz_h,'string', nr_zeros_str );
end

updtpzln('s')
local_update_pid_ldlg

pzg_unre;

if ~isempty(CT_PZGUI)
  pzg_grid( get(CT_PZGUI,'userdata'), CT_PZGUI, ...
            PZG(1).plot_h{12}.ax_h, 12, PZG(1).plot_h{12}.hndl );
end
ct_rloc_h = pzg_fndo( 1, 10,'fig_h');
if ~isempty(ct_rloc_h)
  pzg_grid( get(ct_rloc_h,'userdata'), ct_rloc_h, ...
            PZG(1).plot_h{10}.ax_h, 10, PZG(1).plot_h{10}.hndl );
end

pzg_bkup

if exist('MsgHndl','var') && isequal( 1, ishandle(MsgHndl) )
  delete(MsgHndl)
end

return

function local_update_pid_ldlg
  curr_tools = pzg_tools(1);
  if curr_tools(1)
    gainfilt('s-Domain Pure Gain Design GUI');    
  elseif curr_tools(2)
    ldlgfilt('s-Domain Lead Lag Design GUI');
  elseif curr_tools(3)
    pidfilt('s-Domain PID Design GUI');
  end
return
