function syn_used_nor = get_normalization(syn_used,control_mean,control_std)
% get_syn_normalization   Matrix normalization
%
% The matrix was normalized by z-score normalization
%
%  Inputs:
%      syn_used: input matirx
%      control_mean: mean matrix
%      control_std: std matrix
%
%  Outputs:
%      syn_used_nor: normalized matrix
syn_used_nor = zeros(size(syn_used));
for ip = 1:size(syn_used,5)
    for it = 1:size(syn_used,4)
        for iw = 1:size(syn_used,3)
            temp = syn_used(:,:,iw,it,ip);
            temp = (temp-control_mean)./control_std;
            for ic1 = 1:size(temp,1)
                temp(ic1,ic1) = 0;
            end
            syn_used_nor(:,:,iw,it,ip) = temp;

        end
    end
end

end