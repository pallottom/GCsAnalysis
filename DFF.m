
function [data]= DFF(data)
% DFF 
file_base=data.info.file_base
import ScanImageTiffReader.ScanImageTiffReader;
date= data.info.date;
for exp=1:size(file_base,2)
tiff_filename= ([date,sprintf('_%05d',(file_base(:,exp))),'.tif'])
reader= ScanImageTiffReader(tiff_filename);
vol=reader.data();
metadata=reader.metadata();
metaCell=strsplit(metadata, '\n')';
clear metadata
for i=1:size(metaCell,1)
metadata(i,:)=strsplit(convertCharsToStrings(metaCell{i,:}),'=');
end
I= strfind(metadata, 'SI.hChannels.channelSave')
Index_ch = find(not(cellfun('isempty',I)))
NCh= size(str2num(metadata{38,2}),1) % find the number of Channels

%data.masks {size(file_base,2),6}= [];
%data.info.NCh=NCh;
data.dff {size(file_base,2),6}= [];
for plane=1:6
% calculate DFF with the final masks
    green_plane= (plane*NCh)-1; % GREEN PLANE
    volume = vol(1:size(vol,1),1:size(vol,2), green_plane:7*NCh:size(vol,3));
    clear this mask
    clear roi_sums
    clear f0
    
    masks= data.masks{1, plane};
    ch2_2d = double(reshape(volume,[size(volume,1)...
        *size(volume,2) size(volume,3)]));

    for i=1:size(masks,3)
    thismask = masks(:,:,i);
    roi_sums(i,:) = mean(ch2_2d(find(thismask(:)==1),:),1);
    end

    f0= mean(roi_sums(:,10:30),2); %10:30
    dff= (roi_sums - f0)./f0; % (f-f0)/f0
    roi_df= dff./max(max(dff(:, 15:end)));

data.dff{exp,plane}= [data.dff{exp,plane}; roi_df'];

end
end
end
