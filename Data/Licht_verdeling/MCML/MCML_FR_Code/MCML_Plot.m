MCML_Setup_Data
file_path=LD; %Choose what path to use
PL=0.001;%Laser Power [W] (default 0)
IL=1;%irradiance [W/m^2] (default 1)
h=1 ;%1=big scale, 2= small scale
w_L= [0.0000045 0.0001];%1:e^ radius [m]
v = [1000,1000]; %contourline plot in [W/m^2]

dF=zeros(1000,1000,3);
k=1; m=1 ;                                                      %Index for figures
for i = 1: length(L);
    for j=1:length(NA)
        
        fig=figure(k);                                      %make figure k
        
        n_L=L(i); n_NA=NA(j);                %Specifying data
        protocol_name = ['L_' char(L) '_NA_' char(NA) ]; 
        
        for l=1:3
            [r,z,fRate,filename]=MCML_Data(n_L,n_NA,l,file_path,protocol_name); %Calculation Fluence rate  [mm mm W/m^2]
            psi=fRate.*((pi*w_L(j)^2)/2).*10^3; %fluence rate corresponding to unit peak irradiance [W/m^2]
            %write the data for psi 
            fullfilename=[fullfile(file_path,'UnitFR', filename)];
            filename_r=[fullfile(file_path,'FR_r')];
            filename_z=[fullfile(file_path,'FR_z')];
            csvwrite(fullfilename,psi);
            csvwrite(filename_r, r);
            csvwrite(filename_z, z);
            
            %make the correct conversion for the asked protocol
             if ne(PL,0) == 1
                    
                    IL=PL/((pi*w_L(j)^2)/2);
             end
            phi=IL.*psi;%actual fluence rate corresponding to the used peak irradiance [W/m^2]
            %save in SI units
            dF(:,:,l)=phi;%actual fluence rate corresponding to the used peak irradiance [W/m^2]
            
        end
        %fluence rate plot in [mW/mm^2]
        v=v.*10^-3;
        
        imagesc(r,z,dF(:,:,1).*10^-3);c=colorbar;
        hold on
        
        [C, h]=contour(r,z,dF(:,:,1).*10^-3,v,'color','w');%blue
        x=C(2,2:Iy_0);
        y=C(1,2:Iy_0);
        hold on
        
        [Cplus, hpuls]=contour(r,z,dF(:,:,2).*10^-3,v,':','color','w');%
        xplus=Cplus(2,2:Iy_0plus);
        yplus=Cplus(1,2:Iy_0plus);
        hold on 
        
        [Cminus, hminus]=contour(r,z,dF(:,:,3).*10^-3,v,'--','color','w');%yellow
        xminus=Cminus(2,2:Iy_0minus);
        yminus=Cminus(1,2:Iy_0minus);
        
        title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
            char(n_NA) ', Input Irradiance=' num2str(IL) ]},'interpreter', 'LaTex');
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        c.Label.String= '$\phi(r,z)$ [$mW \cdot mm^{-2}$]';
        c.Label.Interpreter='latex';
        xlim([-0.6 0.6])
        ylim([0 1.5])
        legend('psi(r,z)','+sigma','-sigma')
        set(gca,'ydir','rev')

       imagename=[fullfile(file_path,'gfx','I_',char(I_L),'FR_',protocol_name)];
       print(imagename,'png');
        
       
       if j==1
        s=find(C(1,:)==1,2)
        [y_0,Iy_0]=max(C(2,2:s(length(s))-1));
        elseif j==2
         [y_0,Iy_0]=max(C(2,2:length(C(1,:)))); 
       end
        
       if j==1
        s=find(Cplus(1,:)==1,2)
        [y_0plus,Iy_0plus]=max(Cplus(2,2:s(length(s))-1));
        elseif j==2
        [y_0plus,Iy_0plus]=max(Cplus(2,2:length(Cplus(1,:))));   
       end
        
       if j==1
        s=find(Cminus(1,:)==1,2)
        [y_0minus,Iy_0minus]=max(Cminus(2,2:s(length(s))-1));
        elseif j==2
        [y_0minus,Iy_0minus]=max(Cminus(2,2:length(Cminus(1,:))));  
        end
        
        k=k+1;
        figure(k)
        if j==1 g=4
        elseif j==2 g=3
        end
            plot(x,y,'--','color','k')
            hold on
            p=polyfit(x,y,g);
            plot(x, polyval(p,x),'color','k');
            fun=@(t) pi*(polyval(p,t)).^2;
            int=integral(fun,x(1),x(length(x)))
    
            plot(xplus,yplus,'--','color','r');
            
            pplus=polyfit(xplus,yplus,g);
            plot(xplus, polyval(pplus,xplus),'color','r');
            fun=@(t) pi*(polyval(pplus,t)).^2;
            intplus=integral(fun,xplus(1),xplus(length(xplus)))
            
            plot(xminus,yminus,'--','color','b');
            
            pminus=polyfit(xminus,yminus,g);
            plot(xminus, polyval(pminus,xminus),'color','b');
            fun=@(t) pi*(polyval(pminus,t)).^2;
            intminus=integral(fun,xminus(1),xminus(length(xminus)))
            hold off
       k=k+1; 
       m=m+1;
    end
end
