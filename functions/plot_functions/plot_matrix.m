function plot_matrix(data_mat,net_label,net_order,half_flag)
% This function is used to plot the nodal-level matrix.
% input:
%       data_mat:  N*N matrix;
%       net_label: N*1 label, the value range from 1 to M, 
%                  M is the number of networks;
%       net_order: M*1, the order of networks, e,g., [1,2,3.....,M];
%       half_flag: 0 [default], plot the full matrix;
%                  1 ,plot the lower triangle of the matrix.

% plot the orignal data matrix without reorder
if ~exist('net_label','var')
    
    data_reorder = data_mat;
    data_dim = size(data_reorder);
    data_reorder(1:data_dim(1)+1:end) = max(data_reorder(:));
    figure;
    imagesc(data_reorder);

% plot the reorder data matrix based on the net_order 
else
    if exist('net_order','var')
        order = net_order;
    else
        order = [1 2 3 4 6 7]; % 1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN
    end
    
    % reorder the data matrix
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
    
    % plot the lower triangle of the matrix
    if exist('half_flag','var') && half_flag == 1
        figure;
        imagesc(tril(data_reorder));
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
        imagesc(data_reorder);
        hold on;
        line_end = lines(end)-0.5;
        for j = 2:length(lines) % draw lines dividing network
            line([0.5,line_end],[lines(j)-0.5,lines(j)-0.5],'Color','black','Linewidth',0.5);
            line([lines(j)-0.5,lines(j)-0.5],[0.5,line_end],'Color','black','Linewidth',0.5);
        end
        line([0.5,line_end],[0.5,0.5],'Color','black','Linewidth',0.5);    
    end
    
end

data_vec = mat2vec(data_reorder)';
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
