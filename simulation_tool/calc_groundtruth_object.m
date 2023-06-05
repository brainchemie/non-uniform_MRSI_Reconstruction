%% Groundtruth Ellipses
function TO_ground_truth = calc_groundtruth_object(TO)
% Based on Shepp-Logan phantom definition
% [P,E] = phantom(64);
% figure; imshow(P)

% Ellipses that define the phantom, specified as an e-by-6 numeric matrix
% defining e ellipses.
% The six columns of E are the ellipse parameters.

% Column   | Parameter |             Meaning
% ----------------------------------------------------------------------------------
% Column 1 | A         | Additive intensity value of the ellipse
% Column 2 | a         | Length of the horizontal semiaxis of the ellipse
% Column 3 | b         | Length of the vertical semiaxis of the ellipse
% Column 4 | x0        | x-coordinate of the center of the ellipse
% Column 5 | y0        | y-coordinate of the center of the ellipse
% Column 6 | phi       | Angle (in degrees) between the horizontal semiaxis of the ellipse and the x-axis of the image

% !The domains for the x- and y-axes are [-1,1]. Columns 2 through 5 must
% be specified in terms of this range!

% Sample Input:
% opt_TO = struct(...
%     ... % Parameters of each "Test Tube" or "Phantom"
%     'centre'        ,[12, 15], ... % Object Centre
%     'radius'        ,[19],...
%     'ratio'         ,[0.3],...
%     'angle'         ,[50],...
%     'shape'         ,["ellipse"],...
%     'name'          ,["water"], ...
%     'T2'            ,[0.150], ...         % list of hypothetical T2 in [s] for respective 
%     'delta_omeg'    ,[100.00], ...         % list of hypothetical off-resonance frequency [Hz]
%     'M0'            ,[0.99] ...,          % list of hypothetical magntiduce differences.
%     );           
% 
% opt_recon = struct(...
%     ... % Geometry of reconstructed image space 
%     'pixelSpacing_x',   1,...
%     'pixelSpacing_y',   1,...
%     'n_x'           ,  64,...
%     'n_y'           ,  64 ...,
%     );
% 
% mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]);
% opt_combined = mergestructs(opt_TO,opt_recon);
% 
% TO = make_TestObject(opt_combined, k_Traj);


% Transform into <<phantom>> coordinate domain:
x_scale = 2/(TO.opt.n_x * TO.opt.pixelSpacing_x);
y_scale = 2/(TO.opt.n_y * TO.opt.pixelSpacing_y);

A       = TO.opt.M0;
a       = TO.opt.radius * x_scale * TO.opt.ratio;
b       = TO.opt.radius * y_scale ;
x0      = TO.opt.centre(1,1) * x_scale;
y0      = TO.opt.centre(1,2) * y_scale;
phi     = 90 - TO.opt.angle;

E2 = [A, a, b, x0, y0, phi];
TO_ground_truth = phantom(E2,TO.opt.n_x*4);
TO_ground_truth = imresize(TO_ground_truth,1/4,'bilinear');

% CG QUICK FIX WITH DIMENSIONALITY
TO_ground_truth = permute(TO_ground_truth, [2,1]);
TO_ground_truth = fliplr(TO_ground_truth);
TO_ground_truth = circshift(circshift(TO_ground_truth,1,1),1,2);

% QA FIGURES
% plot_recon_comparison(TO_ground_truth(:), TO.cart.image_2DFT,TO.opt,"dark")
% figure;
% tiledlayout("flow")
% nexttile
% imshow(phantom(E2,64))
% nexttile
% imshow(abs(reshape(TO.cart.image,[64,64])))