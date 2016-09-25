%% steffi_tia_led_treiber_noise
%

dis=struct2cell(dir('~/CODES_local/matlab_workspace/'));
for k=1:length(dis)
	st{k} = dis{1,k};
end
idx=find(~cellfun(@isempty, strfind(st,'ALDO_LED_Driver_opa2350_thd_')));

f1=figure(1); clf; hold all;

for k=1:length(idx)
	noises(k)=importdata(st{idx(k)}, '\t',1);
	plot(noises(k).data(:,3));
end

f2=figure(2); clf; hold all;
for k=1:length(idx)
	noisesI(k)=importdata(st{idx(k)}, '\t',1);
	plot(noisesI(k).data(:,2));
end

grid on
