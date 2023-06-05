% Generate analytical k-space samples for disc of defined radius and centre.
function [ksp_exact, imagesp_exact] = sampleDiscKSpace(varargin)

opt = processVarargin(varargin{:});

%add some noise to the signals
error = 0.000;
ksp_error = zeros(size(opt.kpos)) + error*randn(size(opt.kpos)); %add what ever error in k-space position from ramp up times etc.
ksp = opt.kpos + ksp_error;

% figure(303);scatter(ksp(:,1),ksp(:,2),5,'filled');axis square;grid on
% xlabel('k_x');ylabel('k_y');title('k-space Sampling Locations with instrument error');drawnow;

if ~isfield(opt,'centre') || numel(opt.centre) ~= 2
    error('centre must be a 2D position vector.')
end
opt.centre = reshape(opt.centre,1,2);

if ~isfield(opt,'radius') || numel(opt.radius) ~= 1
    error('radius must be a scalar.')
end

if ~isfield(opt,'kpos') || numel(size(opt.kpos)) ~= 2 || size(opt.kpos,2) ~= 2
    error('kpos must be an Nk x 2 vector filled with positions (kx,ky).')
end

% See Mathematica derivation for a unit disc.
% k = besselj(1,kr)/kr where kr is the k-space radius: kr^2 = kx^2+ky^2
if opt.shape == "square"
    ksp_exact = sinc(ksp(:,1)*10).*sinc(ksp(:,2)*10);
elseif opt.shape == "ellipse"
    % find by changing variables of integration (effectively just a rescaling)
    alpha=1;
    beta=alpha/opt.ratio;
    newx = cosd(opt.angle)*ksp(:,1) - sind(opt.angle)*ksp(:,2);
    newy = sind(opt.angle)*ksp(:,1) + cosd(opt.angle)*ksp(:,2);
    kr = sqrt((newx/alpha).^2 + (newy/beta).^2);
    ksp_exact = alpha*beta*besselj(1,(kr*opt.radius*2*pi))./(kr*opt.radius*2*pi) * opt.radius^2;
    ksp_exact(kr==0) = 0.5 * opt.radius^2; % Zero limit fixup.
else
    kr = sqrt(ksp(:,1).^2 + ksp(:,2).^2);
    ksp_exact = besselj(1,(kr*opt.radius*2*pi))./(kr*opt.radius*2*pi) * opt.radius^2;
    ksp_exact(kr==0) = 0.5 * opt.radius^2; % Zero limit fixup.
end

% Shift to required location
% ksp_exact = ksp_exact .* exp(-2i * pi * ksp * opt.centre.');
ksp_exact = ksp_exact .* exp(2i * pi * ksp * opt.centre.'); % Sign Convention

% figure;  imagesc(abs(reshape(ksp_exact,opt.n_x,opt.n_x))); 
% title(["analyitcal k-space of ", opt.shape]);
% axis square
% set(gca,'YTickLabel',[]);
% set(gca,'XTickLabel',[]);
% colorbar
