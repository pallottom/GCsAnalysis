% TABLE and FISHER TEST

% Creation of a contingency table (matrix) with PN, jAB and mAB for eachn of pulses *using
% myfisher23
clear all
load ('MC_Active')

x=zeros(2,3,size(Active,1));
for exp=1:size(Active,1)
    for age_code=1:size(Active,4)
    x(1,age_code,exp)=sum(sum(Active(exp,:,:,age_code)))
    end
end

clear Active
load('TC_Active')
for exp=1:size(Active,1)
    for age_code=1:size(Active,4)
    x(2,age_code,exp)=sum(sum(Active(exp,:,:,age_code)))
    end
end


% Fisher Test
for exp=1:size(x,3)
myfisher23(x(:,:,exp))
end


x



