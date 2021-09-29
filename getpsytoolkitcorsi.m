function [Cspan NCorrect Tpresented] = getpsytoolkitcorsi(corsidata);
% Usage
% [Cspan NCorrect Tpresented] = getpsytoolkitcorsi(corsidata);
% Input
% corsidata as in Data{6,1}.session{1,1}.vals as generated by
% getpsytookitdata.m
% Output
% Cspan = corsi spian 
% NCorrect = number of correct responses
% Tpresented = total number of presentations 

%% Find Cspan
Cspan = max(corsidata.Var1);

%% Number of correct responses
NCorrect = sum(corsidata.Var3); 

%% Number of presented trials 
Tpresented = length(corsidata.Var3);