%% Apply fid to test object
% Carina Graf
% University of Cambridge
% June 2022
% 
% Applies fid signal modulation to a 2D test object!
%
% Theoretical Basis:
% Input Objects:
% - Ground Truth Items:
%   - 1D test_object in image-space, sampled on *cartesian* grid
%   - 1D test_object in k-space, sampled with *non-cartesian* trajectory
%	- 1D FID simulation with hypothetical 
%       - T2,
%       - delta_omeg, &
%       - relative magnitude 
%
% The FID simulation uses the timing for the non-cartesian k-Trajectory and
% thus only exists for
function [test_object] = apply_fid(test_object, ...
                                   fid)

% Test Input:
% test_object = test_object_multi(1);         % struct with various cartesian and non-cartesian image and k-space information
% fid         = fid.overall;                  % vector with fid-decay modulation for each non-cartesian point.
% k_Traj      = k_Traj;                       % non-cartesian k-space trajectory, includes spatial and temporal information
% 
% clearvars -except test_object fid k_Traj;

%% Apply fid-modulation to non-cartesian k-space test-object

test_object.noncart.ksp_fid_modulated = test_object.noncart.ksp .* fid.signal;

%% Apply fid-modulation to cartesian image test-object (aka Groundtruth)

test_object.cart.image_fid_modulated = repmat(test_object.cart.image, 1, test_object.noncart.opt.opt.sampling_factor);

spectral_axes = calc_ppm_axis(test_object.noncart.opt.opt);
timings = spectral_axes.timeAxis;

fid_combined        = exp(-timings./fid.opt.T2) ...
    .* exp(-2i*pi*fid.opt.delta_omeg.*timings) ...
    .* ones(size(timings))*fid.opt.M0;

spec_combined = fftshift(fft(fid_combined));

% Apply fid modulation to groundtruth data:
for idf = 1:numel(timings)
    test_object.cart.image_fid_modulated(:,idf) = test_object.cart.image * spec_combined(idf);
end

% test_object.cart.image_fid_modulated = 
% repmat(TO_multi(obj_idx).cart.image

% 
% FID_decay = fid_overall;
% 
% test_object.phantom_image_FID = ...
%     single(...
%         repmat(test_object.phantom_image, 1, 1, numel(FID_decay))...
%            );
% 
% % This is the tricky thing: Timings for FID are from the non-cartesian
% % Trajectory, so this adatopn is WRONG!
% % Requirement: Use timings of hypotehtical cartesian Trajectory.
% % (sequential EPSI like) 
% test_object.phantom_ksp_cart_FID = ...
%     single(...
%         repmat(...
%             reshape(test_object.phantom_ksp_cart, [test_object.opt.n_x, test_object.opt.n_y]), ...
%                1, 1, numel(FID_decay)...
%                ) ...
%            );
% 
% test_object.phantom_ksp_noncart_FID = ...
%     single(...
%         repmat(test_object.phantom_ksp_noncart, ...
%                 1, numel(FID_decay)...
%                ) ...
%            );
% 
% for tIdx = 1:numel(FID_decay)
%     
%     % Apply FID Modulation in image-space
%     test_object.phantom_image_FID(:,:,tIdx) = ...
%         test_object.phantom_image .* FID_decay(tIdx);
%     
%     % Apply FID Modulation in k-space:
%     test_object.phantom_ksp_cart_FID(:,:,tIdx) = ...
%         test_object.phantom_ksp_cart_FID(:,:,tIdx) .* FID_decay(tIdx);
% 
%     % Apply FID Modulation in non-cartesian trajectory!
%     test_object.phantom_ksp_noncart_FID(:,tIdx) = ...
%         test_object.phantom_ksp_noncart_FID(:,tIdx) .* FID_decay(tIdx);
% 
% end
% 
% plot_object_fid_sim(test_object,k_Traj,plot_loc)
% 
% % prepare return variables:
% test_object;
% % end