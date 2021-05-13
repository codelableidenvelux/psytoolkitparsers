function [Same Mixed] = getpsytoolkitswitch(taskswitchdata);
% Usage 
% [Same Mixed] = getpsytoolkitswitch(taskswitchdata);
%
% Same contains 
% Same.color Same.shape
% contains: RT_correct(Nx3) RT_incorrect(Nx3); 
% 
% Mixed catorgies (under Mixed) 
% contains:
% RT_correct_switch(Nx4)
% RT_correct_noswitch(Nx4)
% RT_incorrect_switch(Nx4)
% RT_incorrect_noswitch(Nx4)
% 
% where col 1 is RT 
%
% col 2 is the hand in use. 1 is right, 0 is left.
% col 3 is congruent in successive trials (for instance if the same key is
% to be used in the subsequent trial). 1 is congruent, 0 is incongruent 
% col 4 is type of trial (0 color, 1 shape, for mixed output only)
%
% Note, max. RT allowed is 5000 ms, so use <5000 when analysing RT
% Arko Ghosh, Leiden University. 2021

%% Same.color

idx_color = or(strcmp(taskswitchdata.Var2, {'realColor1'}), strcmp(taskswitchdata.Var2, {'realColor2'}));
idx_hand = strcmp(taskswitchdata.Var6, {'right'});
idx_correct = (taskswitchdata.Var8 == 1);
idx_switch = (taskswitchdata.Var5 == 1);
idx_congruent = strcmp(taskswitchdata.Var4, {'congruent'});

Same.color.RT_correct = [taskswitchdata.Var7(idx_color & idx_correct) idx_hand(idx_color & idx_correct) idx_congruent(idx_color & idx_correct)]; 
Same.color.RT_incorrect = [taskswitchdata.Var7(idx_color & ~idx_correct) idx_hand(idx_color & ~idx_correct) idx_congruent(idx_color & ~idx_correct)]; 

%% Same.shape
idx_shape = or(strcmp(taskswitchdata.Var2, {'realShape1'}), strcmp(taskswitchdata.Var2, {'realShape2'}));

Same.shape.RT_correct = [taskswitchdata.Var7(idx_shape & idx_correct) idx_hand(idx_shape & idx_correct) idx_congruent(idx_shape & idx_correct)]; 
Same.shape.RT_incorrect = [taskswitchdata.Var7(idx_shape & ~idx_correct) idx_hand(idx_shape & ~idx_correct) idx_congruent(idx_shape & ~idx_correct)]; 

%% Mixed 
idx_mixed = or(strcmp(taskswitchdata.Var2, {'realMixed1'}), strcmp(taskswitchdata.Var2, {'realMixed2'}));
idx_type = strcmp(taskswitchdata.Var3, {'shape'});

Mixed.RT_correct_switch = [taskswitchdata.Var7(idx_switch & idx_correct) ...
    idx_hand(idx_switch & idx_correct) ...
    idx_congruent(idx_switch & idx_correct) ...
    idx_type(idx_switch & idx_correct)];

Mixed.RT_incorrect_switch = [taskswitchdata.Var7(idx_switch & ~idx_correct) ...
    idx_hand(idx_switch & ~idx_correct) ...
    idx_congruent(idx_switch & ~idx_correct) ...
    idx_type(idx_switch & ~idx_correct)];

Mixed.RT_correct_noswitch = [taskswitchdata.Var7(~idx_switch & idx_correct) ...
    idx_hand(~idx_switch & idx_correct) ...
    idx_congruent(~idx_switch & idx_correct) ...
    idx_type(~idx_switch & idx_correct)];

Mixed.RT_incorrect_noswitch = [taskswitchdata.Var7(~idx_switch & ~idx_correct) ...
    idx_hand(~idx_switch & ~idx_correct) ...
    idx_congruent(~idx_switch & ~idx_correct) ...
    idx_type(~idx_switch & ~idx_correct)];
