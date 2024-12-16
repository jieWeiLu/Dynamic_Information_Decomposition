% The dataset used during the current study is available from the 
% corresponding author on reasonable request.
% Below presents the exemplary code to construct dynamic matrices for one
% trial data. Iterative calculations were used for all trials of PD
% patients and healthy controls, generating the final dynamic briain synergy and 
% redundancy matrices of patients and healthy controls

% Simulation of one preprocessed trial data (could be replaced by the real data)
time_length = 386; % 386=35X11, where "35" indicates 35 seconds, 11 indicates the sampling rate of fNIRS
num_channel = 30; % the number of used fNIRS channels
data_trial = rand(386,30);

% Contruction of dynamic matrices       
synergy_sliding = [];
redun_sliding = [];
for iht = 1:(time_length-20*fs)
    if mod(iht,fs)==1 
        % Segmented data
        data_window = data_trial(iht:(iht+20*fs),:);

        % Construction of dynamic matrices
        synergy_mat = [];
        redundancy_mat = [];
        my_BOLD = data_window';
        for row = 1:size(my_BOLD,1)
            for col = 1:size(my_BOLD,1)
                if row~=col
                    atoms = PhiIDFull([my_BOLD(row,:); my_BOLD(col, :)]);
                    synergy_mat(row,col) = atoms.sts;
                    redundancy_mat(row,col) = atoms.rtr;
                end
            end
        end
        synergy_sliding = cat(3,synergy_sliding,synergy_mat);
        redun_sliding = cat(3,redun_sliding,redundancy_mat);
    end
end
