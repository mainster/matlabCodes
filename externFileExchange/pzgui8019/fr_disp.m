function fr_disp
% Creates and services frequency-response computation display,
% when "show FRF computation" is ON.

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

if isfield( PZG(1),'frcomp_fig') ...
  && ~isempty(PZG(1).frcomp_fig) && isequal( 1, ishandle(PZG(1).frcomp_fig) )
  ct_fr_fig_h = PZG(1).frcomp_fig;
else
  ct_fr_fig_h = ...
    findobj( allchild(0),'name','C-T O.L. Freq-Response Computation' );
  PZG(1).frcomp_fig = ct_fr_fig_h;
  if numel(ct_fr_fig_h) > 1
    delete(ct_fr_fig_h)
    ct_fr_fig_h = [];
    PZG(1).frcomp_fig = [];
  end
end

pzg_fig_h = pzg_fndo( 1, 12,'fig_h');
if isempty(pzg_fig_h)
  if ~isempty(ct_fr_fig_h)
    delete(ct_fr_fig_h)
    PZG(1).frcomp_fig = [];
  end
  return
end

if isempty(PZG(1).PoleLocs) ...
  || ( numel(PZG(1).PoleLocs) > 3 ) ...
  ||( ( numel(PZG(1).ZeroLocs) > 2 ) ...
     && ~isreal(PZG(1).ZeroLocs) )
  delete( ct_fr_fig_h )
  return
end

if isempty( PZG(1).FrqSelNdx )
  PZG(1).FrqSelNdx = pzg_gle( PZG(1).BodeFreqs, 1,'near');
  PZG(1).NegSelect = 0;
end

if ~isequal( 1, ishandle(ct_fr_fig_h) ) ...
  && isequal( 1, PZG(1).pzg_show_frf_computation )
  delete(ct_fr_fig_h)
  close_str = ...
    ['global PZG,' ...
     'PZG(1).frcomp_fig=[];' ...
     'updtpzln(''s'');' ...
     'clear temp_h,', ...
     'closereq'];
   
  ct_fr_fig_h = ...
    figure('name','C-T O.L. Freq-Response Computation', ...
       'units','normalized', ...
       'position',[0.01 0.3 0.98 0.15], ...
       'menubar','none', ...
       'numbertitle','off', ...
       'integerhandle','off', ...
       'handlevisibility','callback', ...
       'dockcontrols','off', ...
       'CloseRequestFcn', close_str, ...
       'DeleteFcn', close_str, ...
       'tag','PZGUI plot');
  PZG(1).frcomp_fig = ct_fr_fig_h;
elseif ~isequal(1,PZG(1).pzg_show_frf_computation) && ~isempty(ct_fr_fig_h)
  delete(ct_fr_fig_h)
  PZG(1).frcomp_fig = [];
  return
elseif isempty(ct_fr_fig_h)
  return
end

hndl = getappdata( ct_fr_fig_h,'hndl');

if ~isfield( hndl,'ct_fr_ax_h')
  ct_fr_ax_h = ...
    axes('parent', ct_fr_fig_h, ...
         'units','normalized', ...
         'position',[0 0 1 1], ...
         'xtick',[0 1], ...
         'ytick',[0 1]);
  hndl.ct_fr_ax_h = ct_fr_ax_h;
else
  ct_fr_ax_h = hndl.ct_fr_ax_h;
end


widths = [ 0.185; 0.225; 0.30; 0.15; 0.07 ];

if isfield( hndl,'num_text_h')
  num_text_h = hndl.num_text_h;
else
  num_text_h = [];
end
if isfield( hndl,'numden_line_h')
  numden_line_h = hndl.numden_line_h;
else
  numden_line_h = [];
end
if isfield( hndl,'den_text_h')
  den_text_h = hndl.den_text_h;
else
  den_text_h = [];
end
if isfield( hndl,'equal_sign_h')
  equal_sign_h = hndl.equal_sign_h;
else
  equal_sign_h = [];
end

for k = 1:5
  if numel(num_text_h) < k
    num_text_h(k) = ...
      text('parent', ct_fr_ax_h, ...
        'units','normalized', ...
        'position',[0.005+(k-1)*0.01+sum(widths(1:k-1)) 0.85 ], ...
        'horizontalalignment','left', ...
        'fontsize', 10, ...
        'fontweight','bold', ...
        'tag',['C-T freq resp num text ' int2str(k)]);
    hndl.num_text_h = num_text_h;
  else
    set( num_text_h(k),'string','');
  end
  
  if numel(numden_line_h) < k
    numden_line_h(k) = ...
      line('parent', ct_fr_ax_h, ...
        'xdata',0.005+(k-1)*0.01+sum(widths(1:k-1))+[ 0; widths(k)-0.01 ], ...
        'ydata',[ 0.70; 0.70 ], ...
        'color','k', ...
        'linewidth', 2, ...
        'tag',['C-T freq resp num/den sep ' int2str(k)]);
    hndl.numden_line_h = num_text_h;
  else
    set( numden_line_h(k),'string','');
  end

  if numel(den_text_h) < k
    den_text_h(k) = ...
      text('parent', ct_fr_ax_h, ...
        'units','normalized', ...
        'position',[0.005+(k-1)*0.01+sum(widths(1:k-1)) 0.55 ], ...
        'horizontalalignment','left', ...
        'fontsize', 10, ...
        'fontweight','bold', ...
        'tag',['C-T freq resp den text ' int2str(k)]);
    hndl.den_text_h = den_text_h;
  else
    set( den_text_h(k),'string','');
  end
end
for k = 1:4
  if numel(equal_sign_h) < k
    equal_sign_h(k) = ...
      text('parent', ct_fr_ax_h, ...
        'string','=', ...
        'units','normalized', ...
        'position',[-0.002+(k-1)*0.01+sum(widths(1:k)) 0.70 ], ...
        'horizontalalignment','left', ...
        'fontsize', 16, ...
        'fontweight','bold', ...
        'tag',['C-T freq resp equalsign ' int2str(k)]);
    hndl.equal_sign_h = equal_sign_h;
  else
    set( equal_sign_h(k),'string','=');
  end
end

if isfield( hndl,'final_magphs_h')
  final_magphs_h = hndl.final_magphs_h;
else
  final_magphs_h = findobj( ct_fr_ax_h,'tag','C-T freq resp final mag/phase');
end
if isempty(final_magphs_h)
  final_magphs_h = ...
    text('parent', ct_fr_ax_h, ...
      'units','normalized', ...
      'position',[ 0.30 0.15 ], ...
      'horizontalalignment','left', ...
      'fontsize', 16, ...
      'fontweight','bold', ...
      'tag','C-T freq resp final mag/phase');
  hndl.final_magphs_h = final_magphs_h;
else
  set( final_magphs_h,'string','');
end

setappdata( ct_fr_fig_h,'hndl', hndl );

set( ct_fr_ax_h, ...
    'xlim',[0 1],'ylim',[0 1], ...
    'xtick',[0 1],'ytick',[0 1]);

freq_select_marker_h = pzg_fndo( 1,(1:14),'Bode_selection_marker');
if isempty(freq_select_marker_h)
  return
else
  freq_radsec = PZG(1).BodeFreqs( PZG(1).FrqSelNdx );
end

% Populate the text box.
num_var_str = pzg_efmt( PZG(1).Gain, 4 );
num_const_str = num_var_str;
num_abs_str = ['|' pzg_efmt( PZG(1).Gain, 4 ) '|'];
num_angle_str = ['\angle(' pzg_efmt( PZG(1).Gain, 4 ) ') '];  
num_mag_str = pzg_efmt( abs(PZG(1).Gain), 4 );
num_angle_sum = 0;
if PZG(1).Gain >= 0
  num_phase_str = ' 0^o';  
else
  if PZG(1).BodePhs(1) > 0
    num_phase_str = ' +180^o';
    num_angle_sum = pi;
  else
    num_phase_str = ' -180^o';
    num_angle_sum = -pi;
  end
end

NUM = PZG(1).Gain;
for k = 1:numel(PZG(1).ZeroLocs)
  num_angle_sum = ...
    num_angle_sum + angle(1i*freq_radsec - PZG(1).ZeroLocs(k));
  this_z_str = loc_replace_i( num2str(PZG(1).ZeroLocs(k),3) );
  num_var_str = [ num_var_str, ...
        ['\bullet[ ' loc_jW ...
         '\color[rgb]{0 0 0} - (' ...
         '\color[rgb]{0.8 0 0}' this_z_str ...
         '\color[rgb]{0 0 0}) ]'] ]; %#ok<AGROW>
  num_const_str = [ num_const_str, ...
        '\bullet[ \color[rgb]{0 0.6 0.6}{\itj}' num2str(freq_radsec,3) ...
        '\color[rgb]{0 0 0} - (' ...
        '\color[rgb]{0.8 0 0}' this_z_str ...
        '\color[rgb]{0 0 0}) ]' ]; %#ok<AGROW>
  tf_factor = 1i*freq_radsec - PZG(1).ZeroLocs(k);
  NUM = NUM * tf_factor;
  num_abs_str = [ num_abs_str,'\bullet' ...
                 '|' loc_replace_i(num2str(tf_factor,3)) '|']; %#ok<AGROW>
  num_angle_str = [ num_angle_str,'+ \angle(' ...
                    loc_replace_i(num2str(tf_factor,3)) ')']; %#ok<AGROW>
  num_mag_str = [ num_mag_str,'\bullet(' ...
                  loc_replace_i(num2str(abs(tf_factor),3)) ')']; %#ok<AGROW>
  if angle(tf_factor) >= 0
    num_phase_str = ...
      [ num_phase_str,'+' ...
        num2str(angle(tf_factor)/pi*180,3) '^o']; %#ok<AGROW>
  else
    num_phase_str = ...
      [ num_phase_str,'-' ...
        num2str(-angle(tf_factor)/pi*180,3) '^o']; %#ok<AGROW>
  end
end

NUM_mag = abs(NUM);
if NUM_mag < 9999.5
  NUM_mag_str = num2str( NUM_mag,4 );
else
  NUM_mag_str = num2str( NUM_mag,3 );
end
NUM_phase_str = [ num2str( num_angle_sum/pi*180, 3 ) '^o'];

den_var_str = '';
den_const_str = '';
den_abs_str = '';
den_angle_str = '';
den_mag_str = '';
den_phase_str = '';

DEN = 1;
for k = 1:numel(PZG(1).PoleLocs)
  this_p_str = loc_replace_i( num2str(PZG(1).PoleLocs(k),3) );
  if strcmp( this_p_str(end),'i' )
    this_p_str = [ this_p_str(1:end-1) '{\itj}'];
  end
  if k > 1
    den_var_str = [ den_var_str, ...
           '\bullet[ ' ...
           '\color[rgb]{0 0.6 0.6}' loc_jW ...
           '\color[rgb]{0 0 0} - (' ...
           '\color[rgb]{0 0.8 0}' this_p_str ...
           '\color[rgb]{0 0 0}) ]']; %#ok<AGROW>
    den_const_str = [ den_const_str, ...
           '\bullet[ ' ...
           '\color[rgb]{0 0.6 0.6}{\itj}' num2str(freq_radsec,3) ...
           '\color[rgb]{0 0 0} - (' ...
           '\color[rgb]{0 0.8 0}' this_p_str ...
           '\color[rgb]{0 0 0}) ]']; %#ok<AGROW>
  else
    den_var_str = ...
      [ den_var_str ...
       '[ ' ...
       '\color[rgb]{0 0.6 0.6} ' loc_jW ...
       '\color[rgb]{0 0 0} - (' ...
       '\color[rgb]{0 0.8 0}' this_p_str ...
       '\color[rgb]{0 0 0}) ]']; %#ok<AGROW>
    den_const_str = [ den_const_str, ...
         '[ ' ...
         '\color[rgb]{0 0.6 0.6}{\itj}' num2str(freq_radsec,3) ...
         '\color[rgb]{0 0 0} - (' ...
         '\color[rgb]{0 0.8 0}' this_p_str ...
         '\color[rgb]{0 0 0}) ]']; %#ok<AGROW>
  end
  tf_factor = 1i*freq_radsec - PZG(1).PoleLocs(k);
  DEN = DEN * tf_factor;
  if k == 1
    den_abs_str = [ den_abs_str, '|'  ...
                    loc_replace_i(num2str(tf_factor,3)) '|']; %#ok<AGROW>
    den_angle_str = [ den_angle_str, '\angle(' ...
                      loc_replace_i(num2str(tf_factor,3)) ')']; %#ok<AGROW>
    den_mag_str = [ den_mag_str, '(' ...
                    loc_replace_i(num2str(abs(tf_factor),3)) ')']; %#ok<AGROW>
    den_phase_str = ...
      [ den_phase_str, ...
        num2str(angle(tf_factor)/pi*180,3) '^o']; %#ok<AGROW>
  else
    den_abs_str = [ den_abs_str, '\bullet|' ...
                    loc_replace_i(num2str(tf_factor,3)) '|']; %#ok<AGROW>
    den_angle_str = [ den_angle_str, '+ \angle(' ...
                      loc_replace_i(num2str(tf_factor,3)) ')']; %#ok<AGROW>
    den_mag_str = [ den_mag_str, '\bullet('  ...
                    loc_replace_i(num2str(abs(tf_factor),3)) ')']; %#ok<AGROW>
    if angle(tf_factor) >= 0
      den_phase_str = ...
        [ den_phase_str, '+' ...
          num2str(angle(tf_factor)/pi*180,3) '^o']; %#ok<AGROW>
    else
      den_phase_str = ...
        [ den_phase_str, '-' ...
          num2str(-angle(tf_factor)/pi*180,3) '^o']; %#ok<AGROW>
    end
  end
end

while ~isempty(strfind(num_var_str,'e+0'))
  ndx_e0 = strfind(num_var_str,'e+0');
  for k = numel(ndx_e0):-1:1
    num_var_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(den_var_str,'e+0'))
  ndx_e0 = strfind(den_var_str,'e+0');
  for k = numel(ndx_e0):-1:1
    den_var_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(num_const_str,'e+0'))
  ndx_e0 = strfind(num_const_str,'e+0');
  for k = numel(ndx_e0):-1:1
    num_const_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(den_const_str,'e+0'))
  ndx_e0 = strfind(den_const_str,'e+0');
  for k = numel(ndx_e0):-1:1
    den_const_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(num_abs_str,'e+0'))
  ndx_e0 = strfind(num_abs_str,'e+0');
  for k = numel(ndx_e0):-1:1
    num_abs_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(den_abs_str,'e+0'))
  ndx_e0 = strfind(den_abs_str,'e+0');
  for k = numel(ndx_e0):-1:1
    den_abs_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(num_angle_str,'e+0'))
  ndx_e0 = strfind(num_angle_str,'e+0');
  for k = numel(ndx_e0):-1:1
    num_angle_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(den_angle_str,'e+0'))
  ndx_e0 = strfind(den_angle_str,'e+0');
  for k = numel(ndx_e0):-1:1
    den_angle_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(num_mag_str,'e+0'))
  ndx_e0 = strfind(num_mag_str,'e+0');
  for k = numel(ndx_e0):-1:1
    num_mag_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(den_mag_str,'e+0'))
  ndx_e0 = strfind(den_mag_str,'e+0');
  for k = numel(ndx_e0):-1:1
    den_mag_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(num_phase_str,'e+0'))
  ndx_e0 = strfind(num_phase_str,'e+0');
  for k = numel(ndx_e0):-1:1
    num_phase_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(den_phase_str,'e+0'))
  ndx_e0 = strfind(den_phase_str,'e+0');
  for k = numel(ndx_e0):-1:1
    den_phase_str(ndx_e0(k)+2) = '';
  end
end

DEN_mag = abs(DEN);
if DEN_mag < 9999.5
  DEN_mag_str = num2str( DEN_mag,4 );
else
  DEN_mag_str = num2str( DEN_mag,3 );
end
DEN_phase_str = [ num2str( angle(DEN)/pi*180, 3 ) '^o'];

while ~isempty(strfind(NUM_mag_str,'e+0'))
  ndx_e0 = strfind(NUM_mag_str,'e+0');
  for k = numel(ndx_e0):-1:1
    NUM_mag_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(DEN_mag_str,'e+0'))
  ndx_e0 = strfind(DEN_mag_str,'e+0');
  for k = numel(ndx_e0):-1:1
    DEN_mag_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(NUM_phase_str,'e+0'))
  ndx_e0 = strfind(NUM_phase_str,'e+0');
  for k = numel(ndx_e0):-1:1
    NUM_phase_str(ndx_e0(k)+2) = '';
  end
end
while ~isempty(strfind(DEN_phase_str,'e+0'))
  ndx_e0 = strfind(DEN_phase_str,'e+0');
  for k = numel(ndx_e0):-1:1
    DEN_phase_str(ndx_e0(k)+2) = '';
  end
end

set( num_text_h(1),'string', num_var_str );
set( den_text_h(1),'string', den_var_str );

set( num_text_h(2),'string', num_const_str );
set( den_text_h(2),'string', den_const_str );

set( num_text_h(3),'string', ...
     [ num_abs_str '  \angle\{' num_angle_str '\}'],'fontsize', 10 );
set( den_text_h(3),'string', ...
     [ den_abs_str '  \angle\{' den_angle_str '\}' ],'fontsize', 10 );

set( num_text_h(4),'string', [ num_mag_str '  \angle\{' num_phase_str '\}'] );
set( den_text_h(4),'string', [ den_mag_str '  \angle\{' den_phase_str '\}'] );

set( num_text_h(5),'string', [ NUM_mag_str '  \angle' NUM_phase_str ] );
set( den_text_h(5),'string', [ DEN_mag_str '  \angle' DEN_phase_str ] );

for k = 1:5
  num_chars = numel(get(num_text_h(k),'string'));
  if k < 5
    if num_chars < 30
      set(num_text_h(k),'fontsize',11)
    elseif num_chars < 45
      set(num_text_h(k),'fontsize',10)
    elseif num_chars < 75
      set(num_text_h(k),'fontsize',9)
    else
      set(num_text_h(k),'fontsize',8)
    end
    den_chars = numel(get(den_text_h(k),'string'));
    if den_chars < 30
      set(den_text_h(k),'fontsize',11)
    elseif den_chars < 45
      set(den_text_h(k),'fontsize',10)
    elseif den_chars < 75
      set(den_text_h(k),'fontsize',9)
    else
      set(den_text_h(k),'fontsize',8)
    end
  else
    if num_chars < 10
      set(num_text_h(k),'fontsize',14)
    else
      set(num_text_h(k),'fontsize',12)
    end
    den_chars = numel(get(den_text_h(k),'string'));
    if den_chars < 10
      set(den_text_h(k),'fontsize',14)
    else
      set(den_text_h(k),'fontsize',12)
    end
  end
end

final_magphs = NUM/DEN;
if PZG(1).Gain >= 0
  rnd_final_phs = 0.1*round( 10*angle(final_magphs)/pi*180 );
  final_phs_str = pzg_efmt( rnd_final_phs, 3 );
else
  rnd_final_phs = 0.1*round( 10*( num_angle_sum - angle(DEN) )/pi*180 );
  if rnd_final_phs >= 99.5
    final_phs_str = pzg_efmt( rnd_final_phs, 4 );
  else
    final_phs_str = pzg_efmt( rnd_final_phs, 3 );
  end
end
rnd_final_dB = 0.1*round( 10 * 20*log10(abs(final_magphs)) );

set( final_magphs_h, ...
    'string', ...
      [ 'H( \color[rgb]{0 0.6 0.6}{\itj}_ \omega' ...
        '\color[rgb]{0 0 0} )  =   ' ...
        'H( \color[rgb]{0 0.6 0.6}{\itj}_ ' pzg_efmt(freq_radsec,3) ...
        '\color[rgb]{0 0 0} )  =   ' ...
        pzg_efmt( abs(final_magphs), 3 ) ...
        ' \angle' final_phs_str '^o    ' ...
        '=   ' ...
        pzg_efmt( rnd_final_dB, 3 ) ...
        ' dB \angle' final_phs_str '^o'] )
            
return

function jW = loc_jW
  jW = '\color[rgb]{0 0.6 0.6}{\itj}\omega'; 
return

function this_str = loc_replace_i(this_str)
  if ~nargin
    this_str = '';
  elseif isempty(this_str) || ~ischar(this_str) ...
    || ( size(this_str,1) > 1 )
    return
  end
  if strcmp( this_str(end),'i')
    % Look for '+' or '-' sign.
    plus_e_ndx = strfind( lower(this_str),'e+');
    minus_e_ndx = strfind( lower(this_str),'e-');
    e_ndxs = [ plus_e_ndx(:); minus_e_ndx(:) ]';
    if ~isempty(e_ndxs)
      e_ndxs = 1 + e_ndxs;
    end
    
    plus_ndx = strfind( this_str,'+');
    if ~isempty(e_ndxs)
      plus_ndx = setdiff( plus_ndx, e_ndxs );
    end
    
    minus_ndx = strfind( this_str,'-');
    if ~isempty(e_ndxs)
      minus_ndx = setdiff( minus_ndx, e_ndxs );
    end
    
    if isempty(plus_ndx) && isempty(minus_ndx)
      this_str = [ '{\itj}' this_str(1:end-1) ];
    elseif ~isempty(plus_ndx) && ~isempty(minus_ndx)
      put_ndx = max( minus_ndx, plus_ndx );
      this_str = [ this_str(1:put_ndx) '{\itj}' this_str(put_ndx+1:end-1) ];
    elseif ~isempty(minus_ndx)
      put_ndx = max(minus_ndx);
      this_str = [ this_str(1:put_ndx) '{\itj}' this_str(put_ndx+1:end-1) ];
    else
      this_str = [ this_str(1:plus_ndx) '{\itj}' this_str(plus_ndx+1:end-1) ];
    end
  end
return

