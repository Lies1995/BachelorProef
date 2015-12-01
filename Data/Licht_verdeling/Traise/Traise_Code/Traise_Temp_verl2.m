%-------Setup-------
format long
Traise_Setup_Data

t1=linspace(0,0.000075,50);%times to evaluate[s] for NA=12
t2=linspace(0,0.040,50); %times to evaluate[s] for NA=37
timesToPlot=[2 16 47];
path=LD; %path
PL=0.001;%Laser Power [W] (default 0)
IL=100000;%irradiance [W/m^2] (default 1)
v=[1000, 1000];
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
dTplus=zeros(4,length(t1));
dTminus=zeros(4,length(t1));
prop=[0 0 g p c k_d 0] ;         %anisotropy factor;tissue density,
%specific heat,thermal diffusivity
%-------PLOT---------
for i = 1: length(L);
    for j=1:length(NA)
        
        %--------Data Collection--------------
        
        %read in fluence rate
        n_L=L(i); n_NA=NA(j);
        datafile_name = ['Traise_Data_FRU_L_' num2str(n_L) '_NA_'...
            num2str(n_NA) ];
        %% 
        datafile_name_plus = ['Traise_Data_FRU_L_' num2str(n_L) '_NA_' ...
            num2str(n_NA) '+sigma' ];
        datafile_name_minus = ['Traise_Data_FRU_L_' num2str(n_L) '_NA_' ...
            num2str(n_NA) '-sigma' ];
        psi=csvread(fullfile(path,datafile_name)); %[W/m^2]
        psiplus=csvread(fullfile(path,datafile_name_plus));
        psiminus=csvread(fullfile(path,datafile_name_minus));
        %define tissue properties
        prop(1)=u_a(i);    %absorption coefficient [m^-1]
        prop(2)=u_s(i) ;   %scattering coefficient [m^-1]
        prop(7)=w_L(j);   %1:e^ radius [m]
        if ne(PL,0) == 1
        IL=PL/((pi*prop(7)^2)/2);
        end
        phi=IL.*psi;%actual fluence rate corresponding to the used peak irradiance [W/m^2]
        phiplus=IL.*psiplus;
        phiminus=IL.*psiminus;
        %--------Calculation--------------
        du_a_plus=[34.9, 55.9];
        du_a_minus=[-34.9, -52.5];
        du_s_plus=[3267, 3558];
        du_s_minus=[-3267, -3492];
        if j==1
            for l=1:length(t1)
                
                %calculate temperature raise
                [dT(:,:,k,l),tau(k)]=Traise_Data(prop,phi,t1(l));
                if i==1
                dTplus(k,l)=dTError2(phiplus(2,500),du_a_plus(i),du_s_minus(i),prop,t1(l));
                dTminus(k,l)=dTError2(phiminus(2,500),du_a_minus(i),du_s_plus(i),prop,t1(l));
                elseif i==2
                dTplus(k,l)=dTError2(phiplus(2,500),du_a_plus(i),du_s_plus(i),prop,t1(l));
                dTminus(k,l)=dTError2(phiminus(2,500),du_a_minus(i),du_s_minus(i),prop,t1(l));
                end
            end
        elseif j==2
            for l=1:length(t2)
                
                %calculate temperature raise
                [dT(:,:,k,l),tau(k)]=Traise_Data(prop,phi,t2(l));
                if i==1
                 dTplus(k,l)=dTError2(phiplus(2,500),du_a_plus(i),du_s_minus(i),prop,t2(l));
                 dTminus(k,l)=dTError2(phiminus(2,500),du_a_minus(i),du_s_plus(i),prop,t2(l));
                elseif i==2
                 dTplus(k,l)=dTError2(phiplus(2,500),du_a_plus(i),du_s_plus(i),prop,t2(l));
                 dTminus(k,l)=dTError2(phiminus(2,500),du_a_minus(i),du_s_minus(i),prop,t2(l));
                end
                
            end
        end
        m=m+1;
        k=k+1;
        
    end
end
figure(1)
hold on
            plot(t1,squeeze(dT(2,500,1,:)),'Color',hex2rgb('352A86'));
            plot(t1,dTplus(1,:),'--','color',hex2rgb('124BB2'))
            plot(t1,dTminus(1,:),'--','color',hex2rgb('124BB2'))
           %[dtTau1 extratau]=Traise_Data([u_a(1) u_s(1) g p c k_d w_L(1)],phi,tau(1));
            plot(tau(1),0,'r*');
            
            plot(t1,squeeze(dT(2,500,3,:)),'Color',hex2rgb('f1b94a'));
            plot(t1,dTplus(3,:),'--','color',hex2rgb('B27A00'))
            plot(t1,dTminus(3,:),'--','color',hex2rgb('B27A00'))
          % [dtTau3 extratau]=Traise_Data([u_a(2) u_s(2) g p c k_d w_L(1)],phi,tau(3));
            plot(tau(3),0,'b*');
            hold off
           
            xlabel('t [s]', 'interpreter', 'LaTex');
            ylabel('dT[K]', 'interpreter', 'LaTex');
figure(2)
hold on
            plot(t2,squeeze(dT(2,500,2,:)),'Color',hex2rgb('352A86'));
            plot(t2,dTplus(2,:),'--','color',hex2rgb('124BB2'))
            plot(t2,dTminus(2,:),'--','color',hex2rgb('124BB2'))
          % [dtTau2 extratau]=Traise_Data([u_a(1) u_s(1) g p c k_d w_L(2)],phi,tau(2));
            plot(tau(2),0,'r*');
            
            plot(t2,squeeze(dT(2,500,4,:)),'Color',hex2rgb('f1b94a')); 
            plot(t2,dTplus(4,:),'--','color',hex2rgb('B27A00'))
            plot(t2,dTminus(4,:),'--','color',hex2rgb('B27A00'))
           %[dtTau4 extratau]=Traise_Data([u_a(2) u_s(2) g p c k_d w_L(2)],phi,tau(4));
            plot(tau(4),0,'b*');
            hold off
           
            xlabel('t [s]', 'interpreter', 'LaTex');
            ylabel('dT[K]', 'interpreter', 'LaTex');
            
            
            
            
            