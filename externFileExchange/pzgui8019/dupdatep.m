function  dupdatep( FromUPDATEPL )
% Updates discrete-time plots after zpk model is modified.
% Coordinates maintenance of the various PZGUI discrete-time
% frequency-domain, Z-plane, and time-response plots.

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

pzg_bkup
evalin('base','global PZG')

temppzmove_h = ...
  [ pzg_fndo( 1,[(1:10),12,14],'pzmove_temporary_line'); ...
    pzg_fndo( 2,[(1:9),11,13,14],'pzmove_temporary_line'); ...
    pzg_fndo( (1:2),(8:9),'pzmove_temporary_forc_line'); ...
    pzg_fndo( (1:2),(8:9),'pzmove_temporary_natl_line') ];
if ~isempty(temppzmove_h)
  set(temppzmove_h,'visible','off')
end

if ~isempty(gcbo) && isequal( get(gcbo,'type'),'uicontrol')
  if ~isempty( strfind( get(gcbo,'callback'),'Erase') )
    return
  end
end

updatepl_called = 0;

prev_msg_h = findobj( allchild(0),'name','CALCULATING');
if isempty(prev_msg_h)
  MsgHndl = ...
    msgbox('Computation may take a minute.   Please wait ...', ...
           'CALCULATING');
  %pause(0.1)
  %drawnow
  if isequal( 1, ishandle(MsgHndl) )
    temp=findobj(MsgHndl,'Tag','OKButton');
    if ~isempty(temp)
      delete(temp(1))
    end
  end
else
  MsgHndl = prev_msg_h(1);
  if numel(prev_msg_h) > 1
    delete(prev_msg_h(2:end))
  end
end

CT_PZGUI = pzg_fndo( 1, 12,'fig_h');
DT_PZGUI = pzg_fndo( 2, 13,'fig_h');

if nargin < 1
  FromUPDATEPL = 0;
end

% Update the contour information.
if ~isequal( PZG(2).recompute_frf, 0 ) ...
  || ~isfield( PZG(2),'cntr_data') ...
  || isempty( PZG(2).cntr_data ) ...
  ||~isstruct( PZG(2).cntr_data ) ...
  ||~isfield( PZG(2).cntr_data,'contour_freq')
  PZG(2).recompute_frf = 0;
  pzg_cntr(2);
  pzg_bodex(2)
  dpzgui;
end
evalin('base','clear PZMoving');

tempUDZ = get(DT_PZGUI,'UserData');

if ~isempty(CT_PZGUI)
  tempUDS = get(CT_PZGUI,'UserData');
  % Is the C-T link checked?
  if ~isempty(tempUDZ) && get(tempUDZ(14,2),'Value')
    % Uncheck the C-T map's link to D-T:
      set( tempUDS(14,2),'Value',0 );
      temp = ...
        [ pzg_fndo( 1,[10;12],'bode_comp_pole_lines'); ...
          pzg_fndo( 1,[10;12],'bode_comp_zero_lines'); ...
          pzg_fndo( 1,[10;12],'bode_comp_pole_text'); ...
          pzg_fndo( 1,[10;12],'bode_comp_zero_text'); ...
          pzg_fndo( 1,[10;12],'bode_comp_freq_text') ];
      if ~isempty(temp)
        set(temp,'visible','off')
      end
  end
end

ScrSize = get(0,'ScreenSize');

%LogChk = pzg_islogx;
DBchk = pzg_isdby;
HZchk = pzg_ishzx;
unwrap_value = pzg_isunwrp;

pzmap_gui = pzg_fndo( 2, 13,'fig_h');

if ~isempty(pzmap_gui)
end

cl_mag_h = pzg_fndo( 2, 3,'fig_h');
if ~isempty(cl_mag_h)
  if get( tempUDZ(2,2),'Value') == 1
    if ScrSize(3) > 1024
      ScrPos = [10 700 335 280];
    elseif ScrSize(3) > 800;
      ScrPos = [10 520 270 210];
    else
      ScrPos = [10 410 220 160];
    end
    bodepl( PZG(2).BodeFreqs,PZG(2).BodeMag,PZG(2).BodePhs, ...
            PZG(2).OLBodeName,PZG(2).FrqSelNdx, ...
            PZG(2).OLBodeName,ScrPos, ...
            ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
             'catch,pzg_err(''''button down'''');' ...
             'end,clear tempfs;']);
    if ( ~isempty(gcbf) && ~isempty(gcbo) && ( gcbf == gcbo ) ) ...
      ||( ~isempty(gcbo) && strcmp( get(gcbo,'type'),'uicontrol') ...
         && ~isempty( strfind( get(gcbo,'callback'),'unwrap checkbox') ) )
      olphs_fig_h = pzg_fndo( 2, 2,'fig_h');
      if ~isempty(olphs_fig_h)
        curr_tools = pzg_tools(2);
        if curr_tools(1)
          pid_ldlg_h = pzg_fndo( 2, 2,'Gain_Preview');
        elseif curr_tools(2)
          pid_ldlg_h = pzg_fndo( 2, 2,'LDLG_Preview');
        elseif curr_tools(3)
          pid_ldlg_h = pzg_fndo( 2, 2,'PID_Preview');
        else
          pid_ldlg_h = [];
        end
        for k = 1:numel(pid_ldlg_h)
          this_phase = (pi/180) * get( pid_ldlg_h(k),'ydata');
          if unwrap_value
            new_phase = (180/pi) * unwrap( this_phase );
            % "Fold" the phase at multiples of Nyquist freq.
            this_freq = PZG(2).BodeFreqs;
            gle_ndx = pzg_gle( this_freq, pi/PZG(2).Ts,'<');
            if numel(this_freq) == 4*gle_ndx
              basic_phs = new_phase(1:gle_ndx);
              new_phase = [ basic_phs, -fliplr(basic_phs) ];
              new_phase = [ new_phase, new_phase ]; %#ok<AGROW>
            end
          else
            new_phase = (180/pi) * angle( exp(1i*this_phase) );
          end
          set( pid_ldlg_h(k),'ydata', new_phase );
        end
      end
    end
  end
  if get( tempUDZ(3,2),'Value') == 1
    if ScrSize(3) > 1024
      ScrPos = [350 700 335 280];
    elseif ScrSize(3) > 800;
      ScrPos = [275 520 270 210];
    else
      ScrPos = [235 410 220 160];
    end
    bodepl(PZG(2).CLBodeFreqs, PZG(2).CLBodeMag, PZG(2).CLBodePhs, ...
           PZG(2).CLBodeName, PZG(2).FrqSelNdx, ...
           PZG(2).CLBodeName,ScrPos, ...
           ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
            'catch,pzg_err(''''button down'''');' ...
            'end,clear tempfs;']);
    if ( ~isempty(gcbf) && isequal(gcbf,gcbo) ) ...
      ||( ~isempty(gcbo)  && strcmp( get(gcbo,'type'),'uicontrol') ...
         && ~isempty( strfind( get(gcbo,'callback'),'unwrap checkbox') ) )
      clphs_fig_h = pzg_fndo( 2, 4,'fig_h');
      if ~isempty(clphs_fig_h)
        curr_tools = pzg_tools(2);
        if curr_tools(1)
          pid_ldlg_h = pzg_fndo( 2, 4,'Gain_Preview');
        elseif curr_tools(2)
          pid_ldlg_h = pzg_fndo( 2, 4,'LDLG_Preview');
        elseif curr_tools(3)
          pid_ldlg_h = pzg_fndo( 2, 4,'PID_Preview');
        else
          pid_ldlg_h = [];
        end
        for k = 1:numel(pid_ldlg_h)
          this_phase = (pi/180) * get( pid_ldlg_h(k),'ydata');
          if unwrap_value
            new_phase = (180/pi) * unwrap( this_phase );
            % "Fold" the phase at multiples of Nyquist freq.
            this_freq = PZG(2).BodeFreqs;
            gle_ndx = pzg_gle( this_freq, pi/PZG(2).Ts,'<');
            if numel(this_freq) == 4*gle_ndx
              basic_phs = new_phase(1:gle_ndx);
              new_phase = [ basic_phs, -fliplr(basic_phs) ];
              new_phase = [ new_phase, new_phase ]; %#ok<AGROW>
            end
          else
            new_phase = (180/pi) * angle( exp(1i*this_phase) );
          end
          set( pid_ldlg_h(k),'ydata', new_phase );
        end
      end
    end
  end
end

ol_mag_h = pzg_fndo( 2, 1,'fig_h');
if ~isempty(ol_mag_h)
  tfemag_h = pzg_fndo( 2, 1,'TFE_Mag_line');
  tfedelmag_h = pzg_fndo( 2, 1,'TFE_Delta_Mag_line');
  vis_chkbox_h = pzg_fndo( 2, 1,'TFE_data_visibility_checkbox');
  delta_vis_chkbox_h = pzg_fndo( 2, 1,'TFE_delta_visibility_checkbox');
  if ~isempty(PZG(2).TFEFreqs) ...
    &&~isempty(PZG(2).TFEMag) ...
    &&( numel(PZG(2).TFEMag) == numel(PZG(2).TFEFreqs) )
    ol_mag_ax_h = pzg_fndo( 2, 1,'ax');
    x_data = PZG(2).TFEFreqs;
    if HZchk
      x_data = x_data/2/pi;
    end
    x_data = x_data(:);
    if isempty(vis_chkbox_h)
      vis_chkbox_h = ...
        uicontrol( ol_mag_h,'style','checkbox', ...
          'units','normalized', ...
          'position',[0.69 0.001 0.149 0.05], ...
          'string','Show TFE', ...
          'value', 1, ...
          'backgroundcolor',[0 0.7 0], ...
          'tag','TFE data visibility checkbox', ...
          'callback','dupdatep');
      PZG(2).plot_h{1}.hndl.TFE_data_visibility_checkbox = vis_chkbox_h;
      data_vis = 1;
    else
      set( vis_chkbox_h,'visible','on');
      data_vis = get( vis_chkbox_h,'value');
    end
    if isempty(delta_vis_chkbox_h)
      delta_vis_chkbox_h = ...
        uicontrol( ol_mag_h,'style','checkbox', ...
          'units','normalized', ...
          'position',[0.85 0.001 0.149 0.05], ...
          'string','Show Diff', ...
          'value', 0, ...
          'backgroundcolor',[0 0.7 0], ...
          'tag','TFE delta visibility checkbox', ...
          'callback','dupdatep');
      PZG(2).plot_h{1}.hndl.TFE_delta_visibility_checkbox = delta_vis_chkbox_h;
      delta_vis = 0;
    else
      set( delta_vis_chkbox_h,'visible','on');
      delta_vis = get( delta_vis_chkbox_h,'value');
    end
    if data_vis && tfe_numel
      if isempty(tfemag_h)
        tfemag_h = ...
          plot( x_data(1:tfe_numel), PZG(2).TFEMag(1:tfe_numel), ...
             'color','g', ...
             'linewidth', 1.5, ...
             'parent', ol_mag_ax_h, ...
             'tag','TFE Mag line');
        PZG(2).plot_h{1}.hndl.TFE_Mag_line = tfemag_h;
      else
        set( tfemag_h, ...
             'xdata', x_data(1:tfe_numel), ...
             'ydata', PZG(2).TFEMag(1:tfe_numel), ...
             'color','g', ...
             'linestyle','-', ...
             'linewidth', 1.5, ...
             'visible','on');
      end
    else
      if ~isempty(tfemag_h)
        set( tfemag_h,'visible','off');
      end
    end
    % Also plot the difference between the model and the TFE data.
    if delta_vis && tfe_numel ...
      &&( isequal( PZG(2).BodeFreqs(1:tfe_numel), ...
                   PZG(2).TFEFreqs(1:tfe_numel) ) ...
         ||isequal( PZG(2).BodeFreqs(1:tfe_numel), ...
                    PZG(2).TFEFreqs(1:tfe_numel)' ) )
      tfe_frf = 10.^(PZG(2).TFEMag(1:tfe_numel)/20) ...
                .*exp(1i*pi/180*PZG(2).TFEPhs(1:tfe_numel));
      bode_frf = 10.^(PZG(2).BodeMag(1:tfe_numel)/20) ...
                .*exp(1i*pi/180*PZG(2).BodePhs(1:tfe_numel));
      bode_tfe_diff = ( bode_frf(:) - tfe_frf(:) );
      if isempty(tfedelmag_h)
        tfedelmag_h = ...
          plot( x_data(1:tfe_numel), 20*log10(abs(bode_tfe_diff)), ...
            'color','g', ...
            'linestyle',':', ...
            'linewidth', 2, ...
            'parent', ol_mag_ax_h, ...
            'tag','TFE Delta Mag line');
        PZG(2).plot_h{1}.hndl.TFE_Delta_Mag_line = tfedelmag_h;
      else
        set( tfedelmag_h, ...
             'xdata', x_data(1:tfe_numel), ...
             'ydata', 20*log10(abs(bode_tfe_diff)), ...
             'color','g', ...
             'linestyle',':', ...
             'linewidth', 2, ...
             'visible','on');
      end
    elseif ~isempty(tfedelmag_h)
      set( tfedelmag_h,'visible','off');
    end
  else
    if ~isempty(vis_chkbox_h)
      set( vis_chkbox_h,'visible','off');
    end
    if ~isempty(delta_vis_chkbox_h)
      set( delta_vis_chkbox_h,'visible','off');
    end
    if ~isempty( tfemag_h )
      set( tfemag_h,'visible','off');
    end
    if ~isempty( tfedelmag_h )
      set( tfedelmag_h,'visible','off');
    end
  end
  bode_y_data = PZG(2).BodeMag;
  if ~DBchk
    bode_y_data = 10.^( bode_y_data/20 );
  end
  bode_x_data = PZG(2).BodeFreqs;
  if HZchk
    bode_x_data = bode_x_data/(2*pi);
  end
  set( PZG(2).plot_h{1}.hndl.Bode_Line, ...
      'xdata', bode_x_data, ...
      'ydata', bode_y_data );
  negfreq_ndxs_1 = ...
    find( ( PZG(2).BodeFreqs > pi/PZG(2).Ts ) ...
         &( PZG(2).BodeFreqs < 2*pi/PZG(2).Ts ) );
  set( PZG(2).plot_h{1}.hndl.Bode_DT_negfreq_Line(1), ...
      'xdata', bode_x_data(negfreq_ndxs_1), ...
      'ydata', bode_y_data(negfreq_ndxs_1) );
  negfreq_ndxs_2 = ...
    find( ( PZG(2).BodeFreqs > 3*pi/PZG(2).Ts ) ...
         &( PZG(2).BodeFreqs < 4*pi/PZG(2).Ts ) );
  set( PZG(2).plot_h{2}.hndl.Bode_DT_negfreq_Line(2), ...
      'xdata', bode_x_data(negfreq_ndxs_2), ...
      'ydata', bode_y_data(negfreq_ndxs_2) );
end

ol_phs_h = pzg_fndo( 2, 2,'fig_h');
if ~isempty(ol_phs_h)
  tfephs_h = pzg_fndo( 2, 2,'TFE_Phs_line');
  tfedelphs_h = pzg_fndo( 2, 2,'TFE_Delta_Phs_line');
  vis_chkbox_h = pzg_fndo( 2, 2,'TFE_data_visibility_checkbox');
  delta_vis_chkbox_h = pzg_fndo( 2, 2,'TFE_delta_visibility_checkbox');
  if ~isempty(PZG(2).TFEFreqs) ...
    &&~isempty(PZG(2).TFEPhs) ...
    &&( numel(PZG(2).TFEPhs) == numel(PZG(2).TFEFreqs) )
    ol_phs_ax_h = pzg_fndo( 2, 2,'ax');
    if isempty(vis_chkbox_h)
      vis_chkbox_h = ...
        uicontrol( ol_phs_h,'style','checkbox', ...
          'units','normalized', ...
          'position',[0.69 0.001 0.149 0.05], ...
          'string','Show TFE', ...
          'value', 1, ...
          'backgroundcolor',[0 0.7 0], ...
          'tag','TFE data visibility checkbox', ...
          'callback','dupdatep');
      PZG(2).plot_h{2}.hndl.TFE_data_visibility_checkbox = vis_chkbox_h;
      data_vis = 1;
    else
      set( vis_chkbox_h,'visible','on');
      data_vis = get( vis_chkbox_h,'value');
    end
    if isempty(delta_vis_chkbox_h)
      delta_vis_chkbox_h = ...
        uicontrol( ol_phs_h,'style','checkbox', ...
          'units','normalized', ...
          'position',[0.85 0.001 0.149 0.05], ...
          'string','Show Diff', ...
          'value', 0, ...
          'backgroundcolor',[0 0.7 0], ...
          'tag','TFE delta visibility checkbox', ...
          'callback','dupdatep');
      PZG(2).plot_h{2}.hndl.TFE_delta_visibility_checkbox = delta_vis_chkbox_h;
      delta_vis = 0;
    else
      set( delta_vis_chkbox_h,'visible','on');
      delta_vis = get( delta_vis_chkbox_h,'value');
    end
    if data_vis && tfe_numel
      x_data = PZG(2).TFEFreqs;
      if HZchk
        x_data = x_data/2/pi;
      end
      tfe_xdata = x_data(1:tfe_numel);
      % Get "wrapped" TFE phase.
      tfe_ydata = ...
        180/pi*angle( exp( (1i*pi/180) * PZG(2).TFEPhs(1:tfe_numel) ) );
      if unwrap_value
        tfe_ydata = 180/pi * unwrap( pi/180 * tfe_ydata );
      end
      if isempty(tfephs_h)
        tfephs_h = ...
          plot( tfe_xdata(:), tfe_ydata(:), ...
            'color','g', ...
            'linewidth', 1.5, ...
            'parent', ol_phs_ax_h, ...
            'tag','TFE Phs line');
        PZG(2).plot_h{2}.hndl.TFE_Phs_line = tfephs_h;
      else
        set( tfephs_h, ...
            'xdata', tfe_xdata(:), ...
            'ydata', tfe_ydata(:), ...
            'color','g', ...
            'linestyle','-', ...
            'linewidth', 1.5, ...
            'visible','on');
      end
    elseif ~isempty(tfephs_h)
      set( tfephs_h,'visible','off');
    end
    if delta_vis && tfe_numel ...
      &&( isequal( PZG(2).BodeFreqs(1:tfe_numel), ...
                   PZG(2).TFEFreqs(1:tfe_numel) ) ...
         ||isequal( PZG(2).BodeFreqs(1:tfe_numel), ...
                    PZG(2).TFEFreqs(1:tfe_numel)' ) )
      tfe_xdata = x_data(1:tfe_numel);
      bode_y_data = PZG(2).BodePhs(1:tfe_numel);
      tfe_y_data = PZG(2).TFEPhs(1:tfe_numel);
      % Unwrap or wrap.
      bode_y_data = ...
        pzg_unwrap( PZG(2).BodeFreqs(1:tfe_numel), ...
                   (180/pi)*angle( exp( (1i*pi/180)*bode_y_data ) ), ...
                    2,'open');
      tfe_y_data = ...
        pzg_unwrap( PZG(2).BodeFreqs(1:tfe_numel), ...
                   (180/pi) * angle( exp( (1i*pi/180)*tfe_y_data ) ), ...
                    2,'open');
      if ~unwrap_value
        bode_y_data = (180/pi) * angle( exp( (1i*pi/180)*bode_y_data ) );
        tfe_y_data = (180/pi) * angle( exp( (1i*pi/180)*tfe_y_data ) );
      end
      delta_phase = bode_y_data(:) - tfe_y_data(:);
      % Put all deltas within +/- 360.
      posdelta_ndx = find( delta_phase > 0 );
      delta_phase(posdelta_ndx) = mod( delta_phase(posdelta_ndx), 360 );
      negdelta_ndx = find( delta_phase < 0 );
      delta_phase(negdelta_ndx) = mod( delta_phase(negdelta_ndx), -360 );
      % Put all deltas within +/- 180;
      posdelta_ndx = find( delta_phase > 180 );
      delta_phase(posdelta_ndx) = delta_phase(posdelta_ndx) - 360;
      negdelta_ndx = find( delta_phase < -180 );
      delta_phase(negdelta_ndx) = delta_phase(negdelta_ndx) + 360;
      if isempty( tfedelphs_h )
        tfedelphs_h = ...
          plot( tfe_xdata(:), delta_phase, ...
             'color','g', ...
             'linestyle',':', ...
             'linewidth', 2, ...
             'parent', ol_phs_ax_h, ...
             'tag','TFE Delta Phs line');
        PZG(2).plot_h{2}.hndl.TFE_Delta_Phs_line = tfedelphs_h;
      else
        set( tfedelphs_h, ...
            'xdata', tfe_xdata(:), ...
            'ydata', delta_phase, ...
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
      set( delta_vis_chkbox_h,'visible','off');
    end
    if ~isempty( tfephs_h )
      set( tfephs_h,'visible','off');
    end
    if ~isempty( tfedelphs_h )
      set( tfedelphs_h,'visible','off');
    end
  end
  bode_y_data = PZG(2).BodePhs;
  if ~unwrap_value
    bode_y_data = (180/pi) * angle( exp( (1i*pi/180)*bode_y_data ) );
  end
  bode_x_data = PZG(2).BodeFreqs;
  if HZchk
    bode_x_data = bode_x_data/(2*pi);
  end
  set( PZG(2).plot_h{2}.hndl.Bode_Line, ...
      'xdata', bode_x_data, ...
      'ydata', bode_y_data );
  negfreq_ndxs_1 = ...
    find( ( PZG(2).BodeFreqs > pi/PZG(2).Ts ) ...
         &( PZG(2).BodeFreqs < 2*pi/PZG(2).Ts ) );
  negfreq_ndxs_1 = [ negfreq_ndxs_1(1), negfreq_ndxs_1, negfreq_ndxs_1(end) ];
  this_ydata = bode_y_data(negfreq_ndxs_1);
  this_ydata(1) = 0;
  this_ydata(end) = 0;
  set( PZG(2).plot_h{2}.hndl.Bode_DT_negfreq_Line(1), ...
      'xdata', bode_x_data(negfreq_ndxs_1), ...
      'ydata', this_ydata );
  negfreq_ndxs_2 = ...
    find( ( PZG(2).BodeFreqs > 3*pi/PZG(2).Ts ) ...
         &( PZG(2).BodeFreqs < 4*pi/PZG(2).Ts ) );
  negfreq_ndxs_2 = [ negfreq_ndxs_2(1), negfreq_ndxs_2 ];
  this_ydata = bode_y_data(negfreq_ndxs_2);
  this_ydata(1) = 0;
  this_ydata(end) = 0;
  set( PZG(2).plot_h{2}.hndl.Bode_DT_negfreq_Line(2), ...
      'xdata', bode_x_data(negfreq_ndxs_2), ...
      'ydata', this_ydata );
end

cl_phs_h = pzg_fndo( 2, 4,'fig_h');
if ~isempty(cl_phs_h)
  bode_x_data = PZG(2).CLBodeFreqs;
  bode_y_data = PZG(2).CLBodePhs;
  if numel(bode_y_data) < 2
    set( PZG(2).plot_h{4}.hndl.Bode_DT_negfreq_Line,'visible','off');
    set( PZG(2).plot_h{4}.hndl.Bode_Line,'visible','off');
  else
    if HZchk
      bode_x_data = bode_x_data/(2*pi);
    end
    if ~unwrap_value
      bode_y_data = (180/pi) * angle( exp( (1i*pi/180)*bode_y_data ) );
    end
    if numel(PZG(2).plot_h{4}.hndl.Bode_Line) == 1
      set( PZG(2).plot_h{4}.hndl.Bode_Line, ...
        'xdata', bode_x_data, ...
        'ydata', bode_y_data );
    end
    if numel( PZG(2).plot_h{4}.hndl.Bode_DT_negfreq_Line ) == 2
      negfreq_ndxs_1 = ...
        find( ( PZG(2).CLBodeFreqs > pi/PZG(2).Ts ) ...
             &( PZG(2).CLBodeFreqs < 2*pi/PZG(2).Ts ) );
      bode_y_data = PZG(2).CLBodePhs(negfreq_ndxs_1);
      if ~unwrap_value
        bode_y_data = (180/pi) * angle( exp( (1i*pi/180)*bode_y_data ) );
      end
      negfreq_ndxs_1 = [negfreq_ndxs_1(1), negfreq_ndxs_1, negfreq_ndxs_1(end)];
      bode_x_data = PZG(2).CLBodeFreqs(negfreq_ndxs_1);
      if HZchk
        bode_x_data = bode_x_data/(2*pi);
      end
      bode_y_data = [ 0, bode_y_data, 0];
      set( PZG(2).plot_h{4}.hndl.Bode_DT_negfreq_Line(1), ...
          'xdata', bode_x_data, ...
          'ydata', bode_y_data );
      negfreq_ndxs_2 = ...
        find( ( PZG(2).CLBodeFreqs > 3*pi/PZG(2).Ts ) ...
             &( PZG(2).CLBodeFreqs < 4*pi/PZG(2).Ts ) );
      bode_y_data = PZG(2).CLBodePhs(negfreq_ndxs_2);
      if ~unwrap_value
        bode_y_data = (180/pi) * angle( exp( (1i*pi/180)*bode_y_data ) );
      end
      negfreq_ndxs_2 = [negfreq_ndxs_2(1), negfreq_ndxs_2];
      bode_x_data = PZG(2).CLBodeFreqs(negfreq_ndxs_2);
      if HZchk
        bode_x_data = bode_x_data/(2*pi);
      end
      bode_y_data = [ 0, bode_y_data ];
      set( PZG(2).plot_h{4}.hndl.Bode_DT_negfreq_Line(2), ...
          'xdata', bode_x_data, ...
          'ydata', bode_y_data );
    end
  end
end

tempH = pzg_fndo( 2, 13,'Sensitivity_checkbox');
if ~isempty(tempH)
  tempH = tempH(1);
  if get( tempH,'Value') == 1
    if ScrSize(3) > 1024
      ScrPos = [300 20 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [250 20 300 250];
    else
      ScrPos = [200 20 240 200];
    end
    % Update the sensitivity plot.
    sensplot(PZG(2).CLBodeFreqs, ...
       PZG(2).CLBodeMag, ...
       PZG(2).CLBodePhs, ...
       PZG(2).SensPlotName, ...
       PZG(2).FrqSelNdx, ...
       PZG(2).SensPlotName, ...
       ScrPos, ...
       ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
        'catch,pzg_err(''''button down'''');' ...
        'end,clear tempfs;'],'z');
  end
end

if ~isempty(gcbo) && ~isequal( gcbo, gcbf )
  gcbo_tag = get(gcbo,'tag');
  gcbo_type = get(gcbo,'type');
  if strcmp( gcbo_type,'uicontrol')
    gcbo_clbk = get(gcbo,'callback');
  else
    gcbo_clbk = '';
  end
else
  gcbo_tag = '';
  gcbo_type = '';
  gcbo_clbk = '';
end
if ( ~isempty(gcbf) && isequal( gcbf, gcbo ) ) ...
   ||( ~isempty(gcbo) && strcmp( gcbo_type,'uimenu') ) ...
   ||( ~isempty(gcbo) ...
      && strcmp( gcbo_type,'uicontrol') ...
      && isempty( strfind( gcbo_clbk,'unwrap checkbox') ) ...
      && isempty( strfind( gcbo_clbk,'Log checkbox') ) ...
      && isempty( strfind( gcbo_clbk,'Hz checkbox') ) ...
      && ~strcmpi( gcbo_tag,'D-T OLbode checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T CLbode checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T Nichols checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T Nyquist checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T OLresp checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T CLresp checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T RtLoc checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T Sensitivity checkbox') ...
      && ~strcmpi( gcbo_tag,'D-T Fix DC checkbox') ...
      && ~strcmpi( gcbo_tag,'dpzgui Link Checkbox') )
    
  if numel(PZG(2).ZeroLocs) > numel(PZG(2).PoleLocs)
    errdlg_h = errordlg( ...
       {'The system has more zeros than poles.'; ...
        'This is a physically un-realizeable system'; ...
        ' (non-real-time).  '; ...
        'Not updating time responses and root locus'; ...
        ' ';'    Click "OK" to continue ...';' '}, ...
        'Some plots are NOT Being Updated','modal');
    uiwait(errdlg_h);
    return
  end
  
  if ~isempty(tempUDZ) && ( get( tempUDZ(4,2),'Value') == 1 )
    if ScrSize(3) > 1024
      ScrPos = [10 10 450 320];
    elseif ScrSize(3) > 800;
      ScrPos = [10 10 360 250];
    else
      ScrPos = [10 10 280 200];
    end
    nicholpl( PZG(2).BodeFreqs, PZG(2).BodeMag, PZG(2).BodePhs, ...
      PZG(2).NicholsName, PZG(2).FrqSelNdx, ...
      PZG(2).NicholsName, ScrPos, ...
      ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
       'catch,pzg_err(''''button down'''');' ...
       'end,clear tempfs;'],'z')
  end
  
  contourpl('refresh plot', 2 );

  if ~isempty(tempUDZ) && ( get( tempUDZ(5,2),'Value') == 1 )
    if ScrSize(3) > 1024
      ScrPos = [495 10 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [380 10 300 250];
    else
      ScrPos = [300 10 240 200];
    end
    tempXLim = [];
    tempYLim = [];
    tempF = pzg_fndo( 2, 8,'fig_h');
    if ~isempty(tempF)
      tempA = pzg_fndo( 2, 8,'ax');
      if ~isempty(tempA)
        tempXLim = pzg_fndo( 2, 8,'ax_xlim');
        tempYLim = pzg_fndo( 2, 8,'ax_ylim');
      end
    end
    resppl( PZG(2).N,PZG(2).D,PZG(2).Gain, ...
            PZG(2).OLTimeRespName,PZG(2).OLTimeRespName, ...
           'z',PZG(2).Ts,ScrPos )
    if isequal( size(tempXLim),[1 2]) ...
      && isequal( size(tempYLim),[1 2]) ...
      &&( diff(tempXLim) > 1e-10 ) ...
      &&( diff(tempYLim) > 1e-10 ) ...
      &&( isempty(gcbo) ...
         || strcmp( get(gcbo,'type'),'figure') ...
         || isempty( strfind( get(gcbo,'callback'),'Set TS') ) )
      set( tempA,'xlim', tempXLim,'ylim', tempYLim )
      PZG(2).plot_h{8}.xlim = tempXLim;
      PZG(2).plot_h{8}.ylim = tempYLim;
      PZG(2).plot_h{8}.hndl.ax_xlim = tempXLim;
      PZG(2).plot_h{8}.hndl.ax_.ylim = tempYLim;
    end
  end

  if ~isempty(tempUDZ) && ( get( tempUDZ(6,2),'Value') == 1 )
    if ScrSize(3) > 1024
      ScrPos = [900 10 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [700 10 300 250];
    else
      ScrPos = [550 10 240 200];
    end
    tempXLim = [];
    tempYLim = [];
    tempF = pzg_fndo( 2, 9,'fig_h');
    if ~isempty(tempF)
      tempA = pzg_fndo( 2, 9,'ax');
      if ~isempty(tempA)
        tempXLim = pzg_fndo( 2, 9,'ax_xlim');
        tempYLim = pzg_fndo( 2, 9,'ax_ylim');
      end
    end
    resppl(PZG(2).N,PZG(2).Dc,PZG(2).CLGain, ...
           PZG(2).CLTimeRespName,PZG(2).CLTimeRespName, ...
           'z',PZG(2).Ts,ScrPos )
    if isequal( size(tempXLim),[1 2]) ...
      && isequal( size(tempYLim),[1 2]) ...
      &&( diff(tempXLim) > 1e-10 ) ...
      &&( diff(tempYLim) > 1e-10 ) ...
      &&( isempty(gcbo) ...
         || strcmp( get(gcbo,'type'),'figure') ...
         || isempty( strfind( get(gcbo,'callback'),'Set TS') ) )
      set( tempA,'xlim', tempXLim,'ylim', tempYLim )
      PZG(2).plot_h{9}.xlim = tempXLim;
      PZG(2).plot_h{9}.ylim = tempYLim;
      PZG(2).plot_h{9}.hndl.ax_xlim = tempXLim;
      PZG(2).plot_h{9}.hndl.ax_.ylim = tempYLim;
    end
  end
  tempH = pzg_fndo( 2, 13,'Nyquist_checkbox');
  if ~isempty(tempH)
    tempH = tempH(1);
    if get( tempH,'Value') == 1
      if ScrSize(3) > 1024
        ScrPos = [200 20 375 320];
      elseif ScrSize(3) > 800;
        ScrPos = [150 20 300 250];
      else
        ScrPos = [100 20 240 200];
      end
      nyqistpl( PZG(2).BodeFreqs, PZG(2).BodeMag, PZG(2).BodePhs, ...
         PZG(2).ZeroLocs, PZG(2).PoleLocs, PZG(2).Gain, ...
         PZG(2).NyquistName, PZG(2).FrqSelNdx, ...
         PZG(2).NyquistName, ScrPos, ...
         ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
          'catch,pzg_err(''''button down'''');' ...
          'end,clear tempfs'], ...
         'z', PZG(2).Ts );

      nyq_ax_h = pzg_fndo( 2, 7,'ax');
      nyqplot_h = pzg_fndo( 2, 7,'Nyquist_Plot');
      nyqplot_data = ...
        get( nyqplot_h,'xdata') + 1i*get( nyqplot_h,'ydata');
      plot_max_mag = max( abs(nyqplot_data) );
      actual_max_mag = max( abs(PZG(2).cntr_data.contour_mapping) );
      if ( actual_max_mag > 20 ) ...
        && ( plot_max_mag > 0.99*actual_max_mag ) ...
        && strcmpi( get(nyq_ax_h,'xlimmode'),'auto') ...
        && strcmpi( get(nyq_ax_h,'ylimmode'),'auto')
        hyb_h = pzg_fndo( 2, 7,'rescale_checkbox');
        if ~isempty(hyb_h)
          set( hyb_h,'value', 1 )
          nyqistpl('hybrid scaling');
        end
      end
    end
  end

  if ~isempty(tempUDZ) && ( get( tempUDZ(10,2),'Value') == 1 )
    Callback = ['temp0=get(gcbf,''''UserData'''');' ...
               'temp=str2num( get(temp0(numel(temp0)-2),''''String'''') );' ...
               'if numel(temp)==1;'...
                 'ZGain=temp;' ...
                 'PZG(2).recompute_frf=0;' ...
                 'pzg_cntr(2);' ...
                 'pzg_bodex(2);' ...
                 'dupdatep;' ...
                 'dpzgui;' ...
               'end;'];
    if ScrSize(3) > 1024
      ScrPos = [485 10 375 320];
    elseif ScrSize(3) > 800;
      ScrPos = [370 10 300 250];
    else
      ScrPos = [290 10 240 200];
    end
    rlocuspl( 1, 1, PZG(2).Gain, ...
       PZG(2).RootLocusName, ...
       [],'z',PZG(2).RootLocusName, ...
       ScrPos,'global PZG;rlocuspl(PZG(2).Gain);pzg_ptr;', ...
       Callback )
  end
end

% Update the "pure delay" edit window in main p/z gui
puredelay_h = pzg_fndo( 2, 13,'PZGUI_pure_delay');
if ~isempty(puredelay_h)
  set( puredelay_h,'string', pzg_efmt( PZG(2).PureDelay ) );
end

% Is the C-T link is checked?
bodedchkbox = 0;
if ~isempty(gcbo) && strcmpi( get(gcbo,'type'),'uicontrol') ...
  && strcmpi( get(gcbo,'style'),'checkbox') ...
  &&( strcmpi( get(gcbo,'string'),'db') ...
     ||strcmpi( get(gcbo,'string'),'hz') ...
     ||strcmpi( get(gcbo,'string'),'log') ...
     ||strcmpi( get(gcbo,'string'),'unwrap') )
  bodedchkbox = 1;
end
if pzg_islink(2) && ~isequal( 1, bodedchkbox )
  tempVal = get( tempUDZ(15,2),'Value');
  
  % Copy over the DC gain, if "Fix DC" is checked.
  CT_DCgain_chkbox_h = pzg_fndo( 1, 12,'Fix_DC_checkbox');
  DCgain_chkbox_h = pzg_fndo( 2, 13,'Fix_DC_checkbox');
  if isequal(1,ishandle(DCgain_chkbox_h)) ...
    && get( DCgain_chkbox_h,'value')
    PZG(1).DCgain = PZG(2).DCgain;
    if isequal(1,ishandle(CT_DCgain_chkbox_h))
      set( CT_DCgain_chkbox_h,'value', 1 )
    end
  elseif isequal(1,ishandle(CT_DCgain_chkbox_h))
    set( CT_DCgain_chkbox_h,'value', 0 )
  end

  if tempVal == 1
    % Direct conversion of z-plane poles and zeros to s-plane
    nr_delay_poles = sum( PZG(2).PoleLocs == 0 );
    if nr_delay_poles
      PZG(1).PoleLocs = ...
        log( PZG(2).PoleLocs(PZG(2).PoleLocs~=0) )/PZG(2).Ts;
      PZG(1).PoleLocs = ...
        [ PZG(1).PoleLocs; ...
          -(10+randn(nr_delay_poles,1))/PZG(2).Ts.*ones(nr_delay_poles,1) ];
    else
      PZG(1).PoleLocs = log(PZG(2).PoleLocs)/PZG(2).Ts;
    end
    nrp_ndxs = ...
      find( ( imag(PZG(2).PoleLocs) == 0 ) & ( real(PZG(2).PoleLocs) < 0 ) );
    if ~isempty(nrp_ndxs)
      PZG(1).PoleLocs(nrp_ndxs) = 5*abs( PZG(1).PoleLocs(nrp_ndxs) );
    end
    for Ck=1:numel(PZG(1).PoleLocs)
      temp = sum( PZG(1).PoleLocs(Ck) == PZG(1).PoleLocs );
      if sum( conj(PZG(1).PoleLocs(Ck)) ...
        == PZG(1).PoleLocs ) == 0
        for Dk = 1:temp
           PZG(1).PoleLocs = ...
             [ PZG(1).PoleLocs; conj(PZG(1).PoleLocs(Ck)) ];
        end
      end
    end
    if any( PZG(2).ZeroLocs == 0 )
      PZG(1).ZeroLocs = ...
        log( PZG(2).ZeroLocs(PZG(2).ZeroLocs~=0) )/PZG(2).Ts;
      PZG(1).ZeroLocs = ...
        [ PZG(1).ZeroLocs; -10/PZG(2).Ts*ones(sum(PZG(2).ZeroLocs == 0 ),1) ];
    else
      PZG(1).ZeroLocs = log(PZG(2).ZeroLocs)/PZG(2).Ts;
    end
    nrz_ndxs = ...
      find( ( imag(PZG(2).ZeroLocs) == 0 ) & ( real(PZG(2).ZeroLocs) < 0 ) );
    if ~isempty(nrz_ndxs)
      PZG(1).ZeroLocs(nrz_ndxs) = 5*abs( PZG(1).ZeroLocs(nrz_ndxs) );
    end
    
    for Ck=1:numel(PZG(1).ZeroLocs)
      temp = sum( abs( PZG(1).ZeroLocs(Ck) - PZG(1).ZeroLocs ) ...
                 /max(1,abs(PZG(1).ZeroLocs(Ck)) ) < 1e-14 );
      cj_temp = sum( abs( conj(PZG(1).ZeroLocs(Ck)) - PZG(1).ZeroLocs ) ...
                    /max(1,abs(PZG(1).ZeroLocs(Ck)) ) < 1e-14 );
      if temp ~= cj_temp
        for Dk = 1:abs(temp-cj_temp)
          PZG(1).ZeroLocs = ...
             [ PZG(1).ZeroLocs; conj(PZG(1).ZeroLocs(Ck)) ];
        end
      end
    end
    
     PZG(1).PureDelay = PZG(2).Ts * PZG(2).PureDelay;

     PZG(1).N = [];
     PZG(1).D = [];
     
     pndxs = find( abs(PZG(2).PoleLocs-1) > 1e-10 );
     zndxs = find( abs(PZG(2).ZeroLocs-1) > 1e-10 );
     nz_ndxs = [ pndxs; zndxs ];
     if isempty( nz_ndxs )
       gain_freq = pi/PZG(2).Ts / 10;
     else
       if ~isempty(pndxs)
         min_pfreq = min( abs( angle( PZG(2).PoleLocs(pndxs) ) ) )/PZG(2).Ts;
       else
         min_pfreq = pi/PZG(2).Ts;
       end
       if ~isempty(zndxs)
         min_zfreq = min( abs( angle( PZG(2).ZeroLocs(zndxs) ) ) )/PZG(2).Ts;
       else
         min_zfreq = pi/PZG(2).Ts;
       end
       gain_freq = max( pi/PZG(2).Ts/10, min( min_zfreq, min_pfreq ) )/10;
     end
     gain_uc_pt = exp( 1i * gain_freq * PZG(2).Ts );
     dt_gain_at_gf = ...
       exp( log(PZG(2).Gain) ...
            + sum( log( gain_uc_pt-PZG(2).ZeroLocs ) ) ...
            - sum( log( gain_uc_pt-PZG(2).PoleLocs ) ) );
     
     PZG(1).Gain = PZG(2).Gain;
     ct_gain_at_gf = ...
       exp( log(PZG(1).Gain) ...
            + sum( log( 1i*gain_freq - PZG(1).ZeroLocs ) ) ...
            - sum( log( 1i*gain_freq - PZG(1).PoleLocs ) ) );
     if ~isnan(dt_gain_at_gf) && ~isinf(dt_gain_at_gf) ...
       && ( dt_gain_at_gf ~= 0 ) ...
       &&~isnan(ct_gain_at_gf) && ~isinf(ct_gain_at_gf) ...
       && ( ct_gain_at_gf ~= 0 )
       PZG(1).Gain = PZG(1).Gain * abs( dt_gain_at_gf / ct_gain_at_gf );
     end
     
  elseif tempVal == 2
    % Compute the inverse-ZOH-equivalent C-T model.
    % Remove any canceling (or nearly-canceling) pole/zero pairs.
    Z_dt = PZG(2).ZeroLocs;
    P_dt = PZG(2).PoleLocs;
    for k = numel(P_dt):-1:1
      pk_dt = P_dt(k);
      if any( abs(Z_dt-pk_dt) < 1e-8);
        [ dist, del_ndx ] = min( abs( Z_dt - pk_dt ) ); %#ok<ASGLU>
        P_dt(k) = [];
        Z_dt(del_ndx) = [];
      end
    end
    
    if ~isempty(P_dt)
      % Save the current model in "undo" data.
      undo_info = [];
      undo_info.PoleLocs = PZG(1).PoleLocs;
      undo_info.ZeroLocs = PZG(1).ZeroLocs;
      undo_info.Gain = PZG(1).Gain;
      undo_info.Ts = PZG(1).Ts;
      undo_info.PureDelay = PZG(1).PureDelay;
      undo_info.DCgain = PZG(1).DCgain;
      if ~isfield(PZG(1),'undo_info') || ~iscell(PZG(1).undo_info)
        PZG(1).undo_info = {};
      end
      if isempty(PZG(1).undo_info) ...
        ||~isequal( PZG(1).undo_info{end}, undo_info )
        PZG(1).undo_info{end+1} = undo_info;
      end
        
      quiet = 1;
      ss_mdl_dt = pzg_moda( 2, 1, 0, 0,'', quiet );
      if ~isempty( ss_mdl_dt ) && all( eig(ss_mdl_dt.a) ~= 0 )
        if isempty(ss_mdl_dt.a)
          ss_mdl_ct = ss_mdl_dt;
          ss_mdl_ct.ts = 0;
        else
          ABz = [ ss_mdl_dt.a        ss_mdl_dt.b; ...
                  zeros(size(ss_mdl_dt.c))   1  ];
          lnABz = logm( ABz ) / PZG(2).Ts;
          norm_ratio = norm(ss_mdl_dt.c)/norm(lnABz(1:end-1,end));
          CDadjust = 1/norm_ratio;
          
          zzz = tzero( lnABz(1:end-1,1:end-1), lnABz(1:end-1,end), ...
                       CDadjust*ss_mdl_dt.c, CDadjust*ss_mdl_dt.d );
          bigz_ndxs = ...
            find( ( ( imag(zzz) ~= 0 ) & ( abs(zzz) > pi/PZG(2).Ts ) ) ...
                 |( ( imag(zzz) == 0 ) & ( abs(zzz) > pi*1e2/PZG(2).Ts ) ) );
          zzz(bigz_ndxs) = []; %#ok<FNDSB>
          ppp = log( PZG(2).PoleLocs ) / PZG(2).Ts;
          
          compfreq_angle = 1e-8;
          compfreq_dtpt = exp( 1i*compfreq_angle );
          while any( abs( PZG(2).PoleLocs - compfreq_dtpt ) < 1e-10 ) ...
            || any( abs( PZG(2).ZeroLocs - compfreq_dtpt ) < 1e-10 )
            compfreq_angle = 0.95*compfreq_angle;
            compfreq_dtpt = exp( 1i*compfreq_angle );
          end
          compfreq_ctpt = 1i*abs( log( compfreq_dtpt ) ) / PZG(2).Ts;

          ctrhp_z_ndx = find( ( imag(zzz) == 0 ) & ( real(zzz) > 0 ) );
          dtrhp_z_ndx = find( ( imag(PZG(2).ZeroLocs) == 0 ) ...
                             &( real(PZG(2).ZeroLocs) > 0 ) );
          while numel(ctrhp_z_ndx) > numel(dtrhp_z_ndx)
            [ sorted_z, sortndxs ] = sort( zzz(ctrhp_z_ndx) ); %#ok<ASGLU>
            zzz(ctrhp_z_ndx(sortndxs(end))) = [];
            ctrhp_z_ndx(sortndxs(end)) = [];
          end
        
          kkk = PZG(2).Gain;
          dt_compgain = 1;
          for kzp = 1:numel(PZG(2).PoleLocs)
            dt_compgain = ...
              dt_compgain / ( compfreq_dtpt - PZG(2).PoleLocs(kzp) );
            if numel(PZG(2).ZeroLocs) >= kzp
              dt_compgain = ...
                dt_compgain * ( compfreq_dtpt - PZG(2).ZeroLocs(kzp) );
            end
          end
          
          ct_compgain = 1;
          for kzp = 1:numel(ppp)
            ct_compgain = ct_compgain / ( compfreq_ctpt - ppp(kzp) );
            if numel(zzz) >= kzp
              ct_compgain = ct_compgain * ( compfreq_ctpt - zzz(kzp) );
            end
          end
          
          kkk = real( kkk * dt_compgain / ct_compgain );
        end

        % Equalize the number of non-minimum-phase zeros in large models.
        if numel(PZG(2).PoleLocs) > 20
          ct_nmp_ndx = find( ( real(zzz) > 0 ) & imag(zzz) ~= 0 );
          dt_nmp_ndx = ...
            find( ( abs(PZG(2).ZeroLocs) > 1 ) & imag(PZG(2).ZeroLocs) ~= 0 );
          if ( numel(ct_nmp_ndx) > numel(dt_nmp_ndx) )
            dt_nmp_zeros = PZG(2).ZeroLocs(dt_nmp_ndx);
            [ dt_nmp_freqs, sortndx ] = ...
                sort( abs(angle(dt_nmp_zeros))/PZG(2).Ts );
            dt_nmp_ndx = dt_nmp_ndx(sortndx);
            
            ct_nmp_zeros = zzz(ct_nmp_ndx);
            [ ct_nmp_freqs, sortndx ] = sort( abs(imag(ct_nmp_zeros)) );
            ct_nmp_ndx = ct_nmp_ndx(sortndx);
            % Eliminate from the list the CT NMP zeros nearest DT NMP zeros
            for knm = numel(dt_nmp_freqs):-1:1
              [ delfreq, closest_ndx ] = ...
                  min( abs( dt_nmp_freqs(knm) - ct_nmp_freqs ) ); %#ok<ASGLU>
              ct_nmp_freqs(closest_ndx) = [];
              ct_nmp_ndx(closest_ndx) = [];
              dt_nmp_freqs(knm) = [];
              dt_nmp_ndx(knm) = [];
            end
            for knm = 1:numel(ct_nmp_ndx)
              zzz(ct_nmp_ndx(knm)) = conj( -zzz(ct_nmp_ndx(knm)) );
            end
          end
        end
      
      else
        % Unlink the models.
        linkcb_h = pzg_fndo( 2, 13,'LinkCheckbox');
        if ~isempty(linkcb_h)
          set( linkcb_h,'value', 0, ...
              'backgroundcolor', get( get(linkcb_h,'parent'),'color') );
        end
        linkmenu_h = pzg_fndo( 2, 13,'LinkMethod');
        if ~isempty(linkmenu_h)
          set( linkmenu_h, ...
              'backgroundcolor', get( get(linkmenu_h,'parent'),'color') );
        end
        
        if any( ( real(PZG(2).PoleLocs) <= 1e-8 ) ...
               &( abs(imag(PZG(2).PoleLocs)) < 1e-10 ) )
          if exist('MsgHndl','var') && ishandle(MsgHndl)
            close(MsgHndl)
          end
          set( tempUDZ(14,2),'Value', 0 );
          errordlg( ...
            {'The discrete-time model has real poles at z <= 0.'; ...
             ' '; ...
             'These poles cannot be converted by ZOH-equivalent.'; ...
             'But they might be convertible by the "bilinear" method.'}, ...
            'Invalid ZOH Conversion','modal');
          return
        end
        zzz = [];
        ppp = [];
        kkk = [];
      end      
      if isempty(zzz) && isempty(ppp) && isempty(kkk)
        % Use the "fallback" method.
        zpk_mdl = zpk( Z_dt, P_dt, PZG(2).Gain, PZG(2).Ts, ...
                      'inputdelay',PZG(2).PureDelay);
        try
          zpk_mdl_ct = d2c( zpk_mdl,'zoh');

        catch  %#ok<CTCH>
          if ~isempty(gcbo) && strcmpi('checkbox', get(gcbo,'style') )
            set(gcbo,'value', 0 )
          end
          wait_h = findobj( allchild(0),'name','CALCULATING');
          delete(wait_h)
          PZG(1).undo_info(end) = [];
          
          temp = lasterror; %#ok<LERR>
          errdlg_h = ...
            errordlg({'Matlab function "D2C" unable to execute.';' '; ...
                      temp.message;' '; ...
                      ' ';'    Click "OK" to continue ...';' '}, ...
                     'Error Calling "D2C"','modal');
          uiwait(errdlg_h)
          return
        end
        disp('pzgui:  ZOH-equivalent conversion may have accuracy issues.')
        PZG(1).ZeroLocs = zpk_mdl_ct.z{1};
        PZG(1).PoleLocs = zpk_mdl_ct.p{1};
        PZG(1).Gain = zpk_mdl_ct.k;
      else
        [ tempz, sortndx ] = sort( -abs( imag(zzz) ) ); %#ok<ASGLU>
        zzz = zzz(sortndx);
        PZG(1).ZeroLocs = zzz;
        PZG(1).PoleLocs = ppp;
        PZG(1).Gain = kkk;
      end
      
      if ~isempty(ppp) && ~isequal( 0, kkk )
        % Check that the frequencies for FRF plotting include at least the 
        % same region as the DT frequencies.
        if ~isempty(PZG(1).BodeFreqs) ...
          &&( ( PZG(1).BodeFreqs(end) < PZG(2).BodeFreqs(end) ) ...
             ||( PZG(1).BodeFreqs(1) > PZG(2).BodeFreqs(1) ) )
          PZG(1).recompute_frf = 1;
        end

        % Equalize the number of integrator poles and zeros.
        if sum( PZG(2).PoleLocs == 1 )
          nr_z_integ_poles = sum( abs( PZG(2).PoleLocs - 1 ) < 1e-12 );
          [ temp, s_integ_ndxs ] = sort( abs( PZG(1).PoleLocs ) ); %#ok<ASGLU>
          PZG(1).PoleLocs(s_integ_ndxs(1:nr_z_integ_poles)) = 0;
        end
        if sum( PZG(2).ZeroLocs == 1 )
          nr_z_integ_zeros = sum( abs( PZG(2).ZeroLocs - 1 ) < 1e-12 );
          [ temp, s_integ_ndxs ] = sort( abs( PZG(1).ZeroLocs ) ); %#ok<ASGLU>
          PZG(1).ZeroLocs(s_integ_ndxs(1:nr_z_integ_zeros)) = 0;
        end
        PZG(1).PureDelay = PZG(2).PureDelay * PZG(2).Ts;
        PZG(1).N = [];
        PZG(1).D = [];
      end
    else
      PZG(1).N = 1;
      PZG(1).D = 1;
      PZG(1).Gain = PZG(2).Gain;
      PZG(1).PureDelay = PZG(2).Ts * PZG(2).PureDelay;
      PZG(1).ZeroLocs = [];
      PZG(1).PoleLocs = [];
    end
    temp = 10^10 * max( 1e-3, max( abs( PZG(1).PoleLocs) ) );
    for Xk = numel(PZG(1).ZeroLocs):-1:1
      if isinf(PZG(1).ZeroLocs(Xk)) && isnan(PZG(1).ZeroLocs(Xk))
        PZG(1).ZeroLocs(Xk) = [];
      elseif abs(PZG(1).ZeroLocs(Xk)) > temp
        PZG(1).Gain = PZG(1).Gain*abs(PZG(1).ZeroLocs(Xk));
        PZG(1).ZeroLocs(Xk) = [];
      end
    end
    PZG(1).N = [];
    
  else
    % Compute the C-T model via inverse-bilinear transformation.
    % Remove any canceling (or nearly-canceling) pole/zero pairs.
    Z_dt = PZG(2).ZeroLocs;
    P_dt = PZG(2).PoleLocs;
    for k = numel(P_dt):-1:1
      pk_dt = P_dt(k);
      if any( abs(Z_dt-pk_dt) < 1e-8);
        [ dist, del_ndx ] = min( abs( Z_dt - pk_dt ) ); %#ok<ASGLU>
        P_dt(k) = [];
        Z_dt(del_ndx) = [];
      end
    end
    
    if ~isempty(P_dt)
      % Save the current model in "undo" data.
      undo_info = [];
      undo_info.PoleLocs = PZG(1).PoleLocs;
      undo_info.ZeroLocs = PZG(1).ZeroLocs;
      undo_info.Gain = PZG(1).Gain;
      undo_info.Ts = PZG(1).Ts;
      undo_info.PureDelay = PZG(1).PureDelay;
      undo_info.DCgain = PZG(1).DCgain;
      if ~isfield(PZG(1),'undo_info') || ~iscell(PZG(1).undo_info)
        PZG(1).undo_info = {};
      end
      if isempty(PZG(1).undo_info) ...
        ||~isequal( PZG(1).undo_info{end}, undo_info )
        PZG(1).undo_info{end+1} = undo_info;
      end
      PZG(1).BodeMag = [];
      PZG(1).BodePhs = [];
      PZG(1).CLBodeMag = [];
      PZG(1).CLBodePhs = [];
      
      quiet = 1;
      ss_mdl_ct = pzg_moda( 1, 0, 0, 0,'tustin', quiet );
      if ~isempty( ss_mdl_ct )
        [ zzz, ppp, kkk ] = ...
            ss2zp( ss_mdl_ct.a, ss_mdl_ct.b, ss_mdl_ct.c, ss_mdl_ct.d, 1 );
        
        nr_diff_zeros = sum( abs( PZG(2).ZeroLocs - 1 ) < 1e-8 );
        if nr_diff_zeros > 0
          % Map the same number of zeros to s = 0.
          [ temp_mags, sortndx ] = sort( abs( zzz ) ); %#ok<ASGLU>
          zzz( sortndx(1:nr_diff_zeros) ) = 0;
        end
      else
        if any( abs( PZG(2).PoleLocs + 1 ) < 1e-8 )
          if exist('MsgHndl','var') && ishandle(MsgHndl)
            close(MsgHndl)
          end
          set( tempUDZ(14,2),'Value', 0 );
          return
        end
        zzz = [];
        ppp = [];
        kkk = [];
      end      
      if isempty(zzz) && isempty(ppp) && isempty(kkk)
        % Use the "fallback" method.
        zpk_mdl = zpk( Z_dt, P_dt, PZG(2).Gain, PZG(2).Ts, ...
                      'inputdelay',PZG(2).PureDelay);
        try
          zpk_mdl_ct = d2c( zpk_mdl,'tustin');
        catch  %#ok<CTCH>
          if ~isempty(gcbo) && strcmpi('checkbox', get(gcbo,'style') )
            set(gcbo,'value', 0 )
          end
          wait_h = findobj( allchild(0),'name','CALCULATING');
          delete(wait_h)
          PZG(1).undo_info(end) = [];
          
          temp = lasterror; %#ok<LERR>
          errdlg_h = ...
            errordlg({'Matlab function "D2C" unable to execute.';' '; ...
                      temp.message;' '; ...
                      ' ';'    Click "OK" to continue ...';' '}, ...
                     'Error Calling "D2C"','modal');
          uiwait(errdlg_h)
          return
        end
      
        disp('pzgui:  bilinear transformation may have accuracy issues.')
        PZG(1).ZeroLocs = zpk_mdl_ct.z{1};
        PZG(1).PoleLocs = zpk_mdl_ct.p{1};
        PZG(1).Gain = zpk_mdl_ct.k;
      else
        PZG(1).ZeroLocs = zzz;
        PZG(1).PoleLocs = ppp;
        PZG(1).Gain = kkk;
      end
      PZG(1).PureDelay = PZG(2).PureDelay * PZG(2).Ts;
      PZG(1).N = [];
      PZG(1).D = [];
    else
      PZG(1).N = [];
      PZG(1).D = [];
      PZG(1).Gain = PZG(2).Gain;
      PZG(1).PureDelay = PZG(2).Ts * PZG(2).PureDelay;
      PZG(1).ZeroLocs = [];
      PZG(1).PoleLocs = [];
    end
    temp = 10^10 * max( 1e-3, max( abs( PZG(1).PoleLocs) ) );
    for Xk=numel(PZG(1).ZeroLocs):-1:1
      if isinf(PZG(1).ZeroLocs(Xk)) && isnan(PZG(1).ZeroLocs(Xk))
        PZG(1).ZeroLocs(Xk) = [];
      elseif abs(PZG(1).ZeroLocs(Xk)) > temp
        PZG(1).Gain = PZG(1).Gain*abs(PZG(1).ZeroLocs(Xk));
        PZG(1).ZeroLocs(Xk) = [];
      end
    end
  end
  delay_h = pzg_fndo( 1, 12,'PZGUI_pure_delay');
  if ~isempty(delay_h)
    set( delay_h,'string', pzg_efmt(PZG(1).PureDelay ) );
  end
  
  for Ck = 1:numel(PZG(1).PoleLocs)
    % Zero-out poles that are extremely close to zero.
    % Preserve their signs, however.
    if abs(PZG(1).PoleLocs(Ck)) < 1e-9
      if isreal(PZG(1).PoleLocs(Ck)) ...
        && ( PZG(1).PoleLocs(Ck) > 0 )
        PZG(1).Gain = -PZG(1).Gain;
      end
      PZG(1).PoleLocs(Ck) = 0;
    end
  end

  if ~isempty(CT_PZGUI) && ~FromUPDATEPL
    set( tempUDS(1,2),'String',pzg_efmt(PZG(1).Gain,6) );
    set( tempUDS(13,2),'String',pzg_efmt(PZG(1).Ts,6) );
    set( tempUDS(14,2),'Value',0 );
    if get(tempUDZ(14,2),'Value') && tempUDZ(11,1) && tempUDS(11,1)
      tempX = ...
        zeros( numel(get(tempUDZ(11,1),'Xdata')), 6 );
      tempY = zeros(size(tempX));
      for Dk=1:6
        tempX(:,Dk) = get(tempUDZ(Dk+10,1),'Xdata')';
        tempY(:,Dk) = get(tempUDZ(Dk+10,1),'Ydata')';
      end
      if get(tempUDZ(15,2),'Value')==3
        temp = PZG(2).Ts*((tempX+1i*tempY)+1);
        if sum(abs(temp)<eps)>0
          Ndx = flipud(sort(temp==0)); %#ok<FLPST>
          for Ck = 1:numel(Ndx)
            if Ndx(Ck)>1
              temp(Ndx(Ck)) = temp(Ndx(Ck-1))/10;
            else
              temp(1) = temp(2)/10;
            end
          end
        end
        tempZ = (2*((tempX+1i*tempY)-1))./temp;
      else
        tempZ = log(tempX+1i*tempY)/PZG(2).Ts;
      end
      tempX = real(tempZ);
      tempY = imag(tempZ);
      for Ck = 1:6
        set(tempUDS(Ck+10,1), ...
            'XData',tempX(:,Ck), ...
            'YData',tempY(:,Ck) );
      end
    end
  end

  if ~isempty(gcbf) && ~isempty(gcbo) ...
    && isequal( get(gcbf,'name'),'Discrete-Time P/Z Map G.U.I.') ...
    && isequal( get(gcbo,'type'),'uicontrol') ...
    && isequal( get(gcbo,'string'),'C-T Link by:') ...
    && isequal( get(gcbo,'value'), 1 )
    % The C-T link has just been activated.
    dtFixDC_checkbox_h = pzg_fndo( 2, 13,'Fix_DC_checkbox');
    if ~isempty(dtFixDC_checkbox_h) ...
      &&isequal(1,get(dtFixDC_checkbox_h,'value'))
      PZG(1).DCgain = PZG(2).DCgain;
      CT_PZGUI = pzg_fndo( 1, 12,'fig_h');
      if ~isempty(CT_PZGUI)
        ctFixDC_checkbox_h = pzg_fndo( 1, 12,'Fix_DC_checkbox');
        if ~isempty(ctFixDC_checkbox_h)
          set( ctFixDC_checkbox_h,'value', 1 );
        end
      end
    end
  end
  
  PZG(1).recompute_frf = 0;
  pzg_cntr(1);
  pzg_bodex(1);
  pzgui
  if ~updatepl_called
    updatepl(1);
    updatepl_called = 1;   %#ok<NASGU>
  end
  
  if strcmpi( get( gcbo,'tag'),'dpzgui Link Checkbox') ...
    && isequal( 1, get(gcbo,'value') )
    pzg_onoff(0);
    msgbox_h = ...
      msgbox( ...
        {'The C-T model is now linked to the D-T model.'; ...
         ' '; ...
         'Changes made in the D-T model will be'; ...
         'automaticallly propagated to the C-T model.'; ...
         ' ';'    Click "OK" to continue.'}, ...
        'dpzgui Advisory','modal');
    uiwait(msgbox_h)
  end
end

nrp_h = pzg_fndo( 2, 13,'number_of_poles');
if ~isempty(nrp_h)
  nr_poles = numel(PZG(2).PoleLocs);
  nr_poles_str = [ num2str(nr_poles) ' POLES'];
  if nr_poles == 0
    nr_poles_str = 'NO POLES';
  elseif nr_poles == 1
    nr_poles_str = '1 POLE';
  end
  set( nrp_h,'string', nr_poles_str );
end
nrz_h = pzg_fndo( 2, 13,'number_of_zeros');
if ~isempty(nrz_h)
  nr_zeros = numel(PZG(2).ZeroLocs);
  nr_zeros_str = [ num2str(nr_zeros) ' ZEROS'];
  if nr_zeros == 0
    nr_zeros_str = 'NO ZEROS';
  elseif nr_zeros == 1
    nr_zeros_str = '1 ZERO';
  end
  set( nrz_h,'string', nr_zeros_str );
end

updtpzln('z')
local_update_pid_ldlg

pzg_unre;
pzg_bkup;

if exist('MsgHndl','var') && ishandle(MsgHndl)
  close(MsgHndl)
end

return

function local_update_pid_ldlg
  curr_tools = pzg_tools(2);
  if curr_tools(1)
    gainfilt('z-Domain Pure Gain Design GUI');    
  elseif curr_tools(2)
    ldlgfilt('z-Domain Lead Lag Design GUI');
  elseif curr_tools(3)
    pidfilt('z-Domain PID Design GUI');
  end
return
