
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
        %u_a=[0.511 1.079]; %cm^-1
        u_a=[51.1 107.9]; %m^-1
        %u_s=[127.33 92.66]; %cm^-1
        u_s=[12733 9266];%m^-1
        g=0.88; %unitless
        p=1040; %kg/m^3 
        c=3650; %J/(kg*K)
        k= 0.530; %W/(m*K)
        w_L= [0.0000045 0.0001]; % m
        
     %times to evaluate
        t=0.010; %s
        
        
    
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
             phi=csvread(fulldatafilename); %kW/m^2
             phi=phi.*10^3; %W/m^2
             prop(1)=u_a(i);
             prop(2)=u_s(i);
             prop(7)=w_L(j);
             dT(:,:,k)=Traise_Data(prop,phi); 
             filename_R=[fullfile(path,'MCML','MCML_FR_Data','MCML_Data_FR_r')];
             filename_Z=[fullfile(path,'MCML','MCML_FR_Data','MCML_Data_FR_z')];
             r=csvread(filename_R); %mm
             %r=r.*10^(-3) ;%m
             z=csvread(filename_Z);%mm
             %z=z.*10^(-3); %m
               
           %  subplot(1,2,1)                                 %Plot Fluence Rate (color) (mW/mm^)
           
             imagesc(r,z,dT(:,:,k)); c=colorbar;                  
               title({'Temperature increase';['$\lambda=$' char(n_L) ', NA=' ...
                   char(n_NA) ', d=' char(n_d)]},'interpreter', 'LaTex');
                xlabel('r [mm]', 'interpreter', 'LaTex'); 
                ylabel('z [mm]', 'interpreter', 'LaTex');
                c.Label.String= '$dT$ [$K$]';
                c.Label.FontSize=20;
                c.Label.Interpreter='latex';
                
              if j==1 
                   xlim([-0.3,0.3]);ylim([0,0.6]);
               elseif j==2 
                   xlim([-1,1]);ylim([0,1.5]);   
               end
            
               
             
         k=k+1;
        
    end
  end 