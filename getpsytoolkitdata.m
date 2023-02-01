function [psyid, Data] = getpsytoolkitdata(psypath, test)
% Test could be 'R_TIME' '2_Back' 'TaskSwitch' 'CORSI'
% Usage [psyid, Data] = getpsytoolkitdata(psypath, test)
% Leiden University, Arko Ghosh, 2023 (original 2021)


%% List all possibleDirectories
to_gen = genpath(psypath);
to_list = regexp([to_gen ';'],'(.*?);','tokens');
to_del = cellfun(@(x) isempty(x{1,1}), to_list);
to_list(to_del) = [];

%% Read the contents in the folder
k = 0;
for f = 1:length(to_list);
    clear tmp_*
    if exist(strcat(to_list{1,f}{1,1},'\data.csv'),'file');
        %tmp_table = readmatrix(strcat(to_list{1,f}{1,1},'\data.csv'),'Delimiter',',', 'OutputType', 'string');
        
        
        tmp_table_pre = readmatrix(strcat(to_list{1,f}{1,1},'\data.csv'),'Delimiter',',', 'OutputType', 'string', 'range', [1]);
        tmp_hdrtop = tmp_table_pre(1,1:end);
        tmp_table = tmp_table_pre(2:end,1:end); 
        % Gather the header
%         fid  = fopen(strcat(to_list{1,f}{1,1},'\data.csv'));
%         [tmp_hdr] = textscan(fid,'%s%s%s%s%s%s%s%s%s','Delimiter',',','HeaderLines',0);
%         fid = fclose(fid);
%         for h = 1:length(tmp_hdr);
%             tmp_hdrtop{h} = tmp_hdr{1,h}{1,1};
%         end
        % identify the different coloumns of interest
        %tmp_hdrtop = tmp_table.Properties.VariableNames; 

        tmp_taskcol = find(cellfun(@(x) contains(x,'examplequestion'), tmp_hdrtop)==true);
        tmp_startcol = find(cellfun(@(x) contains(x,'TIME_start'), tmp_hdrtop)==true);
        tmp_endcol = find(cellfun(@(x) contains(x,'TIME_end'), tmp_hdrtop)==true);
        tmp_idcol = find(cellfun(@(x) contains(x,'user_id'), tmp_hdrtop)==true);
        tmp_assoifuke = find(cellfun(@(x) contains(x,'participant'), tmp_hdrtop)==true);

        % Make a trimmed table containing just was is needed
        tmp_tabletrim = tmp_table(:,[tmp_idcol tmp_taskcol tmp_assoifuke tmp_startcol tmp_endcol]);
        tmp_tabletrim(:,(size(tmp_tabletrim,2)+1)) =  repmat(to_list{1,f}{1,1},size(tmp_tabletrim,1),1);
        % does this contain the test we care about ? If so make a large
        % list with essential info [userid,task,associfile]


        if sum(contains(tmp_table(:,tmp_taskcol),test))>0
            k = k+1;
            if k == 1
                final_table = tmp_tabletrim;
            else
                final_table = vertcat(final_table,tmp_tabletrim);
            end
            clear tmp_table
        end
    end
end

%% Establish the unique files
[~,uidx] = unique(final_table(:,3));
final_tablet = final_table(uidx,:);

%% Establish the unique userids
psyid = unique(final_tablet(:,1));

%% Go through each userid and then place them in as many structs as sessions
% with the session start and end times noted. Absence of end time indicates
% task may not have been completed

for p = 1:length(psyid)
    clear tmp_*
    % find all the vals related to the selected id
    tmp_id = psyid(p);
    % make a shorter table containing the psyid alone
    tmp_idx = ismember(final_tablet(:,1), tmp_id);
    tmp_table = final_tablet(tmp_idx,:);
    for t = 1:size(tmp_table,1)
        if isempty(regexp(tmp_table(t,2), regexptranslate('wildcard',strcat(test,'_*'))));
            tmp_idx_task(t) = false;
        else
            tmp_idx_task(t) = regexp(tmp_table(t,2), regexptranslate('wildcard',strcat(test,'_*')));
        end
    end
    % trim the data further to only contain the task values
    tmp_table(~tmp_idx_task,:) = [];
    tmp_tableuse = tmp_table;

    %% Store data
    Data{p,1}.user_id = tmp_id;
    if size(tmp_tableuse,1) > 0
        for tt = 1:size(tmp_tableuse,1)
            Data{p,1}.session{tt}.TIME_start = datetime(tmp_tableuse(tt,4),'InputFormat','yy-MM-dd-HH-mm');
            try
                Data{p,1}.session{tt}.TIME_end = datetime(tmp_tableuse(tt,5),'InputFormat','yy-MM-dd-HH-mm');
            catch
                Data{p,1}.session{tt}.TIME_end = NaN;
            end
            Data{p,1}.session{tt}.id = tmp_tableuse(tt,3);


            % Note new saving format by psytoolkit introduces ./survey_data for survey
            % responses and ./experiment_data for tests

            if exist(strcat([tmp_tableuse(tt,end)],'\survey_data\',tmp_tableuse(tt,3)))
                Data{p,1}.session{tt}.info = readtable(strcat([tmp_tableuse(tt,end)],'\survey_data\',tmp_tableuse(tt,3)));
            else
                %try % as there simply man not be session info
                 Data{p,1}.session{tt}.info = readtable(strcat([tmp_tableuse(tt,end)],'\',tmp_tableuse(tt,3)));
                %catch
                    %display(['no session info in folder ', tmp_tableuse(tt,end)]);
                %end
            end

            if exist(strcat([tmp_tableuse(tt,end)],'\experiment_data\',tmp_tableuse(tt,2)))
                Data{p,1}.session{tt}.vals = readtable(strcat([tmp_tableuse(tt,end)],'\experiment_data\',tmp_tableuse(tt,2)));
            else
                Data{p,1}.session{tt}.vals = readtable(strcat([tmp_tableuse(tt,end)],'\',tmp_tableuse(tt,2)));

            end

        end
    end
end
