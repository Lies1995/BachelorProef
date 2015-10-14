function MCML_plot
    close all
    
    L = {'470';'560'};                                    
    NA = {'12';'37'};                                                  
    dia = {'9';'200'};
    file_path = '/Users/LIesDeceuninck/Desktop/';
    
    for n_L = 1
    for n_NA = 1                                         
    for n_dia =1
                file_name = ['L_' char(L(n_L)) '_NA_' char(NA(n_NA)) '_d_' char(dia(n_dia)) '.Frzc']; 
                file_Frz = [fullfile(file_path,file_name)];   
        
                [r,z,Data] = read_F(file_Frz);                              % /cm^2
                Data = Data./100;                                           % convert to /mm^2
        
                R_Fig = [-r(end:-1:1), r];                                  % mm
                Data_Fig = [Data(:,end:-1:1) Data]*1;                       % * # mW @ tip

                                       
                imagesc(R_Fig,z,Data_Fig); colorbar;   
                xlabel('r (mm)'); ylabel('z (mm)'); 
                xlim([-0.1,0.1 ]);ylim([0,0.7]);
                
%               plot(z,Data_Fig(:,501))                                     % I(r,z) [mW/mm²]    
%               xlim([0,3]);ylim([0,500]);         
     end
     end
    end
     
    % read data from file            
function [r,z,Data] = read_F(MCML_file_MCO)


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


               

   