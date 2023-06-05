% 
function [fid_overall, fid] = simulate_fid(k_Traj, opt_fid, varargin)

% Test input
% Check if k_Traj is time dependent.

if isempty(k_Traj.t)
    error('k-Trajectory must be time dependant.')
end

% Check equal number of elements for T2, off_res and magnitude:
if numel(unique([numel(opt_fid.T2), ...
        numel(opt_fid.delta_omeg),...
        numel(opt_fid.M0)]))...,
        ~= 1
    error('opt_fid needs equivalent length of items for T2, delta_omeg and magnitude')
end

fid = struct(...
    'opt', opt_fid);

fid_overall.signal = complex(zeros([size(k_Traj.t,1), 1]));


fid_fields = ["decay", "freq_offset", "magnitude", "combined"];

% Compute signal modifications
for fidIdx = 1:numel(opt_fid.T2)
    fid(fidIdx).decay       = exp(-k_Traj.t./opt_fid.T2(fidIdx));
    fid(fidIdx).freq_offset = exp(-2i*pi*opt_fid.delta_omeg(fidIdx).*k_Traj.t);
    fid(fidIdx).magnitude   = ones(size(k_Traj.t))*opt_fid.M0(fidIdx);
    fid(fidIdx).combined    = fid(fidIdx).decay ...
                                .* fid(fidIdx).freq_offset ...
                                .* fid(fidIdx).magnitude;
    fid_overall.signal    = fid_overall.signal + fid(fidIdx).combined;
end

% fid_overall = sum(overall_temp, 2);

% Note:
% Use dbstop if error for debugging
fid_overall.opt = opt_fid;

% for QA
% plot_fid_sim(fid, fid_overall, opt_fid, k_Traj)
end
