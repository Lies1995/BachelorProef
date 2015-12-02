MCML_Setup_Data
                                                    
for i = 1: length(L);
    for j=1:length(NA)
        %------DATA--------
        n_L=L(i); n_NA=NA(j);               
        protocol_name = ['L_' num2str(n_L) '_NA_' num2str(n_NA) ];
        %------Calculation--------
        for l=1:3
            %Calc. Fluence rate  [mm mm W/m^2]
            [r,z,fRate,filename]=...
                MCML_Data(n_L,n_NA,file_path,protocol_name,l); 
            %Calc. Fluence rate I=Unit peak irradiance  
            psi=fRate.*((pi*w_L(j)^2)/2).*10^3; 
            %Convert psi to Fluence rate phi for the asked Power/Irradiance
            if ne(PL,0) == 1
                IL=PL/((pi*w_L(j)^2)/2);
            end
            phi=IL.*psi;
            
            %Save all data
            dF(:,:,l)=phi; %[W/m^2]
            
            fullfilename=[fullfile(file_path,'UnitFR', filename)];
            filename_r=[fullfile(file_path,'FR_r')];
            filename_z=[fullfile(file_path,'FR_z')];
            csvwrite(fullfilename,psi); %[W/m^2]
            csvwrite(filename_r, r);%[mm]
            csvwrite(filename_z, z);%[mm]
        end
        %------Plot--------
        %Change units
        dF(:,:,:)=dF(:,:,:).*10^-3; %[mW/mm^2]
        
        fig=figure(k); 
        hold on
        %Colorgraph
        imagesc(r,z,dF(:,:,1));c=colorbar; 
        
        %Contourlines
        [C, h]=contour(r,z,dF(:,:,1),v,'color','w');
        [Cplus, hpuls]=contour(r,z,dF(:,:,2),v,'--','color','w');
        [Cminus, hminus]=contour(r,z,dF(:,:,3),v,':','color','w');
        
        title({'Fluence Rate';['$\lambda=$' num2str(n_L) ', NA=' ...
            num2str(n_NA) ', Input Irradiance=' num2str(IL) ]},...
            'interpreter', 'LaTex');
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        c.Label.String= '$\phi(r,z)$ [$mW \cdot mm^{-2}$]';
        c.Label.Interpreter='latex';
        c.Label.FontSize=20;
        
        xlim([-0.6 0.6])
        ylim([0 1.5])
        set(gca,'ydir','rev')
        hold off
        
        %------Calculation Stimulated Volume--------
        %Collect the datapoints of the concerning contourline
        if j==1
            s=find(C(1,:)==1,2)
            [y_0,Iy_0]=max(C(2,2:s(length(s))-1));
            s=find(Cplus(1,:)==1,2)
            [y_0plus,Iy_0plus]=max(Cplus(2,2:s(length(s))-1));
             s=find(Cminus(1,:)==1,2)
            [y_0minus,Iy_0minus]=max(Cminus(2,2:s(length(s))-1));
        elseif j==2
            [y_0,Iy_0]=max(C(2,2:length(C(1,:))));
            [y_0plus,Iy_0plus]=max(Cplus(2,2:length(Cplus(1,:))));
            s=find(Cminus(1,:)==1,2)
            [y_0minus,Iy_0minus]=max(Cminus(2,2:s(length(s))-1));
        end
        %Rotate the graph 90degrees
        x=C(2,2:Iy_0);
        y=C(1,2:Iy_0);
        
        xplus=Cplus(2,2:Iy_0plus);
        yplus=Cplus(1,2:Iy_0plus);
 
        xminus=Cminus(2,2:Iy_0minus);
        yminus=Cminus(1,2:Iy_0minus);
        
        %Fit with a polynomial of degree g
        p=polyfit(x,y,g);
        fun=@(t) pi*(polyval(p,t)).^2;
        int=integral(fun,x(1),x(length(x)))
        
        pplus=polyfit(xplus,yplus,g);
        fun=@(t) pi*(polyval(pplus,t)).^2;
        intplus=integral(fun,xplus(1),xplus(length(xplus)))
        
        pminus=polyfit(xminus,yminus,g);
        fun=@(t) pi*(polyval(pminus,t)).^2;
        intminus=integral(fun,xminus(1),xminus(length(xminus)))
        
        
        %Uncomment this section if you want to check the polynomal fit
        %------Plot polynomial fit--------
%         k=k+1;
%         figure(k)
%         plot(x,y,'--','color','k')
%         hold on
%         plot(x, polyval(p,x),'color','k');
%         
%         plot(xplus,yplus,'--','color','r');
%         plot(xplus, polyval(pplus,xplus),'color','r');
%      
%         plot(xminus,yminus,'--','color','b');
%         plot(xminus, polyval(pminus,xminus),'color','b');
%       
%       hold off
        k=k+1;
    end
end
