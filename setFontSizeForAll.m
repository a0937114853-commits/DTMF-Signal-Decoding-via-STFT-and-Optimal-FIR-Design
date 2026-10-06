% function h=setFontSizeForAll() change text font size in all axes of all
% figures, because Linux size default 10 looks too small.
% Last Updated: Nov. 13, 2016
function setFontSizeForAll(s)
h = get(0,'children');
numFigs = length(h);
for ff = 1:numFigs
    g = get(h(ff),'children');
    numAxes = length(g);
    for aa = 1:numAxes
        if isfield(get(g(aa)),'FontSize'); % updated Nov. 13, 2016
            set(g(aa),'FontSize',s);
        end
        if isfield(g(aa),'xlabel'),
            hx = get(g(aa),'xlabel');
            set(hx,'Fontsize',s+2);
            hy = get(g(aa),'ylabel');
            set(hy,'Fontsize',s+2);
        end
        if isfield(g(aa),'title');
            ht = get(g(aa),'title');
            set(ht,'Fontsize',s+2);
        end
    end
end
return