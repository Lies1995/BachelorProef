MCML_Setup_Data
file_path=LD; %Choose what path to use
PL=0.001;%Laser Power [W] (default 0)
IL=1;%irradiance [W/m^2] (default 1)
h=1 ;%1=big scale, 2= small scale
w_L= [0.0000045 0.0001];%1:e^ radius [m]
%v = [1,1];%contourline plot in [mW/mm^2]

dF=zeros(1000,1000,3);
k=1; m=1                                                       %Index for figures
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
        
        imagesc(r,z,dF(:,:,1).*10^-3);c=colorbar;
        hold on
        [C, h]=contour(r,z,dF(:,:,1).*10^-3,v,'color','w');%blue
        if j==1
        s=find(C(1,:)==1,2)
        [y_0,Iy_0]=max(C(2,2:s(length(s))-1));
        elseif j==2
         [y_0,Iy_0]=max(C(2,2:length(C(1,:)))); 
        end
        %if j==1 Iy_0=Iy_0-10; end
        x=C(2,2:Iy_0);
        y=C(1,2:Iy_0);
        hold on
        [Cplus, hpuls]=contour(r,z,dF(:,:,2).*10^-3,v,':','color','w');%
        if j==1
        s=find(Cplus(1,:)==1,2)
        [y_0plus,Iy_0plus]=max(Cplus(2,2:s(length(s))-1));
        elseif j==2
        [y_0plus,Iy_0plus]=max(Cplus(2,2:length(Cplus(1,:))));   
        end
        
        %if j==1 Iy_0plus=Iy_0plus-10; end
        xplus=Cplus(2,2:Iy_0plus);
        yplus=Cplus(1,2:Iy_0plus);
        hold on 
        [Cminus, hminus]=contour(r,z,dF(:,:,3).*10^-3,v,'--','color','w');%yellow
        if j==1
        s=find(Cminus(1,:)==1,2)
        [y_0minus,Iy_0minus]=max(Cminus(2,2:s(length(s))-1));
        elseif j==2
        [y_0minus,Iy_0minus]=max(Cminus(2,2:length(Cminus(1,:))));  
        end
       % if j==1 Iy_0minus=Iy_0minus-10; end
        xminus=Cminus(2,2:Iy_0minus);
        yminus=Cminus(1,2:Iy_0minus);
        title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
            char(n_NA) ', power=' num2str(PL) ]},'interpreter', 'LaTex');
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        xlim([-0.6 0.6])
        ylim([0 1.5])
        legend('psi(r,z)','+sigma','-sigma')
        set(gca,'ydir','rev')
       % grid minor
        
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
