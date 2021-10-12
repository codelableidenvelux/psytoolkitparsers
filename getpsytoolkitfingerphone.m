function [fingerdness, yearsused] = getpsytoolkitfingerphone(backdata) 
% Extracts the finger preference, hand preference on the smartphone and
% years used based on ranked pictures
% Number of years of usage is on entry number 13 in the original extract
% Pictures are ranked from field 30 to 37 in the original extract, finger
% pictures files follow the following code (for documentation)
% 1: RD1
% 2: RD3
% 3: RLD1
% 4: RLD1
% 5: RD2 
% 6: LD3
% 7: LD1
% 8: LD2
% Example usage:
% [fingerdness, yearsused] = getpsytoolkitfingerphone(backdata) 
% input: backdata = Data{5,1}.session{1,3}.surveydata; 
% fingerdness has two variable output 
% fingerdness(1) Is the thumb in use? 1 is yes. and towards 0 is no. 
% fingerdness(2) Is the double thumb in use? 1 is yes. and towards 0 is no.
% 


%% Estimate phone hand and fingerdness 
Ranks = double(backdata(30:37));

if sum(isnan(Ranks)) > 1
    fingerdness = [NaN NaN]; 
else
    
    bestrankthumb = 1-min(find(ismember(Ranks,[1,3,4,7])==1))/8 + 1/8; 
    bestrankLRhand = 1-min(find(ismember(Ranks,[3,4])==1))/8 +1/8;

    fingerdness = [bestrankthumb,bestrankLRhand]; 
    
    
end
    
%% Extract years smartphone use
yearsused = double(backdata(13));


