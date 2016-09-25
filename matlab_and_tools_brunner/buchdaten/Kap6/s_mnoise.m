function [ret,x0,str,ts,xts]=s_mnoise(t,x,u,flag);
%S_MNOISE	is the M-file description of the SIMULINK system named S_MNOISE.
%	The block-diagram can be displayed by typing: S_MNOISE.
%
%	SYS=S_MNOISE(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes S_MNOISE to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling S_MNOISE with a FLAG of zero:
%	[SIZES]=S_MNOISE([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs
%		SIZES(5) number of roots (currently unsupported)
%		SIZES(6) direct feedthrough flag
%		SIZES(7) number of sample times
%
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.3)
if (0 == (nargin + nargout))
     set_param(sys,'Location',[100,118,307,255])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')


%     Subsystem  'Mehrfach-Rauschen'.

new_system([sys,'/','Mehrfach-Rauschen'])
set_param([sys,'/','Mehrfach-Rauschen'],'Location',[40,6553695,445,6554015])


%     Subsystem  ['Mehrfach-Rauschen/Band-Limited',13,'White Noise3'].

new_system([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],'Location',[54,341,339,470])

add_block('built-in/Outport',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/Out_1']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/Out_1']],...
		'position',[230,40,250,60])

add_block('built-in/Gain',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/Gain']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/Gain']],...
		'Gain','[sqrt(Cov)]/[sqrt(Ts)]',...
		'position',[155,31,195,69])

add_block('built-in/Zero-Order Hold',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/Zero-Order',13,'Hold']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/Zero-Order',13,'Hold']],...
		'Sample time','Ts',...
		'position',[85,34,120,66])

add_block('built-in/White Noise',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/White Noise']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3/White Noise']],...
		'Seed','seed',...
		'position',[25,40,45,60])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],[50,50;80,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],[200,50;225,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],[125,50;150,50])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],...
		'Mask Display','plot(t(:),r2(:))',...
		'Mask Type','Continuous White Noise.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],...
		'Mask Dialogue','White noise for continuous (s-domain) systems.\nBand-limited using zero-order-hold.|Noise Power:|Sample Time:|Seed')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],...
		'Mask Translate','Cov = @1; Ts = @2; seed = @3; r = rand(1,12); r2 = [r(1),r;r,r(12)]; t =[1:13;1:13];')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],...
		'Mask Help','Implemented using white noise into Zero-Order Hold block. The seed and power can be vectors of the same length to produce a vector of white noise sources. For faster simulation, set sample time to the highest value possible but in accordance with the fastest dynamics of system.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],...
		'Mask Entries','[0.1]\/0.1\/[23341]\/')


%     Finished composite block ['Mehrfach-Rauschen/Band-Limited',13,'White Noise3'].

set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise3']],...
		'position',[165,82,210,118])


%     Subsystem  ['Mehrfach-Rauschen/Band-Limited',13,'White Noise4'].

new_system([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],'Location',[54,341,339,470])

add_block('built-in/Outport',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/Out_1']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/Out_1']],...
		'position',[230,40,250,60])

add_block('built-in/Gain',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/Gain']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/Gain']],...
		'Gain','[sqrt(Cov)]/[sqrt(Ts)]',...
		'position',[155,31,195,69])

add_block('built-in/Zero-Order Hold',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/Zero-Order',13,'Hold']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/Zero-Order',13,'Hold']],...
		'Sample time','Ts',...
		'position',[85,34,120,66])

add_block('built-in/White Noise',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/White Noise']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4/White Noise']],...
		'Seed','seed',...
		'position',[25,40,45,60])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],[50,50;80,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],[200,50;225,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],[125,50;150,50])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],...
		'Mask Display','plot(t(:),r2(:))',...
		'Mask Type','Continuous White Noise.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],...
		'Mask Dialogue','White noise for continuous (s-domain) systems.\nBand-limited using zero-order-hold.|Noise Power:|Sample Time:|Seed')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],...
		'Mask Translate','Cov = @1; Ts = @2; seed = @3; r = rand(1,12); r2 = [r(1),r;r,r(12)]; t =[1:13;1:13];')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],...
		'Mask Help','Implemented using white noise into Zero-Order Hold block. The seed and power can be vectors of the same length to produce a vector of white noise sources. For faster simulation, set sample time to the highest value possible but in accordance with the fastest dynamics of system.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],...
		'Mask Entries','[0.1]\/0.1\/[341]\/')


%     Finished composite block ['Mehrfach-Rauschen/Band-Limited',13,'White Noise4'].

set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise4']],...
		'position',[165,157,210,193])


%     Subsystem  ['Mehrfach-Rauschen/Band-Limited',13,'White Noise5'].

new_system([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],'Location',[54,341,339,470])

add_block('built-in/Outport',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/Out_1']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/Out_1']],...
		'position',[230,40,250,60])

add_block('built-in/Gain',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/Gain']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/Gain']],...
		'Gain','[sqrt(Cov)]/[sqrt(Ts)]',...
		'position',[155,31,195,69])

add_block('built-in/Zero-Order Hold',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/Zero-Order',13,'Hold']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/Zero-Order',13,'Hold']],...
		'Sample time','Ts',...
		'position',[85,34,120,66])

add_block('built-in/White Noise',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/White Noise']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5/White Noise']],...
		'Seed','seed',...
		'position',[25,40,45,60])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],[50,50;80,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],[200,50;225,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],[125,50;150,50])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],...
		'Mask Display','plot(t(:),r2(:))',...
		'Mask Type','Continuous White Noise.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],...
		'Mask Dialogue','White noise for continuous (s-domain) systems.\nBand-limited using zero-order-hold.|Noise Power:|Sample Time:|Seed')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],...
		'Mask Translate','Cov = @1; Ts = @2; seed = @3; r = rand(1,12); r2 = [r(1),r;r,r(12)]; t =[1:13;1:13];')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],...
		'Mask Help','Implemented using white noise into Zero-Order Hold block. The seed and power can be vectors of the same length to produce a vector of white noise sources. For faster simulation, set sample time to the highest value possible but in accordance with the fastest dynamics of system.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],...
		'Mask Entries','[0.1]\/0.1\/[2313541]\/')


%     Finished composite block ['Mehrfach-Rauschen/Band-Limited',13,'White Noise5'].

set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise5']],...
		'position',[170,227,215,263])

add_block('built-in/Mux',[sys,'/','Mehrfach-Rauschen/Mux'])
set_param([sys,'/','Mehrfach-Rauschen/Mux'],...
		'inputs','6',...
		'position',[320,107,350,163])


%     Subsystem  ['Mehrfach-Rauschen/Band-Limited',13,'White Noise2'].

new_system([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],'Location',[54,341,339,470])

add_block('built-in/Outport',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/Out_1']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/Out_1']],...
		'position',[230,40,250,60])

add_block('built-in/Gain',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/Gain']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/Gain']],...
		'Gain','[sqrt(Cov)]/[sqrt(Ts)]',...
		'position',[155,31,195,69])

add_block('built-in/Zero-Order Hold',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/Zero-Order',13,'Hold']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/Zero-Order',13,'Hold']],...
		'Sample time','Ts',...
		'position',[85,34,120,66])

add_block('built-in/White Noise',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/White Noise']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2/White Noise']],...
		'Seed','seed',...
		'position',[25,40,45,60])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],[50,50;80,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],[200,50;225,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],[125,50;150,50])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],...
		'Mask Display','plot(t(:),r2(:))',...
		'Mask Type','Continuous White Noise.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],...
		'Mask Dialogue','White noise for continuous (s-domain) systems.\nBand-limited using zero-order-hold.|Noise Power:|Sample Time:|Seed')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],...
		'Mask Translate','Cov = @1; Ts = @2; seed = @3; r = rand(1,12); r2 = [r(1),r;r,r(12)]; t =[1:13;1:13];')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],...
		'Mask Help','Implemented using white noise into Zero-Order Hold block. The seed and power can be vectors of the same length to produce a vector of white noise sources. For faster simulation, set sample time to the highest value possible but in accordance with the fastest dynamics of system.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],...
		'Mask Entries','[0.1]\/0.1\/[2973341]\/')


%     Finished composite block ['Mehrfach-Rauschen/Band-Limited',13,'White Noise2'].

set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise2']],...
		'position',[75,202,120,238])


%     Subsystem  ['Mehrfach-Rauschen/Band-Limited',13,'White Noise1'].

new_system([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],'Location',[54,341,339,470])

add_block('built-in/Outport',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/Out_1']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/Out_1']],...
		'position',[230,40,250,60])

add_block('built-in/Gain',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/Gain']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/Gain']],...
		'Gain','[sqrt(Cov)]/[sqrt(Ts)]',...
		'position',[155,31,195,69])

add_block('built-in/Zero-Order Hold',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/Zero-Order',13,'Hold']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/Zero-Order',13,'Hold']],...
		'Sample time','Ts',...
		'position',[85,34,120,66])

add_block('built-in/White Noise',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/White Noise']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1/White Noise']],...
		'Seed','seed',...
		'position',[25,40,45,60])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],[50,50;80,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],[200,50;225,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],[125,50;150,50])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],...
		'Mask Display','plot(t(:),r2(:))',...
		'Mask Type','Continuous White Noise.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],...
		'Mask Dialogue','White noise for continuous (s-domain) systems.\nBand-limited using zero-order-hold.|Noise Power:|Sample Time:|Seed')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],...
		'Mask Translate','Cov = @1; Ts = @2; seed = @3; r = rand(1,12); r2 = [r(1),r;r,r(12)]; t =[1:13;1:13];')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],...
		'Mask Help','Implemented using white noise into Zero-Order Hold block. The seed and power can be vectors of the same length to produce a vector of white noise sources. For faster simulation, set sample time to the highest value possible but in accordance with the fastest dynamics of system.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],...
		'Mask Entries','[0.1]\/0.1\/[233]\/')


%     Finished composite block ['Mehrfach-Rauschen/Band-Limited',13,'White Noise1'].

set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise1']],...
		'position',[70,132,115,168])


%     Subsystem  ['Mehrfach-Rauschen/Band-Limited',13,'White Noise'].

new_system([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],'Location',[54,341,339,470])

add_block('built-in/Outport',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/Out_1']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/Out_1']],...
		'position',[230,40,250,60])

add_block('built-in/Gain',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/Gain']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/Gain']],...
		'Gain','[sqrt(Cov)]/[sqrt(Ts)]',...
		'position',[155,31,195,69])

add_block('built-in/Zero-Order Hold',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/Zero-Order',13,'Hold']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/Zero-Order',13,'Hold']],...
		'Sample time','Ts',...
		'position',[85,34,120,66])

add_block('built-in/White Noise',[sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/White Noise']])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise/White Noise']],...
		'Seed','seed',...
		'position',[25,40,45,60])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],[50,50;80,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],[200,50;225,50])
add_line([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],[125,50;150,50])
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],...
		'Mask Display','plot(t(:),r2(:))',...
		'Mask Type','Continuous White Noise.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],...
		'Mask Dialogue','White noise for continuous (s-domain) systems.\nBand-limited using zero-order-hold.|Noise Power:|Sample Time:|Seed')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],...
		'Mask Translate','Cov = @1; Ts = @2; seed = @3; r = rand(1,12); r2 = [r(1),r;r,r(12)]; t =[1:13;1:13];')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],...
		'Mask Help','Implemented using white noise into Zero-Order Hold block. The seed and power can be vectors of the same length to produce a vector of white noise sources. For faster simulation, set sample time to the highest value possible but in accordance with the fastest dynamics of system.')
set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],...
		'Mask Entries','[0.1]\/0.1\/[1257]\/')


%     Finished composite block ['Mehrfach-Rauschen/Band-Limited',13,'White Noise'].

set_param([sys,'/',['Mehrfach-Rauschen/Band-Limited',13,'White Noise']],...
		'position',[70,57,115,93])

add_block('built-in/Outport',[sys,'/','Mehrfach-Rauschen/out_1'])
set_param([sys,'/','Mehrfach-Rauschen/out_1'],...
		'position',[380,125,400,145])
add_line([sys,'/','Mehrfach-Rauschen'],[220,245;285,245;285,160;315,160])
add_line([sys,'/','Mehrfach-Rauschen'],[125,220;270,220;270,150;315,150])
add_line([sys,'/','Mehrfach-Rauschen'],[215,175;260,175;260,140;315,140])
add_line([sys,'/','Mehrfach-Rauschen'],[120,150;210,150;210,130;315,130])
add_line([sys,'/','Mehrfach-Rauschen'],[215,100;260,100;260,120;315,120])
add_line([sys,'/','Mehrfach-Rauschen'],[120,75;270,75;270,110;315,110])
add_line([sys,'/','Mehrfach-Rauschen'],[355,135;375,135])


%     Finished composite block 'Mehrfach-Rauschen'.

set_param([sys,'/','Mehrfach-Rauschen'],...
		'position',[95,50,125,100])

drawnow

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str,ts,xts] = feval(sys);
	end
else
	drawnow % Flash up the model and execute load callback
end
