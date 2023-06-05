%% Example Trajectories for the Abstract presented as:
% "Simulation tool for non-Fourier MRSI reconstruction" #2407
% by Carina Graf and Christopher T Rodgers
% University of Cambridge, UK
%
% Presented at ISMRM 2023, Toronto, Canada

%% Add dependencies
addpath(genpath(pwd))

%% Test Object Parameters:

opt_TO = struct(...
    ... % Parameters of each "Test Tube" or "Phantom"
    'name'          ,   ["water"    ;       "fat"], ......
    'centre'        ,   [-12, 8     ;       16, 4], ... 
    'radius'        ,   [15         ;           6],...
    'ratio'         ,   [0.5        ;         0.8],...
    'angle'         ,   [15         ;          45],...
    'shape'         ,   ["ellipse"  ;   "ellipse"],...
    'T2'            ,   [0.150       ;       0.20], ...           % list of hypothetical T2 in [s] for respective 
    'delta_omeg'    ,   [0.001      ;         500], ...           % list of hypothetical off-resonance frequency [Hz]
    'M0'            ,   [100      ;         40]...             % list of hypothetical magntiduce differences....
    ); 

opt_recon = struct(...
    ... % Geometry of reconstructed image space 
    'pixelSpacing_x',   1,...
    'pixelSpacing_y',   1,...
    'n_x'           ,  64,...
    'n_y'           ,  64 ...,
    );

%% CASE 1: Equidistant, DENSE
name = 'equidistant_dense';

opt_CRT = struct(...
    'n_circles'         , 32, ... %32 number of circles (not including centre if applicable)
    'include_centre'    , true, ... % Adds central point of k-space to trajectory (default: false)
    'r_min'             , 0.01, ...
    'r_max'             , 0.5, ...
    'radial_density'    , "constant",... % "exponential", "constant"; TBC: "hamming" 
    'angular_density'   , "constant",... % "constant","linear", "exponential" ... %CAV CLV
    'time_dependency'   , true, ...
    'interleaved_dwell_time'        , 360E-06, ... % time to complete a single full circle trajectory
    'n_theta'           , 2^6,.........2^5, ...
    'theta_multiple'    , 2^10, ...
    'sampling_factor'   , 50, ...
    'test_point_ID'     , 64);


k_Traj = make_CRT(opt_CRT);
[TO, ~] = make_multi_freq_test_object(opt_TO, opt_recon, k_Traj);

try
    save(['.\sim_objects\', name, '.mat'], "k_Traj", "TO")
catch
    mkdir 'sim_objects'
    save(['.\sim_objects\', name, '.mat'], "k_Traj", "TO")
end

plotKTraj_quick(k_Traj)
plot_groundtruth(TO, k_Traj)

% ========================================================================
%% CASE 2: Equidistant, Sparse
name = 'equidistant_sparse';

opt_CRT = struct(...
    'n_circles'         , 8, ... %32 number of circles (not including centre if applicable)
    'include_centre'    , true, ... % Adds central point of k-space to trajectory (default: false)
    'r_min'             , 0.01, ...
    'r_max'             , 0.5, ...
    'radial_density'    , "constant",... % "exponential", "constant"; TBC: "hamming" 
    'angular_density'   , "constant",... % "constant","linear", "exponential" ... %CAV CLV
    'time_dependency'   , true, ...
    'interleaved_dwell_time'        , 360E-06, ... % time to complete a single full circle trajectory
    'n_theta'           , 2^6,.........2^5, ...
    'theta_multiple'    , 2^10, ...
    'sampling_factor'   , 50, ...
    'test_point_ID'     , 64);


k_Traj = make_CRT(opt_CRT);
[TO, ~] = make_multi_freq_test_object(opt_TO, opt_recon, k_Traj);
save(['sim_objects\', name, '.mat'], "k_Traj", "TO")

plotKTraj_quick(k_Traj)
plot_groundtruth(TO, k_Traj)







% ========================================================================
%% CASE 3: DW, Dense

name = 'DW_dense';

opt_CRT = struct(...
    'n_circles'         , 32, ... %32 number of circles (not including centre if applicable)
    'include_centre'    , true, ... % Adds central point of k-space to trajectory (default: false)
    'r_min'             , 0.01, ...
    'r_max'             , 0.5, ...
    'radial_density'    , "exponential",... % "exponential", "constant"; TBC: "hamming" 
    'angular_density'   , "constant",... % "constant","linear", "exponential" ... %CAV CLV
    'time_dependency'   , true, ...
    'interleaved_dwell_time'        , 360E-06, ... % time to complete a single full circle trajectory
    'n_theta'           , 2^6,.........2^5, ...
    'theta_multiple'    , 2^10, ...
    'sampling_factor'   , 50, ...
    'test_point_ID'     , 64);


k_Traj = make_CRT(opt_CRT);
[TO, ~] = make_multi_freq_test_object(opt_TO, opt_recon, k_Traj);
save(['sim_objects\', name, '.mat'], "k_Traj", "TO")

plotKTraj_quick(k_Traj)
plot_groundtruth(TO, k_Traj)









% ========================================================================
%% CASE 4: DW, Sparse

name = 'DW_sparse';

opt_CRT = struct(...
    'n_circles'         , 8, ... %32 number of circles (not including centre if applicable)
    'include_centre'    , true, ... % Adds central point of k-space to trajectory (default: false)
    'r_min'             , 0.01, ...
    'r_max'             , 0.5, ...
    'radial_density'    , "exponential",... % "exponential", "constant"; TBC: "hamming" 
    'angular_density'   , "constant",... % "constant","linear", "exponential" ... %CAV CLV
    'time_dependency'   , true, ...
    'interleaved_dwell_time'        , 360E-06, ... % time to complete a single full circle trajectory
    'n_theta'           , 2^6,.........2^5, ...
    'theta_multiple'    , 2^10, ...
    'sampling_factor'   , 50, ...
    'test_point_ID'     , 64);


k_Traj = make_CRT(opt_CRT);
[TO, ~] = make_multi_freq_test_object(opt_TO, opt_recon, k_Traj);
save(['sim_objects\', name, '.mat'], "k_Traj", "TO")

plotKTraj_quick(k_Traj)
plot_groundtruth(TO, k_Traj)











% ========================================================================

%% CASE 5: Constant Density Weighting (angular frequency)


name = 'constant_high_linearang';

opt_CRT = struct(...
    'n_circles'         , 32, ... %32 number of circles (not including centre if applicable)
    'include_centre'    , true, ... % Adds central point of k-space to trajectory (default: false)
    'r_min'             , 0.01, ...
    'r_max'             , 0.5, ...
    'radial_density'    , "constant",... % "exponential", "constant"; TBC: "hamming" 
    'angular_density'   , "linear",... % "constant","linear", "exponential" ... %CAV CLV
    'time_dependency'   , true, ...
    'interleaved_dwell_time'        , 360E-06, ... % time to complete a single full circle trajectory
    'n_theta'           , 2^6,.........2^5, ...
    'theta_multiple'    , 2^10, ...
    'sampling_factor'   , 50, ...
    'test_point_ID'     , 64);


k_Traj = make_CRT(opt_CRT);
[TO, ~] = make_multi_freq_test_object(opt_TO, opt_recon, k_Traj);
save(['sim_objects\', name, '.mat'], "k_Traj", "TO")

plotKTraj_quick(k_Traj)
plot_groundtruth(TO, k_Traj)











% ========================================================================