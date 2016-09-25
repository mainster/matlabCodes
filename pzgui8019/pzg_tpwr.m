function  pole_rep_resid = pzg_tpwr( pole, nr_reps, Ts )

% PZG_TPWR
% Call format:    pole_rep_resid = pzg_tpwr( pole, nr_reps, Ts )
%   
%   where     "pole" is the value of the repeated D-T pole
%             "nr_reps" is the number of repetitions of the pole
%             "Ts" is the sample period of the discrete-time system
%   and
%      "pole_rep_resid" contains Z-transform information as described below.
%
% Returns the Z-transform of "pure" powers of [(nT)^k * p^n]/k!, for k > 0, 
% in partial-fraction-expansion form.  The corresponding 
% time-domain sequence when the pole is repeated N+1 times, is the 
% simple (nT)^N * p^n/N!, similar to the C-T computation, (t^N)*(p^t)/N!.
% In C-T, when p=1, these signals are the unit-step, unit-ramp, unit-parabola,
% etc., and the corresponding Laplace transforms are simply 1/( s^(N+1) ).
% The situation in D-T is considerably more complicated.  Hence, this function
% is useful for obtaining the residues of the various PFE's.
%
% Residues of the Z-transforms (in PFE form) are returned in matrix form,  
% with #rows = [ nr_reps+1 ].  Thus, this function returns all Z-transforms 
% up to [(nT)^(nr_reps-1)*p^n]/(nr_reps-1)!.
%
% The k-th row corresponds to the residues of [(nT)^(k-1) * p^n]/(k-1)!.
% The columns of the matrix correspond to the various residues, starting
% with the direct-term in the first column (zero in all but the first row);
% followed by the residue of the first-order term in second column;
% the residue of the second-order term in the third column; and so on.
%
% Note that only the non-repeated pole (row #1) has a nonzero direct-term.
% That's because all the other cases, where there is a multiple of time index,
% will be equal to zero at n=0.  This highlights the fact that the inverse
% Z-transforms of all the other terms of the PFE (i.e., all but the direct term)
% are delayed by one sample, because there is no factor of Z in the numerators, 
% there is only the constant (the pole-residue).

% The following copyrighted m-files comprise the PZGUI tool:
%    ** The contents of these files may not be included **
%    **  in any other program without explicit written  **
%    **    consent from the author, Mark A. Hopkins     **
%     bodepl.m        pzg_bkup.m      pzg_islink.m     pzg_seltxt.m
%     contents.m      pzg_box.m       pzg_islogx.m     pzg_tools.m
%     contourpl.m     pzg_c2d.m       pzg_isunwrp.m    pzg_tpwr.m
%     dpzgui.m        pzg_cntr.m      pzg_lims.m       pzg_txan.m
%     dupdatep.m      pzg_cphndl.m    pzg_menu.m       pzg_unre.m
%     figopts.m       pzg_d2c.m       pzg_moda.m       pzg_unwrap.m
%     fr_disp.m       pzg_disab.m     pzg_onoff.m      pzg_updtfilt.m
%     freqserv.m      pzg_efmt.m      pzg_pfesim.m     pzgcalbk.m
%     gainfilt.m      pzg_err.m       pzg_prvw.m       pzgui.m
%     helpserv.m      pzg_fndo.m      pzg_ptr.m        pzmvserv.m 
%     ldlgfilt.m      pzg_gle.m       pzg_recovr.m     resppl.m
%     nicholpl.m      pzg_grid.m      pzg_res.m        rlocuspl.m
%     nyqistpl.m      pzg_inzpk.m     pzg_rsppfe.m     sensplot.m
%     pidfilt.m       pzg_isdby.m     pzg_rss.m        updatepl.m
%     pz_move.m       pzg_ishzx.m     pzg_scifmt.m     updtpzln.m
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

pole_rep_resid = [];
if ( nargin < 3 ) ...
  || ~isnumeric(pole) || ~isequal( 1, numel(pole) ) ...
  || ~isnumeric(nr_reps) || ~isequal( 1, numel(nr_reps) ) ...
  || ~isequal( round(nr_reps), nr_reps ) || ( nr_reps < 1 ) ...
  || ~isnumeric(Ts) || ~isequal( 1, numel(Ts) )
  beep
  disp('Incorrect or invalid input arguments.')
  return;
end
if Ts <= 0
  Ts = 1;
end

if isreal(pole) && ( abs(pole) > 1e-9 )
  pole_rep_resid = zeros(nr_reps,nr_reps+1);
  for k = 1:nr_reps
    if abs(pole-1) < 1e-9
      PPc = zeros(k,1);
    else
      PPc = log(pole) * ones(k,1);
    end
    pzgctss.a = diag(PPc) + diag( ones(numel(PPc)-1,1), 1 );
    pzgctss.b = zeros(numel(PPc),1);
    pzgctss.b(end) = 1;
    pzgctss.c = zeros(1, numel(PPc),1);
    pzgctss.c(1) = 1;
    %pzgctss = pzg_moda( [], [], PPc, 1 );
    
    [ Ad, Bd, Cd, Dd ] = ...
        c2dm( pzgctss.a, pzgctss.b, pzgctss.c, 0, 1 ); %#ok<ASGLU>
    reses = Bd;
    
    %[ ZZd, PPd, KKd ] = ss2zp( Ad, Bd, Cd, 0 );
    %[ reses, poles, direct ] = pzg_res( ZZd, PPd, KKd ); %#ok<NASGU,ASGLU>

    pole_rep_resid(k,2:1+k) = reses.';
  end
  
  for k = 1:size(pole_rep_resid,1)
    pole_rep_resid(k,:) = pole_rep_resid(k,:)*Ts^(k-1);
  end
  
else
  pole_rep_resid = zeros(nr_reps,nr_reps+1);
  for k = 1:nr_reps
    if abs(pole-1) < 1e-9
      PPc = zeros(k,1);
    else
      PPc = log(pole)/Ts * ones(k,1);
    end
    Ac = diag(PPc) + diag( ones(numel(PPc)-1,1), 1 );
    Bc = zeros(numel(PPc),1);
    Cc = Bc';
    Bc(end) = 1;
    Cc(1) = 1;
    Dc = 0;
    if abs(imag(PPc)) > 1e-14
      Ac = [ Ac zeros(size(Ac)); zeros(size(Ac)) conj(Ac) ]; %#ok<AGROW>
      Bc = [ Bc; conj(Bc) ]; %#ok<AGROW>
      Cc = [ Cc, conj(Cc) ]; %#ok<AGROW>
    end
    pzgctss = ss( Ac, Bc, Cc, Dc );

    [ Ad, Bd, Cd, Dd ] = ...
        c2dm( pzgctss.a, pzgctss.b, pzgctss.c, pzgctss.d, Ts );

    [ ZZd, PPd, KKd ] = ss2zp( Ad, Bd, Cd, Dd );

    [ reses, poles, direct ] = pzg_res( ZZd, PPd, KKd ); %#ok<ASGLU>

    pole_rep_resid(k,2:1+k) = reses(1:k).';
  end
  pole_rep_resid = pole_rep_resid / Ts;
end

return
