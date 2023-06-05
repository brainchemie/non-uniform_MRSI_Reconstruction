function I = pt_Idx(x_pt, y_pt, x_coords, y_coords)

% finds the index of the nearest neighbouring point to given coordinates
% (x_pt, y_pt)

comb_array = [];
comb_array(:,1) = x_coords - x_pt;
comb_array(:,2) = y_coords - y_pt;

[~,I] = min(sum(abs(comb_array),2));