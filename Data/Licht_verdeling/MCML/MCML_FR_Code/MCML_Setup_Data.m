%------Setup--------
    close all
    % Change default text font size
        set(0,'DefaultAxesFontSize', 18)
    %File Path
        LD = '/Users/LIesDeceuninck/Documents/github/BachelorProef/Data/Licht_verdeling/MCML_Sim/Output';
        HV= 'C:\Users\hannelore\Documents\2015-2016\BachelorProef\Data\Licht_verdeling\MCML_Sim\Output';                                  
%------DATA--------
    %Wavelengths(nm)
        L = {'474';'560'}; 
    %Numerical Aperture (dimensionless)
        NA = {'12';'37'};  
    %Diameter (mum)
        d = {'9';'200'};    
    