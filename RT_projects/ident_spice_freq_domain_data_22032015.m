%%  Nachweis dass Regelparameter aus simulink übernommen werden können
%   - est. tf der alten 12V endstufe
%   - Reglerbandbreit klein genug wegen sättigung der Endstufen- FET's
    FILES = {   '../LTSpice_projects/galvoscanner/endstufe_BJT_EMIT_MJ1101xG_ltc6090_ada4700_compare_FERTIG.raw',...
                '../LTSpice_projects/galvoscanner/cheby_DAC_lochraster_3khz.raw',...
				'../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_ada4700_compare_nur_ein_hv_FERTIG_hoch2_maerz2015_higain_NOCOIL.raw',...;
				'../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_ada4700_compare_nur_ein_hv_FERTIG_hoch2_maerz2015_higain_COIL.raw',...
				'../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_HV_highgain_maerz2015.raw',...
				'../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_G0_at_Isens_170uH_3.5ohm_HV_highgain_maerz2015.raw',...
				'../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_G0_at_Isens_50uH_3.5ohm_HV_highgain_maerz2015.raw',...
				'../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_G0_at_Isens_0uH_3.5ohm_HV_highgain_maerz2015.raw',...
                '../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_G0_at_Isens_170uH_3.5ohm_INV_INV_maerz2015.raw',...
                '../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_G0_at_Isens_0uH_3.5ohm_INV_INV_maerz2015.raw',...
                '../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_G0_at_Isens_170uH_3.5ohm_INV_maerz2015.raw',...
                '../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/endstufe_BJT_EMIT_MJ1101xG_ltc6090_compare_inductive_load_G0_at_Isens_0uH_3.5ohm_INV_maerz2015.raw',...
                '../LTSpice_projects/galvoscanner/aktuell/LM3886_v4.raw'};

%% 21-05-2015            
clear FILES fitsG0 ccG0

FILES={ '../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/sysCompl_endstufe_FET_v13_transducer_v13_NoPwr.raw',...
        '../LTSpice_projects/galvoscanner/aktuell/bauteile_bestimmt/sysCompl_endstufe_FET_v13_transducer_v13a_NoPwr.raw'     
        };
fSel = 2;
    
    cd(ol.projectsPath);
    
%    clear fr
    sigName ='V(posx_adc)';
%	sigName = 'V(isensa)';

    intVect = [0.1 1e6];
    pv = [[1 0];[1 1];[2 0];[2 1];[2 2];[3 0];[3 1];[3 2];[3 3];[4 0];[4 1];[4 2];[4 3];[4 4]];
    pSel = [length(pv)-5:length(pv)];
    pSel = [1:length(pv)-5];
    
%% create fieldnames from raw filenames    
    spl = strrep(FILES(fSel), {'.'},{'_DOT_'})        
% FILES pfad mit delimiter '_' auftrennen	
    spl = cellfun(@strsplit, spl,[repmat({'_';},1,length(FILES(fSel)))], 'UniformOutput', false);
	
	ret = 'n';
	if (exist('fr'))
		ret = input('fr exists, skip frequency response estimation?  Y/N [Y]: ', 's');
		if isempty(ret)
			ret = 'y';
		end
	end
	
	if (~strcmpi(ret, 'y'))  
		clear fr;
		fieldnam = cell( length(FILES(fSel)) );		% malloc
		for k=1:length(FILES(fSel))
			fieldnam{k} = sprintf('%s_',spl{1,k}{end-11:end-3});
%			fieldnam{k} = sprintf('%s_',spl{1,k}{end-3:end-3});
            fieldnam{k} = strrep(fieldnam{k},'/','_');
			fr.(fieldnam{k}(1:end-1)) = estimationLoop(FILES{fSel(k)}, sigName, intVect, pv(pSel,:));
		end
	end
	
%%
    fr
	frFields = fields(fr);
	
	% fieldname (signal name) from estimationLoop is not known at
	% this point, discover
	frSigName = fields(fr.(frFields{1}) )		

	for k=1:length(frFields)
		fr.(frFields{k}).(frSigName{:})
	end
%*********************************************************************
%%    beste fit- ergebnisse raussuchen und speichern in sysEst
% *********************************************************************    
	for k=1:length(frFields)
		clear ind;
		
		fitsG0 = cellfun(@str2num,...
			strrep( fr.(frFields{k}).(frSigName{:})(:,4) ,'%',''))/100;
		af = fields( fr.(frFields{k}));

		[~, ind(1)] = max(fitsG0);
		ccG0.(frFields{k}).est   = fr.(frFields{k}).(af{:})(ind(1),:);
		ccG0.(frFields{k}).est{1,1}.OutputName = ccG0.(frFields{k}).est(7);

		[num, den] = tfdata(ccG0.(frFields{k}).est{1,1});
		ccG0.(frFields{k}).tf = tf(num, den, 'y',...
			ccG0.(frFields{k}).est{1,1}.OutputName );

		if length(ind) > 1
			[~, ind(2)] = max(fitsGtot);
			ccGt.(frFields{k}).est = fr.(frFields{2}).v_out_a(ind(2),:);
			ccGt.(frFields{k}).est{1,1}.OutputName = ccGt.(frFields{k}).est(7);
			[num den] = tfdata(ccGt.(frFields{k}).est{1,1});
			ccGt.(frFields{k}).tf = tf(num, den, 'y',...
				ccGt.(frFields{k}).est{1,1}.OutputName );
		end

		ccG0.(frFields{k}).est;
		disp(ccG0.(frFields{k}).tf);
		ccG0.(frFields{k}).tf.Name = frFields{k};
		fprintf('\n\n');
	
		ccG0.(frFields{k}).spiceLap = tf2spiceLaplace(ccG0.(frFields{k}).tf, 'NumDen', 3);

% 		fprintf(['numerator:\t\t[ ',...
% 			repmat('%i ',1,length(ccG0.(frFields{k}).tf.num{1})), ']\n'],...
% 			ccG0.(frFields{k}).tf.num{1});
% 
% 		fprintf(['denominator:\t[ ',...
% 			repmat('%i ',1,length(ccG0.(frFields{k}).tf.den{1})), ']\n'],...
% 			ccG0.(frFields{k}).tf.den{1});
	end
	%%
	
	for k=1:length(frFields)
		disp( ccG0.(frFields{k}).spiceLap );
		ltilist{k} = ccG0.(frFields{k}).tf;
	end

	%% arbitrary input signal generation for time response simulation
	ts = 1/100e3;
	tt = [0:ts:50e-3-ts];
	sig1 = 15*sin(2*pi*100*tt);

	%% open ltiview ???	
	ret = input('start ltiviewer?  Y/N [N]: ','s');
	if (strcmpi(ret, 'y')) 
		ltiview({'step';'nyquist';'bode';'pzmap'},...
			ltilist{:});
		ltiview('lsim', ltilist{:}, sig1, tt);
	end
% *********************************************************************
% *********************************************************************    
% *********************************************************************    
% *********************************************************************   