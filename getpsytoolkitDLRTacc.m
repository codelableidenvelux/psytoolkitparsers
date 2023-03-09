function [sRT cRT sRTacc cRTacc] = getpsytoolkitDLRTacc(RTdata); 
% get the reaction times for correct responses seperated as 
% simple and choice reaction times 
% usage [sRT cRT sRTacc cRTacc] = getpsytoolkitDLRT(RTdata); 
% sRT and cRT are Nx2
% col 1 is RT
% col 2 is Hand used (only for cRT, 1 right, 0 left)
% sRTacc = % correct responses, 1 value
% cRTacc = % correct responses, 1 value 
% Arko Ghosh, Leiden University, 2021
% Arko Ghosh, Modified to add acc, 09/03/2023


% Gather simple reaction time values 
simpleidx = strcmp(RTdata.Var1,'dlsimple_real');
correctidx = ismember(RTdata.Var7,1);

sRT = RTdata.Var6((simpleidx&correctidx)); 
sRTacc = (sum((simpleidx&correctidx))/sum(simpleidx))*100;

clear *idx

% Gather complex reaction time 
simpleidx = strcmp(RTdata.Var1,'dlchoice_real');
correctidx = ismember(RTdata.Var7,1);

Rightidx = (RTdata.Var5)>0;

cRT = [RTdata.Var6((simpleidx&correctidx)) Rightidx((simpleidx&correctidx))]; 
cRTacc = (sum((simpleidx&correctidx))/sum(simpleidx))*100;
clear *idx

end