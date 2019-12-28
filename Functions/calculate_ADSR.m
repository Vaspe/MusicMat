%% Header
%
% Create ADSR envelope with amplitude for each time step
%
function ADSR_env = calculate_ADSR(fs,Tvec,Att_val,Att_over_val,Dec_val,Sus_val,Sus_level,Rel_val,mode) 

% if time requested is longer than the duration of the note pad with zeros. If
% bigger just cut it


if strcmp(mode,'linear')
    flag_linear=1;
elseif strcmp(mode,'exponential')
    flag_linear=0;
else
    error(['Wrong input ' mode])
end
%  y = interp1([0 (0.01+A) (0.12+D) Dur - (0.601 - S) - R-0.02 Dur], [0 1 0.4 0.4 0], t); % !!      


if Att_val==0 && Dec_val==0 && Sus_val==0 && Rel_val==0 % case that all is off
   
    % Just add a very fast attack and a very fast decay in the mean amplitude
    % equal to mominal
    t_att_Alloff = 0.1;
    t_dec_Alloff = 0.1;
    
    [~,IndInt1] = min(abs(Tvec-t_att_Alloff));
    [~,IndInt2] = min(abs(Tvec-(Tvec(end)-t_dec_Alloff)));
    ADSR_env = [linspace(0,1,IndInt1) ones(1,numel(Tvec)-IndInt1-(numel(Tvec)-IndInt2)) linspace(1,0,numel(Tvec)-IndInt2) ];
  
elseif flag_linear==1;  %linear parts
    if Att_val==0  %check if 0 is requested and add a small value to smooth out the signal
       Att_val=0.01;
    end
    
    if Rel_val==0 %check if 0 is requested and add a small value to smooth out the signal
        Rel_val=0.01;
    end
    
    [~,Att_ind] = min(abs(Tvec-Att_val)); 
    [~,Dec_ind] = min(abs(Tvec-(Att_val+Dec_val) ));
    [~,Sus_ind] = min(abs(Tvec-(Att_val+Dec_val+Sus_val)));
    [~,Rel_ind] = min(abs(Tvec-(Att_val+Dec_val+Sus_val+Rel_val)));
    
    ADSR_env = [linspace(0,Att_over_val,Att_ind) linspace(Att_over_val,Sus_level,Dec_ind-Att_ind) ...
        Sus_level*ones(1,Sus_ind-Dec_ind) linspace(Sus_level,0,Rel_ind-Sus_ind) ];
    
    if numel(ADSR_env)<numel(Tvec)   % if adsr points are less add zeros to the end
        for i =1:numel(Tvec)-numel(ADSR_env)
            ADSR_env(end+1)= 0 ;
        end
    elseif numel(ADSR_env)>numel(Tvec)  % if it is bigger just cut it
        ADSR_env = ADSR_env(1:numel(Tvec));
    end
    
else
    if Att_val==0  %check if 0 is requested and add a small value to smooth out the signal
       Att_val=0.01;
    end
    
    if Rel_val==0 %check if 0 is requested and add a small value to smooth out the signal
        Rel_val=0.01;
    end    
    
end
