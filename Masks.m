function [data]= Masks(data)

% FUNCTION THAT MODIFY MASKS
import ScanImageTiffReader.ScanImageTiffReader;
file_base=data.info.file_base
date= data.info.date;
exp = 1 % le masks sono le stesse per ogni esperimento
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

data.masks {size(file_base,2),6}= [];
data.info.NCh=NCh;

% Load files
for plane= 1:6 % 6 planes
    % Load file
    green_plane= (plane*NCh)-1; % GREEN PLANE
    volume = vol(1:size(vol,1),1:size(vol,2), green_plane:7*NCh:size(vol,3));

%----- Calculate nearest neighbor vertical correlations __ KEVIN's CODE
width= size(volume,1);
height=size(volume,2);
im1=volume;
template_mask=1;
vert_xcorr = [];
for count = 1:width
r = corrcoef(single(squeeze(im1(:,count,:)))');
x_vec = [2:height]'; y_vec = [1:(height-1)]';
vert_xcorr(:,count) = r(sub2ind([height height],x_vec,y_vec));
end
vert_xcorr(height,:) = 0;
vert_xcorr = vert_xcorr.*template_mask;

% Calculate nearest neighbor horizontal correlations
horz_xcorr = [];
for count = 1:height
r = corrcoef(single(squeeze(im1(count,:,:)))');
x_vec = [2:width]'; y_vec = [1:(width-1)]';
horz_xcorr(count,:) = r(sub2ind([width width],x_vec,y_vec));
end
horz_xcorr(:,width) = 0;
horz_xcorr = horz_xcorr.*template_mask;

% Combine correlation maps
xcorr_im = horz_xcorr .* vert_xcorr;
xcorr_im = xcorr_im .* template_mask;


% FIND MASK
    centers= data.coordinates.centers{:,plane};
    radii= data.coordinates.radii{plane};

% Find masks
clear masks
    clear thismask
    clear dff
    clear roi_df
    for i= 1:size(centers,1)
    thismask= createCirclesMask(volume(:,:,1), centers(i,:), radii(i));
    masks(:,:,i)= thismask;
    end

% CHECK IF THERE ARE OVERLAY ROIS
overlaying_rois=zeros(size(masks,3),size(masks,3));
j=2;
for i=1:size(masks,3)
    while j<size(masks,3)
    if any(any(masks(:,:,i)+masks(:,:,j)==2));
        overlaying_rois(i,j)=1;
    end
    j=j+1;
    end
    j=i+2;
end

% REMOVE OVERLAY PIXELS
[roi1,roi2]=(find(overlaying_rois==1)); % roi pairs that overlay

for i= 1: size(roi1,1)
    over_roi1= masks(:,:,roi1(i));
    over_roi2= masks(:,:,roi2(i));
    roi_sum=over_roi1+over_roi2;

    over_roi1(roi_sum==2) = [0];
    over_roi2(roi_sum==2) = [0];
    
    masks(:,:,roi1(i))= over_roi1;
    masks(:,:,roi2(i))= over_roi2;
end

% loop for all the rois
clear final_masks
for ii=1:size(masks,3)
    if sum(sum(masks(:,:,ii)))>10 % si puo' aggiungere un filtro di almeno 10 pixels
my_mask= masks(:,:,ii);

% Calculate average dF/F per ROI
ch2_2d = double(reshape(volume,[size(volume,1)*size(volume,2) size(volume,3)]));
pixels_dff = (ch2_2d(find(my_mask(:)==1),:));
[pixels_x,pixels_y]= find(my_mask==1);

% DF/F 
clear pixel_df
f0= mean(pixels_dff(:,10:30),2);
dff= (pixels_dff - f0)./f0; % (f-f0)/f0
pixels_df= dff./max(max(dff(:,15:end))); %nel fare la normalizzazione, non considero i primi 10  frames- artefact
my_mask(xcorr_im<0.015)=[0]; % set the threshold %was 0.015
final_masks(:,:,ii)=my_mask; 
    else
        final_masks(:,:,ii)= zeros(512,512);
    end
end

data.masks{1,plane}= [data.masks{1,plane}; final_masks];
end
end
