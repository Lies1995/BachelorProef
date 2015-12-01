%------Setup--------
close all
% Change default text font size
    set(0,'DefaultAxesFontSize', 18)
%File Path
    LD =[fullfile('/Users','LIesDeceuninck', 'Documents','Bachelorproef','Data','Licht_verdeling','Code','Data')];
    HV=[fullfile('C:','Users','hannelore','Documents','2015-2016','BachelorProef2015',...
        'Bachelorproef','Data','Licht_verdeling','Code','Data')]; 
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
        
t1=linspace(0,0.000075,50);%times to evaluate[s] for NA=12
t2=linspace(0,0.040,50); %times to evaluate[s] for NA=37
timesToPlot=[2 16 47];
path=LD; %path
PL=0.001;%Laser Power [W] (default 0)
IL=100000;%irradiance [W/m^2] (default 1)
v=[1000, 1000];
%positions in tissue
filename_R=[fullfile(path,'FR_r')];
filename_Z=[fullfile(path,'FR_z')];
r=csvread(filename_R);  %radial position[mm]
z=csvread(filename_Z);  %axial position[mm]
%tau=zeros(1,4);

%-----Inistiations---
m=1; %index for the figures
k=1; %index for the protocols
tau=zeros(1,length(L)*length(NA)); %time constants for each protocol
dT=zeros( 1000, 1000 , 4,length(t1) ); %1000X1000 data points, 4 protocols, t1 times to evaluate, 
dTplus=zeros(4,length(t1));
dTminus=zeros(4,length(t1));
prop=[0 0 g p c k_d 0] ;         %anisotropy factor;tissue density,
%specific heat,thermal diffusivity