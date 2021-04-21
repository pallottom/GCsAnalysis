function [data]=AUC_GCs (data)

file_base=data.info.file_base
data.AUC {size(file_base,2),6}= [];
data.pks_locs_w {size(file_base,2),6}= [];

for  exp=1:size(file_base,2)
for plane= 1:6
dff= data.dff{exp, plane};
frames_stim= data.info.frames_stim{exp,:}
[slope, pks_locs_w, AUC]=FindPeaks4GC2(dff, frames_stim, plane);

data.AUC{exp,plane}= [data.AUC{exp,plane}; AUC];
data.pks_locs_w{exp,plane}= [data.pks_locs_w{exp,plane}; pks_locs_w];


end
end

end