%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logicals in int umwandeln
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u=RxDataRaw;  u2=RxDataRaw2;
doub=fliplr(double(u));
doub2=fliplr(double(u2));
%doub=fliplr(double(u));  % doub2=fliplr(double(u2));
val=0; val2=0;

for i=1:length(doub)
    val=val + doub(i)*2^(i-1);
    val2=val2 + doub2(i)*2^(i-1);
end

RxData=val;
RxData2=val2;

TxData=eval(get_param('spiBitbang_complete_v1/TxData/','Value'));
sprintf('TxData:   %i   %s\nRxData:   %i   %s\nRxData 2: %i   %s',TxData,dec2bin(TxData),RxData,dec2bin(RxData),RxData2,dec2bin(RxData2))

break;


%b = strread(num2str(myLogical),'%s')'
%[lz ls]=size(myLogical);

myLogical = logical([0 0 0 1 0 0 0 1])
doub=fliplr(double(myLogical));
val=0;

for i=1:length(doub)
    val=val + doub(i)*2^(i-1);
end

val


%arrayfun(@num2str, a, 'unif', 0)