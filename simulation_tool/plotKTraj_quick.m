function plotKTraj(k_Traj, varargin)

unpackStruct(k_Traj)

if numel(size(k_x))~=2 || size(k_x,2)~=1
    error('k_x must be a column vector.')
end

if numel(size(k_y))~=2 || size(k_y,2)~=1 || any(size(k_x) ~= size(k_y))
    error('k_y must be a column vector same size as k_x.')
end

if numel(size(ptCol))~=2 || size(ptCol,2)~=1 || any(size(k_x) ~= size(ptCol))
    error('ptCol must be a column vector same size as k_x.')
end

if exist('test_point_ID','var')
    unique_ID = test_point_ID;         % Specific (k_x,k_y) point to be highlighted
else
    warning('Requires a specifc pt_ID to plot, using pt_ID = 1.')
    unique_ID = 1;
end

% Add markers on repeated (k_x, k_y) pairs
% Make up ptIDs if non-existent
if exist('pt_ID','var') == 0
    pt_ID = 1:numel(k_x);
    warning('Requires a pt_ID array to plot.')
end

ptColUnique = unique(ptCol);
N = numel(ptColUnique);

% make masks to avoid repetitive comparisons:
for pt_ID_idx = 1:numel(unique_ID)
    ID_mask(:,pt_ID_idx) =  (pt_ID == unique_ID(pt_ID_idx));
end

% Plotting acceleration to avoid need of for-loops for each excitation
% make color masks to avoid repetitive comparisons:
% New Solution:
% Use point colours in advance to define cmap used by <<scatter>>.
% Step 1: find unique ptCol and number of unique ptCol
% => Done, this is currently a n(kx,ky) x N(uniquePtCol) binary matrix
% Step 2: get enough unique RGB triplets, for discrete data, I use
% Step 3: assign each unique ptCol an RGB triplet

cmap_unique = tab10(N);
cmap_full = zeros(size(ptCol, 1), 3);

for color_idx = 1:N
    color_mask(:,color_idx) = (ptCol == ptColUnique(color_idx));
    cmap_full(color_mask(:,color_idx),:) = ...
        repmat(cmap_unique(color_idx,:), ...
               sum(color_mask(:,color_idx),"all"),1);
end


%% Set up Figure Layout
figure; clf;

set(gcf, 'Visible', 'off');

% if exist('t','var') ~= 0 && any(t)
%     set(gcf, 'Position', [182,712,1693,420])
%     t_layout = tiledlayout(1,3);
% else
    set(gcf, 'Position', [182,712,435,420])
    t_layout = tiledlayout(1,1);
% end

t_layout.Padding = "tight";
t_layout.TileSpacing = "tight";

%% Plot k_x vs k_y
ax(1) = nexttile;
set(ax(1),'DefaultAxesColorOrder',tab10(N))

hold all

% This old code snippet took very long to plot, and wasn't efficient as it
% had to be repeated for the plots further down below, too.
% for colDx=1:N
%     plot(k_x(color_mask(:,colDx)), ...
%         k_y(color_mask(:,colDx)), ...
%         '.-')    
% end

% cmap = jet(length(k_x)); % Make 1000 colors.

scatter(k_x, k_y, 5, cmap_full, 'filled')

xlabel("k_x"); ylabel("k_y");
axis square; grid on; grid minor;

% Colour Order
pt_marker = repmat(["mx"; "y+"; "g*"], 100, 1);

% Highlight individual unique (kx, ky) points
% for pt_ID_idx = 1:numel(unique_ID)
% 
%     plot(k_x(ID_mask(:,pt_ID_idx)), k_y(ID_mask(:,pt_ID_idx)),...
%         pt_marker(pt_ID_idx),...
%         'MarkerSize',15,...
%         'LineWidth',2);
% end

hold off;

% %% Add a temporal information where applicable
% if exist('t','var') ~= 0 && any(t,'all')
% 
%     % add timecourse view
%     ax(2) = nexttile;
% 
%     set(ax(2),'DefaultAxesColorOrder',tab10(N))
%     
%     hold all 
% %     for colDx=1:numel(ptColUnique)
% %         x_temp = t(color_mask(:,colDx));
% %         y_temp = k_y(color_mask(:,colDx));
% % 
% %         plot(x_temp, y_temp,'x--');
% %     end
%     
%     scatter(t, k_y, 5, cmap_full, 'filled')
% 
%     xlabel("time (s)"); ylabel("k_y");
% %   xlim([min(x_temp), max(x_temp)]);
%     grid on; grid minor;
%      
% 
%     % Add markers on repeated (k_x, k_y) pairs
%     for pt_ID_idx = 1:numel(unique_ID)
% 
%         plot(t(ID_mask(:,pt_ID_idx)), ...
%             k_y(ID_mask(:,pt_ID_idx)),...
%             pt_marker(pt_ID_idx),...
%             'MarkerSize',15,...
%             'LineWidth',2);
%     end
% 
%     % Crop time-axis for display purposes.
%     sampling_factor = sum(pt_ID == 1);
%     N_PERIODS = 5;
% 
%     if sampling_factor > N_PERIODS
%         x_t_max = max(t) * N_PERIODS/sampling_factor;
%         xlim([0, x_t_max])
%     end
% 
%     hold off;
% 
%     % Add timing course:
%     ax(3) = nexttile();
% 
%     set(ax(3),'DefaultAxesColorOrder',tab10(N))
% 
%     id_len = 1:numel(t);
%     
%     hold all 
%     scatter(id_len, t, 3,cmap_full,'filled')
%     
%     xlabel("ADC (pts)")
%     ylabel("readout timing (s)");
% 
%     % Add markers on repeated (k_x, k_y) pairs
%     for pt_ID_idx = 1:numel(unique_ID)
% 
%         plot(id_len(ID_mask(:,pt_ID_idx)), ...
%             t(ID_mask(:,pt_ID_idx)),...
%             pt_marker(pt_ID_idx),...
%             'MarkerSize',15,...
%             'LineWidth',2);
%     end
% 
%     xlim([min(id_len), max(id_len)*1.05])
%     ylim([min(t,[],'all'), max(t,[],'all')])
% 
% end

dark_figure();
presentation_figure();

set(gcf, 'Visible', 'on')

end