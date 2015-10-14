function [R_Fig,z, FluenceRate] = MCML_Data(L,NA,dia,path)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

                file_name = ['L_' char(L) '_NA_' char(NA) '_d_' char(dia) '.Frzc']; 
                file_Frz = [fullfile(path,file_name)];   
                [r,z,Data] = read_F(file_Frz);                              % /cm^2
                Data = Data./100;                                           % convert to /mm^2
                R_Fig = [-r(end:-1:1), r];                                  % mm
                Data_Fig = [Data(:,end:-1:1) Data]*1;                      % * # mW @ tip
                FluenceRate=Data_Fig;
                
end

