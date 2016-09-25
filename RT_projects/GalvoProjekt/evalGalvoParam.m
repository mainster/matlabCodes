function evalGalvoParam (varargin)
%% @@@MDB

if nargin > 0
    if varargin{1} > 3
        evalin('base','JR=str2num(param.JR);');
        evalin('base','KMT=str2num(param.KMT);');
        evalin('base','Rc=str2num(param.Rc);');
        evalin('base','Lc=str2num(param.Lc);');
        evalin('base','KFR=str2num(param.KFR);');
        evalin('base','KTB=str2num(param.KTB);');
        evalin('base','KBM=str2num(param.KBM);');
        evalin('base','Rsh=str2num(param.Rsh);');

        evalin('base','Kp_cc=str2num(paramCtrl.Kp_cc);');
    end
else
    evalin('base','RIN=str2num(param.RIN);');
    evalin('base','TRC=str2num(param.TRC);');
    evalin('base','CR=str2num(param.CR);');
    evalin('base','CL=str2num(param.CL);');
    evalin('base','FR=str2num(param.FR);');
    evalin('base','KTR=str2num(param.KTR);');
    evalin('base','BEM=str2num(param.BEM);');
    
end
