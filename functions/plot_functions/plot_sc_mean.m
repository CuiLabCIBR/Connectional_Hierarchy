function [data_mat_mean,net_edges] = plot_sc_mean(data_mat,net_label,net_order,half_flag)
% This function is used to plot the network-avearged sc matrix.
% input:
%       data_mat:  N*N matrix;
%       net_label: N*1 label, the value range from 1 to M, 
%                  M is the number of networks;
%       net_order: M*1, the order of networks, e,g., [1,2,3.....,M];
%       half_flag: 0 [default], plot the full matrix;
%                  1 ,plot the lower triangle of the matrix.
% output:
%       data_mat_mean: N*M matrix, network averaged matrix.
%       net_edges: M*M cell matrix which stores edges within and between networks.

%% reorder the network
t = [];
start = 1;
lines = 1;
mask = net_label;

for i = 1:length(net_order)
    add = find(mask==net_order(i));
    t = [t;add];
    start = start + length(add);
    lines(i+1) = start;
end

data_reorder = data_mat(t,t);

%% get the network-averaged values
line_num = length(lines);
idx_begin = lines(1:line_num-1);
idx_end = lines(2:line_num)-1;
data_reorder_mean = data_reorder;

for i = 1:line_num-1
   for j = 1:line_num-1
       data_temp = data_reorder(idx_begin(i):idx_end(i),idx_begin(j):idx_end(j));
       if i == j
           data_temp = mat2vec(data_temp);
       end
       data_temp = data_temp(:);
       data_temp = log(data_temp(data_temp > 0));
       data_mat_mean(i,j) = mean(data_temp);
       net_edges{i,j} = data_temp;
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

load('cmap.mat','cmap')
colormap(cmap); 

set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
box off
axis square;

set(gcf, 'units', 'inches', 'position', [0, 0, 5, 5], 'PaperUnits', 'inches', 'PaperSize', [5, 5])