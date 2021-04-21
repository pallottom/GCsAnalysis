

clear all
filename=  [{'data161120_13'},{'data211020_11'},{'data151020_8'},{'data171120_7'},{'data161020_22'}]
    %MC: [{'data141020_21.mat'}, {'data180321_25.mat'},{'data201120_15.mat'},{'data121120_12'},...
    %{'data111120_23.mat'}, {'data220620_15.mat'},{'data101120_15.mat'}]...
    %TC: [{'data161120_13'},{'data211020_11'},{'data151020_8'},{'data220620_5'},{'data161020_22'}]
    
for file=1:size(filename,2)
    clear data
   load (filename{file});

for exp=1:size(data.p,1)

    for plane=1:size(data.p, 2)
       plane_sum(plane)=sum(data.p{exp,plane}<0.001);
    end 
    exp_sum(exp)=sum(plane_sum);
end

 [~,I]=max(exp_sum)
 
 
select_data.info{file,:}=data.info
select_data.dff{file,:}={data.dff{I,:}}
select_data.p{file,:}={data.p{I,:}}
select_data.AUC{file,:}={data.AUC{I,:}}
select_data.agecode{file,:}={data.agecode{:,:}}

end

save(['MC_data.mat'], 'select_data' ) % change name MC or TC!!!




