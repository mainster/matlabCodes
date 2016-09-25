% function varargout = figuresArrange ()
   global ol ch fh;
   
   getWrap=@ol.getWrap;
   clear ch fh
   
   %% figure handles, they are already sorted
   %fh = evalin('base','findall(0,''type'',''figure'')')
   
   %% Instance a graphics root object 
   gr = groot;
   fh = gr.Children;
   mon = gr.MonitorPositions;
   
   time=0; ctr=1;
   tic; 
   while time <= 20
      ptr(ctr,:) = get(groot,'PointerLocation');
      fprintf('cursor: x= %g\ty= %g\n', ptr(ctr,1), ptr(ctr,2))
      ctr=ctr+1;
      pause(.1);
      
   end
   mon.l.xrng = [mon(1,3) ,mon(1,4)]
   mon.l.yrng = [mon(1,3) ,mon(1,4)]
   
%    %% handles to figure children
%    for k=1:length(fh)
%       ch(:,k) = fh(k).Children;
%    end
%    ch
%%   
   idx=find(~cellfun(@isempty, strfind( getWrap(ch(2,:),'Type'), 'axes')))
   if nargout > 0
      varargout{1} = fh;
   end
% end