%-------Setup-------
Puls_Setup_Data
format long

%-------Fill in-----
path=LD;
pos=[500 2]; %position in the tissue [r z]
tL=0.0005 ; %pulse length [s]
freq=10 ; %frequency of the pulses [s^-1]
time=0.02 ; %total time length
ntss=200; %number of time steps in a puls
ntsd=500; %number of time steps between pulses

%-----Initiations---

F=2*tL; %time between pulses [s]
t_w=floor(time/F); %number of timewindows

t1=linspace(0,tL,ntss); %times to evaluate in one puls
t2=linspace(tL+t1(2),F-t1(2),ntsd); %times to evaluate between pulses
dT=zeros(2, (length(t1)+length(t2))*t_w , 4); %datacollection vector

m=1; %index for the figures
k=1; %index for the protocols
prop=[0 0 g rho c k_d 0] ;         %anisotropy factor;tissue density,
%specific heat,thermal diffusivity
%-------PLOT---------
for i = 1: length(L);
    for j=1:length(NA)
        t1=linspace(0,tL,ntss);
        t2=linspace(tL+t1(2),F-t1(2),ntsd); %have to be initialized for each protocol
        %--------Data Collection--------------
        
        %read in fluence rate
        n_L=L(i); n_NA=NA(j);
        datafile_name = ['MCML_Data_FR_L_' num2str(n_L) '_NA_'...
            num2str(n_NA)];
        phi=csvread(fullfile(path,datafile_name)); %[kW/m^2]
        phi=phi.*10^3; %[W/m^2]
        
        %define tissue properties
        prop(1)=u_a(i);    %absorption coefficient [m^-1]
        prop(2)=u_s(i) ;   %scattering coefficient [m^-1]
        prop(7)=w_L(j);   %1:e^ radius [m]
        
        for h=1:t_w %index for the time windows    
            if h==1 %first time window
                %in the first time window there is one stijgende or one
                %dalende
                for l= 1:length(t1)
                    dT(1,l,k)=t1(l);
                    dT(2,l,k)=Stijgend(pos, prop, phi, t1(l) ,F,h);
                end
                for l=length(t1)+1: length(t1)+length(t2)
                    dT(1,l,k)=t2(l-length(t1));
                    dT(2,l,k)=Dalend(pos, prop, phi, t2(l-length(t1)) , F, tL,h-1);
                end
            else %other time windows
                %in the other time windows there is a sum over all the
                %previous dalende
                for l= (h-1)*(length(t1)+length(t2))+1:(h-1)*(length(t1)+length(t2))+length(t1)
                    dT(1,l,k)=t1(l-((h-1)*(length(t1)+length(t2))));
                    dT(2,l,k)=Stijgend(pos,prop,phi,t1(l-(h-1)*(length(t1)+length(t2))),F,h); %Stijgende
                    for p=1:h-1 %sum over previous dalende
                        dT(2,l,k)=dT(2,l,k)+Dalend(pos, prop, phi, t1(l-(h-1)*(length(t1)+length(t2))) , F, tL,p-1);
                    end
                    
                end
                
                for l=(h-1)*(length(t1)+length(t2))+length(t1)+1: (h-1)*(length(t1)+length(t2))+length(t1)+length(t2)
                    dT(1,l,k)=t2(l-((h-1)*(length(t1)+length(t2))+length(t1)));
                    for p=1:h %sum over previous dalende
                        dT(2,l,k)=dT(2,l,k)+Dalend(pos, prop, phi, t2(l-((h-1)*(length(t1)+length(t2))+length(t1))) , F, tL,p-1);
                    end
                end
            end
            
            t1=t1+F;
            t2=t2+F; %move the time one period
        end

        
        
        figure(m)
         plot(squeeze(dT(1,:,k)),squeeze(dT(2,:,k)))
         title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) ', $\nu$=' num2str(freq) ', $t_L$=' num2str(tL)...
                ]},'interpreter', 'LaTex');
        xlabel('t [s]', 'interpreter', 'LaTex'); 
         ylabel('dT [K]', 'interpreter', 'LaTex')
         
        m=m+1;
        k=k+1;
    end
    
end

%  plot(squeeze(dT(1,:,1)),squeeze(dT(2,:,1)));
%   title('bla');
%  xlabel('t [s]', 'interpreter', 'LaTex'); 
%  ylabel('dT [K]', 'interpreter', 'LaTex');
%  dT(:,:,2)

