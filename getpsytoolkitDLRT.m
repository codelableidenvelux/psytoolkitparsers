function [sRT cRT] = getpsytoolkitDLRT(RTdata); 
% get the reaction times for correct responses seperated as 
% simple and choice reaction times 
% usage [sRT cRT] = getpsytoolkitDLRT(RTdata); 


% Gather simple reaction time values 
simpleidx = strcmp(RTdata.Var1,'dlsimple_real');
correctidx = ismember(RTdata.Var7,1);

sRT = RTdata.Var6((simpleidx&correctidx)); 

clear *idx

% Gather complex reaction time 
simpleidx = strcmp(RTdata.Var1,'dlchoice_real');
correctidx = ismember(RTdata.Var7,1);

cRT = RTdata.Var6((simpleidx&correctidx)); 

clear *idx

end