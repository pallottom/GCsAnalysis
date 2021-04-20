function [data] = Center_Radii(date, file_base, file_rois, n_stim,code_number_green,code_number_red)

% FUNCTION TO PUT TOGETHER COORDINATES, RADII and AGE CODE and some INFO


colors= {'GREEN', 'RED'};
data.coordinates.centers {1,6}= [];
data.coordinates.radii {1,6}= [];
data.agecode{1,6}= [];

for c= 1: size(colors,2) % if goes thought the two colors
ROIsfilename= ([colors{c},'rois_',date,sprintf('_%05d',(file_rois)),'_']);

for plane= 1:6 % loops the planes

    clear REDrois
    clear GREENrois
    load ([ROIsfilename, num2str(plane), '.mat'])
    clear centers
    clear radii
    clear myrois
    clear x
    clear y
    clear z
    clear c

    if contains(ROIsfilename,'GREEN')
        myrois=GREENrois;
    elseif contains(ROIsfilename, 'RED')
        myrois=REDrois;
    elseif contains(ROIsfilename, 'roi')
        myrois=roi_df;
    end
if size(myrois) ~= [0,0] %se ho disegnato delle rois
    for i=1:size(myrois,2)
        centers(i,:)=myrois{1,i}.Center;
        radii(i,:)=myrois{1,i}.Radius;
    end
    data.coordinates.centers{:,plane}= [data.coordinates.centers{:,plane};centers];
    data.coordinates.radii{:,plane}= [data.coordinates.radii{:,plane};radii];
end
    data.info.roisfilename=(ROIsfilename);
    data.info.date= date;
    data.info.file_base= file_base;
    data.info.file_rois= file_rois;
    data.info.n_stim= n_stim;
    data.info.color_code.green=code_number_green;
    data.info.color_code.red=code_number_red;

    clear agecode
    agecode= age2code(ROIsfilename, plane, code_number_green, code_number_red);
    data.agecode{:,plane}= [data.agecode{:,plane}; agecode];

end
end
end




