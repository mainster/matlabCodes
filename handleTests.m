% handle tests

delete(findall(0,'type','line'));

% Where 'object' can be a function or class name. The advantage of this  
% method for me is that you can call it from outside the mfile in question.
% This is necessary if you need to get the path to a derived class from 
% the base class for example.
[folder, name, ext] = fileparts(which('object'));


f5=figure(5);
get(f5,'type')

hold all
for i=1:5
    step(tf([1],[i 1]),[1:0.1:10])
end

figChilds=get(f5,'Children');
%get(get(chf5(1),'Children'),'type')
axisChilds=get(figChilds(2),'Children');
get(axisChilds(:),'DisplayName')

str=[]
for i=1:10
    str=[str sprintf('no-%.f:',i)];
end
strs=strsplit(str,':');
legend(strs)

inc=strfind(get(axisChilds(:),'DisplayName'),'-2')
ind=find(~cellfun(@isempty,inc))


targetNameChilds=get(axisChilds(ind),'Children');
get(targetNameChilds,'type')
DispName=get(targetNameChilds(:),'DisplayName')
Tag=get(targetNameChilds(:),'Tag')

hStemLin=get(targetNameChilds(1));
hCurve=get(targetNameChilds(2));

hCurve
hStemLin
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%set(hCurve,'LineWidth',3)
%set(hStemLin,'Color',[.1 .1 .1])

set(targetNameChilds(2),'LineWidth',3)
set(targetNameChilds(1),'Color',[0.1 0.1 0.1])
set(targetNameChilds(1),'Visible','On')

hStemLin=get(targetNameChilds(1));
hCurve=get(targetNameChilds(2));


hCurve
hStemLin


return;









