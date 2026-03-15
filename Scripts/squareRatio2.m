% function to plot squares around ratios
function squareRatio2(maxN,maxk,mkr,c,sz,l_sz)
gcf;

if maxk < 1 && maxk > 0.5
    y = maxk;
    nw_y = maxk-0.02;
elseif maxk < 0.5
    y = maxk+(maxk*.05);
    nw_y = maxk;
elseif maxk > 100
    y = maxk+25;
    nw_y = maxk+1;
else
    y = maxk+0.25;
    nw_y = maxk;
end

for ii=1:maxN
    for jj=1:maxN
        if (ii==jj)&&(ii~=1)
            continue
        end
       
        if ii+jj>5
            continue
        end
        v=[ii,jj];
        v=v/sum(v)*1; %get coordinates for proportions

        if min(v)>0.1
            hold all
            rat=v(1);
            msg=sprintf('%d:%d',ii,jj);
            %plot(rat,y,'sk');
            text(rat,y,msg,'Color','k','HorizontalAlignment','center',...
                'VerticalAlignment','middle','EdgeColor','k','FontSize',sz); %write proprtions on graph
            plot([rat rat],[0 nw_y],mkr, 'Color',c,'MarkerSize',9,'LineWidth',l_sz)
            %xlim([0 1])
        end
    end
end

end