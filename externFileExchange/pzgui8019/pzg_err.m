function pzg_err(source)
% Reports details of certain PZGUI callback errors to the command line.

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
global pzg_err_info

if ~nargin || ~ischar(source)
  source = '';
end

try
  if  ~isempty(gcbf) ...
    && ~isempty(pzg_err_info) && isstruct(pzg_err_info) ...
    && isfield( pzg_err_info,'source') ...
    && isfield( pzg_err_info,'clock') ...
    && isfield( pzg_err_info,'gcbf')
    if isequal( source, pzg_err_info.source ) ...
      && isequal( gcbf, pzg_err_info.gcbf )
      if etime( clock, pzg_err_info.clock ) < 1
        return
      end
    end
  end
  pzg_err_info.source = source;
  pzg_err_info.gcbf = gcbf;
  pzg_err_info.clock = clock;

  temp_lasterr = lasterror; %#ok<LERR>

  if ~isempty(source) && ischar(source)
    fprintf( ['\n  Error processing ' source '\n' ] );
  end
  temp_lasterr.message
  
  if isfield(temp_lasterr,'stack') && ~isempty(temp_lasterr.stack)
    start_sp = '  ';
    for k = numel(temp_lasterr.stack):-1:1
      if k < numel(temp_lasterr.stack)
        fprintf([ start_sp ' ==> '])
      else
        fprintf([ start_sp ' '])
      end
      start_sp = [ start_sp ' ']; %#ok<AGROW>
      fprintf(['line# ' num2str(temp_lasterr.stack(k).line) ]);
      fprintf([' of ' temp_lasterr.stack(k).name '\n']);
    end
    fprintf('Please report this bug to:  mark.hopkins@rit.edu\n')
  end
  
  nonvisfig_h = findobj(allchild(0),'type','figure','visible','off');
  for k = 1:numel(nonvisfig_h)
    if ~isempty( strfind( get( nonvisfig_h(k),'tag'),'PZGUI') )
      delete(nonvisfig_h(k))
    end
  end
  CALC_h = findobj(allchild(0),'type','figure','tag','Msgbox_CALCULATING');
  if ~isempty(CALC_h)
    delete(CALC_H)
  end
  
catch %#ok<CTCH>
  fprintf('\n An error has occurred.  Unable to process error info. \n');
end

pzg_onoff(1)

return
