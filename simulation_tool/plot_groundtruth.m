function plot_groundtruth(TO, k_Traj)

ptIdx(1) = pt_Idx(-12, 8, TO.cart.opt.x_coords, TO.cart.opt.y_coords); % Centre water
ptIdx(2) = 46*25; % Random Point
ptIdx(3) = pt_Idx(-6, 0, TO.cart.opt.x_coords, TO.cart.opt.y_coords); % Edge Water
ptIdx(4) = pt_Idx(16, 4, TO.cart.opt.x_coords, TO.cart.opt.y_coords); % Center Fat

spectral_axes = calc_ppm_axis(k_Traj.opt);
limits = [0, 120];

figure; clf; cla;
set(gcf, 'Visible', 'off')
tiledlayout("flow",'TileSpacing','compact','Padding','compact')

%----------------------GROUNDTRUTH________________________
nexttile
hold on
scatter(TO.cart.opt.x_coords, ...
    TO.cart.opt.y_coords,...
    [],...
    abs(max(TO.cart.image_fid_modulated,[],2)),...
    'filled',...
    'Marker','square',...
    'SeriesIndex',5);
colormap(viridis); colorbar;

for idx = 1:numel(ptIdx)
    plot(TO.cart.opt.x_coords(ptIdx(idx)),TO.cart.opt.y_coords(ptIdx(idx)),'x',...
    'MarkerSize',25,...
    'LineWidth',5)
end

%set(gca,'ColorOrder',tab10(numel(ptIdx)))

title("MIP - Groundtruth")
xlabel("x"); ylabel("y")
axis square; xlim tight; ylim tight; box on;
% caxiss(limits)
hold off

nexttile
hold on

plot(spectral_axes.freqAxis, abs(TO.cart.image_fid_modulated(ptIdx,:)),...
    'LineWidth',1.5)
xlabel("Frequency (Hz)")
set(gca,'Color','none')
%set(gca,'ColorOrder',tab10(numel(ptIdx)))
legend(sprintf("voxel (%d, %d)",TO.cart.opt.x_coords(ptIdx(1)), TO.cart.opt.y_coords(ptIdx(1))),...
    sprintf("voxel (%d, %d)",TO.cart.opt.x_coords(ptIdx(2)), TO.cart.opt.y_coords(ptIdx(2))),...
    sprintf("voxel (%d, %d)",TO.cart.opt.x_coords(ptIdx(3)), TO.cart.opt.y_coords(ptIdx(3))),...
    sprintf("voxel (%d, %d)",TO.cart.opt.x_coords(ptIdx(4)), TO.cart.opt.y_coords(ptIdx(4))));
hold off

presentation_figure()
dark_figure()

set(gcf, 'Visible', 'on')