function [slope, pks_locs_w_p, AUC]= FindPeaks4GC2(dff, frames_stim, plane)
% this function returns the slope and pks, locs, w and prominence(according to the
% finction findpeacks)
%Inputs: basename (ex. 'GREENdff_220620_00019_': cell x frames), n_pulses
%(10, 20, 30, 50, 70 or 100)
%Outputs: slope, pks, locs and w (according to the
% finction findpeacks)

frames_interval = [(frames_stim - 10); (frames_stim + 40)];

% Calcolo stings
clear strings
clear string_mean
% strings= zeros(size(dff,1),size(dff,2), (frames_interval(2,1)-frames_interval (1,1))+1,...
%      size(frames_interval,2)); % preallocation
 for i = 1: size(frames_interval, 2)
     strings(:,:,i) = dff(frames_interval(1, i):frames_interval(2, i),:);
 end

string_mean(:,:,:)= mean(strings,3)';
string_mean(isnan(string_mean))=0;
% Trovo il max

clear max_point
for i= 1:size(string_mean,1)
max_point(i)=find(string_mean(i,:)==(max(string_mean(i,:))),1, 'first'); 
end

% creo vettore dallo stimolo (at 12) al max_point e POLIFIT 
clear slope_temp
slope_temp=[];
temp=[];
for i=1:size(string_mean,1)
    clear temp
    x=[1:max_point(:,i)-11];
    y=string_mean(i,12:max_point(i));
    temp=polyfit(x,y,1);
    slope_temp= [slope_temp;temp];
    
end
slope=slope_temp;


    clear pks_locs_w_p_temp
    
    pks_locs_w_p_temp=zeros(4,size(string_mean,1));
for ii = 1: size(string_mean,1)
    clear pks_temp
    clear locs_temp
    clear w_temp
    clear p_temp
    [pks_temp,locs_temp,w_temp,p_temp] = findpeaks(string_mean(ii,:)) ;
    if pks_temp ~= 0
    maxima=max(pks_temp);
    pks_locs_w_p_temp(:,ii)= [pks_temp(find (pks_temp== maxima, 1, 'first')),...
        locs_temp(find (pks_temp== maxima,1, 'first')), ...
        w_temp(find (pks_temp== maxima,1, 'first'))...
        p_temp(find (pks_temp== maxima,1, 'first'))];
    end
end

pks_locs_w_p=pks_locs_w_p_temp;

% FIND AUC (Aurea Under the Curve)

AUC= trapz(string_mean(:, 12:30),2);


end


