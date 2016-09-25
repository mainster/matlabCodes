%A=[-2 -2 4 -2]'

%  C= A(ia,:) and A = C(ic,:)

%[C ia ic]=unique(A);
%hc=histc(A,C)

% hc(1) mal den wert der bei C(1) drin steht
% hc(2) mal den wert der bei C(2) drin steht
% str1=[];
% for i=1:length(C)
%     str1=[str1 sprintf('Der Wert %i ist %i mal in A vorhanden\n',...
%         C(i),hc(i))];
% end

%disp(str1)
%ahc=histc(A,CCa);
MODE=1;

if MODE==0
    clear all;

    poles1=[1 2 1];
    poles2=[1 3 -3];
    poles3=[2 25 2];
    A=[poles1; poles2; poles3];

    [m n]=size(A);
    CC=zeros(m,n);
    hc=zeros(m,n);

    for i=1:length(A)
        tCC=unique(A(i,:));
        thc=histc(A(i,:),tCC);

        CC(i,1:length(tCC))=tCC;
        hc(i,1:length(thc))=thc;

        clear thc tCC
    end

    hc
    CC
end




if MODE==1
    clear all;

    poles1=[1 2 1];
    poles2=[1 3 -3];
    poles3=[2+3*j 2-3*j 7];
    A=[poles1; poles2; poles3];

    [m n]=size(A);
    CC=zeros(m,n);
    hc=zeros(m,n);

    for i=1:length(A)
        tCC=unique(A(i,:));
        thc=histc(A(i,:),tCC);
        histc(A(i,:),tCC);
%        thcAn=histc(sort(angle(A(i,:))),sort(angle(tCC)));

        CC(i,1:length(tCC))=tCC;
        hc(i,1:length(thc))=thc;
%        hcAn(i,1:length(thcAn))=thcAn;

        clear thc tCC
    end

    for i=1:3
%        hc(i,:)
        CC(i,:)
    end
%     Y=abs(real(CC)) > 1e6*abs(imag(CC));
%     Y2=(abs(real(CC)) < 1e-6) & (abs(imag(CC)) < 1e-6);
%     delC=Y | Y2;
%     
%     CCneu=zeros(m,n);
%     for i=1:3
%         CC(i,delC(i,:))=0;%real(CC(i,delC(i,:)))
%     end
end


% 
% return
% 
% for i=1:length(A)
%     [aC(i,:) ia(i,:) ic(i,:)]=unique(A(i,:));
%     ahc(i,:)=histc(A(i,:),aC(i,:));
% end
% 
% A
% ahc(1,:)
% aC(1,:)
% 
% 
% B=[-1-j -1+j; -1-2*j -1+2*j; -1-j -1+j;];
% 
% return;
% 
% clear zC izz izc zhc;
% for i=1:length(A)
%     [zC(i,:) izz(i,:) izc(i,:)]=unique(real(A(i,:))+imag(A(i,:)))
%     zhc(i,:)=histc(A(i,:),zC(i,:));
% end

