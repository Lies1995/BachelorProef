%------Setup--------
    close all
    % Change default text font size
        set(0,'DefaultAxesFontSize', 18)
        set(0,'defaulttextinterpreter','latex')
        
    %File Path
        LD =[fullfile('/Users','LIesDeceuninck', 'Documents','Bachelorproef',...
            'Data','Licht_verdeling','code','Data','UnitFR')];
        HV=[fullfile('C:','Users','hannelore','Documents','2015-2016',...
            'BachelorProef2015','BachelorProef','Data','Licht_verdeling','code','Data','UnitFR')];    
        path=LD;
%------DATA--------
%optical properties
    L = [474 560];          %Wavelengths(nm)
    NA = [12 37];           %Numerical Aperture (dimensionless)
    d = [9 200];            %Diameter (mum)
%tissue properties
    u_a=[51.1 107.9];       % absorpion coefficient [m^-1]
    u_s=[12733 9266];       %scattering coefficient [m^-1]
    g=0.88;                 %anisotropy factor [unitless]
    rho=1040;               %tissue density [kg/m^3] 
    c=3650;                 %specific heat [J/(kg*K)]
    k_d=0.530;              %,thermal diffusivity [W/(m*K)]
    w_L= [0.0000045 0.0001];%1:e^ radius [m] 
%Laser Power [W] (default 0)
    PL=1;
%Irradiance [W/m^2] (default 1)
    IL=46000
%Pulse length [s]
    tL=0.001; 
%Frequency of the pulses [s^-1]
    freq=40; 
    F=1/freq;               %time between pulses [s]
%Times to evaluate[s] 
    time=0.2;               %total time length
    ntss=400;               %number of time steps in a puls
    ntsd=500;               %number of time steps between pulses
    
    t1=linspace(0,tL,ntss); %times to evaluate in one puls
    t2=linspace(tL+t1(2),F-t1(2),ntsd); %times to evaluate between pulses
    
    t_w=floor(time/F);      %number of timewindows
%Position in the tissue to evaluate dT [z r]
    pos=[2 500];
%-----Initiations---
dT=zeros(2, (length(t1)+length(t2))*t_w , 4); %datacollection vector
prop=[0 0 g rho c k_d 0 tL F] ;         
                            %anisotropy factor;tissue density,specific 
                            %heat,thermal diffusivity,pulse length [s], 
                            %time between pulses[s]
k=1; %index for the protocols

