function spectral_axes = calc_ppm_axis(opt_kTraj)


% Snippet directly from Spectro.Spec in Oxsa

%         tmp = size(spectral_axes.spectra{coilDx},1)/2;
%         spectral_axes.dwellTime = info{1}.csa.RealDwellTime*1e-9;
%         spectral_axes.bandwidth = 1/spectral_axes.dwellTime;
%         spectral_axes.imagingFrequency = info{1}.csa.ImagingFrequency;
%         spectral_axes.samples = size(spectral_axes.spectra{1},1);
%
%         % In Hz
%         spectral_axes.freqAxis = ((-tmp):(tmp-1)).'/(spectral_axes.dwellTime*tmp*2);
%
%         % In ppm
%         spectral_axes.ppmAxis = spectral_axes.freqAxis / spectral_axes.imagingFrequency;
%
%         % In s
%         spectral_axes.timeAxis = spectral_axes.dwellTime*(0:spectral_axes.samples-1).';

tmp = opt_kTraj.sampling_factor/2;

spectral_axes.dwellTime = opt_kTraj.interleaved_dwell_time;
spectral_axes.bandwidth = 1/spectral_axes.dwellTime;
spectral_axes.imagingFrequency = 300E06;
spectral_axes.samples = opt_kTraj.sampling_factor;

% In Hz
spectral_axes.freqAxis = ((-tmp):(tmp-1)).'/(spectral_axes.dwellTime*tmp*2);

% In ppm
spectral_axes.ppmAxis = spectral_axes.freqAxis / spectral_axes.imagingFrequency;

% In s
spectral_axes.timeAxis = spectral_axes.dwellTime*(0:spectral_axes.samples-1).';


end

