function out = expect(x, fx)
   if ~isa(fx,'function_handle')
      error('fx must be a function handle the pdf of x');
   end
   
   out = int(x*fx(x),-inf,inf);

end
