function [R_Fig,z, Data_Fig, file_name] = MCML_Data_Err(L,NA,l,path)
%MCML_Data.m Creates Fluence Rate for each grid point 
%   Reads the data file by using the function read_F
%   The data file is chosen by the parameters of the tissue (L,NA,dia)
%   path is the loaction of the data files
%   Puts the data in the right configuration to use it in MCML_plot_conm     

                file_name = ['L_' char(L) '_NA_' char(NA) ]; 

                if l==1
                    file_Frz = [fullfile(path,'MCML_Sim','Output',[file_name '.Frzc'])];
                elseif l==2
                    file_Frz = [fullfile(path,'MCML_Sim','Output-mu_s+1sigma',[file_name '.Frzc'])];
                elseif l==3
                    file_Frz = [fullfile(path,'MCML_Sim','Output-mu_s-1sigma',[file_name '.Frzc'])];
                end
                [r,z,Data] = MCML_read_F(file_Frz);               %Read data, [mm,mm,/mm^2]                            
                R_Fig = [-r(end:-1:1), r];                                  
                Data_Fig = [Data(:,end:-1:1) Data]*1;        % * # mW/mm^2 @ tip
                                                        
end

