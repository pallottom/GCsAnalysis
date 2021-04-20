function [data]= p_values(data)
% this function perform the Permutation test (1000 permutation) on data
% from GC App. 
%Inputs: basename (ex. 'GREENdff_220620_00019_': cell x frames), n_pulses
%(10, 20, 30, 50, 70 or 100)
%Outputs: p-value, observeddifference, effectsize (outputs of the
%permutation test)

%exp= data.info.file_base;
file_base=data.info.file_base;
data.info.frames_stim{:,:}=[];

for exp= 1: size(file_base,2) % loops thougth the experiments

import ScanImageTiffReader.ScanImageTiffReader;
date= data.info.date;
tiff_filename= ([date,sprintf('_%05d',(file_base(:,exp))),'.tif'])
reader= ScanImageTiffReader(tiff_filename);
vol=reader.data();
metadata=reader.metadata();
metaCell=strsplit(metadata, '\n')';
clear metadata
for i=1:size(metaCell,1)
metadata(i,:)=strsplit(metaCell{i},'=');
end
I= strfind(metadata, 'SI.hChannels.channelSave')
Index_ch = find(not(cellfun('isempty',I)))
NCh= size(str2num(metadata{38,2}),1) % find the number of Channels
n_stim= data.info.n_stim;


% Find the number of stim
if NCh== 3
stim = vol(1:size(vol,1),1:size(vol,2), 1:21:end);
stim_vec=squeeze(mean(mean(stim,1),2));
times=find(-stim_vec>mean(-stim_vec));
frames_stim= times(1);
i=2; n=2;
while n~=6
% for i= 1:size(stim_vec,1)-1
if (times(i)-1~=times(i-1))
frames_stim(n)=times(i);
n=n+1
end 
i=i+1
end
% end
elseif n_stim(exp) == 10
    frames_stim=  [53, 97, 142, 184, 229];
elseif n_stim(exp) ==20
    frames_stim= [53, 98, 144, 191, 237];
elseif n_stim (exp)== 30
    frames_stim= [53, 100, 146, 194, 240];
elseif n_stim (exp)== 50
    frames_stim= [53, 102, 149, 198, 249];
elseif n_stim (exp)== 70
    frames_stim= [53, 106, 161, 215, 270];
elseif n_stim (exp)== 100
    frames_stim= [53, 111, 166, 223, 283];
end

data.info.frames_stim{exp,:}=frames_stim;

frames_interval = [(frames_stim - 10); (frames_stim + 40)];
for exp= 1: size(data.info.file_base,2)
for plane= 1:6 % loops the planes

clear dff
dff= data.dff{exp,plane};

clear temp_pre
clear pre
clear temp_post
clear post
 
for i= 1:size(frames_stim,2)
    temp_pre (:,:,i) = dff(frames_stim(i)-20:frames_stim(i)-3,:);
    temp_post(:,:,i) = dff (frames_stim(i)+3:frames_stim(i)+20,:);
end

pre = permute(temp_pre,[1 3 2]); % was 1 3 2
pre = reshape(pre,[],size(temp_pre,2),1);

post = permute(temp_post,[1 3 2]);
post = reshape(post,[],size(temp_post,2),1);

% PERMUTATION TEST
for i= 1:size(pre, 2)
[p_temp(i), observeddifference_temp(i), effectsize_temp(i)] = ...
    permutationTest(pre(:,i), post(:,i), 1000);
end

p{exp, plane}=p_temp';
% observeddifference{plane}=observeddifference_temp;
% effectsize{plane}=effectsize_temp;

 clear p_temp
% clear observeddifference_temp
% clear effectsize_temp

data.p{exp,plane}= p{exp, plane};
end
end
end

