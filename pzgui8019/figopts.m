function  figopts( varargin )
% Services background-color selection from pzgui options menu

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

if ( numel(varargin) < 2 )
  return
elseif ~ischar(varargin{1})
  return
end

for k = 1:size(varargin,1)
  if size( varargin{k,1},1 ) == 1
    
    switch varargin{k,1}
      case {'default','this_plot','all_plots'}
        if ischar( varargin{k,2} ) ...
          &&(  strcmpi( varargin{k,2}(1),'w') ...
             ||strcmpi( varargin{k,2}(1),'b') ...
             ||strcmpi( varargin{k,2}(1),'k') )
        
          % Get all non-integer figure handles.
          all_figs = ...
            [ pzg_fndo( 1,[(1:10),12,14],'fig_h'); ...
              pzg_fndo( 2,[(1:9),11,13,14],'fig_h')];
          for m = numel(all_figs):-1:1
            if isempty( strfind( get(all_figs(m),'name'),'Continuous-Time') ) ...
              &&isempty( strfind( get(all_figs(m),'name'),'Discrete-Time') ) ...
              &&isempty( strfind( get(all_figs(m),'name'),'PZGui Help Window') )
              all_figs(m) = [];
            end
          end
          
          if strcmpi( varargin{k,2}(1),'w')
            bg_color = [ 1 1 1 ];
            set_white_background( all_figs )
            PZG(1).DefaultBackgroundColor = 'w';
            PZG(2).DefaultBackgroundColor = 'w';
          else
            bg_color = [ 0 0 0 ];
            set_black_background( all_figs )
            PZG(1).DefaultBackgroundColor = 'k';
            PZG(2).DefaultBackgroundColor = 'k';
          end
        end
            
      case 'apply_default_color'
        for m = 1:numel(varargin{k,2})
          if ishandle( varargin{k,2}(m) ) ...
            &&strcmp('figure', get( varargin{k,2}(m),'type') )
            if strcmpi( PZG(1).DefaultBackgroundColor(1),'w')
              set_white_background( varargin{k,2}(m) )
              bg_color = [ 1 1 1 ];
            else
              bg_color = [ 0 0 0 ];
              set_black_background( varargin{k,2}(m) )
            end
          end
        end
        
      otherwise
        if strcmpi( PZG(1).DefaultBackgroundColor(1),'w')
          bg_color = [ 1 1 1 ];
        else
          bg_color = [ 0 0 0 ];
        end
    end
  else
    if strcmpi( PZG(1).DefaultBackgroundColor(1),'w')
      bg_color = [ 1 1 1 ];
    else
      bg_color = [ 0 0 0 ];
    end
  end
end

dtlink_h = pzg_fndo( 1, 12,'LinkCheckbox');
dtmethod_h = pzg_fndo( 1, 12,'LinkMethod');
if ~isempty(dtlink_h)
  if get(dtlink_h,'value')
    set([dtlink_h;dtmethod_h],'backgroundcolor',[0 0.7 0]);
  else
    set([dtlink_h;dtmethod_h], ...
        'backgroundcolor', PZG(1).DefaultBackgroundColor );
  end
end
ctlink_h = pzg_fndo( 2, 13,'LinkCheckbox');
ctmethod_h = pzg_fndo( 2, 13,'LinkMethod');
if ~isempty(ctlink_h)
  if get(ctlink_h,'value')
    set([ctlink_h;ctmethod_h],'backgroundcolor',[0 0.7 0]);
  else
    set([ctlink_h;ctmethod_h], ...
        'backgroundcolor', PZG(2).DefaultBackgroundColor );
  end
end

legend_h = [ pzg_fndo( 1, 10,'legend'); pzg_fndo( 2, 11,'legend') ];
if ~isempty(legend_h)
  set( legend_h, 'color', bg_color,'textcolor', 1-bg_color );
end

pzg_grid;

return


% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% Local functions

% =====================================================================
function set_white_background( fig_nrs )
  set( fig_nrs,'color','w');
  for k = 1:numel(fig_nrs)
    ax_h = findobj( fig_nrs(k),'type','axes');
    if ~isempty(ax_h)
      for m = 1:numel(ax_h)
        set( ax_h(m), ...
            'color','w', ...
            'xcolor','k', ...
            'ycolor','k', ...
            'zcolor','k' );
        set( get(ax_h(m),'title'),'color','k')
        set( get(ax_h(m),'xlabel'),'color','k')
        set( get(ax_h(m),'ylabel'),'color','k')
        line_h = findobj( allchild(ax_h(m)),'type','line');
        for L = 1:numel(line_h)
          this_color = get( line_h(L),'color');
          if ( max(this_color) > 0.5 ) ...
            && isequal( this_color(1), this_color(2) ) ...
            && isequal( this_color(2), this_color(3) )
            set( line_h(L),'color', 1-this_color );
          end
        end
        yellow_obj = findobj( allchild(ax_h(m)),'color','y');
        if ~isempty(yellow_obj)
          set(yellow_obj,'color',[0.7 0.7 0]);
        end
        cyan_obj = findobj( allchild(ax_h(m)),'color','c');
        if ~isempty(cyan_obj)
          set(cyan_obj,'color',[0 0.7 0.7]);
        end
        axes_child_white_obj = findobj( allchild(ax_h(m)),'color',[1 1 1]);
        for n = 1:numel(axes_child_white_obj)
          obj_type = get( axes_child_white_obj(n),'type');
          if strcmp( obj_type,'text') || strcmp( obj_type,'line')
            set( axes_child_white_obj(n),'color','k');
          end
        end
      end
    end
    ui_h = findobj( fig_nrs(k),'type','uicontrol','backgroundcolor',[0 0 0]);
    for kui = 1:numel(ui_h)
      set( ui_h(kui),'backgroundcolor',[ 1 1 1 ])
      fg_color = get( ui_h(kui),'foregroundcolor');
      if all( fg_color > 0.8 )
        set( ui_h(kui),'foregroundcolor', 1-fg_color);
      elseif fg_color(1) == 0
        set( ui_h(kui),'foregroundcolor',[0 0.65 0.65]);
      end
    end
    % Required to make checkboxes readable on Mac's.
    cb_h = findobj( fig_nrs(k),'type','uicontrol','style','checkbox');
    set( cb_h,'backgroundcolor',[ 1 1 1 ],'foregroundcolor',[ 0 0 0 ]);
    if ~isempty( strfind( get(fig_nrs(k),'name'),'P/Z Map G.U.I.') )
      for kcb = 1:numel(cb_h)
        if strcmpi( get(cb_h(kcb),'string'),'Help') 
          if get(cb_h(kcb),'value')
            set( cb_h(kcb),'foregroundcolor',[ 1 0 0 ]);
          end
          break
        end
      end
    end
  end
    
  reptext_h = ...
    [ findobj( fig_nrs,'type','text','tag','zero_repstr_h'); ...
      findobj( fig_nrs,'type','text','tag','pole_repstr_h') ];
  if ~isempty(reptext_h)
    set( reptext_h,'color',[0.1 0.1 0.1]);
  end

return

% =====================================================================
function set_black_background( fig_nrs )
  set( fig_nrs,'color','k');
  for k = 1:numel(fig_nrs)
    ax_h = findobj( fig_nrs(k),'type','axes');
    if ~isempty(ax_h)
      for m = 1:numel(ax_h)
        set( ax_h(m), ...
            'color','k', ...
            'xcolor','w', ...
            'ycolor','w', ...
            'zcolor','w' );
        set( get(ax_h(m),'title'),'color','w')
        set( get(ax_h(m),'xlabel'),'color','w')
        set( get(ax_h(m),'ylabel'),'color','w')
        line_h = findobj( allchild(ax_h(m)),'type','line');
        for L = 1:numel(line_h)
          this_color = get( line_h(L),'color');
          if ( max(this_color) < 0.5 ) ...
            && isequal( this_color(1), this_color(2) ) ...
            && isequal( this_color(2), this_color(3) )
            set( line_h(L),'color', 1-this_color );
          end
        end
        yellow_obj = findobj( allchild(ax_h(m)),'color',[0.7 0.7 0]);
        if ~isempty(yellow_obj)
          set(yellow_obj,'color','y');
        end
        cyan_obj = findobj( allchild(ax_h(m)),'color',[0 0.7 0.7]);
        if ~isempty(cyan_obj)
          set(cyan_obj,'color','c');
        end
        axes_child_black_obj = findobj( allchild(ax_h(m)),'color',[0 0 0]);
        for n = 1:numel(axes_child_black_obj)
          obj_type = get( axes_child_black_obj(n),'type');
          if strcmp( obj_type,'text') || strcmp( obj_type,'line')
            set( axes_child_black_obj(n),'color','w');
          end
        end
      end
    end
    ui_h = findobj( fig_nrs(k),'type','uicontrol','backgroundcolor',[1 1 1]);
    for kui = 1:numel(ui_h)
      set( ui_h(kui),'backgroundcolor',[ 0 0 0 ])
      fg_color = get( ui_h(kui),'foregroundcolor');
      if all( fg_color < 0.2 )
        set( ui_h(kui),'foregroundcolor', 1-fg_color);
      elseif fg_color(1) == 0
        set( ui_h(kui),'foregroundcolor',[0 0.85 0.85]);
      end
    end
    
    % Required to make checkboxes readable on Mac's.
    cb_h = findobj( fig_nrs(k),'type','uicontrol','style','checkbox');
    set( cb_h,'backgroundcolor',[ 0 0 0 ],'foregroundcolor',[ 1 1 1 ]);
    if ~isempty( strfind( get(fig_nrs(k),'name'),'P/Z Map G.U.I.') )
      for kcb = 1:numel(cb_h)
        if strcmpi( get(cb_h(kcb),'string'),'Help') 
          if get(cb_h(kcb),'value')
            set( cb_h(kcb),'foregroundcolor',[ 1 0 0 ]);
          end
          break
        end
      end
    end
  end
  
  reptext_h = ...
    [ findobj( fig_nrs,'type','text','tag','zero_repstr_h'); ...
      findobj( fig_nrs,'type','text','tag','pole_repstr_h') ];
  if ~isempty(reptext_h)
    set( reptext_h,'color',[0.9 0.9 0.9]);
  end

return
