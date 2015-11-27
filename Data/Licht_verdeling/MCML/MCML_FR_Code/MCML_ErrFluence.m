MCML_Setup_Data
file_path=LD; %Choose what path to use
PL=0.001;%Laser Power [W] (default 0)
IL=1;%irradiance [W/m^2] (default 1)
h=1 ;%1=big scale, 2= small scale
w_L= [0.0000045 0.0001];%1:e^ radius [m]
%v = [1,1];%contourline plot in [mW/mm^2]

dF=zeros(1000,1000,3);
k=1;                                                        %Index for figures
for i = 1: length(L);
    for j=1:length(NA)
        
        fig=figure(k);                                      %make figure k
        %set(fig, 'Position', [10 1000 1400 500]);
        
        
        
        n_L=L(i); n_NA=NA(j);                %Specifying data
        for l=1:3
            [r,z,fRate,filename]=MCML_Data_Err(n_L,n_NA,l,file_path); %Calculation Fluence rate  [mm mm mW/mm^2]
            fRate=fRate.*10^3; %[W/m^2]
            psi=fRate.*((pi*w_L(j)^2)/2).*10^3; %fluence rate corresponding to unit peak irradiance [W/m^2]
            fullfilename=[fullfile(file_path,'Traise','Traise_Data',['Traise_Data_FRU_' filename])];
            csvwrite(fullfilename,psi);
             if ne(PL,0) == 1
                    
                    IL=PL/((pi*w_L(j)^2)/2);
             end
            phi=IL.*psi;%actual fluence rate corresponding to the used peak irradiance [W/m^2]
            
            dF(:,:,l)=phi;%actual fluence rate corresponding to the used peak irradiance [W/m^2]
            
        end
        v=[1,1];
        %fluence rate plot in [mW/mm^2]
        imagesc(r,z,dF(:,:,1).*10^3);c=colorbar;
        hold on
        contour(r,z,dF(:,:,1).*10^-3,v,'color','w')%blue
        hold on
        contour(r,z,dF(:,:,2).*10^-3,v,':','color','w')%green
        hold on 
        contour(r,z,dF(:,:,3).*10^-3,v,'--','color','w')%yellow
        title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
            char(n_NA) ', power=' num2str(PL) ]},'interpreter', 'LaTex');
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        xlim([-0.6 0.6])
        ylim([0 1.5])
       % legend('psi(r,z)','+sigma','-sigma')
        set(gca,'ydir','rev')
       % grid minor
        
        k=k+1;
        
    end
end
