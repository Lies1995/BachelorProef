%------Setup--------
    close all
    % Change default text font size
        set(0,'DefaultAxesFontSize', 18)
    %File Path
        LD = '/Users/LIesDeceuninck/Documents/BachelorProef/Data/Licht_verdeling/Code/Data';
        HV= 'C:\Users\hannelore\Documents\2015-2016\BachelorProef2015\BachelorProef\Data\Licht_verdeling\Code\Data'; 
    %Choose what path to use
        file_path=LD; 
%------DATA--------
    %Wavelengths(nm)
        L = [474,560]; 
    %Numerical Aperture (dimensionless)
        NA = [12,37];  
    %Diameter (mum)
        d = [9,200];
    %1/e^2 radius [m]
        w_L= [0.0000045 0.0001];

    %Choose the stimulation, specify either the input power or the input
    %irradiace. Set the other to the default value
    %Laser Power [W] (default 0)
        PL=0.001;
    %Irradiance [W/m^2] (default 1)
        IL=1;  
    %Value contourline [mW/mm^2] (plots will be in mW/mm^2)
        v = [1,1];
    %Polynomial degree of contourfit
        g=3 ;
%------Initiations-------- 
    %Vector to store Fluence Rates
    dF=zeros(1000,1000,3);
    %Index for figures
    k=1;  