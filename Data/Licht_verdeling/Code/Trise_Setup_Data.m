%------Setup--------
close all
% Change default text font size
    set(0,'DefaultAxesFontSize', 18)
%File Path
    LD =[fullfile('/Users','LIesDeceuninck', 'Documents','Bachelorproef','Data','Licht_verdeling','Code','Data')];
    HV=[fullfile('C:','Users','hannelore','Documents','2015-2016','BachelorProef2015',...
        'Bachelorproef','Data','Licht_verdeling','Code','Data')];
    path=LD;
%------DATA--------

%Optical properties
    L = [474 560];          %Wavelengths(nm)
    NA = [12 37];           %Numerical Aperture (dimensionless)
    d = [9 200];            %Diameter (mum)
%Tissue properties
    u_a=[51.1 107.9];       % absorpion coefficient [m^-1]
    u_s=[12733 9266];       %scattering coefficient [m^-1]
    g=0.88;                 %anisotropy factor [unitless]
    p=1040;                 %tissue density [kg/m^3] 
    c=3650;                 %specific heat [J/(kg*K)]
    k_d=0.530;               %,thermal diffusivity [W/(m*K)]
    w_L= [0.0000045 0.0001];%1:e^ radius [m] 
%Errors
    du_a_plus=[34.9, 55.9];
    du_a_minus=[-34.9, -52.5];
    du_s_plus=[3267, 3558];
    du_s_minus=[-3267, -3492];
%Times to evaluate[s]       
    t1=linspace(0,0.000075,50);
    t2=linspace(0,0.040,50);
%Time indices to plot
    timesToPlot=[2 16 47];
%Laser Power [W] (default 0)
    PL=0.001;
%Irradiance [W/m^2] (default 1)
    IL=1;
 %positions in tissue
    filename_R=[fullfile(path,'FR_r')];
    filename_Z=[fullfile(path,'FR_z')];
    r=csvread(filename_R);  %radial position[mm]
    z=csvread(filename_Z);  %axial position[mm]
%-----Inistiations---
    %Tissue properties
    prop=[0 0 g p c k_d 0] ;%anisotropy factor;tissue density,
                            %specific heat,thermal diffusivity
    %Vector to store timeconstants
    tau=zeros(1,length(L)*length(NA)); 
    %Vector to store Temperature increases
    dT=zeros(1000,1000,4,length(t1)); 
    dTplus=zeros(4,length(t1));
    dTminus=zeros(4,length(t1));
    k=1%index for protocols
    m=1%index for figures    


