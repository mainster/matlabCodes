function [ timevec, y, y_natfrc ] = ...
              pzg_pfesim( reses, poles, direct, timevec, Ts, ...
                          architec, SigType, ...
                          cosFreq, nr_dt_delay_poles )
% Computes time-domain simulation of a SISO partial-fraction 
% expanded transfer function.

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

y = [];
y_natfrc = [];

if nargin < 4
  return
end

if ( nargin < 5 ) || isempty(Ts)
  Ts = 0;
elseif numel(Ts) > 1
  Ts = Ts(1);
end

if ( nargin < 6 ) || ~ischar(architec)
  architec = 'open loop'; %#ok<NASGU>
end

if nargin < 7
  SigType = 2;
end

if nargin < 8
  cosFreq = 0;
end

if nargin < 9
  nr_dt_delay_poles = 0;
end

if ~isnumeric(reses) || ~isnumeric(poles) ...
  || ~isnumeric(direct) || ~isnumeric(Ts) ...
  || ~isnumeric(timevec) || ( numel(timevec) < 2 ) ...
  || ~isequal( numel(reses), numel(poles) )
  return
end

if numel(direct) ~= 1
  direct = 0;
end
Ts = abs(Ts);
y = zeros(size(timevec));
if sum( imag(poles) >= 0 ) <= 12
  y_natfrc = zeros( sum( imag(poles) >= 0 ), numel(timevec) );
end

if ~isempty(reses)
  if Ts == 0
    % Continuous-time system.
    log_timevec = -Inf*ones(size(timevec));
    nzndx = find( timevec ~= 0 );
    log_timevec(nzndx) = log( timevec(nzndx) );
    natfrc_ndx = 0;
    prev_pole = inf;
    rep_nr = 1;
    for k = 1:numel(reses)
      if imag(poles(k)) < 0
        continue
      end
      natfrc_ndx = natfrc_ndx + 1;
      if ( k > 1 ) ...
        && ( abs( poles(k) - prev_pole )/max(1,abs(poles(k))) < 1e-12 )
        rep_nr = rep_nr + 1;
      else
        rep_nr = 1;
        prev_pole = poles(k);
      end
      if reses(k) ~= 0
        this_term = reses(k) * exp( poles(k) * timevec );
        if rep_nr > 1
          multiplier = exp( (rep_nr-1) * log_timevec )/factorial(rep_nr-1);
          this_term = this_term .* multiplier;
        end
        if imag(poles(k)) == 0
          y = y + this_term;
          if ~isempty(y_natfrc)
            y_natfrc(natfrc_ndx,:) = this_term(:)'; %#ok<AGROW>
          end
        else
          y = y + 2*real( this_term );
          if ~isempty(y_natfrc)
            y_natfrc(natfrc_ndx,:) = 2*real( this_term(:)' ); %#ok<AGROW>
          end
        end
      end
    end
    
  else   % Discrete-time system.
    N_vec = round( timevec / Ts );
    %log_timevec = -Inf*ones(size(timevec));
    %nzndx = find( timevec ~= 0 );
    %log_timevec(nzndx) = log( timevec(nzndx) );
    rep_nr = 1;
    prev_pole = inf;
    
    SigIn = zeros(size(timevec));
    % The input signal is needed in case there are any delay poles.
    if any( poles == 0 )
      switch SigType
        case 1 % Unit impulse
          SigIn(1) = 1; %#ok<NASGU>
        case 2 % Unit step
          SigIn = ones(size(timevec)); %#ok<PREALL>
        case 3 % Ramp
          SigIn = timevec; %#ok<NASGU>
        case 4 % Parabola
          SigIn = (1/2)*timevec.^2; %#ok<NASGU>
        case 5 % Sinusoid (unit-magnitude cosine function).
          % Construct the cosine input.
          SigIn = cos( cosFreq * timevec ); %#ok<NASGU>
        otherwise
      end
    end
        
    natfrc_ndx = 0;
    for k = 1:numel(reses)
      pp = poles(k);
      if imag(pp) < 0
        continue
      end
      natfrc_ndx = natfrc_ndx + 1;
      if ( k > 1 ) ...
        && ( abs( pp - prev_pole )/max(1,abs(pp)) < 1e-10 )
        rep_nr = rep_nr + 1;
      else
        rep_nr = 1;
        prev_pole = pp;
      end
      this_term = zeros(size(N_vec));
      if ~isequal( reses(k), 0 )
        if abs(pp) > 1e-10
          this_term(2:end) = reses(k) * exp( log(pp) * N_vec(1:end-1) );
          this_term(1) = 0;
        else
          this_term = zeros(size(N_vec));
          this_term(rep_nr+1) = reses(k);
        end
        if ( rep_nr > 1 ) && ( abs(pp) > 1e-10 )
          multiplier = ones(size(timevec));
          for k_repnr = 2:rep_nr
            multiplier = multiplier .* ( N_vec - N_vec(k_repnr) );
          end
          if rep_nr > 2
            multiplier = multiplier / factorial(rep_nr-1);
          end
          this_term = this_term .* multiplier;
        end
        if abs(imag(pp)) < 1e-10
          y = y + this_term;
          if ~isempty(y_natfrc)
            y_natfrc(natfrc_ndx,:) = this_term(:); %#ok<AGROW>
          end
        else
          y = y + 2*real( this_term );
          if ~isempty(y_natfrc)
            y_natfrc(natfrc_ndx,:) = 2*real( this_term(:) ); %#ok<AGROW>
          end
        end
      end
    end
  end
end

ndx0 = find( timevec == 0 );
y(ndx0) = y(ndx0) + direct;
y( timevec < 0 ) = 0;
y = real(y);

if ( nr_dt_delay_poles > 0 )
  if timevec(1) == 0
    y(nr_dt_delay_poles+1:end) = y(1:end-nr_dt_delay_poles);
    y(1:nr_dt_delay_poles) = 0;
    y_natfrc(nr_dt_delay_poles+1:end,:) = y_natfrc(1:end-nr_dt_delay_poles,:);
    y_natfrc(1:nr_dt_delay_poles,:) = 0;
  else
    timevec = timevec + Ts*nr_dt_delay_poles;
  end
end  
  
return
