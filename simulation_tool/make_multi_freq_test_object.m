%% Make a multi-frequency test_objet inlucding fid and k-trajectory simulation
% Carina Graf
% University of Cambridge
% July 2022
%
% Combines
% - an arbitrary k_Trajectory with
% - parameters for test object (TO): <<make_TestObject>>
% - and simulates <<simulate_fid>> with opt_fid parameters
%   multi-frequency
%
%
% Sample input:
% (1) Parameters of each "Test Tube" or "Phantom"
%     Note: All individual "phantoms" entries are separated by a semi-colon (";")
%
%  opt_TO = struct(...
% ...% TO-geometry
%     'name'           ,["water" ;     "fat" ], ...    
%     'centre'         ,[-12,8   ;     -12,8 ], ...        % 1st & 2nd centre
%     'radius'         ,[15      ;       15  ], ...
%     'ratio'          ,[0.5     ;        0.5], ...
%     'angle'          ,[15      ;       15  ], ...
%     'shape'          ,["circle";   "circle"], ...
% ... % TO- FID simulation parameters
%     'T2'             ,[inf     ;        inf], ...       % list of hypothetical T2 in [s] for respective 
%     'delta_omeg'     ,[0       ;       10  ], ...       % list of hypothetical off-resonance frequency [Hz]
%     'M0'             ,[1       ;        0.8]); ...,     % list of hypothetical magnitude differences. 
%
% (2) Image parameters for reconstructed image
% opt_recon = struct(...
%     'pixelSpacing_x',    1,  ...
%     'pixelSpacing_y',    1,  ...
%     'n_x'           ,   64,  ...
%     'n_y'           ,   64); ...,
%
% (3) Arbitrary k-space trajectory as struct generated e.g. with
%     <<make_CRT>> or <<make_CSI>.
% k_Traj = struct(...
%   k_x, ...           % single column vector, size N_ADC x 1  
%   k_y, ...           % single column vector, size N_ADC x 1  
%   k_z, ...           % single column vector, size N_ADC x 1
%   t, ...             % single column vector, size N_ADC x 1
%   ptID, ...          % single column vector, size N_ADC x 1         
%   ptCol, ...         % single column vector, size N_ADC x 1 
%   test_point_ID, ... % single column vector, size n_test_point x 1 
%   opt);              % struct with all parameters used for simulating k_Traj
%   
%
function [TO_combined, TO_multi] = make_multi_freq_test_object(opt_TO, opt_recon, k_Traj)

%% Prepare multi-frequency object for <<disk-kspace>>:
% Find number of individual test elements:
% This must be equal for all opt_TO fieldnames:

multi_params = ["centre", "radius", "ratio", "angle", "shape", ...
    "T2", "delta_omeg", "M0", "name"];

image_params = ["pixelSpacing_x", "pixelSpacing_y", "n_x", "n_y"];

% Concatenate structures:
mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]);
opt_combined = mergestructs(opt_TO,opt_recon);

% Test all options are complete
for multi_IDx = 1:numel(multi_params)
    opt_sizes(multi_IDx) = size(opt_combined.(multi_params(multi_IDx)),1);
end

n_objects = unique(opt_sizes);

% if numel(n_objects) > 1
%     error("Test Error Message")
% end

% Initialise simulation objects
opt_TO_multi    = struct();
fid_multi       = struct();

for obj_idx = 1:n_objects

    %% Prepare test object parameters/options
    %
    % Allocate individual frequency parameters
    for multi_IDx = 1:numel(multi_params)
        opt_TO_multi(obj_idx).(multi_params(multi_IDx)) ...
            = opt_combined.(multi_params(multi_IDx))(obj_idx,:);
    end
    
    % Duplicate image recon parameters
    for img_idx = 1:numel(image_params)
        opt_TO_multi(obj_idx).(image_params(img_idx)) ...
            = opt_combined.(image_params(img_idx));
    end

    %% Make individual test objects
    [TO_multi(obj_idx)] = make_TestObject(opt_TO_multi(obj_idx), k_Traj);

%         % *QA*: Save figures and info to .md:
%         destination = fullfile(pwd, 'daily_reports');
%         print_struct_params(destination, opt_TO_multi(obj_idx), ['Test Object Parameters ', num2str(obj_idx)])
%     
%         temp_figures = findobj('Type','figure');
%         for idx = 1:numel(temp_figures)
%             add_figure_to_report(destination, temp_figures(idx));
%             pause(2)
%         end
%     
%         close all

    %% Simulate individual FIDs:
    [fid_multi(obj_idx).overall, fid_ind] = simulate_fid(k_Traj, opt_TO_multi(obj_idx));
        
%         % *QA*: Save figures and info to .md:
%         print_struct_params(destination, opt_TO_multi(obj_idx), ['FID Simulation Parameters ', num2str(obj_idx)])
%         temp_figures = findobj('Type','figure');
%         for idx = 1:numel(temp_figures)
%             add_figure_to_report(destination, temp_figures(idx));
%             pause(2)
%         end
%     
%         close all
    
    %% Apply FIDs to respective Test Objects:
    [TO_multi(obj_idx)] = apply_fid(TO_multi(obj_idx), ...
                                                    fid_multi(obj_idx).overall);

end

%% Combine data of Test Objects:
TO_combined = TO_multi(1);

TO_combined.noncart.ksp_fid_modulated = zeros(size(TO_multi(1).noncart.ksp_fid_modulated));
TO_combined.cart.image_fid_modulated = complex(zeros(size(TO_multi(1).cart.image_fid_modulated)));

for obj_idx = 1:n_objects
    % non-cart - k-space data
    TO_combined.noncart.ksp_fid_modulated = ...
        TO_combined.noncart.ksp_fid_modulated ...
        + TO_multi(obj_idx).noncart.ksp_fid_modulated;
    
    % cart - "Ground Truth" image space data:
    TO_combined.cart.image_fid_modulated = TO_combined.cart.image_fid_modulated ...
        + TO_multi(obj_idx).cart.image_fid_modulated;

end

TO_combined.cart.image_fid_modulated = fliplr(TO_combined.cart.image_fid_modulated);
    
end