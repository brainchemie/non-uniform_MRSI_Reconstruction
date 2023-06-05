% Set up x,y and kx,ky grid that is consistent for CONCEPT MRI.
function [out] = imaging_makeCONCEPT(varargin)

% Reference: Haacke, 1999, Chapter 13.

opt = processVarargin(varargin{:});

if ~isfield(opt,'n_x')
    error('You must specify the resolution n_x along x-axis.')
end

if ~isfield(opt,'n_y')
    error('You must specify the resolution n_y along y-axis.')
end

if mod(opt.n_x,2) ~= 0 || mod(opt.n_y,2) ~= 0
    error('Resolution must be an even number.')
end

if ~isfield(opt,'pixelSpacing_x')
    error('You must specify pixel spacing along x-axis.')
end

if ~isfield(opt,'pixelSpacing_y')
    error('You must specify pixel spacing along y-axis.')
end

% Page 268. Periodicity must be x --> x + 1/\Delta k are identical.
% So Eq 13.6: \Delta k = 1 / L (FOV)
% So Eq 13.8 follows: \Delta x = L (FOV) / N (num pixels)
%                             = 1 / (N * \Delta k)
out.x = ((-opt.n_x/2):(opt.n_x/2 -1)) * opt.pixelSpacing_x;
out.y = ((-opt.n_y/2):(opt.n_y/2 -1)) * opt.pixelSpacing_y;

Delta_kx = 1 / (opt.n_x * opt.pixelSpacing_x);
Delta_ky = 1 / (opt.n_y * opt.pixelSpacing_y);

out.kx = ((-opt.n_x/2):(opt.n_x/2 -1)) * Delta_kx;
out.ky = ((-opt.n_y/2):(opt.n_y/2 -1)) * Delta_ky;
