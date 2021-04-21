function [code]= age2code(ROIsfilename, plane, code_number_green, code_number_red)

% The function assign a code to a specific age: specifically: 1=
% PN, 2= jAB, 3= mAB

load ([ROIsfilename, num2str(plane), '.mat'])

if contains(ROIsfilename,'GREEN')
code_number= code_number_green;
myrois= GREENrois;
elseif contains(ROIsfilename, 'RED')
code_number= code_number_red;
myrois=REDrois;
end

code= code_number*ones(size(myrois,2),1)