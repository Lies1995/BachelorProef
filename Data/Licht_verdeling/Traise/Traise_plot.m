
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
    %Absorptie
        u_a=[0.511 1.079]; %cm^-1
        u_s=[127.33 92.66]; %cm^-1
        g=0.88;
        p=1040; %kg/m^3
        c=3650; %mJ/(g*K)
        k= 0.530; %W/(m*K)
        w_L= [4.5 100]; % um
        
     %times to evaluate
        t=0.001; %s
        
        
    
path=LD;

dT=zeros(gp, gp,length(t));
prop=[0 0 g p c k 0]
% %-------PLOT-------

k=1;
  for i = 1: length(L); 
    for j=1:length(NA)
        
        
        fig=figure(k);                                      %make figure
        %set(fig, 'Position', [10 1000 1400 500]);    
        
        
             n_L=L(i); n_NA=NA(j); n_d=d(j);                %Specifying data
             datafile_name = ['L_' char(n_L) '_NA_' char(n_NA) '_d_' char(n_d)];
             fulldatafilename=fullfile(path,'MCML','MCML_FR_Data',['MCML_Data_FR_' datafile_name]);
             phi=csvread(fulldatafilename);
             prop(1)=u_a(i);
             prop(2)=u_s(i);
             prop(7)=w_L(j);
             dT(:,:,k)=Traise_Data(prop,phi,t); 
             filename_R=[fullfile(path,'MCML','MCML_FR_Data','MCML_Data_FR_r')];
             filename_Z=[fullfile(path,'MCML','MCML_FR_Data','MCML_Data_FR_z')];
             r=csvread(filename_R);
             z=csvread(filename_Z);
               
           %  subplot(1,2,1)                                 %Plot Fluence Rate (color) (mW/mm^)
           
             imagesc(r,z,dT(:,:,k)); c=colorbar;                  
                title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
                    char(n_NA) ', d=' char(n_d)]},'interpreter', 'LaTex');
                xlabel('r [mm]', 'interpreter', 'LaTex'); 
                ylabel('z [mm]', 'interpreter', 'LaTex');
                c.Label.String= '$\phi$ [$\frac{mW}{mm^2}$]';
                c.Label.FontSize=20;
                c.Label.Interpreter='latex';
                
                
            
               
               gfxfullfilename=fullfile(path,'MCML','MCML_FR_gfx',['MCML_gfx_FR' datafile_name]);
            saveas(fig, gfxfullfilename,'pdf');
         k=k+1;
        
    end
  end 