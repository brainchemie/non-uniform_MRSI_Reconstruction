function [k_CRT] = make_CRT( CRT_opt ) %...
    %n_circles, r_min, r_max, radial_density, n_theta, theta_multiple, angular_density, time_dependency, sampling_factor)
% make_CRT(varargin)

%% Check input variables
% Unpack input structure
unpackStruct(CRT_opt)

% N_k [int]: number of k-space points sampled in total
% To be included later

% n_circles [int]: number of 
if ~isint(n_circles)
    warning("n_circles needs to be integer, rounding input to closest integer.")
    n_circles = round(n_circles);
end

% n_theta [int]: number of pts per circle, if constant. [default 2^5];

if ~isint(n_theta)
    warning("n_circles needs to be integer, using default 2^5.")
    n_theta = 2^5;
end

if ~isint(theta_multiple)
    warning("n_circles needs to be integer, using default 2^6.")
    theta_multiple = 2^6;
end

if ~isint(sampling_factor)
    warning("sampling_factor needs to be integer, using default 1.")
    sampling_factor = 1;
end

try
   include_centre;
catch
   include_centre = false;
end

% radial & angular density [str]: describes density pattern of radii angular used.
%   Options include 
%  (1) "constant"
%  (2) "linear"
%  (3) "exponential"
% N.B. if angular density is constant, a radial-like k-space trajectory is
% created. 

if ~any(strcmp(radial_density,["constant", "exponential"]))
    warning("Radial density is undefined, using constant as default")
    radial_density = "constant";
end

if ~any(strcmp(angular_density,["constant", "linear", "exponential"]))
    warning("Angular density is undefined, using constant as default")
    angular_density = "constant";
end

if ~islogical(time_dependency)
    warning("time_dependency must be specified as logical, using false as default")
    time_dependency = false;
end

%% Make k-trajectory

% get radius spacing
if radial_density == "constant"
    radius_list = linspace(r_min, r_max, n_circles);
elseif radial_density == "exponential"
    radius_list = logspace(log10(r_min), log10(r_max), n_circles);
end

% Add centre of k-space:
if include_centre
    % Required for overall image color
    n_circles   = n_circles + 1;
    
    if radial_density == "constant"
        radius_list = linspace(0, r_max, n_circles);
    elseif radial_density == "exponential"
        radius_list = logspace(log10(r_min), log10(r_max), n_circles-1);
        radius_list = [0, radius_list];
    end

end


% get angular spacing parameters
N_THETA = n_theta;
THETA_MULTIPLE = theta_multiple;

angle_list = [];
time_list = [];

n_theta_max = THETA_MULTIPLE * radius_list(end);

if angular_density == "constant" % makes a radial like trajectory
    angle_list = linspace(0,2*pi,N_THETA + 1);
    time_list = linspace(0,interleaved_dwell_time,N_THETA + 1);

    % remove duplicate at 0, 2*pi
    angle_list = angle_list(1:end-1);
    time_list = time_list(1:end-1);

    % repeat angle_list with number of circles
    angle_list = repmat(angle_list,n_circles,1);
    time_list = repmat(time_list,n_circles,1);
    
    % Add unique point IDs.
    % this will be an integer matrix with looking like this:
    % [1, 2, 3, 4, ..... numel(angle_list);...
    %  numel(angle_list)+1, numel(angle_list)+2,...;...
    % .
    % .
    % .;
    % ...,size(angle_list,2)*n_circles)]

    pt_ID_list = 1:(size(angle_list,2)*n_circles);
    pt_ID_list = reshape(pt_ID_list,size(angle_list));

elseif angular_density == "linear"  % number of points increases linearly with radius

    angle_list = nan(n_circles, n_theta_max);
    time_list  = nan(n_circles, n_theta_max);
    pt_ID_list = nan(n_circles, n_theta_max);

    for radius_idx = 1:n_circles
        angles_temp = linspace(0, 2*pi, THETA_MULTIPLE * radius_list(radius_idx) + 1);
        time_temp = linspace(0, interleaved_dwell_time, THETA_MULTIPLE * radius_list(radius_idx) + 1);
        
        % remove duplicate point at 0, 2*pi
        if numel(angles_temp) >= 2
            angle_list_temp = angles_temp(1:end-1);
            time_list_temp = time_temp(1:end-1);
        else
            angle_list_temp = angles_temp;
            time_list_temp = time_temp;
        end

        
        pt_temp_start = max(pt_ID_list,[],'all','omitnan') + 1;
        if isnan(pt_temp_start)
            pt_temp_start = 1;
        end
        pt_ID_temp = pt_temp_start:(pt_temp_start+numel(angle_list_temp)-1);
        
        % add to full list of angles
        angle_list(radius_idx,1:numel(angle_list_temp)) = angle_list_temp;
        time_list(radius_idx,1:numel(time_list_temp)) = time_list_temp;
        pt_ID_list(radius_idx,1:numel(pt_ID_temp)) = pt_ID_temp;
        
        % angle_list(end+1:end+numel(angle_list_temp)) = angle_list_temp;

        % ptCol(end+1:end+numel(angle_list_temp)) = radius_idx;
    end

end

% Create  unique point indices:
% Effectively, each non-NaN angle from angle_list will get a unique index!
% pt_ID_list = nan(n_circles, n_theta_max);
% for radius_idx = 1:n_circles
% pt_temp_start = max(pt_ID_list,[],'all','omitnan') + 1;
%         if isnan(pt_temp_start)
%             pt_temp_start = 1;
%         end
%         pt_ID_temp = pt_temp_start:(pt_temp_start+numel(angle_list_temp)-1);
% 
%         pt_ID_list(radius_idx,1:numel(pt_ID_temp)) = pt_ID_temp;
% end
% pt_ID_list = nan(size(angle_list));
% pt_ID_list(angle_list(~isnan(angle_list))) = 1:numel(angle_list(~isnan(angle_list)));

% Create Theoretical Trajectory
k_x         = nan(size(angle_list, 2), n_circles);
k_y         = nan(size(angle_list, 2), n_circles);
k_z         = nan(size(angle_list, 2), n_circles); % Placeholder for future
t           = nan(size(angle_list, 2), n_circles);
pt_ID       = nan(size(angle_list, 2), n_circles);
ptCol       = nan(size(angle_list, 2), n_circles);


k_x     = transpose(times(cos(angle_list), radius_list')); 
k_y     = transpose(times(sin(angle_list), radius_list'));


pt_ID   = transpose(pt_ID_list);
t       = transpose(time_list);

% Make categorical list of 
angle_list_bin = double(~isnan(angle_list));
angle_list_bin(angle_list_bin == 0) = NaN;
ptCol = transpose(times(angle_list_bin, radius_list'));


if sampling_factor ~= 1
    for idx = 1:n_circles

        k_x_single_ring = k_x(:,idx);
        k_y_single_ring = k_y(:,idx);
        t_single_ring = t(:,idx);
        ptCol_single_ring = ptCol(:,idx);
        pt_ID_single_ring = pt_ID(:,idx);

        k_x_multi(:,:,idx)      = repmat(k_x_single_ring,   1, sampling_factor);
        k_y_multi(:,:,idx)      = repmat(k_y_single_ring,   1, sampling_factor);
        t_multi(:,:,idx)        = repmat(t_single_ring,     1, sampling_factor);
        pt_col_multi(:,:,idx)   = repmat(ptCol_single_ring, 1, sampling_factor);
        pt_ID_multi(:,:,idx)    = repmat(pt_ID_single_ring, 1, sampling_factor);
    end

    k_x     = reshape(k_x_multi,    size(angle_list, 2) , n_circles * sampling_factor);
    k_y     = reshape(k_y_multi,    size(angle_list, 2) , n_circles * sampling_factor);
    t       = reshape(t_multi,      size(angle_list, 2) , n_circles * sampling_factor);
    pt_ID   = reshape(pt_ID_multi,  size(angle_list, 2) , n_circles * sampling_factor);
    ptCol   = reshape(pt_col_multi, size(angle_list, 2) , n_circles * sampling_factor);
end

% edit sampling timing:
% Goal : each ring is sampled within the same time limit. the full time
% limit is given by:
% interleaved_dwell_time * sampling_factor

for r_idx = 1:numel(radius_list)

    t_temp = linspace(0, interleaved_dwell_time * sampling_factor, numel(t(ptCol == radius_list(r_idx))) + 1);
    
    % Remove final point so that spacing is equivalent:
    t_temp = t_temp(1:end-1);

    t(ptCol == radius_list(r_idx)) = t_temp;
end
  
   
% find number of k-space point pairs
n_pts = numel(k_x) - sum(isnan(k_x),'all');

% for idx = 1:n_circles
%     k_x(:,idx) = radius_list(idx) .* cos(angle_list);
%     k_y(:,idx) = radius_list(idx) .* sin(angle_list);
% end

k_x = k_x(:);
k_y = k_y(:);
t   = t(:);
ptCol = ptCol(:);
pt_ID = pt_ID(:);

k_x     = k_x(~isnan(k_x))';        k_x     = transpose(k_x);
k_y     = k_y(~isnan(k_y))';        k_y     = transpose(k_y);
k_z     = zeros(size(k_y)); % Matching dimensions for placeholder
t       = t(~isnan(t))'     ;       t       = transpose(t);
ptCol   = ptCol(~isnan(ptCol))';    ptCol   = transpose(ptCol);
pt_ID   = pt_ID(~isnan(pt_ID))';    pt_ID   = transpose(pt_ID);

% %% Add time-dependency
% % TBC
% if time_dependency == false
%     t = [];
% else
%     t = linspace(0,n_pts-1, n_pts)/n_pts;
%     t = reshape(t, size(k_x));
% end

%% Prepare return struct
k_CRT = struct(...
    'k_x', k_x,...
    'k_y', k_y,...
    'k_z', k_z,...
    't', t,...
    'ptCol', ptCol,...
    'pt_ID', pt_ID,...
    'test_point_ID', test_point_ID,...
    'opt', CRT_opt);

%% Plot trajectory
% plotKTraj(k_CRT)

end