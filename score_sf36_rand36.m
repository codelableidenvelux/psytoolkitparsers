function [oblique_PCS, oblique_MCS, ...
    PF, RP, BP, GH, VT, SF, RE, MH] = score_sf36_rand36(responses)
% Function to calculate Oblique PCS and MCS scores from SF36 response using
% the RAND36 mscoring method
% The function accepts in input the array of 36 responses and outputs the 8
% subscores: PF, RP, BP, GH, VT, SF, RE, MH
% and the 2 oblique scores PCS and MCS obtained from z -scoring over US
% population
% 
% example of input
% res = [2,3,1,1,2,1,...
%        2,2,1,1,1,2,...
%        1,1,1,1,1,1,...
%        2,4,2,4,1,5,...
%        6,4,5,6,3,4,...
%        3,2,4,2,5,2];
%
% Enea Ceolini, Leiden University, 26/05/2021
         
   
%% IRT weighted score

% q1
Q_MAT = [100,75,50,25,0,-1;...
% q2
100,75,50,25,0,-1;...
% q3
0,50,100,-1,-1,-1;...
% irt4
0,50,100,-1,-1,-1;...
% irt5
0,50,100,-1,-1,-1;...
% irt6
0,50,100,-1,-1,-1;...
% irt7
0,50,100,-1,-1,-1;...
% irt8
0,50,100,-1,-1,-1;...
% irt9
0,50,100,-1,-1,-1;...
% irt10
0,50,100,-1,-1,-1;...
% irt11
0,50,100,-1,-1,-1;...
% irt12
0,50,100,-1,-1,-1;...
% irt
0,100,-1,-1,-1,-1;...
% irt14
0,100,-1,-1,-1,-1;...
% irt15
0,100,-1,-1,-1,-1;...
% irt16
0,100,-1,-1,-1,-1;...
% irt17
0,100,-1,-1,-1,-1;...
% irt18
0,100,-1,-1,-1,-1;...
% irt19
0,100,-1,-1,-1,-1;...
% irt20
100,75,50,25,0,-1;...
% irt21
100,80,60,40,20,0;...
% irt22
100,75,50,25,0,-1;...
% irt23
100,80,60,40,20,0;...
% irt24
0,20,40,60,80,100;...
% irt25
0,20,40,60,80,100;...
% irt26
100,80,60,40,20,0;...
% irt27
100,80,60,40,20,0;...
% irt28
0,20,40,60,80,100;...
% irt29
0,20,40,60,80,100;...
% irt30
100,80,60,40,20,0;...
% irt31
0,20,40,60,80,100;...
% irt32
0,25,50,75,100,-1;...
% irt33
0,25,50,75,100,-1;...
% irt34
100,75,50,25,0,-1;...
% irt35
0,25,50,75,100,-1;...
% irt36
100,75,50,25,0,-1];

%% score 
scaled_scores = zeros(36, 1);
for i = 1:36
    scaled_scores(i) = Q_MAT(i, responses(i));
end

%% 6 scores

PF  = mean(scaled_scores(3:12));
RP = mean(scaled_scores(13:16));
BP  = mean(scaled_scores(21:22));
GH = (scaled_scores(1) + sum(scaled_scores(33:36))) / 5;
VT  = (scaled_scores(23) + scaled_scores(27) + scaled_scores(29) + scaled_scores(31)) / 4;
SF  = (scaled_scores(20) + scaled_scores(32)) / 2;
RE = mean(scaled_scores(17:19));
MH = (sum(scaled_scores(24:26)) + scaled_scores(28) + scaled_scores(30)) / 5;

%% z-scoring
pop_stat = cell2table({ 50.68,	14.48,	0.42402,	-0.22999,	0.2,	-0.02;...
49.47,	14.71,	0.35119,	-0.12329,	0.31,	0.03;
50.66,	16.28,	0.31754,	-0.09731,	0.23,	0.04;
 50.1,     16.87,	0.24954,	-0.01571,	0.2,	0.1;
53.71,	15.35,	0.02877,	0.23534,	0.13,	0.29;
 51.37,	13.93,	-0.00753,	0.26876,	0.11,	0.14;
51.44,	13.12,	-0.19206,	0.43407,	0.03,	0.2;
 54.27,	13.28, 	-0.22069,	0.48581,	-0.03,	0.35},... 
'VariableNames', { 'mean', 'std', 'ort-PCS', 'ort-MCS', 'obl-PCS', 'obl-MCS'}, 'RowNames', ...
{'PF', 'RP', 'BP', 'GH', 'VT', 'SF', 'RE', 'MH'});

PF_z = (PF - pop_stat{'PF', 'mean'}) / pop_stat{'PF', 'std'};
RP_z = (RP - pop_stat{'RP', 'mean'}) / pop_stat{'RP', 'std'};
BP_z = (BP - pop_stat{'BP', 'mean'}) / pop_stat{'BP', 'std'};
GH_z = (GH - pop_stat{'GH', 'mean'}) / pop_stat{'GH', 'std'};
VT_z = (VT - pop_stat{'VT', 'mean'}) / pop_stat{'VT', 'std'};
SF_z = (SF - pop_stat{'SF', 'mean'}) / pop_stat{'SF', 'std'};
RE_z = (RE - pop_stat{'RE', 'mean'}) / pop_stat{'RE', 'std'};
MH_z = (MH - pop_stat{'MH', 'mean'}) / pop_stat{'MH', 'std'};

%% PC/MC Oblique

obl_PC_z = sum(PF_z * pop_stat{'PF', 'obl-PCS'} + ...
           RP_z * pop_stat{'RP', 'obl-PCS'} + ...
           BP_z * pop_stat{'BP', 'obl-PCS'} + ...
           GH_z * pop_stat{'GH', 'obl-PCS'} + ...
           VT_z * pop_stat{'VT', 'obl-PCS'} + ...
           SF_z * pop_stat{'SF', 'obl-PCS'} + ...
           RE_z * pop_stat{'RE', 'obl-PCS'} + ...
           MH_z * pop_stat{'MH', 'obl-PCS'});
       
obl_MC_z = sum(PF_z * pop_stat{'PF', 'obl-MCS'} + ...
           RP_z * pop_stat{'RP', 'obl-MCS'} + ...
           BP_z * pop_stat{'BP', 'obl-MCS'} + ...
           GH_z * pop_stat{'GH', 'obl-MCS'} + ...
           VT_z * pop_stat{'VT', 'obl-MCS'} + ...
           SF_z * pop_stat{'SF', 'obl-MCS'} + ...
           RE_z * pop_stat{'RE', 'obl-MCS'} + ...
           MH_z * pop_stat{'MH', 'obl-MCS'});
       
oblique_PCS = (obl_PC_z * 10) + 50;
oblique_MCS = (obl_MC_z * 10) + 50;
%% PC/MC Orthogonal

ort_PC_z = sum(PF_z * pop_stat{'PF', 'ort-PCS'} + ...
           RP_z * pop_stat{'RP', 'ort-PCS'} + ...
           BP_z * pop_stat{'BP', 'ort-PCS'} + ...
           GH_z * pop_stat{'GH', 'ort-PCS'} + ...
           VT_z * pop_stat{'VT', 'ort-PCS'} + ...
           SF_z * pop_stat{'SF', 'ort-PCS'} + ...
           RE_z * pop_stat{'RE', 'ort-PCS'} + ...
           MH_z * pop_stat{'MH', 'ort-PCS'});
       
ort_MC_z = sum(PF_z * pop_stat{'PF', 'ort-MCS'} + ...
           RP_z * pop_stat{'RP', 'ort-MCS'} + ...
           BP_z * pop_stat{'BP', 'ort-MCS'} + ...
           GH_z * pop_stat{'GH', 'ort-MCS'} + ...
           VT_z * pop_stat{'VT', 'ort-MCS'} + ...
           SF_z * pop_stat{'SF', 'ort-MCS'} + ...
           RE_z * pop_stat{'RE', 'ort-MCS'} + ...
           MH_z * pop_stat{'MH', 'ort-MCS'});
    
orthogonal_PCS = (ort_PC_z * 10) + 50;
orthogonal_MCS = (ort_MC_z * 10) + 50;


end

