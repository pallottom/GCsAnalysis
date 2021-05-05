% SPATIAL DISTRIBUTION

figure;
xy=[]
color_code={'g','y','r'}

for code=1:3
%Matrix with ACTIVE CELLS
for exp=1:size(select_data.info,1)
for plane=1:6
my_p=find(select_data.p{exp,1}{1,plane}<0.001  ...
    & select_data.agecode{exp,1}{1,plane}==code)  
if size(my_p,1)~=0
xy=[select_data.coordinates.centers{exp,1}{1,plane}(my_p,:)]
plot(xy(:,1),xy(:,2), '*', 'color',color_code{code})
set(gca,'Color',[0.4 0.4 0.4])
hold on
end
end
end
end
xlabel('um')
ylabel('distance to MCL (um)')




figure;
xy=[]
color_code={'g','y','r'}

color_code={'b','c'}

for code=1:3
%Matrix with ACTIVE CELLS
for exp=1:size(select_data.info,1)
for plane=1:6
my_p=find(select_data.p{exp,1}{1,plane}<0.001  ...
    & select_data.agecode{exp,1}{1,plane}>=code)  
if size(my_p,1)~=0
xy=[xy;select_data.coordinates.centers{exp,1}{1,plane}(my_p,:)]
end
end
end
[y,x]=hist(xy(:,2),20)
plot(x*0.5859,y,'color','c','LineWidth', 2)
hold on
xy=[];
end
xlabel('distance from MCL (um)')
ylabel('GCs Number')
legend('MC', 'TC'),'mAB')
