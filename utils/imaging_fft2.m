% fft2 with shifts for MRI

function [out] = imaging_fft2(in)

if numel(size(in))~=2, error('Expect 2D input.'), end

out = fftshift(fftshift(fft2(fftshift(fftshift(in,1),2)),1),2);
