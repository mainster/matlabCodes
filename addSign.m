function strOut=addSign(num,formatSpec)
%Add leading sign for string concatenation
%Example:   addSign(1+2*i,'%.2f')
%Example:   addSign(1.22+2*i,'adjust')

    if real(num)>0
        lead='+';
    else
        if real(num)<0
            lead='';
        else
            lead='';
        end
    end

    ncr=1;

    if strcmp(formatSpec,'')
        formatSpecOut='%.10f';
    else
        if strcmp(formatSpec,'Adjust') | strcmp(formatSpec,'adjust')
            if(real(num)>=1e-6)
                strRe=num2str(real(num));   
            else
                strRe='0';
            end
            
            if(imag(num)>=1e-6)
                strIm=num2str(imag(num));   
            else
                strIm='0';
            end
            
            ncr=length(strRe)-strfind(strRe,'.'); % länge - anzahl nachkomma
            nci=length(strIm)-strfind(strIm,'.'); % länge - anzahl nachkomma
            formatSpecOut=['%.' num2str(max([ncr nci])) 'f'];
        else
            sprintf('Unknowen formatSpec')
            formatSpecOut='%.10f';
        end
    end
    
    strOut=[lead num2str(num, formatSpecOut)];
end
    
