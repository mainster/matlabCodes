function sys1 = gcbtf ()
% @@@MDB
try
    fns = lower(fieldnames(get_param(gcb,'ObjectParameters')));
    
    if ~isempty( find(~cellfun(@isempty, strfind(fns, 'numerator'))) )
        sys1=tf(str2num(get_param(gcb, 'Numerator')),...
        str2num(get_param(gcb, 'Denominator')));
    else
        if ~isempty( find(~cellfun(@isempty, strfind(fns, 'zero'))) )
            sys1=zpk(   str2num(get_param(gcb, 'Zeros')),...
                        str2num(get_param(gcb, 'Poles')),...
                        str2num(get_param(gcb, 'Gain')) );
        else
            error('no tf data and no zpk data found')
        end
    end
catch err
    num=str2num(get_param(gcb, 'Numerator'));
    dens=get_param(gcb, 'Denominator');
    den=evalin('base',dens);
    sys1=tf(num, den);
end    

end