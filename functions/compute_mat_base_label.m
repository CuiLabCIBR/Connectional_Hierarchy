function parcellated_data = compute_mat_base_label(data,label_range,label_vertex)
% This function is used to parcellate the surface bold data based on an given atlas.
% input:
%       data: N*T surface bold data, N is the vertex number, T is the timepoint number.
%       label_range: [0:M] vector, M is the roi number.
%       label_vertex: N*1 vector, the label of each vertex.
% output£º
%       parcellated_data: M*T bold data, the avearged bold signal of each roi.

parcellated_data = zeros(length(label_range),size(data,2));

for roi_i = 1:length(label_range)
    roi_idx = find(label_vertex==label_range(roi_i)); % get the index of region i.
    if label_range(roi_i) == 0
        parcellated_data(roi_i,:) = zeros(1,size(data,2));
    else
        parcellated_data(roi_i,:) = mean(data(roi_idx,:));
    end
end

