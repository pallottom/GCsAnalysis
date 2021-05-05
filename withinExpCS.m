% COSINE SIM WITHIN TABLE

load('MC_data.mat')



code=1

temp_dff=[];
tdff=[];

   for exp=1: size(select_data.p,1)
       
       
       frames_stim=select_data.info{exp,1}.frames_stim;
       for plane=1 :6 %number of planes 
           I= find(select_data.p{exp,1}{1,plane}<0.001  ...
             & select_data.agecode{exp,1}{1,plane}>=code)
           temp_dff=[temp_dff, select_data.dff{exp,:}{:,plane}(:,I)];
       end
       
       for i= 1:size(frames_stim,2)
         temp = [mean(temp_dff(frames_stim(i)-9:frames_stim(i)+40,:),3)];
       end
temp_dff=[];
temp(sum(isnan(temp), 2) >= 1, :) = [];%remove nan
           tdff=[tdff, temp];
        temp=[];
        size(tdff)


% COSINE SIMILARITY TEST

for cellX=1:size(tdff,2)
    for cellY=1:size(tdff,2)
        CS(cellX,cellY)=getCosineSimilarity(tdff(:,cellX),tdff(:,cellY));
        
    end
end

% figure;
% imagesc(CS)
% colorbar


figure; imagesc(triu(CS))

title_strng=select_data.info{exp,1}.date
figure; histogram(triu(CS))
xlabel('cosine similarity score')
ylabel('number of observations')
title(title_strng)

   end
