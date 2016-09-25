%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Handle- Tricks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ar=get(f1,'Children');
ar(find(~cellfun(@isempty,strfind(get(get(f1,'Children'),'type'),'axes'))))

set(ar(find(~cellfun(@isempty,strfind(get(get(f1,'Children'),'type'),'axes')))),'XTickLabelMode','manual')
set(ar(find(~cellfun(@isempty,strfind(get(get(f1,'Children'),'type'),'axes')))),'XTickMode','manual')
set(ar(find(~cellfun(@isempty,strfind(get(get(f1,'Children'),'type'),'axes')))),'YTickLabelMode','manual')
set(ar(find(~cellfun(@isempty,strfind(get(get(f1,'Children'),'type'),'axes')))),'YTickMode','manual')
set(ar(find(~cellfun(@isempty,strfind(get(get(f1,'Children'),'type'),'axes')))),'ZTickLabelMode','manual')
set(ar(find(~cellfun(@isempty,strfind(get(get(f1,'Children'),'type'),'axes')))),'ZTickLabel','manual')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%   Durchsuche Figure- Handles  nach childs mit bestimmtem namen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figChilds=[get(f2,'Children') ; get(f4,'Children')];

inc=strfind(get(figChilds(:),'type'),'axes');        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc));            % take all children handles of all axes handle into structure

axisChilds=get(figChilds(ind),'Children')';

for i=1:length(axisChilds)
    sprintf('Child %.f (DisplayName)',i);
    get(axisChilds{i},'DisplayName');
    % objekt suchen und indexieren
    inc=strfind(get(axisChilds{i},'DisplayName'),  FINDSTR);
    if ~isempty(find(~cellfun(@isempty,inc))')
        indDispName{i,1}=find(~cellfun(@isempty,inc));
    end
end

for i=1:length(axisChilds)
    sprintf('Child %.f (Tag)',i);
    get(axisChilds{i},'Tag');
    % objekt suchen und indexieren
    inc=strfind(get(axisChilds{i},'Tag'),  FINDSTR);
    if ~isempty(find(~cellfun(@isempty,inc))')
        indTag{i,1}=find(~cellfun(@isempty,inc));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indDispName=indDispName';
indTag=indTag';

% SEL=2;   % Zugriff auf 1. handle der 2. axes (suchstring in 'DisplayName')
% get(axisChilds{SEL}(indDispName{SEL}),'DisplayName')
% SEL=3;   % Zugriff auf 1. handle der 3. axes
% get(axisChilds{SEL}(indDispName{SEL}),'DisplayName')
% SEL=1;   % Zugriff auf 1. handle der 1. axes (suchstring in 'Tag')
% get(axisChilds{SEL}(indTag{SEL}),'Tag')
% SEL=2;
% set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'LineWidth',5)

SEL=2;
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'LineWidth',5)
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'Color',[1 0 0])

SEL=5;
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'LineWidth',5)
set(get(axisChilds{SEL}(indDispName{SEL}),'Children'),'Color',[1 0 0])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









