% SPATIAL LOCATION


%create a table with the active cells

code=1 %1=PN, 2=jAB, 3=mAB
n_bins= 20 %define number of bins
f=512/n_bins
my_map_active= zeros(n_bins,n_bins,6, size(select_data.info,1));
my_map_total= zeros (n_bins,n_bins,6, size(select_data.info,1));


% Matrix with ALL the cells
for exp=1:size(select_data.info,1)
for plane=1:6

my_p=find(select_data.agecode{exp,1}{1,plane}>=code) 
%find(select_data.agecode{exp,1}{1,plane}==code)  %select cell from CODE and pValue
if size(my_p,1)~=0
xy= round(select_data.coordinates.centers{exp,1}{1,plane}(my_p,:)/f)
xy(xy==0)= 1;
for i=1:size(xy,1)
my_map_total(xy(i,1),xy(i,2),plane,exp)=my_map_total(xy(i,1),xy(i,2),1)+1;
end
end

end
end

%Plot spatial location all cells

figure; 
imagesc(sum(sum(my_map_total,4),3))
colorbar


%Matrix with ACTIVE CELLS
for exp=1:size(select_data.info,1)
for plane=1:6

my_p=find(select_data.p{exp,1}{1,plane}<0.001  ...
    & select_data.agecode{exp,1}{1,plane}==code ...
    )  %select cell from CODE and pValue
if size(my_p,1)~=0
xy= round(select_data.coordinates.centers{exp,1}{1,plane}(my_p,:)/f)
xy(xy==0)= 1;
for i=1:size(xy,1)
my_map_active(xy(i,1),xy(i,2),plane,exp)=my_map_active(xy(i,1),xy(i,2),1)+1;
end
end

end
end


final_map= sum(sum(my_map_active,4),3)./sum(sum(my_map_total,4),3)


figure; 
tiledlayout(1, 3)
nexttile([1, 1])
plot(nansum(final_map,2), 'color', 'k')
view([-90 90])
nexttile(2,[1,2])
imagesc(final_map)
axis square;




hold on
imagesc(nansum(nansum(my_map_total,4),3), 'AlphaData', .1)
c=colormap(hot)

colormapeditor
