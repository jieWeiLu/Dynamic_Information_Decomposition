% Simulation of the daynamic synergy data of patients and healthy controls
% "30": channel number, "16": number of sliding windows
% "3": trial number, "36": number of healthy controls, "63": number of PD patients
syn_hc = rand(30,30,16,3,36);
syn_off = rand(30,30,16,3,63);
syn_on = rand(30,30,16,3,63);

% mean and std matrices
control_used = [];
for ip = 1:size(syn_hc,5)
    for it = 1:size(syn_hc,4)
        control_used = cat(3,control_used,syn_hc(:,:,:,it,ip));
    end
end
control_mean = mean(control_used, 3);
control_std = std(control_used,0,3);

% normalization
syn_hc_nor = get_normalization(syn_hc,control_mean,control_std);
syn_off_nor = get_normalization(syn_off,control_mean,control_std);
syn_on_nor = get_normalization(syn_on,control_mean,control_std);

signal_index = [ones(1,14)*1,ones(1,8)*2,ones(1,8)*3];

% extract features
syn_used = syn_off_nor; % select for syn_off_nor or syn_on_nor
num_win = size(syn_used,3); 
num_trial = size(syn_used,4); 
num_peo = size(syn_used,5); 
fea_all = [];
for ip = 1:num_peo
   % trial iteration
   fea_trial = [];
   for it = 1:num_trial
       % extract dynamic matrices of one trial
       matrix_dynamic = syn_used(:,:,:,it,ip);

       fea_dynamic = [];
       for iw = 1:num_win
           % extract one matrix
           matrix_one = matrix_dynamic(:,:,iw);
           loc_negative = find(matrix_one<0);
           matrix_one_negative = zeros(size(matrix_one));
           matrix_one_negative(loc_negative) = abs(matrix_one(loc_negative));
           
           % calculate global and local efficiency
           ge = efficiency_wei(matrix_one_negative);
           ge_loc = efficiency_wei(matrix_one_negative,2);
           ge_loc1 = mean(ge_loc(signal_index==1)); % "1": PFC
           ge_loc2 = mean(ge_loc(signal_index==2)); % "2": PMC
           ge_loc3 = mean(ge_loc(signal_index==3)); % "3": S1

           fea_dynamic = [fea_dynamic;ge ge_loc1 ge_loc2 ge_loc3];
       end

       % dynamic features
       num_f = size(fea_dynamic,2); 
       fead = [];fa = [];
       for ifd = 1:num_f
           value_column = fea_dynamic(:,ifd);
           fea_var = var(value_column);
           fea_peak = max(value_column);
           fead = [fead fea_var fea_peak];
       end
       fea_trial = [fea_trial;fead];
   end
   fea_trial_mean = mean(fea_trial);
   fea_all = [fea_all;fea_trial_mean];
end


