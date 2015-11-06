
%-------Setup-------
format long
Traise_Setup_Data

t1=linspace(0,0.00015,50);%times to evaluate[s] for NA=12
t2=linspace(0,1,50); %times to evaluate[s] for NA=37
timesToPlot=[3 20 40];
path=LD; %path
PL=0;%Laser Power [W] (default 0)
IL=350000;%irradiance [W/m^2] (default 1)

%positions in tissue
filename_R=[fullfile(path,'MCML_Data_FR_r')];
filename_Z=[fullfile(path,'MCML_Data_FR_z')];
r=csvread(filename_R);  %radial position[mm]
z=csvread(filename_Z);  %axial position[mm]
%tau=zeros(1,4);

%-----Inistiations---
m=1; %index for the figures
k=1; %index for the protocols
tau=zeros(1,length(L)*length(NA)); %time constants for each protocol
dT=zeros( 1000, 1000 , 4,length(t1) ); %1000X1000 data points, 4 protocols, t1 times to evaluate, 
prop=[0 0 g p c k_d 0] ;         %anisotropy factor;tissue density,
%specific heat,thermal diffusivity
%-------PLOT---------
for i = 1: length(L);
    for j=1:length(NA)
        
        %--------Data Collection--------------
        
        %read in fluence rate
        n_L=L(i); n_NA=NA(j);
        datafile_name = ['MCML_Data_FRU_L_' num2str(n_L) '_NA_'...
            num2str(n_NA) ];
        psi=csvread(fullfile(path,datafile_name)); %[W/m^2]
       
        %define tissue properties
        prop(1)=u_a(i);    %absorption coefficient [m^-1]
        prop(2)=u_s(i) ;   %scattering coefficient [m^-1]
        prop(7)=w_L(j);   %1:e^ radius [m]
        if ne(PL,0) == 1
        IL=PL/((pi*prop(7)^2)/2);
        end
        phi=IL.*psi;%actual fluence rate corresponding to the used peak irradiance
        
        %--------Calculation--------------
        if j==1
            for l=1:length(t1)
                
                %calculate temperature raise
                [dT(:,:,k,l),tau(k)]=Traise_Data(prop,phi,t1(l));
            end
        elseif j==2
            for l=1:length(t2)
                
                %calculate temperature raise
                [dT(:,:,k,l),tau(k)]=Traise_Data(prop,phi,t2(l));
            end
        end
        %--------Plot--------------
        fig=figure(m);
        set(fig, 'Position', [10 1000 1200 2000]);
        % plot temperature raise (color) (K)
        subplot(2,2,1)
        imagesc(r,z,dT(:,:,k,timesToPlot(1))); c=colorbar;
        
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
        
        %scaling
        if j==1
            xlim([-0.3,0.3]);ylim([0,0.6]);
        elseif j==2
            xlim([-1,1]);ylim([0,1.5]);
        end
        
        subplot(2,2,2)
        imagesc(r,z,dT(:,:,k,timesToPlot(2))); c=colorbar;
        
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
        
        %scaling
        if j==1
            xlim([-0.3,0.3]);ylim([0,0.6]);
        elseif j==2
            xlim([-1,1]);ylim([0,1.5]);
        end
        
         subplot(2,2,4)
        imagesc(r,z,dT(:,:,k,timesToPlot(3))); c=colorbar;
        
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
        
        %scaling
        if j==1
            xlim([-0.3,0.3]);ylim([0,0.6]);
        elseif j==2
            xlim([-1,1]);ylim([0,1.5]);
        end
        
        
        subplot(2,2,3)
        if j==1
            hold on
            plot(t1,squeeze(dT(2,500,k,:))); 
           [dtTau extratau]=Traise_Data(prop,phi,tau(k));
            plot(tau(k),dtTau(2,500),'r*');
            hold off
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) '$\tau$=' num2str(extratau)]},...
                'interpreter', 'LaTex');
            xlabel('t [s]', 'interpreter', 'LaTex');
            ylabel('dT[K]', 'interpreter', 'LaTex');
        elseif j==2
            hold on
            plot(t2,squeeze(dT(2,500,k,:)));
            [dtTau extratau]=Traise_Data(prop,phi,tau(k));
            plot(tau(k),dtTau(2,500),'r*');
            hold off
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) , '$\tau$=' num2str(extratau)]},...
                'interpreter', 'LaTex');
            xlabel('t [s]', 'interpreter', 'LaTex');
            ylabel('dT[K]', 'interpreter', 'LaTex');
        end
        
        m=m+1;
        k=k+1;
        
    end
end