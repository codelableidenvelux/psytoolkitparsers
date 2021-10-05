function [psyid, Data]=getpsytoolkitsurvy(psypath, test)
% Test could be 'phonesurvy' 'sf36'
% Usage [psyid, Data] = getpsytoolkitsurvy(psypath, test)
% Wenyu Wan, CODELAB, Leiden University
%% set input parameter
str = ["phonesurvy","sf36";
       "handedness","q33q36"];
nn=[79,41];
if ismember(str,test)==0
    error('please check your input test name, the test must be phonesurvy or sf36')
else
    [T1,T2]=find(ismember(str,test));
    n=nn(T2);
    test2=str(2,T2);
end

%% List all possibleDirectories
to_gen = genpath(psypath);
to_list = regexp([to_gen ':'],'(.*?):','tokens');
to_del = cellfun(@(x) isempty(x{1,1}), to_list);
to_list(to_del) = [];

%% Read the contents in the folder 
k = 0; 
for f = 1:length(to_list) 
    clear tmp_*
    if exist(fullfile(to_list{1,f}{1,1},'data.csv'),'file') 
        tmp_table = readmatrix(fullfile(to_list{1,f}{1,1},'data.csv'),'Delimiter',',', 'OutputType', 'string');        
        % Gather the header 
        fid  = fopen(fullfile(to_list{1,f}{1,1},'data.csv'));
        column=repmat('%s',1,n);%the number of columns
        [tmp_hdr] = textscan(fid,column,'Delimiter',',','HeaderLines',0);
        fid = fclose(fid);
        for h = 1:length(tmp_hdr)
        tmp_hdrtop{h} = tmp_hdr{1,h}{1,1};   
        end
        % identify the different coloumns of interest
        tmp_startcol = find(cellfun(@(x) contains(x,'TIME_start'), tmp_hdrtop)==true);
        tmp_endcol = find(cellfun(@(x) contains(x,'TIME_end'), tmp_hdrtop)==true);
        tmp_idcol = find(cellfun(@(x) contains(x,'user_id'), tmp_hdrtop)==true);
        tmp_assoifuke = find(cellfun(@(x) contains(x,'participant'), tmp_hdrtop)==true);

        % Make a trimmed table containing just was is needed 
        tmp_tabletrim = tmp_table(:,[tmp_idcol tmp_assoifuke tmp_startcol tmp_endcol]);
        tmp_tabletrim(:,(size(tmp_tabletrim,2)+1)) =  repmat(to_list{1,f}{1,1},size(tmp_tabletrim,1),1);
        % does this contain the test we care about ? If so make a large
        % list with essential info [userid,task,associfile]
        
        if sum(contains(tmp_hdrtop,test2))>0
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
[~,uidx] = unique(final_table(:,2)); 
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
    
    %% Store data
    Data{p,1}.user_id = tmp_id; 
    if size(tmp_table,1) > 0
    for tt = 1:size(tmp_table,1)
    Data{p,1}.session{tt}.TIME_start = datetime(tmp_table(tt,3),'InputFormat','yy-MM-dd-HH-mm'); 
    try
    Data{p,1}.session{tt}.TIME_end = datetime(tmp_table(tt,4),'InputFormat','yy-MM-dd-HH-mm');
    catch
    Data{p,1}.session{tt}.TIME_end = NaN;    
    end
    Data{p,1}.session{tt}.id = tmp_table(tt,1);
  try
    A = readmatrix(fullfile([tmp_table(tt,end)],'data.csv'),'Delimiter',',','OutputType', 'string');
    [L1,L2] = find(ismember(A,tmp_table(tt,2)));
    Data{p,1}.session{tt}.surveydata=transpose(A(L1,:));
    [B1,B2,B3]=xlsread(fullfile([tmp_table(tt,end)],'data.csv'));
    Data{p,1}.session{tt}.surveydata=[transpose(B2(1,:)),Data{p,1}.session{tt}.surveydata]; 
  end
    end
    end
end
