% WORKFLOW ALL DATA TOGETHER

clear all
date= ('101120');
file_base=[17 19 16 15 18 20]; % files to do the analysis [07,06,05,08,09,10]
file_rois= 15; % number of the file I took the rois
n_stim= [10, 20, 30, 50, 70, 100]; % Number of stims [10, 20, 30, 50, 70, 100]
code_number_green=1;
code_number_red=2;

tic
data= Centers_Radii(date, file_base, file_rois, n_stim,code_number_green,code_number_red);
data= Masks(data);
data= DFF(data);
data= p_values(data);
data= AUC_GCs(data);
toc

save(['data',num2str(date),'_',num2str(file_rois),'.mat'], 'data' )


% PLOT
[fig1, fig2]=PLOT_active_vs_pulses_multidata(data)
figname= (['Active',data.info.date,'.png' ])
saveas(fig1,figname);



