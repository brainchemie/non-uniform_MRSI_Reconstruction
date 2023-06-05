% Dark Mode for Figure:

function dark_figure()

background_color = 0.2 *[1, 1, 1]; % dark grey
font_color = 1 * [1, 1, 1]; % white

% Get figure objects:
fig_axes = findobj(gcf, 'type','Axes');
fig_colorbar = findobj(gcf, 'type','ColorBar');
fig_tiles = findobj(gcf, 'type','TiledLayout');
fig_legend = findobj(gcf, 'type', 'Legend');

% Change Background Color
% Axes
for axIdx = 1:numel(fig_axes)
    fig_axes(axIdx).Color = background_color;
end

% Figure Background
set(gcf, 'Color', background_color);

% Change Font Colors
% Axes
for axIdx = 1:numel(fig_axes)
    fig_axes(axIdx).XColor = font_color;
    fig_axes(axIdx).YColor = font_color;
    fig_axes(axIdx).ZColor = font_color;
    fig_axes(axIdx).Title.Color = font_color;
end

% Colobar
if ~isempty(fig_colorbar)
    for axIdx = 1:numel(fig_colorbar)
        fig_colorbar(axIdx).Color = font_color;
    end
end

% Tiled Titles/Axes
if ~isempty(fig_tiles)
    for axIdx = 1:numel(fig_tiles)
        fig_tiles(axIdx).XLabel.Color = font_color;
        fig_tiles(axIdx).YLabel.Color = font_color;
        %     fig_tiles(axIdx).ZLabel.Color = font_color;
        fig_tiles(axIdx).Title.Color = font_color;
    end
end

% Legend
if ~isempty(fig_legend)
    for axIdx = 1:numel(fig_legend)
        fig_legend(axIdx).TextColor = font_color;
        fig_legend(axIdx).EdgeColor = font_color;
        fig_legend(axIdx).Color = background_color;
    end
end

end