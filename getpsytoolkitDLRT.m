function [sRT cRT] = getpsytoolkitDLRT(RTdata); 
% get the reaction times for correct responses seperated as 
% simple and choice reaction times 
% usage [sRT cRT] = getpsytoolkitDLRT(RTdata); 
% sRT and cRT are Nx2
% col 1 is RT
% col 2 is Hand used (only for cRT, 1 right, 0 left)
% Arko Ghosh, Leiden University, 2021

% Gather simple reaction time values 
simpleidx = strcmp(RTdata.Var1,'dlsimple_real');
correctidx = ismember(RTdata.Var7,1);

sRT = RTdata.Var6((simpleidx&correctidx)); 

clear *idx

% Gather complex reaction time 
simpleidx = strcmp(RTdata.Var1,'dlchoice_real');
correctidx = ismember(RTdata.Var7,1);

Rightidx = (RTdata.Var5)>0;

cRT = [RTdata.Var6((simpleidx&correctidx)) Rightidx((simpleidx&correctidx))]; 

clear *idx

end