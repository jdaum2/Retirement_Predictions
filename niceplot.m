%   NICEPLOT creates a very nice looking plot
% varargin options
% 'l' - legend (cell array)
% 'p' - legend placement (string, 'nw', 'ne', 'sw', 'se')
% 'f' - fontsize (scalar)
% 'w' - linewidth (.5, 1)
% 'g' - grid ('pff')
% 'xa' - x axis limits (2 element array)
% 'ya' - y axis limits (2 element array)
% 'axes' - x and y limits (4 element array)
% 's' - plot symbol and color (string, 'rx' 'b.')
% 'e' - export as jpg to current dir as filename (string, filename)
% 'cp' - copy to clipboard (scalar, 1)
% 'h' - hold
% 'c' - color
% 'a' - annotate
%
%   [figure_handle] = niceplot(xdata, ydata, xlabel, ylabel, title, varargin)
% creats a nice looking plot with predetermined fontweights, grids, etc.
% Use options to change fontsweight, linewidth, etc.
%
%   Input:  xdata, ydata, xlabel, ylabel, plottitle, varargin
%
%   Output: function handle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Jared Daum (NASA-JSC)
%   Date:   12/06/13
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Updates:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ figure_handle plot_handle] = NICEPLOT( xdata, ydata, labelx, labely, plottitle, varargin )
% close all
% % default params
gridon='on';
fontweighttitle = 'bold';
fontweightlabel = 'bold';
fontsizetitle = 18;
fontsizelabel = 14;
linewidth = 2;
onlegend = 0;
custx = 0;
custy = 0;
custall = 0;
% symbol =[];
fontnametitle ='garamond';
fontnamelabel = 'garamond';
symbol='b-';
export = 0;
copy = 0;
legend_location = 'best';
annotate=1;
annotationstr = 'Jared Daum';
color = 'b';
hold_on = 0;
subscale_wind = 0;

for i=1:2:length(varargin)
    if varargin{i} == 'l'
        onlegend = 1;
        legendcontent = varargin{i+1};
        
        
    elseif varargin{i} == 'f'
        fontweighttitle = varargin{i+1};
        
        
    elseif min(varargin{i} == 'w')
        linewidth = varargin{i+1};
        
        
    elseif varargin{i} == 'g'
        grigon = varargin{i+1};
        
    elseif varargin{i} == 'a'
        if varargin{i+1} == 0
            annotate = 0;
        elseif varargin{i+1}
            annotationstr = varargin{i+1};
        end
        
    elseif varargin{i} == 'p'
        legend_location = varargin{i+1};
        
    elseif varargin{i} == 'h'
        hold_on = varargin{i+1};
        
    elseif varargin{i} == 'c'
        color = varargin{i+1};
        
    elseif varargin{i} == 's'
        symbol = varargin{i+1};
        
        
    elseif varargin{i} == 'e'
        export = varargin{i+1};
    elseif varargin{i} == 'xa'
        custx = 1;
        xlimits = varargin{i+1};
        
        
    elseif varargin{i} == 'ya'
        custy=1;
        ylimits = varargin{i+1};
        
        
        
        
        
        
    elseif varargin{i} == 'cp'
        copy = 1;
        
        
        
    elseif varargin{i} == 'ws'
        subscale_wind = varargin{i+1};
        
        
        
    elseif varargin{i} == 'axes'
        custall=1;
        alllimits = varargin{i+1};
        
    end
    
end

if hold_on
    figure_handle = gcf;
    hold on
else
    %     close all
    figure_handle = figure;
end

if nargin == 1
    plot_handle = plot(xdata,color,'linewidth',linewidth);
else
    plot_handle = plot(xdata,ydata,symbol,'linewidth',linewidth);
    xlabel(inputname(1), 'fontsize', fontsizelabel,'interpreter','none', 'fontWeight', fontweightlabel, 'fontname', fontnamelabel);
    ylabel(inputname(2),'fontsize', fontsizelabel,'interpreter','none', 'fontweight', fontweightlabel, 'fontname', fontnamelabel);
    title([inputname(1) ' vs. ' inputname(2)],'fontsize', fontsizetitle,'interpreter','none', 'fontweight', fontweighttitle, 'fontname', fontnametitle);
end



if nargin > 2
    xlabel(labelx, 'fontsize', fontsizelabel, 'fontWeight', fontweightlabel, 'fontname', fontnamelabel);
    ylabel(labely,'fontsize', fontsizelabel, 'fontweight', fontweightlabel, 'fontname', fontnamelabel);
end

if nargin > 4
    title(plottitle,'fontsize', fontsizetitle, 'fontweight', fontweighttitle, 'fontname', fontnametitle);
end

grid(gridon);

if onlegend
    legend(legendcontent,'Location',legend_location);
end


if custx
    set(gca,'XLim', xlimits);
end

if custy
    set(gca,'YLim', ylimits);
end

if custall
    axes(alllimits)
end

set(gca, ...
    'Box'         , 'off'     , ...
    'XMinorTick'  , 'on'      , ...
    'YMinorTick'  , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XGrid'       , 'off'     , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'Layer'       , 'bottom'     , ...
    'Tickdir'     , 'out'     , ...
    'LineWidth'   , 1         );

set(gcf, ...
    'Color'       , [.9 .9 .9]);
box on

if annotate
    annotation('Textbox',[.8 .067 1 0],'String',{annotationstr; datestr(clock)},'edgecolor','none')
end

if subscale_wind
    set(gca, 'XTickLabel',{'North (0)','East (90)','South (180)','West (270)','North (0)','East (90)','South (180)'}, 'XTick',1:540/6:540);
end

if export
    saveas(gcf, export, 'jpg')
    saveas(gcf, export, 'fig')
end

if copy
    editmenufcn(gcf,'EditCopyFigure');
end



end








