%-------Setup-------
Puls_Setup_Data
format long

%-------Fill in-----
path=LD;
pos=[2 500]; %position in the tissue [z r]
tL=0.001; %pulse length [s]
freq=40; %frequency of the pulses [s^-1]
time=0.2; %total time length
ntss=400; %number of time steps in a puls
ntsd=500; %number of time steps between pulses
PL=1;%Laser Power [W] (default 1)
IL=46000;%irradiance [W/m^2] (default 1)
%-----Initiations---

F=1/freq; %time between pulses [s]
t_w=floor(time/F); %number of timewindows

t1=linspace(0,tL,ntss); %times to evaluate in one puls
t2=linspace(tL+t1(2),F-t1(2),ntsd); %times to evaluate between pulses
dT=zeros(2, (length(t1)+length(t2))*t_w , 4); %datacollection vector


k=1; %index for the protocols
prop=[0 0 g rho c k_d 0 tL F] ;         %anisotropy factor;tissue density,
%specific heat,thermal diffusivity, pulse length [s], time between pulses
%[s]
%-------PLOT---------
for i = 1: length(L);
    for j=1:length(NA)
        t1=linspace(0,tL,ntss);
        t2=linspace(tL+t1(2),F-t1(2),ntsd); %have to be initialized for each protocol
        %--------Data Collection--------------
        
        %read in fluence rate
        n_L=L(i); n_NA=NA(j);
        
        datafile_name = ['MCML_Data_FRU_L_' num2str(n_L) '_NA_'...
            num2str(n_NA)];
        psi=csvread(fullfile(path,datafile_name)); %fluence rate corresponding to unit peak irradiance [W/m^2]
        
       
        
        
        %define tissue properties
        prop(1)=u_a(i);    %absorption coefficient [m^-1]
        prop(2)=u_s(i) ;   %scattering coefficient [m^-1]
        prop(7)=w_L(j);   %1:e^ radius [m]
       
        if ne(PL,1) == 1 %your input irradiance depends on the power
        IL=PL/((pi*prop(7)^2)/2);
        end
        
        phi=IL.*psi;%actual fluence rate corresponding to the used peak irradiance
        
        for h= 1:t_w %index for the time windows    
            if h==1 %first time window
                %in the first time window there is one stijgende or one
                %dalende
                
                for l= 1:length(t1)
                    dT(1,l,k)=t1(l);
                    dT(2,l,k)=Stijgend(pos, prop, phi, t1(l) ,h);
                end
                for l=length(t1)+1: length(t1)+length(t2)
                    dT(1,l,k)=t2(l-length(t1));
                    dT(2,l,k)=Dalend(pos, prop, phi, t2(l-length(t1)),h-1);
                end
            else %other time windows
                %in the other time windows there is a sum over all the
                %previous dalende
                
                for l= (h-1)*(length(t1)+length(t2))+1:(h-1)*(length(t1)+length(t2))+length(t1)
                    dT(1,l,k)=t1(l-((h-1)*(length(t1)+length(t2))));
                    dT(2,l,k)=Stijgend(pos,prop,phi,t1(l-(h-1)*(length(t1)+length(t2))),h); %Stijgende
                    for p=1:h-1 %sum over previous dalende
                        dT(2,l,k)=dT(2,l,k)+Dalend(pos, prop, phi, t1(l-(h-1)*(length(t1)+length(t2))),p-1);
                    end
                    
                end
                
                for l=(h-1)*(length(t1)+length(t2))+length(t1)+1: (h-1)*(length(t1)+length(t2))+length(t1)+length(t2)
                    dT(1,l,k)=t2(l-((h-1)*(length(t1)+length(t2))+length(t1)));
                    for p=1:h %sum over previous dalende
                        dT(2,l,k)=dT(2,l,k)+Dalend(pos, prop, phi, t2(l-((h-1)*(length(t1)+length(t2))+length(t1))),p-1);
                    end
                end
            end
            
            t1=t1+F;
            t2=t2+F; %move the time one period
        end

        k=k+1;
    end
    
end
fig=figure
%set(fig, 'Position', [10 1000 1000 750]);
% subplot(2,2,1)
% plot(squeeze(dT(1,:,1)),squeeze(dT(2,:,1)))
% xlabel('t [s]', 'interpreter', 'LaTex');
% ylabel('dT [K]', 'interpreter', 'LaTex');
% h=legend(['$\lambda=$' num2str(L(1))...
%     ', NA=' num2str(NA(1))]);
% set(h,'Interpreter','latex')
% set(h,'Box','off')
% grid on

%subplot(2,2,3)
% plot(squeeze(dT(1,:,2)),squeeze(dT(2,:,2)))
% ylim([0 0.0010]);
% xlabel('t [s]', 'interpreter', 'LaTex');
% ylabel('dT [K]', 'interpreter', 'LaTex');
% set(gca,'yaxislocation','right');
% h=legend(['$\lambda=$' num2str(L(1))...
%     ', NA=' num2str(NA(2))]);
% set(h,'Interpreter','latex')
% set(h,'Box','off')
% grid on

% subplot(2,2,2)
% plot(squeeze(dT(1,:,3)),squeeze(dT(2,:,3)))
% 
% xlabel('t [s]', 'interpreter', 'LaTex');
% ylabel('dT [K]', 'interpreter', 'LaTex');
% h=legend(['$\lambda=$' num2str(L(2))...
%     ', NA=' num2str(NA(1))]);
% set(h,'Interpreter','latex')
% set(h,'Box','off')
% grid on
%subplot(2,2,4)
plot(squeeze(dT(1,:,4)),squeeze(dT(2,:,4)))

xlabel('t [s]', 'interpreter', 'LaTex');
ylabel('dT [K]', 'interpreter', 'LaTex');
set(gca,'yaxislocation','right');
h=legend(['$\lambda=$' num2str(L(2))...
    ', NA=' num2str(NA(2))]);
set(h,'Interpreter','latex')
set(h,'Box','off')
grid on
% 
% shg;
% p=mtit('Temperature increase for Pulsed stimulation for' ,...
%     'fontsize',24,'interpreter', 'LaTex',...
%     'xoff',0,'yoff',.05);
% 
% p=mtit( ['$\nu$=' num2str(freq) ' Hz , $t_L$=' num2str(tL) ' s , $I$=' num2str(IL) '$ \frac{W}{m^2}$'],...
%     'fontsize',24,'interpreter', 'LaTex',...
%     'xoff',0,'yoff',.015);

