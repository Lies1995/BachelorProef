MCML_Setup_Data
file_path=LD; %Choose what path to use
PL=0.001;%Laser Power [W] (default 0)
IL=1;%irradiance [W/m^2] (default 1)
h=1 ;%1=big scale, 2= small scale
w_L= [0.0000045 0.0001];%1:e^ radius [m]
v = [1,1];%contourline plot in [mW/mm^2]

dF=zeros(10000,10000,2)
k=1;                                                        %Index for figures
for i = 1: length(L);
    for j=1:length(NA)
        
        fig=figure(k);                                      %make figure k
        %set(fig, 'Position', [10 1000 1400 500]);
        
        
        
        n_L=L(i); n_NA=NA(j);                %Specifying data
        for l=1:2
            [r,z,fRate,filename]=MCML_Data_Err(n_L,n_NA,l,file_path,h); %Calculation Fluence rate  [mm mm mW/mm^2]
            fRate=fRate.*10^3; %[W/m^2]
            psi=fRate.*((pi*w_L(j)^2)/2).*10^3; %fluence rate corresponding to unit peak irradiance [W/m^2]
            
            if ne(PL,0) == 1
                
                IL=PL/((pi*w_L(j)^2)/2);
            end
            
            dF(:,:,l)=IL.*psi;%actual fluence rate corresponding to the used peak irradiance [W/m^2]
            
        end
        
        
        contour(r,z,dF(:,:,1).*10^-3,v,'color','k')
        hold on
        contour(r,z,dF(:,:,2).*10^-3,v,'color','k')
        title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
            char(n_NA) ', power=' num2str(PL) ]},'interpreter', 'LaTex');
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        set(gca,'ydir','rev')
        
        
        k=k+1;
        
    end
end
