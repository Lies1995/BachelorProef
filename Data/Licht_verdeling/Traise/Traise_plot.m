
%------Setup--------
    close all
    % Change default text font size
        set(0,'DefaultAxesFontSize', 18)
    %File Path
        LD = '/Users/LIesDeceuninck/Documents/BachelorProef/Data/Licht_verdeling';
       % HV= 'C:\Users\hannelore\Documents\2015-2016\BachelorProef\Data\Licht_verdeling';   
    %number of grid points (in 1D)
    gp=1000;
%------DATA--------
    %Wavelengths(nm)
        L = {'474';'560'}; 
    %Numerical Aperture (dimensionless)
        NA = {'12';'37'};  
    %Diameter (mum)
        d = {'9';'200'};    
    
path=LD
filename=fullfile(LD,'MCML','MCML_FR_Data')
phi= csvread(filename)
dT=zeros(gp, gp,length(t))
% %-------PLOT-------

k=1;
  for i = 1: length(L); 
    for j=1:length(NA)
        
        fig=figure(k);                                      %make figure
        %set(fig, 'Position', [10 1000 1400 500]);    
        
        
             n_L=L(i); n_NA=NA(j); n_d=d(j);                %Specifying data
             datafile_name = ['L_' char(L) '_NA_' char(NA) '_d_' char(dia)];
             fulldatafilename=fullfile(path,'MCML','MCML_FR_Data',['MCML_Data_FR' datafilename]);
             phi=csvread(fulldatafilename);
             dT(:,:,k)=Trais_Data(;                    
               
           %  subplot(1,2,1)                                 %Plot Fluence Rate (color) (mW/mm^)
             imagesc(r,z,dT(:,:,k)); c=colorbar;                  
                title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
                    char(n_NA) ', d=' char(n_d)]},'interpreter', 'LaTex');
                xlabel('r [mm]', 'interpreter', 'LaTex'); 
                ylabel('z [mm]', 'interpreter', 'LaTex');
                c.Label.String= '$\phi$ [$\frac{mW}{mm^2}$]';
                c.Label.FontSize=20;
                c.Label.Interpreter='latex';
                
                
            
               
               gfxfullfilename=fullfile(file_path,'MCML','MCML_FR_gfx',['MCML_gfx_FR' filename]);
            saveas(fig, gfxfullfilename,'pdf');
         k=k+1;
        
    end
  end 