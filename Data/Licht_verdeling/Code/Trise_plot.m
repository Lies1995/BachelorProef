format long
Trise_Setup_Data
for i = 1: length(L);
    for j=1:length(NA)
        
        %--------Data--------------
        n_L=L(i); n_NA=NA(j);
        protocol_name = ['L_' num2str(n_L) '_NA_' num2str(n_NA) ];
        %define tissue properties
        prop(1)=u_a(i);    %absorption coefficient [m^-1]
        prop(2)=u_s(i) ;   %scattering coefficient [m^-1]
        prop(7)=w_L(j);   %1:e^ radius [m]
      
        %Read Fluence rate I=Unit peak irradiance  
        psi=csvread(fullfile(path,'UnitFR',protocol_name)); %[W/m^2]
        %Fluence rate +u_a
        psiplus=csvread(fullfile(path,'UnitFR',[protocol_name '+u_a+u_s']));
        %Fluence rate -u_a
        psiminus=csvread(fullfile(path,'UnitFR',[protocol_name '-u_a-u_s']));
        %Convert psi to Fluence rate phi for the asked Power/Irradiance
        if ne(PL,0) == 1
        IL=PL/((pi*prop(7)^2)/2);
        end
        %Save all data
        phi=IL.*psi;
        phiplus=IL.*psiplus; 
        phiminus=IL.*psiminus;
        
        %--------Calculation--------------
        if j==1
            for l=1:length(t1)
                
                %Calc. Temperature increade
                [dT(:,:,k,l), tau(k)]=Trise_Data(phi,0,0,prop,t1(l));
                
                [dTplus(k,l) p]=Trise_Data(phiplus(2,500),du_a_plus(i),...
                    du_s_plus(i),prop,t1(l));
                [dTminus(k,l), p]=Trise_Data(phiminus(2,500),du_a_minus(i),...
                    du_s_minus(i),prop,t1(l));
               
            end
        elseif j==2
            for l=1:length(t2)
                
                %calculate temperature raise
                [dT(:,:,k,l), tau(k)]=Trise_Data(phi,0,0,prop,t2(l));
                
                 [dTplus(k,l),p]=Trise_Data(phiplus(2,500),du_a_plus(i),...
                     du_s_plus(i),prop,t2(l));
                [dTminus(k,l),p]=Trise_Data(phiminus(2,500),du_a_minus(i),...
                     du_s_minus(i),prop,t2(l));
               
                
            end
        end
        figure(m);
        imagesc(r,z,dT(:,:,k,timesToPlot(1))); c=colorbar;
        
        %scaling
        if j==1
            xlim([-0.25,0.25]);ylim([0,0.6]);
        elseif j==2
            xlim([-0.5,0.5]);ylim([0,1]);
        end
        if i==1 && j==1
            caxis([0 0.001]);
        elseif i==1 && j==2
            caxis([0 0.012]);
        elseif i==2 && j==1
            caxis([0 0.002]);
        elseif i==2 && j==2
            caxis([0 0.025]);
        end

        %labels
        if j==1
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) ', t=' ...
                num2str(t1(timesToPlot(1)))]},'interpreter', 'LaTex');
        elseif j==2
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) '; t='...
                num2str(t2(timesToPlot(1)))]},'interpreter', 'LaTex');
        end
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        c.Label.String= '$dT$ [$K$]';
        c.Label.FontSize=20;
        c.Label.Interpreter='latex';
        

        %------------------------------------------------------------------    
        m=m+1  ;     
        figure(m);
        imagesc(r,z,dT(:,:,k,timesToPlot(2))); c=colorbar;
         %scaling
        if j==1
            xlim([-0.25,0.25]);ylim([0,0.6]);
        elseif j==2
            xlim([-0.5,0.5]);ylim([0,1]);
        end
        if i==1 && j==1
            caxis([0 0.001]);
        elseif i==1 && j==2
            caxis([0 0.012]);
        elseif i==2 && j==1
            caxis([0 0.002]);
        elseif i==2 && j==2
            caxis([0 0.025]);
        end

        %labels
        if j==1
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) ', t=' ...
                num2str(t1(timesToPlot(2)))]},'interpreter', 'LaTex');
        elseif j==2
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) '; t='...
                num2str(t2(timesToPlot(2)))]},'interpreter', 'LaTex');
        end
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        c.Label.String= '$dT$ [$K$]';
        c.Label.FontSize=20;
        c.Label.Interpreter='latex';

        %------------------------------------------------------------------        
        m=m+1;       
        fig=figure(m);
        imagesc(r,z,dT(:,:,k,timesToPlot(3))); c=colorbar;
          %scaling
        if j==1
            xlim([-0.25,0.25]);ylim([0,0.6]);
        elseif j==2
            xlim([-0.5,0.5]);ylim([0,1]);
        end
        if i==1 && j==1
            caxis([0 0.001]);
        elseif i==1 && j==2
            caxis([0 0.012]);
        elseif i==2 && j==1
            caxis([0 0.002]);
        elseif i==2 && j==2
            caxis([0 0.025]);
        end

        %labels
        if j==1
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) ', t=' ...
                num2str(t1(timesToPlot(3)))]},'interpreter', 'LaTex');
        elseif j==2
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) '; t='...
                num2str(t2(timesToPlot(3)))]},'interpreter', 'LaTex');
        end
        xlabel('r [mm]', 'interpreter', 'LaTex');
        ylabel('z [mm]', 'interpreter', 'LaTex');
        c.Label.String= '$dT$ [$K$]';
        c.Label.FontSize=20;
        c.Label.Interpreter='latex';
        
        m=m+1;
        k=k+1;
        
        
    end
end
%------Plot--------
figure(m)
hold on
            plot(t1,squeeze(dT(2,500,1,:)),'Color',hex2rgb('352A86'));
            plot(t1,dTplus(1,:),'*','color',hex2rgb('352A86'))
            plot(t1,dTminus(1,:),'--','color',hex2rgb('352A86'))
           %[dtTau1 extratau]=Traise_Data([u_a(1) u_s(1) g p c k_d w_L(1)],phi,tau(1));
            plot(tau(1),0,'r*');
            
            plot(t1,squeeze(dT(2,500,3,:)),'Color',hex2rgb('f1b94a'));
            plot(t1,dTplus(3,:),'*','color',hex2rgb('B27A00'))
            plot(t1,dTminus(3,:),'--','color',hex2rgb('B27A00'))
          % [dtTau3 extratau]=Traise_Data([u_a(2) u_s(2) g p c k_d w_L(1)],phi,tau(3));
            plot(tau(3),0,'b*');
            hold off
           
            xlabel('t [s]', 'interpreter', 'LaTex');
            ylabel('dT[K]', 'interpreter', 'LaTex');
m=m+1;
figure(m)
hold on
            plot(t2,squeeze(dT(2,500,2,:)),'Color',hex2rgb('352A86'));
            plot(t2,dTplus(2,:),'*','color',hex2rgb('124BB2'))
            plot(t2,dTminus(2,:),'--','color',hex2rgb('124BB2'))
          % [dtTau2 extratau]=Traise_Data([u_a(1) u_s(1) g p c k_d w_L(2)],phi,tau(2));
            plot(tau(2),0,'r*');
            
            plot(t2,squeeze(dT(2,500,4,:)),'Color',hex2rgb('f1b94a')); 
            plot(t2,dTplus(4,:),'*','color',hex2rgb('B27A00'))
            plot(t2,dTminus(4,:),'--','color',hex2rgb('B27A00'))
           %[dtTau4 extratau]=Traise_Data([u_a(2) u_s(2) g p c k_d w_L(2)],phi,tau(4));
            plot(tau(4),0,'b*');
            hold off
           
            xlabel('t [s]', 'interpreter', 'LaTex');
            ylabel('dT[K]', 'interpreter', 'LaTex');          
m=m+1 

           
            
            
            