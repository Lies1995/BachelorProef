
%-------Setup-------
MCML_Setup_Data
file_path=LD; %Choose what path to use
h=1 ;%1=big scale, 2= small scale
%LD=Lies Deceuninck, HV=Hannelore Verhoeven

% %-------PLOT-------
k=1;                                                        %Index for figures
  for i = 1: length(L); 
    for j=1:length(NA)
        
        fig=figure(k);                                      %make figure k
        set(fig, 'Position', [10 1000 1400 500]);
        
    
             n_L=L(i); n_NA=NA(j);                %Specifying data
             [r,z,fRate,filename]=MCML_Data(n_L,n_NA,file_path,h); %Calculation Fluence rate 
             
             fullfilename=[fullfile(file_path,'MCML','MCML_FR_Data',['MCML_Data_FR_' filename])];
             filename_r=[fullfile(file_path,'MCML','MCML_FR_Data','MCML_Data_FR_r')];
             filename_z=[fullfile(file_path,'MCML','MCML_FR_Data','MCML_Data_FR_z')];
             csvwrite(fullfilename,fRate); %store data in external datafiles. row--> Z collumn-->r
             csvwrite(filename_r, r);
             csvwrite(filename_z, z);
               
             subplot(1,2,1)    
             
             %Plot Fluence Rate (color) (mW/mm^)
             imagesc(r,z,fRate); c=colorbar;                  
                title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
                    char(n_NA) ]},'interpreter', 'LaTex');
                xlabel('r [mm]', 'interpreter', 'LaTex'); 
                ylabel('z [mm]', 'interpreter', 'LaTex');
                c.Label.String= '$\phi$ [$\frac{mW}{mm^2}$]';
                c.Label.FontSize=20;
                c.Label.Interpreter='latex';
%                 if h==1
%                     if j==1
%                         xlim([-0.3,0.3]);ylim([0,0.6]);
%                     elseif j==2
%                         xlim([-1,1]);ylim([0,1.5]);
%                     end
%                 elseif h==3
%                     
%                     if j==1
%                         xlim([-0.1,0.1]);ylim([0,0.3]);
%                     elseif j==2
%                         xlim([-1,1]);ylim([0,1.5]);
%                     end
%                 end
                
             subplot(1,2,2)                                 %Plot Fluence Rate (height) (mW/mm^)
             plot(z,fRate(:,501)) 
                title({'Fluence Rate at r=0';['$\lambda=$' char(n_L) ', NA=' ...
                    char(n_NA) ]},'interpreter', 'LaTex');
                xlabel('z [mm]', 'interpreter', 'LaTex'); 
                ylabel('$\phi$ [$\frac{mW}{mm^2}$]', 'interpreter', 'LaTex'); 
                if h==1
                    if j==1
                        xlim([0,0.6]);ylim([0,3200]);
                    elseif j==2
                        xlim([0,2]);ylim([0,80]);
                    end
                elseif h==3
                    if j==1
                        xlim([0,0.5]);
                        % ylim([0,4000]);
                    elseif j==2
                        xlim([0,2]);ylim([0,80]);
                    end
                end
         k=k+1;
        
    end
  end 
