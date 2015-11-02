%-------Setup-------
Puls_Setup_Data

path=HV;
tL= ; %pulse length [s]
freq= ; %frequency of the pulses [s^-1]
time= ; %total time length 
timesteps= ;%number of time steps

F=1/freq; %time between pulses [s]
t= linspace(0,time,timesteps);
stepsize=time/(timesteps-1);%length of one time step

% %------Calculation of l------
% l=floor(time/F)*2; %number of subsections for which a different function is needed
% remainder=rem(time,F);
% if (remainder==0)
%     l=l;
% elseif (remainder < tL)
%     l=l+1;
% else
%     l=l+2;
% end

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
dT=zeros( 1000, 1000 , 4,length(t) ); %1000X1000 data points, 4 protocols, t1 times to evaluate, 
prop=[0 0 g p c k_d 0] ;         %anisotropy factor;tissue density,
%specific heat,thermal diffusivity
%-------PLOT---------
for i = 1: length(L);
    for j=1:length(NA)
        
        %--------Data Collection--------------
        
        %read in fluence rate
        n_L=L(i); n_NA=NA(j); n_d=d(j);
        datafile_name = ['MCML_Data_FR_L_' num2str(n_L) '_NA_'...
            num2str(n_NA) '_d_' num2str(n_d)];
        phi=csvread(fullfile(path,datafile_name)); %[kW/m^2]
        phi=phi.*10^3; %[W/m^2]
        
        %define tissue properties
        prop(1)=u_a(i);    %absorption coefficient [m^-1]
        prop(2)=u_s(i) ;   %scattering coefficient [m^-1]
        prop(7)=w_L(j);   %1:e^ radius [m]
        
        %--------Calculation--------------
%         if j==1
%             for l=1:length(t1)
%                 
%                 %calculate temperature raise
%                 [dT(:,:,k,l),tau(k)]=Traise_Data(prop,phi,t1(l));
%             end
%         elseif j==2
%             for l=1:length(t2)
%                 
%                 %calculate temperature raise
%                 [dT(:,:,k,l),tau(k)]=Traise_Data(prop,phi,t2(l));
%             end
%         end
          for l=1:length(t)
              a=1; %index for the different subsections of the function
              b=1; %boolean representing the pulse: 1 -> pulse, 0 -> no pulse
              if(abs(tL-t(l))<=(stepsize/2))
                  if(b==1)
                      a=a+1;
                      b=0;
                  end
              elseif(rem(t-tL,F)<=(stepsize/2))
                  if(b==1)
                      a=a+1;
                      b=0;
                  end
              elseif(rem(t,F)<=(stepsize/2))
                  if(b==0)
                      a=a+1;
                      b=1;
                  end
              end
              if(b==1)%b is true, there is a pulse at this moment
                  if(a==1) %the first subsection doesn't need a dalende
                      dT(:,:,k,l)=Stijgend(prop,phi,t(l),F,a);
                  else %stijdende + sum dalende
                      dT(:,:,k:l)=Stijgend(prop,phi,t(l),F,a);
                      for d=0:floor((a/2)-1)
                          dT(:,:,k,l)=dT(:,:,k,l)+ Dalend(prop,phi,t(l),F,tL,d);
                      end
                  end
              else %b is false, no pulse at this moment -> only dalende
                  for d=0:((a/2)-1)
                      dT(:,:,k,l)=dT(:,:,k,l)+ Dalend(prop,phi,t(l),F,tL,d);
                  end
              end
          end    
          
%         %--------Plot--------------
%         fig=figure(m);
%         % plot temperature raise (color) (K)
%         
%         imagesc(r,z,dT(:,:,k,3)); c=colorbar;
%         
%         %labels
%         if j==1
%             title({'Temperature increase';['$\lambda=$' num2str(n_L)...
%                 ', NA=' num2str(n_NA) ', d=' num2str(n_d),'t=' ...
%                 num2str(t1(l))]},'interpreter', 'LaTex');
%         elseif j==2
%             title({'Temperature increase';['$\lambda=$' num2str(n_L)...
%                 ', NA=' num2str(n_NA) ', d=' num2str(n_d),'t='...
%                 num2str(t2(l))]},'interpreter', 'LaTex');
%         end
%         xlabel('r [mm]', 'interpreter', 'LaTex');
%         ylabel('z [mm]', 'interpreter', 'LaTex');
%         c.Label.String= '$dT$ [$K$]';
%         c.Label.FontSize=20;
%         c.Label.Interpreter='latex';
%         
%         %scaling
%         if j==1
%             xlim([-0.3,0.3]);ylim([0,0.6]);
%         elseif j==2
%             xlim([-1,1]);ylim([0,1.5]);
%         end
%         
%         
%         m=m+1;
%         
%         
%         fig=figure(m);
%         if j==1
%             plot(t1,squeeze(dT(2,500,k,:))); 
%             title({'Temperature increase';['$\lambda=$' num2str(n_L)...
%                 ', NA=' num2str(n_NA) ', d=' num2str(n_d)]},...
%                 'interpreter', 'LaTex');
%             xlabel('t [s]', 'interpreter', 'LaTex');
%             ylabel('dT[K]', 'interpreter', 'LaTex');
%         elseif j==2
%             plot(t2,squeeze(dT(2,500,k,:)));
%             title({'Temperature increase';['$\lambda=$' num2str(n_L)...
%                 ', NA=' num2str(n_NA) ', d=' num2str(n_d)]},...
%                 'interpreter', 'LaTex');
%             xlabel('t [s]', 'interpreter', 'LaTex');
%             ylabel('dT[K]', 'interpreter', 'LaTex');
%         end
%         
        m=m+1;
        k=k+1;
        
    end
end