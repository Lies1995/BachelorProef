%------Setup--------
    close all
    % Change default text font size
        set(0,'DefaultAxesFontSize', 18)
    %File Path
        LD =[fullfile('/Users','LIesDeceuninck', 'Documents','Bachelorproef',...
            'Data','Licht_verdeling','MCML','MCML_FR_Data')];
        HV=[fullfile('C:','Users','hannelore','Documents','2015-2016',...
            'BachelorProef2015','BachelorProef','Data','Licht_verdeling','MCML','MCML_FR_Data')];    
        
%------DATA--------
%optical properties
    L = [474 560];          %Wavelengths(nm)
    NA = [12 37];           %Numerical Aperture (dimensionless)
    d = [9 200];            %Diameter (mum)
%tissue properties
    u_a=[51.1 107.9];       % absorpion coefficient [m^-1]
    u_s=[12733 9266];       %scattering coefficient [m^-1]
    g=0.88;                 %anisotropy factor [unitless]
    rho=1040;                 %tissue density [kg/m^3] 
    c=3650;                 %specific heat [J/(kg*K)]
    k_d=0.530;               %,thermal diffusivity [W/(m*K)]
    w_L= [0.0000045 0.0001];%1:e^ radius [m] 