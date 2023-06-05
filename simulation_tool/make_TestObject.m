function [TO] = make_TestObject(opt, k_traj)

TO.opt = opt;

%% Ground truth k-space data
% This exists because certain shapes (e.g. circles, ellipses, etc. have an
% analytical Fourier transform)

% (a) Sampled for intended, non-cartesian trajectory

% Get exact k-space data of test object with Test trajectory:
TO.noncart.ksp = ...
    sampleDiscKSpace(TO.opt,'kpos',[k_traj.k_x k_traj.k_y]);

    % Display data for QA:
    % plot_test_obj(TO.noncart.ksp, "ksp", opt, k_traj,"dark","presentation")

% (b) Sampled for hypothetical cartesian trajectory - required for ground
%     truth estimation

% Cartesian Imaging Grid Definition - CONCEPT Eqivalent is <<make_CRT>>
geom_TestObj_cart = imaging_makeCartesian(TO.opt);

% Sampling Locations in image-space
% also required for Fourier Encoding
% "isocentre" will be at the opt.n_x/2+1 index
[TO.opt.x_coords_2D, TO.opt.y_coords_2D] = ndgrid(geom_TestObj_cart.x, geom_TestObj_cart.y);

TO.opt.x_coords = TO.opt.x_coords_2D(:);
TO.opt.y_coords = TO.opt.y_coords_2D(:);

% % Temp reversal:
% temp_x = reshape(test_object.opt.x_coords,  [numel(geom_TestObj_cart.x), numel(geom_TestObj_cart.y)]);
% temp_y = reshape(test_object.opt.y_coords,  [numel(geom_TestObj_cart.x), numel(geom_TestObj_cart.y)]);

% Sampling Locations in k-sapce
[TO.opt.k_x, TO.opt.k_y] = ndgrid(geom_TestObj_cart.kx, geom_TestObj_cart.ky);

TO.opt.k_x = TO.opt.k_x(:);
TO.opt.k_y = TO.opt.k_y(:);
TO.opt.ptCol = ones(size(TO.opt.k_x));

TO.cart.ksp = sampleDiscKSpace(TO.opt,'kpos',[TO.opt.k_x, TO.opt.k_y]);

%     % Display data:
%     plot_test_obj(test_object.phantom_ksp_cart, "ksp", test_object.opt,"dark","presentation")

%     % Display helper cartesian k-space trajectory:
%     plotKTraj(test_object.opt)
%     
%% "Ground truth" image space data - as sampled on CARTESIAN grid

% It ~estimates~ the "ground truth" by reconstructing cartesian sampled analytical 
% k-space data of <<test_object>> specifications

TO.cart.image_2DFT = imaging_fft2(reshape(TO.cart.ksp, [TO.opt.n_x, TO.opt.n_y])); 
TO.cart.image = calc_groundtruth_object(TO);



% This could be improved by having exact image space data for cartesian
% grid, e.g. for circle:
% test_object.phantom_image = (double(((xidx - opt_TestObj.centre(1)).^2 + (yidx - opt_TestObj.centre(2)).^2)<=opt_TestObj.radius.^2))/(2*pi);

    % % Display data:
    % plot_test_obj(TO.cart.image, [], opt, TO.opt,"dark","presentation")


%% Prepare return test object
TO.cart.opt = TO.opt;
TO.cart.ksp = TO.cart.ksp;
TO.cart.image = TO.cart.image(:);

TO.noncart.ksp = TO.noncart.ksp;
TO.noncart.opt = k_traj;

end