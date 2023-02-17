function data_mat_mean = plot_matrix_mean(data_mat,net_label,net_order,half_flag)
% This function is used to plot the network-avearged matrix.
% input:
%       data_mat:  N*N matrix;
%       net_label: N*1 label, the value range from 1 to M, 
%                  M is the number of networks;
%       net_order: M*1, the order of networks, e,g., [1,2,3.....,M];
%       half_flag: 0 [default], plot the full matrix;
%                  1 ,plot the lower triangle of the matrix.
% output:
%       data_mat_mean: N*M matrix, network averaged matrix.

%%
if exist('net_order','var')
    order = net_order;
else
    order = [1 2 3 4 6 7]; %1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN
end

%% reorder the network
t = [];
start = 1;
lines = 1;
mask = net_label;

for i = 1:length(order)
    add = find(mask==order(i));
    t = [t;add];
    start = start + length(add);
    lines(i+1) = start;
end

data_reorder = data_mat(t,t);
data_dim = size(data_reorder);
data_reorder(1:data_dim(1)+1:end) = max(data_reorder(:));

%% get the network-averaged values
idx_begin = lines(1:end-1);
idx_end = lines(2:end)-1;
data_reorder_mean = data_reorder;

for i = 1:length(lines)-1
   for j = 1:length(lines)-1
       data_temp = data_reorder(idx_begin(i):idx_end(i),idx_begin(j):idx_end(j));
       if i == j
           data_temp = convet_matrix_to_vector(data_temp);
       end
       data_temp = data_temp(:);
       data_mat_mean(i,j) = mean(data_temp);
       data_reorder_mean(idx_begin(i):idx_end(i),idx_begin(j):idx_end(j)) = data_mat_mean(i,j);
   end
end

%% plot the matrix
% plot the lower triangle of the matrix
if exist('half_flag','var') && half_flag == 1
    figure;
    imagesc(tril(data_reorder_mean));
    hold on;
    line_end = lines(end)-0.5;
    for j = 2:length(lines)
        line_num = lines(j)-0.5;
        line([0.5,line_num],[line_num,line_num],'Color','black','Linewidth',0.5);
        line([line_num,line_num],[line_num,line_end],'Color','black','Linewidth',0.5);
    end
    line([0.5,line_end],[0.5,line_end],'Color','black','Linewidth',0.5);
% plot the full matrix
else
    figure;
    imagesc(data_reorder_mean);
    hold on;
    line_end = lines(end)-0.5;
    for j = 2:length(lines) % draw lines dividing network
        line([0.5,line_end],[lines(j)-0.5,lines(j)-0.5],'Color','black','Linewidth',0.5);
        line([lines(j)-0.5,lines(j)-0.5],[0.5,line_end],'Color','black','Linewidth',0.5);
    end
    line([0.5,line_end],[0.5,0.5],'Color','black','Linewidth',0.5);    
end

data_vec = mat2vec(data_reorder_mean)';
data_min = min(data_vec);
data_max = max(data_vec);
caxis([data_min,data_max])

load('cmap.mat','cmap')
colormap(cmap); 

set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
box off
axis square;

set(gcf, 'units', 'inches', 'position', [0, 0, 5, 5], 'PaperUnits', 'inches', 'PaperSize', [5, 5])