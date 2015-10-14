function [r,z,Data] = read_F(MCML_file_MCO)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    S= importdata(MCML_file_MCO);
    r = S.data(:,1); 
    z = S.data(:,2); 
    Data = S.data(:,3); 
    clear S;

    step_z = z(2)-z(1); z_min = min(z); z_max = max(z);
    
    z_length = round((z_max - z_min)./step_z)+1;
    r_length = length(r)./z_length;
    
    r = reshape(r,z_length,r_length); 
    r = r(1,:).*10;  % cm->mm
    z = reshape(z,z_length,r_length); 
    z = z(:,1)'.*10;% cm->mm
    Data = reshape(Data,z_length,r_length);
    Data(end,:) = 0;
    Data(:,end) = 0;

end

