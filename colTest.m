nChan=12;
col=zeros(nChan,3);
r=1;g=2;b=3;

dc=3/nChan


% for cs=1:3
%     for jj=1:1:nChan/3
%         col(jj+(cs-1)*dc,cs)=dc*jj
%     end
% end
    for jj=1:1:nChan/3
        col(jj,r)=dc*jj
    end

    for jj=1:1:nChan/3
        col(jj+nChan/3,g)=dc*jj
    end

    for jj=1:1:nChan/3
        col(jj+2*nChan/3,b)=dc*jj
    end




