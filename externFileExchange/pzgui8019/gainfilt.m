function   gainfilt( Domain, DeleteAll, quiet )
% Creates and services the pure-gain design tool in PZGUI.

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
if ( numel(Domain) > 1 ) ...
  &&( strcmpi( Domain(1),'s') || strcmpi( Domain(1),'z') )
  Domain_arg = Domain(2:end);
end

if strcmpi( Domain(1),'s') ...
  ||( ( numel(Domain) > 12 )...
     && strcmpi( Domain(1:10),'continuous') )
  Domain = 's';
  dom_ndx = 1;
  GainFig = PZG(1).Gain_fig;
  GainFigName = get( GainFig,'name');
elseif strcmpi( Domain(1),'z') ...
  ||( ( numel(Domain) > 12 )...
     && strcmpi( Domain(1:8),'discrete') )
  Domain = 'z';
  dom_ndx = 2;
  GainFig = PZG(2).Gain_fig;
  GainFigName = get( GainFig,'name');
elseif strcmpi( Domain,'mouse motion')
  GainFig = GCBF;
  GainFigName = get( GainFig,'name');
  if strcmpi( GainFigName(1),'s')
    Domain = 's';
    dom_ndx = 1;
  else
    Domain = 'z';
    dom_ndx = 2;
  end
else
  return
end
if isempty(GainFig)
  GainFigName = [ Domain '-Domain Pure Gain Design GUI'];
  GainFig = findobj( allchild(0),'name', GainFigName );
  if numel(GainFig) > 1
    delete(GainFig)
    GainFig = [];
  end
end

if ~isempty(GainFig) && isequal( 1, ishandle(GainFig) ) ...
  && isappdata(GainFig,'hndl')
  PZG(dom_ndx).Gain_fig = GainFig;
  hndl = getappdata(GainFig,'hndl');
else
  if ~isempty(GainFig)
    delete(GainFig)
    GainFig = [];
  end
  hndl = [];
end
if isempty(GainFig) ...
  ||( ( nargin == 2 ) && ~isequal( DeleteAll, 0 ) )
  prvw_h = pzg_fndo( dom_ndx,[(1:9),dom_ndx+9],'Gain_Preview');
  if ~isempty(prvw_h)
    set( prvw_h,'visible','off')
  end
end

% Enforce validity of pure-gain controller data.
if ~isfield(PZG,'puregain')
  PZG(1).puregain = [];
  PZG(2).puregain = [];
end

slider_is_moving = 0;
if ( nargin == 1 ) && strcmpi( Domain_arg,'mouse motion') && ~isempty(gcbf)
  % See if slider has been adjusted.
  GainFig = gcbf;
  if ~isfield( hndl,'puregain_slider')
    return
  end
  slider_is_moving = 1;
  slider_value = get( hndl.puregain_slider,'value');
  if ~isappdata( hndl.puregain_slider,'old_slider')
    old_slider_values = slider_value;
    setappdata( hndl.puregain_slider,'old_slider', old_slider_values )
    return
  else
    old_slider_values = getappdata( hndl.puregain_slider,'old_slider');
    if ~isnumeric(old_slider_values) || ( numel(old_slider_values) ~= 1 )
      old_slider_values = 0.5;
      setappdata( hndl.puregain_slider,'old_slider', old_slider_values )
    end
  end
  gcbf_name = get(GainFig,'name');
  if strcmpi( gcbf_name,'s-Domain Pure Gain Design GUI')
    Domain = 's';
  elseif strcmpi( gcbf_name,'z-Domain Pure Gain Design GUI')
    Domain = 'z';
  else
    return
  end
  if isempty(hndl.preview_pushbutton) || isempty(hndl.clear_preview_pushbutton)
    return
  end

  if isequal( slider_value, old_slider_values )
    existing_prev_h = pzg_fndo( dom_ndx,[(1:9),9+dom_ndx],'Gain_Preview');
    if ~isempty(hndl.preview_pushbutton)
      if isequal( get(hndl.preview_pushbutton,'backgroundcolor'),[0.5 1 0.5] )
        set( [ hndl.puregain_slider; hndl.puregain_slider_label; ...
               hndl.clear_preview_pushbutton ],'visible','on');
      else
        set( [ hndl.puregain_slider; hndl.puregain_slider_label; ...
               hndl.clear_preview_pushbutton ],'visible','off');
        if ~isempty(existing_prev_h)
          set( existing_prev_h,'visible','off');
        end
      end
    end
    return
  else
    new_slider_values = slider_value;
    setappdata( hndl.puregain_slider,'old_slider', new_slider_values )
  end
  
  curr_gain = str2double( get( hndl.Gain,'string') );
  old_slider = old_slider_values;
  if old_slider == 0.5
    base_gain = curr_gain;
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
  set( hndl.Gain,'string', num2str(new_gain,6) );
  if strcmp( Domain,'s')
    PZG(1).puregain = new_gain;
  else
    PZG(2).puregain = new_gain;
  end
end

if nargin < 2
  DeleteAll = 0;
end
if nargin < 3
  quiet = 0;
end

if ~isnumeric( PZG(1).puregain )
  PZG(1).puregain = [];
elseif ndims( PZG(1).puregain ) > 2 %#ok<ISMAT>
  PZG(1).puregain = [];
elseif ~isequal(numel(PZG(1).puregain), 1 )
  PZG(1).puregain = [];
end
if ~isnumeric( PZG(2).puregain )
  PZG(2).puregain = [];
elseif ndims( PZG(2).puregain ) > 2 %#ok<ISMAT>
  PZG(2).puregain = [];
elseif ~isequal(numel(PZG(2).puregain), 1 )
  PZG(2).puregain = [];
end

LdLgFig = PZG(dom_ndx).LDLG_fig;
PidFig = PZG(dom_ndx).PID_fig;
if ~isempty(PidFig) && ( ( nargin < 1 ) || ~DeleteAll )
  questdlg_ans = ...
    questdlg({'The PID design GUI must be closed before opening'; ...
              'the pure-gain design GUI.'; ...
              ' '; ...
              'Do you want the PID design GUI to be closed?'}, ...
              'Must Close PID Design GUI', ...
              'Yes, close it','No, Leave it open','Yes, close it');
  if strcmpi( questdlg_ans,'No, Leave it open')
    return
  else
    close(PidFig)
  end
elseif ~isempty(LdLgFig) && ( ( nargin < 2 ) || ~DeleteAll )
  questdlg_ans = ...
    questdlg({'The Lead-Lag design GUI must be closed before opening'; ...
              'the pure-gain design GUI.'; ...
              ' '; ...
              'Do you want the Lead-Lag design GUI to be closed?'}, ...
              'Must Close Lead-Lag Design GUI', ...
              'Yes, close it','No, Leave it open','Yes, close it');
  if strcmpi( questdlg_ans,'No, Leave it open')
    return
  else
    close(LdLgFig)
  end
end
blank_h = ...
  [ pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'LDLG_Preview'); ...
    pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'PID_Preview') ];
if ~isempty(blank_h)
  set( blank_h,'visible','off')
end

if isempty(GCBF) || ~isequal( GCBF, GainFigName )
  quiet = 1;
end

hSize = 1/5;
vSize = 0.12;
xSpace = (1-4*hSize)/4;
Col2 = 3.5*xSpace + hSize;
Col4 = 3.5*xSpace + 3*hSize;
Row1 = 1 - vSize;
Row2 = 1 - 2*vSize;
Row3 = 1 - 3*vSize;
Row4 = 0.001 + 2*vSize;
Row5 = 0.001 + vSize;
Row6 = 0.001;

if DeleteAll
  local_clear_preview( dom_ndx )
  design_line_h = pzg_fndo( dom_ndx, 6,'CL_0dB_contour');
  if ~isempty(design_line_h)
    set(design_line_h,'xdata',[],'ydata',[],'visible','off');
  end
  design_text_h = pzg_fndo( dom_ndx, 6,'LeadLag_Text');
  if ~isempty(design_text_h)
    set(design_text_h,'string','','visible','off');
  end
  if isequal( 1, ishandle(GainFig) )
    if isfield( hndl,'no_vis_axes')
      gain_ax_h = hndl.no_vis_axes;
    else
      gain_ax_h = findobj(GainFig,'type','axes');
    end
    if ~isempty(gain_ax_h)
      if numel(gain_ax_h) > 1
        delete(gain_ax_h(2:end))
      end
      set(gain_ax_h(1),'tag','no-vis axes','visible','off');
    end
  end
  return
end

if strcmpi( Domain_arg,'preview')
  set( hndl.preview_pushbutton,'enable','on', ...
      'backgroundcolor', [0.5 1 0.5] );
  set( hndl.clear_preview_pushbutton,'visible','on');
  set( hndl.puregain_slider_label,'visible','on');
  set( hndl.puregain_slider,'visible','on');
elseif strcmpi( Domain_arg,'clear_preview')
  local_clear_preview( dom_ndx )
  return
end

mod_hndl = 0;

new_figure = 0;
if isempty(GainFig)
  new_figure = 1;
  scr_size = get( 0,'screensize');
  GainFig = ...
    figure('menubar','none', ...
       'units','pixels', ...
       'Name', GainFigName, ...
       'position',[scr_size(3)/2 scr_size(4)/6 510 150], ...
       'numbertitle','off', ...
       'integerhandle','off', ...
       'tag','PZGUI plot', ...
       'handlevisibility','callback', ...
       'dockcontrols','off', ...
       'visible','off', ...
       'deletefcn', ...
         ['global PZG,' ...
          'gainfilt(get(gcbf,''name''),1);' ...
          'PZG(' num2str(dom_ndx) ').Gain_fig=[];'], ...
       'windowbuttonmotionfcn', ...
         [ mfilename '(''mouse motion'');']);
  PZG(dom_ndx).Gain_fig = GainFig;
  set( GainFig,'units','normalized');
  hndl = [];
  mod_hndl = 1;
end

if ~isfield( hndl,'no_vis_axes')
  mod_hndl = 1;
  hndl.no_vis_axes = ...
    axes('parent', GainFig,'tag','no-vis axes','visible','off');
end

GainInit = PZG(dom_ndx).puregain;
if isempty(GainInit)
  GainInit = 1;
  PZG(dom_ndx).puregain = 1;
end


if ~isfield( hndl,'preview_pushbutton')
  mod_hndl = 1;
  hndl.preview_pushbutton = ...
    uicontrol( GainFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4 (0.8*Row1+0.2*Row2) hSize 1.1*vSize ], ...
      'string','Preview', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Preview', ...
      'tooltipstring','pre-view the effects of the extra gain factor', ...
      'Callback', ...
        ['tempPRVcbo=gcbo;' ...
         'set(tempPRVcbo,''enable'',''off'');' ...
         'try,' ...
         'gainfilt(''' Domain 'Preview'');' ...
         'catch,pzg_err(''Pure Gain Preview pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempPRVcbo,''enable'',''on'');' ...
         'clear tempPRVcbo'] );
end

if ~isfield( hndl,'GainText1')
  mod_hndl = 1;
  hndl.GainText1 = ...
    uicontrol( GainFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 Row4 hSize vSize ], ...
      'backgroundcolor', get(GainFig,'color'), ...
      'string','Gain', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tooltipstring','Extra gain factor to multiply current gain', ...
      'tag','GainText1');
end
if ~isfield( hndl,'GainText2')
  mod_hndl = 1;
  hndl.GainText2 = ...
    uicontrol( GainFig,'style','text', ...
      'units','normalized', ...
      'position',[ Col2 Row6 hSize vSize ], ...
      'backgroundcolor', get(GainFig,'color'), ...
      'string','', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','GainText2');
end
if ~isfield( hndl,'Gain')
  mod_hndl = 1;
  hndl.Gain = ...
    uicontrol( GainFig,'style','edit', ...
      'units','normalized', ...
      'position',[ Col2 Row5 hSize vSize ], ...
      'string',num2str(GainInit), ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Gain', ...
      'tooltipstring','Extra gain factor to multiply current gain', ...
      'Callback','gainfilt(get(gcbf,''Name''))');
end

if ~isfield( hndl,'clear_preview_pushbutton')
  mod_hndl = 1;
  hndl.clear_preview_pushbutton = ...
    uicontrol( GainFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4 (0.6*Row2+0.4*Row3) 1.05*hSize vSize ], ...
      'string','clear preview', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'visible','off', ...
      'tag','clear preview', ...
      'Callback', ...
        ['tempCLRcbo=gcbo;' ...
         'set(tempCLRcbo,''enable'',''off'');' ...
         'try,' ...
         'gainfilt(''' Domain 'clear_preview'');' ...
         'catch,pzg_err(''Pure Gain Clear Preview pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempCLRcbo,''enable'',''on'');' ...
         'clear tempCLRcbo'] );
end

if ~isfield( hndl,'apply_pushbutton')
  mod_hndl = 1;
  hndl.apply_pushbutton = ...
    uicontrol( GainFig,'style','pushbutton', ...
      'units','normalized', ...
      'position',[ Col4+0.1*hSize 1.5*vSize 0.8*hSize 1.2*vSize ], ...
      'string','Apply', ...
      'fontweight','bold', ...
      'fontsize', 12, ...
      'tag','Apply', ...
      'tooltipstring','Apply the extra gain factor into the model', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'try,' ...
         'gainfilt(''' Domain 'Apply'');' ...
         'catch,pzg_err(''Pure Gain Apply pushbutton'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
end

if ~isfield( hndl,'puregain_slider_label')
  mod_hndl = 1;
  hndl.puregain_slider_label = ...
    uicontrol( GainFig,'style','text', ...
      'units','normalized', ...
      'position',[ 0.04 4.8*vSize 0.5 vSize ], ...
      'string','Vary the Gain with this slider', ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'backgroundcolor', get( GainFig,'color'), ...
      'visible','off', ...
      'tag','puregain slider label');
end

if ~isfield( hndl,'puregain_slider')
  mod_hndl = 1;
  hndl.puregain_slider = ...
    uicontrol( GainFig,'style','slider', ...
      'units','normalized', ...
      'position',[ 0.003 3.7*vSize 0.93 vSize ], ...
      'value', 0.5, ...
      'sliderstep',[0.0025 0.025], ...
      'fontweight','bold', ...
      'fontsize', 10, ...
      'backgroundcolor',[0.5 1 0.5], ...
      'tag','puregain slider', ...
      'visible','off', ...
      'Callback', ...
        ['tempAPPcbo=gcbo;' ...
         'set(tempAPPcbo,''enable'',''off'');' ...
         'try,' ...
         'gainfilt(get(gcbf,''Name''));' ...
         'catch,pzg_err(''Pure Gain slider'');end,' ...
         'drawnow,' ...
         'set(tempAPPcbo,''enable'',''on'');' ...
         'clear tempAPPcbo'] );
end

if mod_hndl
  setappdata( GainFig,'hndl', hndl );
end

pzgplot_h = pzg_fndo( dom_ndx,[ (1:9), 9+dom_ndx ],'fig_h');
if isempty(pzgplot_h)
  set( hndl.preview_pushbutton, ...
      'enable','on', ...
      'backgroundcolor', 0.9412*[1 1 1] );
  set( hndl.clear_preview_pushbutton,'visible','off')
  set( hndl.puregain_slider,'visible','off')
  set( hndl.puregain_slider_label,'visible','off')
else
  set( hndl.preview_pushbutton,'enable','on','visible','on');
  if isequal( get(hndl.preview_pushbutton,'backgroundcolor'), [0.5 1 0.5] )
    set( hndl.clear_preview_pushbutton,'visible','on')
    set( hndl.puregain_slider,'visible','on')
    set( hndl.puregain_slider_label,'visible','on')
  else
    set( hndl.clear_preview_pushbutton,'visible','off')
    set( hndl.puregain_slider,'visible','off')
    set( hndl.puregain_slider_label,'visible','off')
  end
end

set( GainFig,'visible','on')
if new_figure && isempty( pzgplot_h )
  return
end

if isempty(GCBO) && isempty(Domain_arg)
  return
end

if isempty(pzgplot_h)
  if strcmpi( Domain_arg,'preview')
    errdlg_h = ...
      errordlg( ...
        {'No preview plots are currently open.'; ...
         ' '; ...
         'The pure-gain design is previewed in frequency-response plots'; ...
         'and time-response plots.'; ...
         ' '; ...
         ['Currently, the only open ' upper(Domain) ...
           '-domain plots are pole/zero maps,']; ...
         'which are unaffected by a change in the gain.'}, ...
      'Pure-Gain Design:  advisory','modal');
    uiwait(errdlg_h)
    return
  end
end

GCBOtag = get(GCBO,'Tag');
TagNdx = 0;
if isappdata( hndl.puregain_slider,'old_slider')
  old_slider_values = getappdata( hndl.puregain_slider,'old_slider');
  if ~isnumeric(old_slider_values) ...
    || ~isequal( numel(old_slider_values), 1 )
    setappdata( hndl.puregain_slider,'old_slider', 0.5 );
    old_slider_values = 0.5;
  end
else
  setappdata( hndl.puregain_slider,'old_slider', 0.5 );
  old_slider_values = 0.5;
end

Gain = str2double( get(hndl.Gain,'string') );
if strcmp( GCBOtag,'Gain')
  TagNdx = 1;
  old_slider_values = 0.5;
  setappdata( hndl.puregain_slider,'old_slider', old_slider_values );
  set( hndl.puregain_slider,'value', 0.5 );
end

if TagNdx == 1
  temp = str2num( get( GCBO,'string') ); %#ok<ST2NM>
  if TagNdx == 1
    temp = abs(temp);
  end
  if ~strcmp( get( GCBO,'style'),'checkbox')
    set( GCBO,'string', num2str(temp) );
    if ~isempty(temp)
      PZG(dom_ndx).puregain(TagNdx) = temp;
    end
  end
  
  set( hndl.Gain,'string', num2str(Gain,9) )
  set( hndl.puregain_slider,'value', old_slider_values );
  setappdata( hndl.puregain_slider,'old_slider', old_slider_values );
  PZG(dom_ndx).puregain = Gain;
end

% Create or update preview whenever preview lines already exist,
% or the user has pushed the "preview" pushbutton.
preview_on = 0;
if strcmp( get(hndl.puregain_slider,'visible'),'on')
  preview_on = 1;
end

if strcmpi( GCBOtag,'Preview') ...
  ||( preview_on ...
     && ~strcmpi( GCBOtag,'clear preview') ...
     && ~strcmpi( GCBOtag,'Apply') )
  
  visoff_h = ...
    [ pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'LDLG_Preview'); ...
      pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'PID_Preview') ];
  if ~isempty(visoff_h)
    set( visoff_h,'visible','off')
  end

  % Compute and display the bode.
  Gain = real( str2num( get( hndl.Gain,'string') ) ); %#ok<ST2NM>
  if isempty(Gain)
    set( hndl.preview_pushbutton,'backgroundcolor',0.9412*[1 1 1]);
    set([hndl.puregain_slider;hndl.puregain_slider_label],'visible','off');
    if isequal( 0, slider_is_moving )
      errdlg_h = ...
        errordlg({'Gain is unspecified.'; ...
                  ' ';'    Click "OK" to continue ...';' '}, ...
                 'Filter Preview Error','modal');
      uiwait(errdlg_h)
    end
    return
  elseif ~isreal(Gain)
    set( hndl.preview_pushbutton,'backgroundcolor',0.9412*[1 1 1]);
    set([ hndl.puregain_slider;hndl.puregain_slider_label; ...
          hndl.clear_preview_pushbutton ],'visible','off');
    errordlg('The gain must be real-valued.', ...
             'Filter Preview Error')
    return
  end
  set( hndl.preview_pushbutton,'backgroundcolor', [0.5 1 0.5]);
  set([hndl.puregain_slider;hndl.puregain_slider_label],'visible','on');
  Freqs = PZG(dom_ndx).BodeFreqs;
  CplxBode = Gain * ones(size(Freqs));
  Mag = 20*log10(abs(Gain)) * ones(size(Freqs));
  Phs = 180/pi*angle(Gain) * ones(size(Freqs));
  
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
    nich_ax_h = PZG(dom_ndx).plot_h{6}.ax_h;
    nyqmap_h = pzg_fndo( dom_ndx, 6,'show_nyq_mapping_checkbox');
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
    LineH = pzg_fndo( dom_ndx, 6,'Gain_Preview');
    if size(BasePhs,1) == 1
      xdata = [ BasePhs(LineNdx); ...
                BasePhs(LineNdx)+LinePhs(:)'; ...
                NaN*ones(1,numel(LineNdx)) ];          
    else
      xdata = [ BasePhs(LineNdx)'; ...
                ( BasePhs(LineNdx)+LinePhs(:) )'; ...
                NaN*ones(1,numel(LineNdx)) ];          
    end
    if size(PZG(dom_ndx).BodeMag,1) == 1
      ydata = [ PZG(dom_ndx).BodeMag(LineNdx); ...
                PZG(dom_ndx).BodeMag(LineNdx)+LineMag(:)'; ...
                NaN*ones(1,numel(LineNdx)) ];          
    else
      ydata = [ PZG(dom_ndx).BodeMag(LineNdx)'; ...
                ( PZG(dom_ndx).BodeMag(LineNdx)+LineMag(:) )'; ...
                NaN*ones(1,numel(LineNdx)) ];          
    end
    if ~isequal( numel(LineH), 3 )
      delete(LineH)
      LineH = ...
        plot( xdata(:), ydata(:), ...
          'color','y', ...
          'linewidth', 0.5, ...
          'parent', nich_ax_h, ...
          'tag',[Domain 'Gain Preview'] );
    else
      set( LineH(1), ...
          'xdata', xdata(:), ...
          'ydata', ydata(:), ...
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
    if ~isequal( numel(LineH), 3 )
      LineH(2) = ...
        plot( xdata, ydata, ...
           'color','m', ...
           'linewidth', 3, ...
           'tag',[Domain 'Gain Preview'], ...
           'parent', get( NicholFig,'currentaxes') );
      conjline_h = ...
        plot( -xdata, ydata, ...
           'color',[0.7 0.7 0.7], ...
           'linestyle','-', ...
           'linewidth', 2, ...
           'tag',[Domain 'Gain Preview'], ...
           'parent', get( NicholFig,'currentaxes') );
      LineH(3) = conjline_h;
      PZG(dom_ndx).plot_h{6}.hndl.Gain_Preview = LineH(:);
    else
      set( LineH(end-1), ...
          'xdata', xdata, ...
          'ydata', ydata, ...
          'color','m', ...
          'linewidth', 3, ...
          'visible','on')
      set( LineH(end), ...
          'xdata', -xdata, ...
          'ydata', ydata, ...
          'color', [0.7 0.7 0.7], ...
          'linewidth', 2 )
      conjline_h = LineH(end);
    end
    if get( nyqmap_h,'value')
      set( conjline_h,'visible','on');
    else
      set( conjline_h,'visible','off');
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
                 'closed loop',[Domain 'Gain'], 1 ); %#ok<NASGU,ASGLU>
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
    if isequal( 0, slider_is_moving )
      msgbox_h = ...
        msgbox( ...
         {'With this gain, the closed-loop system is unstable.'; ...
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
    dB_checkbox_h = pzg_fndo( dom_ndx, 3,'BodeDBChkbox');
    if ~isempty(dB_checkbox_h)
      if ~get(dB_checkbox_h,'value')
        CLMag = 10.^(CLMag/20);
      end
    end
    plotFreqs = Freqs;
    hz_checkbox_h = pzg_fndo( dom_ndx, 3,'BodeHZChkbox');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 3,'Gain_Preview');
    if CLstable
      if ~isequal( numel(LineH), 1 )
        delete(LineH)
        LineH = ...
          plot( plotFreqs, CLMag,'m', ...
             'parent', get(CLMagFig,'currentaxes'), ...
             'linewidth', 2, ...
             'tag',[Domain 'Gain Preview']);
        PZG(dom_ndx).plot_h{3}.hndl.Gain_Preview = LineH;
      else
        set( LineH,'xdata', plotFreqs,'ydata', CLMag,'visible','on')
      end
    else
      set( LineH,'visible','off')
    end
    if strcmp( get( PZG(dom_ndx).plot_h{3}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{3}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 3 );
    end
  end
  CLPhsFig = pzg_fndo( dom_ndx, 4,'fig_h');
  if ~isempty(CLPhsFig)
    unwrap_h = pzg_fndo( dom_ndx, 4,'UnwrapChkbox');
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
    LineH = pzg_fndo( dom_ndx, 4,'Gain_Preview');
    if CLstable
      if ~isequal( 1, numel(LineH) )
        delete(LineH)
        LineH = ...
          plot( plotFreqs, CLPhs,'m', ...
            'parent', get(CLPhsFig,'currentaxes'), ...
            'tag',[Domain 'Gain Preview'], ...
            'linewidth', 2 );
        PZG(dom_ndx).plot_h{4}.hndl.Gain_Preview = LineH;
        if ~CLstable
          set( LineH,'visible','off');
        end
      else
        set( LineH,'xdata', plotFreqs,'ydata', CLPhs,'visible','on')
      end
    else
      set( LineH,'visible','off')
    end
    if strcmp( get( PZG(dom_ndx).plot_h{4}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{4}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 4 );
    end
  end
  
  OLMagFig = pzg_fndo( dom_ndx, 1,'fig_h');
  if ~isempty(OLMagFig)
    % Determine if log y-axis is currently selected.
    dB_checkbox_h = pzg_fndo( dom_ndx, 1,'BodeDBChkbox');
    filtMag = 20*log10(abs(CplxBode));
    compMag = filtMag + PZG(dom_ndx).BodeMag;
    if ~isempty(dB_checkbox_h)
      if ~get(dB_checkbox_h,'value')
        filtMag = abs(CplxBode);
        compMag = filtMag .* 10.^(PZG(dom_ndx).BodeMag/20);
      end
    end
    plotFreqs = Freqs;
    hz_checkbox_h = pzg_fndo( dom_ndx, 1,'BodeHZChkbox');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 1,'Gain_Preview');
    if ~isequal( 1, numel(LineH) )
      delete(LineH)
      LineH = ...
        plot( plotFreqs, compMag,'m', ...
           'parent', get(OLMagFig,'currentaxes'), ...
           'tag',[Domain 'Gain Preview'], ...
           'linewidth', 2 );
    else
      set( LineH,'xdata', plotFreqs,'ydata', compMag,'visible','on')
    end
    PZG(dom_ndx).plot_h{1}.hndl.Gain_Preview = LineH;
    if strcmp( get( PZG(dom_ndx).plot_h{1}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{1}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 1 );
    end
  end
  OLPhsFig = pzg_fndo( dom_ndx, 2,'fig_h');
  if ~isempty(OLPhsFig)
    plotFreqs = Freqs;
    hz_checkbox_h = pzg_fndo( dom_ndx, 2,'BodeHZChkbox');
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
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
    
    LineH = pzg_fndo( dom_ndx, 2,'Gain_Preview');
    if ~isequal( 1, numel(LineH) )
      delete(LineH)
      LineH = ...
        plot( plotFreqs, OLPhs_ydata,'m', ...
           'parent', get(OLPhsFig,'currentaxes'), ...
           'tag',[Domain 'Gain Preview'], ...
           'linewidth', 2 );
      PZG(dom_ndx).plot_h{2}.hndl.Gain_Preview = LineH;
    else
      set( LineH,'xdata', plotFreqs,'ydata', OLPhs_ydata,'visible','on')
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
    LineH = pzg_fndo( dom_ndx, 7,'Gain_Preview');
    hyb_h = pzg_fndo( dom_ndx, 7,'rescale_checkbox');
    if isempty(hyb_h) || ~get( hyb_h,'value')
      if ~isequal( 2, numel(LineH) )
        delete(LineH)
        LineH = ...
          [ plot( line_ud.OLCplxBode, ...
              'color',[0.7 0 0.7], ...
              'parent', get(NyqFig,'currentaxes'), ...
              'tag',[Domain 'Gain Preview'], ...
              'userdata', line_ud, ...
              'linewidth', 2 );
            plot( conj(line_ud.OLCplxBode), ...
              'parent', get(NyqFig,'currentaxes'), ...
              'color',[0.7 0.7 0.7], ...
              'linestyle','-', ...
              'tag',[Domain 'Gain Preview'], ...
              'userdata', line_ud, ...
              'linewidth', 2 ) ];
        PZG(dom_ndx).plot_h{7}.hndl.Gain_Preview = LineH;
      else
        set( LineH(1),'xdata', real(line_ud.OLCplxBode), ...
            'ydata', imag(line_ud.OLCplxBode),...
            'visible','on')
        set( LineH(2),'xdata', real(line_ud.OLCplxBode), ...
            'ydata', -imag(line_ud.OLCplxBode),...
            'visible','on')
      end
    else
      if ~isequal( 2, numel(LineH) )
        delete(LineH)
        LineH = ...
          [ plot( line_ud.scaled_OLCplxBode, ...
              'color',[0.7 0 0.7], ...
              'parent', get(NyqFig,'currentaxes'), ...
              'tag',[Domain 'Gain Preview'], ...
              'userdata', line_ud, ...
              'linewidth', 2 );
            plot( conj(line_ud.scaled_OLCplxBode), ...
              'parent', get(NyqFig,'currentaxes'), ...
              'color',[0.7 0.7 0.7], ...
              'linestyle','-', ...
              'tag',[Domain 'Gain Preview'], ...
              'userdata', line_ud, ...
              'linewidth', 2 ) ];
        PZG(dom_ndx).plot_h{7}.hndl.Gain_Preview = LineH;
      else
        set( LineH(1),'xdata', real(line_ud.scaled_OLCplxBode), ...
            'ydata', imag(line_ud.scaled_OLCplxBode), ...
            'userdata', line_ud, ...
            'visible','on')
        set( LineH(2),'xdata', real(line_ud.scaled_OLCplxBode), ...
            'ydata', -imag(line_ud.scaled_OLCplxBode), ...
            'userdata', line_ud, ...
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
    %architec = 'closed loop';
    incl_pade = 1;
    incl_prvw = 'sGain';
    if isequal( Domain,'z')
      incl_prvw = 'zGain';
    end
    resp_ax_h = PZG(dom_ndx).plot_h{9}.ax_h;
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
      freq_ed_h = pzg_fndo( dom_ndx, 9,'sinusoid_freq_hz_edit');
      if ~isempty(freq_ed_h)
        freq_hz = str2double( get( freq_ed_h,'string') );
      end
      
      [ input_zeros, input_poles, input_gain ] = ...
          pzg_inzpk( input_type, Domain, freq_hz );
      
      [ resp_res, resp_poles, resp_direct ] = ...
          pzg_rsppfe( ...
            dom_ndx, input_zeros, input_poles, input_gain, ...
            'closed loop', incl_prvw, incl_pade );
          
      wb_h = -1;
      
      gain_time_resp = zeros(size(time_vec));
      gain_time_resp(1) = resp_direct;
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
            gain_time_resp = gain_time_resp + this_term;
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
            gain_time_resp(2:end) = gain_time_resp(2:end) + this_term(1:end-1);
          end
          
          if ishandle(wb_h)
            waitbar( 0.95*k/numel(resp_poles), wb_h )
          end
        end
        if ishandle(wb_h)
          delete( wb_h )
        end
      end
      gain_time_resp = real(gain_time_resp);
      input_line_h = pzg_fndo( dom_ndx, 9,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      err_ydata = in_ydata(:) - gain_time_resp(:);
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
      LineH = pzg_fndo( dom_ndx, 9,'Gain_Preview');
      if ~isequal( 2, numel(LineH) ) ... 
        || ~isequal( 2, sum( ishandle(LineH) ) )
        delete(LineH)
        LineH = ...
          plot( time_vec(:), gain_time_resp(:), ...
            'color',[ 1 0 1 ], ...
            'linewidth', 1.5, ...
            'linestyle','-', ...
            'parent', resp_ax_h, ...
            'tag',[Domain 'Gain Preview']);
        LineH(2) = ...
          plot( time_vec(:), err_ydata(:), ...
            'color', err_color, ...
            'linewidth', 1.5, ...
            'linestyle','--', ...
            'parent', resp_ax_h, ...
            'visible', resp_err_vis, ...
            'tag',[Domain 'Gain Preview']);
        PZG(dom_ndx).plot_h{9}.hndl.Gain_Preview = LineH;
      else
        set( LineH(1), ...
            'xdata', time_vec(:), ...
            'ydata', gain_time_resp(:), ...
            'color', [ 1 0 1 ], ...
            'visible','on')
        set( LineH(2), ...
            'xdata', time_vec(:), ...
            'ydata', err_ydata(:), ...
            'color', err_color, ...
            'visible', resp_err_vis )
      end
      if input_type == 1
        set( LineH(2),'xdata',[],'ydata',[],'visible','off');
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{9}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{9}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 9 );
    end
  end
  
  OLRespFig = pzg_fndo( dom_ndx, 8,'fig_h');
  if ~isempty(OLRespFig)
    %architec = 'open loop';
    incl_pade = 0;
    incl_prvw = 'sGain';
    if isequal( Domain,'z')
      incl_prvw = 'zGain';
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
      input_type_h = pzg_fndo( dom_ndx, 8,'input_type_popupmenu');
      if ~isempty(input_type_h)
        input_type = get( input_type_h,'value');
      else
        input_type = 2;
      end
      freq_hz = 1;
      freq_ed_h = pzg_fndo( dom_ndx, 8,'sinusoid_freq_hz_edit');
      if ~isempty(freq_ed_h)
        freq_hz = str2double( get( freq_ed_h,'string') );
      end
      
      [ input_zeros, input_poles, input_gain ] = ...
          pzg_inzpk( input_type, Domain, freq_hz );
      
      [ resp_res, resp_poles, resp_direct ] = ...
          pzg_rsppfe( ...
            dom_ndx, input_zeros, input_poles, input_gain, ...
            'open loop', incl_prvw, incl_pade );

      direct_resp = zeros(size(time_vec));
      if isequal( Domain,'s')
        if PZG(1).PureDelay == 0
          direct_resp(1) = resp_direct;
        else
          delay_ndx = pzg_gle( time_vec, PZG(1).PureDelay,'near');
          direct_resp(delay_ndx) = resp_direct;
        end
        gain_time_resp = direct_resp;
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
            gain_time_resp = gain_time_resp + this_term;
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
        gain_time_resp = direct_resp;
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
            gain_time_resp(2:end) = gain_time_resp(2:end) + this_term(1:end-1);
          end
        end
      end
      gain_time_resp = real(gain_time_resp(:));
      
      input_line_h = pzg_fndo( dom_ndx, 8,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      if isequal( numel(in_ydata), numel(gain_time_resp) );
        err_xdata = time_vec(:);
        err_ydata = in_ydata(:) - gain_time_resp(:);
      else
        err_xdata = time_vec(1);
        err_ydata = 0;
      end
      this_bgcolor = get( PZG(dom_ndx).plot_h{8}.ax_h,'color');
      if max( this_bgcolor ) < 0.5
        err_color = [0.6 1 1];
      else
        err_color = [0 0.5 0.5];
      end
      if get( pzg_fndo( dom_ndx, 8,'show_io_difference'),'value') ...
        && ( numel(err_ydata) > 1 )
        resp_err_vis = 'on';
      else
        resp_err_vis = 'off';
      end
      
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
          gain_time_resp(nr_delay_samples+1:end) = ...
            gain_time_resp(1:end-nr_delay_samples);
          gain_time_resp(1:nr_delay_samples) = 0;
        else
          time_vec(1:nr_delay_samples) = [];
          gain_time_resp(end-nr_delay_samples+1:end) = [];
        end
      end
      LineH = pzg_fndo( dom_ndx, 8,'Gain_Preview');
      if ~isequal( 2, numel(LineH) ) || ~isequal( 2, sum(ishandle(LineH)) )
        delete(LineH)
        LineH = ...
          plot( time_vec(:), gain_time_resp(:), ...
             'color',[ 1 0 1 ], ...
             'linewidth', 1.5, ...
             'linestyle','-', ...
             'parent', resp_ax_h, ...
             'tag',[Domain 'Gain Preview']);
        LineH(2) = ...
          plot( err_xdata(:), err_ydata(:), ...
             'color', err_color, ...
             'linewidth', 1.5, ...
             'linestyle','--', ...
             'parent', resp_ax_h, ...
             'visible', resp_err_vis, ...
             'tag',[Domain 'Gain Preview']);
        PZG(dom_ndx).plot_h{8}.hndl.Gain_Preview = LineH;
      else
        set( LineH(1), ...
            'xdata', time_vec(:), ...
            'ydata', gain_time_resp(:), ...
            'visible','on')
        set( LineH(2), ...
            'xdata', err_xdata(:), ...
            'ydata', err_ydata(:), ...
            'color', err_color, ...
            'visible', resp_err_vis )
      end
      if input_type == 1
        set( LineH(2),'xdata',[],'ydata',[],'visible','off');
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{8}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{8}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 8 );
    end
  end
  
  RtLocFig = pzg_fndo( dom_ndx, 9+dom_ndx,'fig_h');
  if ~isempty(RtLocFig)
    purejordan = 1;
    include_pade = 1;
    if dom_ndx == 1
      include_prvw = 'sGain';
    else
      include_prvw = 'zGain';
    end
    modalss = ...
      pzg_moda( dom_ndx, purejordan, include_pade, include_prvw, [], 1 );
    
    if ~isempty(modalss)
      AA = modalss.a;
      BC = modalss.b * modalss.c;
      DD = modalss.d;
      CLpoles = eig( AA-BC/(DD+1) );
    end
    rloc_ax_h = PZG(dom_ndx).plot_h{9+dom_ndx}.ax_h;
    LineH = pzg_fndo( dom_ndx, 9+dom_ndx,'Gain_Preview');
    if ~isequal( 1, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.Gain_Preview = ...
        plot( real(CLpoles), imag(CLpoles),'s', ...
           'color',[1 0 1], ...
           'linewidth', 3, ...
           'linestyle','none', ...
           'markersize', 12, ...
           'parent', rloc_ax_h, ...
           'tag',[Domain 'Gain Preview'] );
    else
      set( LineH, ...
          'xdata', real(CLpoles), ...
          'ydata', imag(CLpoles), ...
          'visible','on')
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
    hz_checkbox_h = PZG(dom_ndx).plot_h{5}.hndl.BodeHZChkbox;
    if ~isempty(hz_checkbox_h)
      if get(hz_checkbox_h,'value')
        plotFreqs = plotFreqs/2/pi;
      end
    end
    LineH = pzg_fndo( dom_ndx, 5,'Gain_Preview');
    if ~isequal( 1, numel(LineH) )
      delete(LineH)
      PZG(dom_ndx).plot_h{5}.hndl.Gain_Preview = ...
        plot( plotFreqs, Sens, ...
             'color','m', ...
             'parent', get(SensFig,'currentaxes'), ...
             'tag',[Domain 'Gain Preview'], ...
             'visible','off', ...
             'linewidth', 2 );
      if CLstable
        set( PZG(dom_ndx).plot_h{5}.hndl.Gain_Preview,'visible','on');
      end
    else
      if CLstable
        set( LineH,'xdata', plotFreqs,'ydata', Sens,'visible','on');
      else
        set( LineH,'visible','off');
      end
    end
    if strcmp( get( PZG(dom_ndx).plot_h{5}.ax_h,'xlimmode'),'auto') ...
      ||strcmp( get( PZG(dom_ndx).plot_h{5}.ax_h,'ylimmode'),'auto')
      pzg_lims( dom_ndx, 5 );
    end
  end

elseif strcmpi( GCBOtag,'Apply') && strcmpi( get(gcbo,'enable'),'on')
  set( gcbo,'enable','off');
  waitmsg_h = findobj( allchild(0),'name','Applying, Please Wait ...');
  if isempty(waitmsg_h)
    % Add the compensator to the system in the PZGUI.
    local_clear_preview( dom_ndx )

    Gain = str2num( get( hndl.Gain,'string') ); %#ok<ST2NM>
    PZG(dom_ndx).puregain = Gain;

    if ~isequal( numel(Gain), 1 ) ...
      || ~isreal(Gain) ...
      || isnan(Gain) || isinf(Gain) || isequal( Gain, 0 )
      errordlg({'Gain is not properly specified.'; ...
                ' ';'Gain must be a real-valued nonzero finite number'}, ...
               'Filter Build Error')
      return
    end

    save_undo_info(dom_ndx);

    waitmsg_h = ...
      msgbox({'Please wait while the gain is applied'; ...
              'into the main GUI ...';' '}, ...
             'Applying, Please Wait ...');
    if ~isnan(Gain) && ~isinf(Gain) && ( Gain ~= 0 )
      PZG(dom_ndx).Gain = PZG(dom_ndx).Gain * Gain;
    end
    PZG(dom_ndx).recompute_frf = 1;

    % Turn off "Fix DC"
    fixdc_h = pzg_fndo( dom_ndx, 11+dom_ndx,'Fix_DC_checkbox');
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
      msgbox({'The gain has been applied into the main GUI.'; ...
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
  end
  set( gcbo,'enable','on');
  
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

set( hndl.no_vis_axes,'visible','off');

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

function local_clear_preview( dom_ndx )
  global PZG
  prev_h = pzg_fndo( dom_ndx,[(1:9),dom_ndx+[9,11]],'Gain_Preview');
  if ~isempty(prev_h)
    set( prev_h,'visible','off')
  end
  GainFig = PZG(dom_ndx).Gain_fig;
  if ~isempty(GainFig)
    hndl = getappdata( GainFig,'hndl');
    if isfield( hndl,'preview_pushbutton')
      set( hndl.preview_pushbutton,'backgroundcolor', 0.9412*[1 1 1]);
    end
    if isfield( hndl,'clear_preview_pushbutton')
      set( hndl.clear_preview_pushbutton,'visible','off');
    end
    if isfield( hndl,'puregain_slider_label')
      set( hndl.puregain_slider_label,'visible','off');
    end
    if isfield( hndl,'puregain_slider')
      set( hndl.puregain_slider,'visible','off');
    end
    pzgplot_h = pzg_fndo( dom_ndx,(1:9),'fig_h');
    if isempty(pzgplot_h)
      set( hndl.preview_pushbutton,'enable','off');
    else
      set( hndl.preview_pushbutton,'enable','on');
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















