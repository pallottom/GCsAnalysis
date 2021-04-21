% RATIO Active/Total GGs


table=zeros(size(select_data.p, 1),3);


for exp=1:size(select_data.p, 1) %experiment
    for code= 1:3 % age code
        temp= zeros(6,1);
        for plane=1:6 % plane
        temp(plane)=sum((select_data.agecode{exp,1}{1,plane}==code & select_data.p{exp,1}{1,plane}<0.001))/...
            sum((select_data.agecode{exp,1}{1,plane}==code))
        end
        table(exp, code)= mean(temp,1);
    end
end


figure;
bar(nanmean(table, 1))
hold on
plot([1,2,3], table, '*', 'color','k')
hold on
vec=[1,2,3];
for i=1:7
    temp=~isnan(table(i,:));
    plot(vec(temp),table(i,temp), 'color', 'k') 
    hold on
    clear temp
end


