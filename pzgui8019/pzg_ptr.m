function pzg_ptr
% Updates the mouse pointer-style when mouse is moved in PZGUI plots.

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

GCBF = gcbf;
if isempty(GCBF)
  return
end

hndl = [];
if isappdata( GCBF,'hndl')
  hndl = getappdata( GCBF,'hndl');
  if isfield(hndl,'ax') ...
    && isfield(hndl,'ax_xlim') ...
    && isfield(hndl,'ax_ylim')
    if ~isequal(1,ishandle(hndl.ax))
      return
    else
      GCBA = hndl.ax;
      x_lim = hndl.ax_xlim;
      y_lim = hndl.ax_ylim;
    end
  else
    return;
  end
end
if ~isfield( hndl,'dom_ndx') || ~isfield( hndl,'ploth_ndx')
  return
end
dom_ndx = hndl.dom_ndx;
fig_h_ndx = hndl.ploth_ndx;

currpt = get( GCBA,'currentpoint');

drawbox = 0;
handptr = 0;
if ( isequal( dom_ndx, 1 ) && isequal( fig_h_ndx, 12 ) ) ...
  ||( isequal( dom_ndx, 2 ) && isequal( fig_h_ndx, 13 ) )
  busysignal = 0;
  drawbox_h = pzg_fndo( dom_ndx, fig_h_ndx,'draw_box_checkbox');
  if ~isempty(drawbox_h)
    drawbox = get( drawbox_h,'value');
    if strcmp( get( drawbox_h,'enable'),'off')
      busysignal = 1;
    end
  end
  
  if ~drawbox && ~busysignal
    PZ_Locs = [];
    if isequal( dom_ndx, 1 ) && isequal( fig_h_ndx, 12 )
      PZ_Locs = [ PZG(1).PoleLocs; PZG(1).ZeroLocs ];
    elseif isequal( dom_ndx, 2 ) && isequal( fig_h_ndx, 13 )
      PZ_Locs = [ PZG(2).PoleLocs; PZG(2).ZeroLocs ];
    end
    this_point = currpt(1,1) + 1i*currpt(1,2);
    pz_distances = ...
      sqrt( ( abs( real(this_point) - real(PZ_Locs) )/diff(x_lim) ).^2 ...
             +( abs( imag(this_point) - imag(PZ_Locs) )/diff(y_lim) ).^2 );
    nr_nearby_pz = ...
      sum( ( pz_distances < 0.0175 ) & ( pz_distances > 1e-14 ) );
    nr_in_reach = ...
      sum( ( pz_distances < 0.0150 ) & ( pz_distances > 1e-14 ) );
    if ( nr_in_reach == 1 ) && ( nr_nearby_pz == 1 )
      handptr = 1;
    elseif ( nr_in_reach > 1 ) && ( nr_nearby_pz > 1 )
      if numel( unique( pz_distances( pz_distances < 0.0175 ) ) ) == 1
        % All nearby are same repeated pole or zero, so allow drag-and-drop.
        handptr = 1;
      end
    end
  end
end
  
if ( currpt(1,1) < x_lim(1) ) || ( currpt(1,1) > x_lim(2) ) ...
  ||( currpt(1,2) < y_lim(1) ) || ( currpt(1,2) > y_lim(2) )
  set( GCBF,'pointer','arrow');
  
elseif drawbox
  box_hotspot = [7 7];
  box_cdata = ...
    [ 1   1   1   1   1   1   1   1   1   1   1   1   1  NaN NaN NaN
      1   1  NaN NaN NaN NaN NaN NaN NaN NaN NaN  1   1  NaN NaN NaN
      1  NaN  1  NaN NaN NaN NaN NaN NaN NaN  1  NaN  1  NaN NaN NaN
      1  NaN NaN  1  NaN NaN NaN NaN NaN  1  NaN NaN  1  NaN NaN NaN
      1  NaN NaN NaN  1  NaN NaN NaN  1  NaN NaN NaN  1  NaN NaN NaN
      1  NaN NaN NaN NaN  1  NaN  1  NaN NaN NaN NaN  1  NaN NaN NaN
      1  NaN NaN NaN NaN NaN  1  NaN NaN NaN NaN NaN  1  NaN NaN NaN
      1  NaN NaN NaN NaN  1  NaN  1  NaN NaN NaN NaN  1  NaN NaN NaN
      1  NaN NaN NaN  1  NaN NaN NaN  1  NaN NaN NaN  1  NaN NaN NaN
      1  NaN NaN  1  NaN NaN NaN NaN NaN  1  NaN NaN  1  NaN NaN NaN
      1  NaN  1  NaN NaN NaN NaN NaN NaN NaN  1  NaN  1  NaN NaN NaN
      1   1  NaN NaN NaN NaN NaN NaN NaN NaN NaN  1   1  NaN NaN NaN
      1   1   1   1   1   1   1   1   1   1   1   1   1  NaN NaN NaN
     NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
     NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
     NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ];
  if isequal( get(GCBF,'color'),[ 0 0 0 ] )
    box_cdata(box_cdata == 1) = 2;
  end
  set( GCBF,'pointershapecdata', box_cdata, ...
      'pointershapehotspot', box_hotspot, ...
      'pointer','custom');
    
elseif handptr
  try
    set( GCBF,'pointer','hand');
  catch %#ok<CTCH>
    set( GCBF,'pointer','arrow');
  end
  
else
  if strcmpi( get(GCBF,'pointer'),'arrow') ...
    ||strcmpi( get(GCBF,'pointer'),'hand')
    zoom_hotspot = [6 6];
    zoom_cdata = ...
      [NaN NaN NaN NaN  1   1   1   1  NaN NaN NaN NaN NaN NaN NaN NaN
       NaN NaN  1   1  NaN NaN NaN NaN  1   1  NaN NaN NaN NaN NaN NaN
       NaN  1  NaN NaN NaN  1   1  NaN NaN NaN  1  NaN NaN NaN NaN NaN
       NaN  1  NaN NaN NaN  1   1  NaN NaN NaN  1  NaN NaN NaN NaN NaN
        1  NaN NaN NaN NaN  1   1  NaN NaN NaN NaN  1  NaN NaN NaN NaN
        1  NaN  1   1   1  NaN NaN  1   1   1  NaN  1  NaN NaN NaN NaN
        1  NaN  1   1   1  NaN NaN  1   1   1  NaN  1  NaN NaN NaN NaN
        1  NaN NaN NaN NaN  1   1  NaN NaN NaN NaN  1  NaN NaN NaN NaN
       NaN  1  NaN NaN NaN  1   1  NaN NaN NaN  1  NaN NaN NaN NaN NaN
       NaN  1  NaN NaN NaN  1   1  NaN NaN NaN  1  NaN NaN NaN NaN NaN
       NaN NaN  1   1  NaN NaN NaN NaN  1   1  NaN  1  NaN NaN NaN NaN
       NaN NaN NaN NaN  1   1   1   1  NaN NaN  1  NaN  1  NaN NaN NaN
       NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN  1  NaN  1  NaN NaN
       NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN  1  NaN  1  NaN
       NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN  1  NaN  1
       NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN  1   1 ];
  if isequal( get(GCBF,'color'),[ 0 0 0 ] )
    zoom_cdata(zoom_cdata == 1) = 2;
  end
  set( GCBF,'pointershapecdata', zoom_cdata, ...
      'pointershapehotspot', zoom_hotspot, ...
      'pointer','custom');
  end
end

return
