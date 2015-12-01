function [R_Fig,z, Data_Fig, file_name] = MCML_Data(L,NA,path,protocol_name,l)
%MCML_Data.m Creates Fluence Rate for each grid point 
%   Reads the data file by using the function read_F
%   The data file is chosen by the protocol; protocol_name and the error
%   l=1 No error
%   l=2 +sigma u_a, +sigma u_s
%   l=3 -sigma u_a, -sigma u_s 
%   path is the loaction of the data files
%   Puts the data in the right configuration to use it in MCML_plot    

    if l==1
         file_name = ['L_' num2str(L) '_NA_' num2str(NA) ] ;
        file_Frz = [fullfile(path,'OutputMCML',[protocol_name '.Frzc'])] ;
    elseif l==2
         file_name = ['L_' num2str(L) '_NA_' num2str(NA) '+u_a+u_s']; 
        file_Frz = [fullfile(path,'Output+',[protocol_name '.Frzc'])];
    elseif l==3
         file_name = ['L_' num2str(L) '_NA_' num2str(NA) '-u_a-u_s']; 
        file_Frz = [fullfile(path,'Output-',[protocol_name '.Frzc'])];
    end
    [r,z,Data] = MCML_read_F(file_Frz);               %Read data, [mm,mm,/mm^2]                            
    R_Fig = [-r(end:-1:1), r];                                  
    Data_Fig = [Data(:,end:-1:1) Data]*1;        % * # mW/mm^2 @ tip
    Data_Fig= Data_Fig.*10^3; % SI units W/m^2                                        
end

