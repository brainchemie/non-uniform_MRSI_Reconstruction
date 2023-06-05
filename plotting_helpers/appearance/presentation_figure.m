function presentation_figure(varargin)

textsize = 15;

% Get figure objects:
fig_axes = findobj(gcf, 'type','Axes');
fig_colorbar = findobj(gcf, 'type','ColorBar');
fig_tiles = findobj(gcf, 'type','TiledLayout');
fig_legend = findobj(gcf, 'type', 'Legend');

% Change Background Color
% Axes
for axIdx = 1:numel(fig_axes)
    fig_axes(axIdx).FontSize = textsize;
end

% % Figure Background
% set(gcf, 'Color', background_color);

% Change Font Colors
% Axes
for axIdx = 1:numel(fig_axes)
    fig_axes(axIdx).FontSize = textsize;
end

% Colobar
if ~isempty(fig_colorbar)
    for axIdx = 1:numel(fig_colorbar)
        fig_colorbar(axIdx).FontSize = 0.8*textsize;

    end
end

% Tiled Titles/Axes
if ~isempty(fig_tiles)
    for axIdx = 1:numel(fig_tiles)
        fig_tiles(axIdx).XLabel.FontSize = textsize;
        fig_tiles(axIdx).YLabel.FontSize = textsize;
        %     fig_tiles(axIdx).ZLabel.Color = font_color;
        fig_tiles(axIdx).Title.FontSize = 1.2*textsize;
    end
    fig_tiles.Title.FontSize = 1.5*textsize;
    fig_tiles.Title.FontWeight = 'bold';
end

% Legend
if ~isempty(fig_legend)
    for axIdx = 1:numel(fig_legend)
        fig_legend(axIdx).FontSize = 0.8*textsize;
    end
end

end

