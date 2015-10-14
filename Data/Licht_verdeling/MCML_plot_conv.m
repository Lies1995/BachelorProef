
function MCML_plot
    close all
%------DATA--------
    L = {'474';'560'};    
    NA = {'12';'37'};                                                  
    dia = {'9';'200'};
    file_path = '/Users/LIesDeceuninck/Documents/github/BachelorProef/Data/Licht_verdeling/Output';
    k=1;
%-------PLOT-------
    for i = 1: length(L); 
    for j=1:length(NA)
        
        figure(k)
        
                n_L=L(i); n_NA=NA(j); n_dia=dia(j);                    % * # mW @ tip
                [R_Fig,z,Data_Fig]=MCML_Data(n_L,n_NA,n_dia,file_path);               
                imagesc(R_Fig,z,Data_Fig); colorbar;   
                xlabel('r (mm)'); ylabel('z (mm)'); 
%                xlim([-0.1,0.1 ]);ylim([0,0.7]);

%                 plot(z,Data_Fig(:,501))                                     % I(r,z) [mW/mm²]    
%                 xlim([0,3]);ylim([0,500]); 
            k=k+1;
        
  end
  end 
               
