function [TOT_Table, SIGN_Table]  = summary_table(filename)
% CREAT SUMMARY TABLEs
% actully the data will be placed in an array 4x3, and not in a table
% TOTAL CELLS


for file=1:size(filename,2)
    clear select_data
   load (filename{file});
   
   %TOT CELLS
for exp=1:size(select_data.p,1)
    for plane=1:6
        code=1:3
    temp(code,plane, exp)= sum(select_data.agecode{exp,:}{:,plane}==code)  %Tot GCs
    end
end

TOT_Table(file, :)=sum(sum(temp,2),3)'


% STAT SIGN CELLS

for exp=1:size(select_data.p,1)
    for plane=1:6
        code=1:3
    temp(code,plane, exp)= sum(select_data.agecode{exp,:}{:,plane}==code &...
        select_data.p{exp,:}{:,plane}<0.001)  %ACTIVE GCs
    end
end

SIGN_Table(file, :)=sum(sum(temp,2),3)'


end






