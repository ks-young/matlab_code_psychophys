% Extracting Physio data - EMG, UCSD study (POS_NEG_EMO_RDOC)

%TO DO
% 

clear all; close all; clc

%===========USER INPUT SECTION================
site = 'UCLA'; %'UCLA' or 'UCSD'
%===========END USER INPUT SECTION============

%set up data locations
main_dir = 'C:\users\kyoung\Box Sync\matlab_code_psychophys\POS_NEG_EMO_RDOC';
if strcmp(site,'UCLA')==1
    data_dir = strcat(main_dir,'\Processed_EMG_data\EMG_DATA_UCLA');
elseif strcmp(site,'UCSD')==1
    data_dir = strcat(main_dir,'\Processed_EMG_data\EMG_DATA_UCSD');
else
    fprintf('error setting site \n')
end
cd(data_dir)
%find data files & print out list
bl_list = dir('9*EMGbl.xlsx');
max_list = dir('9*EMGmx.xlsx');
fprintf('Compiling data file list: \n')
for a = 1:length(bl_list)
    bl_name{a,1} = bl_list(a).name;
    max_name{a,1} = max_list(a).name;
    fprintf(strcat(bl_name{a,1},'\t',max_name{a,1},'\n'))
end
%=======================
%=======================

% EMG extraction
for b = 1:length(file_list)
    fprintf(strcat('Reading data file: \t', bl_name{b}, '...\n'))
    audio = xlsread(bl_name{b,1},'Parameters','E:E');
    emg = xlsread(bl_name{b,1},'Parameters','G:G');
    [data txt raw] = xlsread(bl_name{b,1},'Parameters','O:O');
    
    fprintf('Finding startle markers \n')
    index = strfind(txt(:,1),'BASELINE STARTLE');
    bl_onsets = find(~cellfun(@isempty,index));
    
    fprintf('Extracting participant data\n')
    for c = 1:length(bl_onsets)
        
        %find peak audio output
        audio_range = audio(bl_onsets(c):bl_onsets(c)+199,1);
        peak_audio = max(audio_range);
        index_peak = bl_onsets(c)+find(audio_range==peak_audio);
        
        %find peak EMG
        emg_max_range = emg(index_peak+1:index_peak+15,1);
        peak_emg = max(emg_max_range);
        sub(b).base(c).emg_max = peak_emg;
        
        %find baseline EMG
        emg_base_range = emg(index_peak-21:index_peak-2,1);
        base_emg = mean(emg_base_range);
        sub(b).base(c).emg_bl = base_emg;
    end
    clear data txt raw audio emg
    fprintf(strcat('---- finished extraction for file: \t', bl_name{b}, '\n'));
end

%     fprintf('Writing output file...');
%     filename = 'emg_extracted.xlsx';
%             xlswrite(filename,sub(d),'emg','B2')
%     
fprintf('SCRIPT FINISHED-----END OF PROCESSING-----\n')