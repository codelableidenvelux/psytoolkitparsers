function [Dprime pHit pFA Nhits Nmiss NfA NCorRej RThits RTfalseA] = getpsytoolkit2Back(backdata); 
% get key 2 back analysis 
% Usage
% [Dprime pHit pFA Nhits Nmiss NfA NCorRej RThits RTfalseA] = getpsytoolkit2Back(backdata);
% Input
% backdata -> the vals variable generated using getpsytoolkitdata 
% example: Data{6, 1}.session{1, 1}.vals  
% Output
% Dprime of the 2back (dpri,ccrit)
% N umber of hits, misses, falsealarm and correct rejection
% Reaction times of hits, and false alarrms
% Arko Ghosh, Leiden University, 05/05/2021

%% Gather the hits (col3 & col5)
hits_idx = and(backdata.Var3 == 1, backdata.Var5 == 1); 
Nhits = sum(hits_idx); 
RThits = backdata.Var8(hits_idx); 
%% Gather the misses
miss_idx = and(backdata.Var3 == 1, backdata.Var6 == 1); 
Nmiss = sum(miss_idx); 

%% Gather the correct rejections
correj_idx = and(backdata.Var3 == 0, backdata.Var7 == 0); 
NCorRej = sum(correj_idx); 

%% Gather the falsealarm 
fa_idx = and(backdata.Var3 == 0, backdata.Var7 == 1); 
NfA = sum(fa_idx); 
RTfalseA = backdata.Var8(fa_idx); 

%% Estimate D prime 

pHit = Nhits/sum(backdata.Var3 == 1);% pHit
pFA = NfA/sum(backdata.Var3 == 0); %
[Dprime.dpri,Dprime.ccrit] = dprime(pHit,pFA);