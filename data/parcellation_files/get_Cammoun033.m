%
% This manuscript excluded the corpuscallosum from the Cammoun033 atlas,
% The default order is right_hemisphere followed by left_hemisphere.
% We moved regions in left hemispheres forward.
%

clear
clc

working_dir = 'F:\Cui_Lab\Projects\Connectional_Hierarchy\data\parcellation_files\';
cd(working_dir)
Yeo2011_7Networks = cifti_read('Yeo2011_7Networks_N1000.dlabel.nii');
Yeo2011_7Networks = Yeo2011_7Networks.cdata;
%% Lausanne-scale33 / DK68
L = gifti('atl-Cammoun2012_space-fslr32k_res-033_hemi-L_deterministic.label.gii');
L_label = L.labels;
L_label = L_label.name';
L_label([1,5]) = []; % remove corpuscallosum
for i = 1:34
    L_label{i} = ['L_' L_label{i}];
end

R = gifti('atl-Cammoun2012_space-fslr32k_res-033_hemi-R_deterministic.label.gii');
R_label = R.labels;
R_label = R_label.name';
R_label([1,5]) = []; % remove corpuscallosum
for i = 1:34
    R_label{i} = ['R_' R_label{i}];
end

Cammoun033_label = [L_label;R_label];
xlswrite('Cammoun033_label.xlsx',Cammoun033_label)
save('Cammoun033_label.mat','Cammoun033_label');
%%
L_cdata = L.cdata;
L_cdata(L_cdata == 4) = 0;
L_cdata(L_cdata > 4) = L_cdata(L_cdata > 4) - 1;

R_cdata = R.cdata;
R_cdata(R_cdata == 4) = 0;
R_cdata(R_cdata > 4) = R_cdata(R_cdata > 4) - 1;
R_cdata(R_cdata > 0) = R_cdata(R_cdata > 0) + 34;

Cammoun033 = [L_cdata;R_cdata];

for i = 1:68
    data_i = Yeo2011_7Networks(Cammoun033 == i);
    tbl = tabulate(data_i);
    [max_percent(i,1),max_idx] = max(tbl(:,3));
    net_label(i,1) = tbl(max_idx,1);
end

save('Cammoun033.mat','Cammoun033','net_label','max_percent');