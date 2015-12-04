%-------Setup-------
Puls_Setup_Data
%-------PLOT---------
for i = 1: length(L);
    for j=1:length(NA)
        %--------Data--------------
        n_L=L(i); n_NA=NA(j);
        protocol_name = ['L_' num2str(n_L) '_NA_' num2str(n_NA) ];
        %initialisation times to evaluate for each protocol
        t1=linspace(0,tL,ntss);
        t2=linspace(tL+t1(2),F-t1(2),ntsd); 
        %define tissue properties
        prop(1)=u_a(i);    %absorption coefficient [m^-1]
        prop(2)=u_s(i) ;   %scattering coefficient [m^-1]
        prop(7)=w_L(j);   %1:e^ radius [m]
        
        %Read Fluence rate I=Unit peak irradiance  
        psi=csvread(fullfile(path,protocol_name)); %[W/m^2]
        %Convert psi to Fluence rate phi for the asked Power/Irradiance
        if ne(PL,1) == 1 
        IL=PL/((pi*prop(7)^2)/2);
        end
        %Save all data
        phi=IL.*psi;
        %--------Calculation--------------
        %A loop over all the time windows
        for h= 1:t_w 
            if h==1 %first time window
                for l= 1:length(t1)
                    dT(1,l,k)=t1(l);
                    dT(2,l,k)=Rising(pos, prop, phi, t1(l) ,h);
                end
                for l=length(t1)+1: length(t1)+length(t2)
                    dT(1,l,k)=t2(l-length(t1));
                    dT(2,l,k)=Descending(pos, prop, phi, t2(l-length(t1)),h-1);
                end
            else %other time windows
                %first window is one rising and a sum over the previous
                %descending functions
                %The next one has only descending functions
                
                %rising
                for l= (h-1)*(length(t1)+length(t2))+1:...
                        (h-1)*(length(t1)+length(t2))+length(t1)
                    dT(1,l,k)=t1(l-((h-1)*(length(t1)+length(t2))));
                    dT(2,l,k)=Rising(pos,prop,phi,...
                        t1(l-(h-1)*(length(t1)+length(t2))),h); 
                %sum over previous descending functions
                    for p=1:h-1 
                        dT(2,l,k)=dT(2,l,k)+Descending(pos, prop, phi, ...
                            t1(l-(h-1)*(length(t1)+length(t2))),p-1);
                    end
                    
                end
                %sum over previous descending funcitons
                for l=(h-1)*(length(t1)+length(t2))+length(t1)+1:...
                        (h-1)*(length(t1)+length(t2))+length(t1)+length(t2)
                    dT(1,l,k)=t2(l-((h-1)*...
                        (length(t1)+length(t2))+length(t1)));
                    for p=1:h 
                        dT(2,l,k)=dT(2,l,k)+Descending(pos, prop, ...
                            phi,t2(l-((h-1)*...
                            (length(t1)+length(t2))+length(t1))),p-1);
                    end
                end
            end
            %Move the time one period
            t1=t1+F;
            t2=t2+F; 
        end

        k=k+1;
    end
    
end
fig=figure
set(fig, 'Position', [10 1000 1000 750]);
subplot(2,2,1)
plot(squeeze(dT(1,:,1)),squeeze(dT(2,:,1)))
xlabel('t [s]', 'interpreter', 'LaTex');
ylabel('dT [K]', 'interpreter', 'LaTex');
h=legend(['$\lambda=$' num2str(L(1))...
    ', NA=' num2str(NA(1))]);
set(h,'Interpreter','latex')
set(h,'Box','off')
grid on

subplot(2,2,3)
plot(squeeze(dT(1,:,2)),squeeze(dT(2,:,2)))
ylim([0 0.0010]);
xlabel('t [s]', 'interpreter', 'LaTex');
ylabel('dT [K]', 'interpreter', 'LaTex');
set(gca,'yaxislocation','right');
h=legend(['$\lambda=$' num2str(L(1))...
    ', NA=' num2str(NA(2))]);
set(h,'Interpreter','latex')
set(h,'Box','off')
grid on

subplot(2,2,2)
plot(squeeze(dT(1,:,3)),squeeze(dT(2,:,3)))

xlabel('t [s]', 'interpreter', 'LaTex');
ylabel('dT [K]', 'interpreter', 'LaTex');
h=legend(['$\lambda=$' num2str(L(2))...
    ', NA=' num2str(NA(1))]);
set(h,'Interpreter','latex')
set(h,'Box','off')
grid on
subplot(2,2,4)
plot(squeeze(dT(1,:,4)),squeeze(dT(2,:,4)))

xlabel('t [s]', 'interpreter', 'LaTex');
ylabel('dT [K]', 'interpreter', 'LaTex');
set(gca,'yaxislocation','right');
h=legend(['$\lambda=$' num2str(L(2))...
    ', NA=' num2str(NA(2))]);
set(h,'Interpreter','latex')
set(h,'Box','off')
grid on

shg;
p=mtit('Temperature increase for Pulsed stimulation for' ,...
    'fontsize',24,'interpreter', 'LaTex',...
    'xoff',0,'yoff',.05);

p=mtit( ['$\nu$=' num2str(freq) ' Hz , $t_L$=' num2str(tL) ' s , $I$=' num2str(IL) '$ \frac{W}{m^2}$'],...
    'fontsize',24,'interpreter', 'LaTex',...
    'xoff',0,'yoff',.015);

