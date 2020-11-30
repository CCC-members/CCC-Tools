function fig_out = merge_figures(fig_name, fig_title, figures_path)
fig_out = figure('Name', fig_name, 'NumberTitle', 'off', 'Position', [200,500,750,150]);
axis off
title(fig_title);
clear title;
for i=1:length(figures_path)
    h(i)=subplot(1,length(figures_path),i);
    axis off
    handle=hgload(figures_path{i});
    title_obj = get(gca,'title');
    clear title;
    title_str = title_obj.String;
    copyobj(allchild(get(handle,'CurrentAxes')),h(i));
    close(handle);
    title(title_str);
end
color_map   = load('mycolormap.mat');
cmap_a      = color_map.cmap_a;
colormap(cmap_a)
end

