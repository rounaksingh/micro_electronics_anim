% Exp function profile 
% Constant Dose

close all;
clear all;
format shortEng

%%
% Variables
animation_delay=0.5;    % in seconds

% Give one of Q or Csurf, put other one as zero.
% program will find other value. Don't give both program will not run.
initial_Csurf=2.8E20;     % inital surface concentration (Note: Required Csurf>Csub)
Q=0;                % Dose

predep_time=600;    % in seconds
Csub=4E15;              % substrate concentration
t_final=3000;           % drivein time in sec
x_final=2E-4;          % Last depth into substrate (in cm)
x_resolution=400;       % number of points between 0 and x_final
% For Boron
D0=10.5;            % in cm^2/sec
Ea=3.69;             %in eV
T_celsius=1100;  % in deg celsius

%% Donot change anything below, unless you know what you are doing
% Feel free to learn Matlab animation
k=8.617E-5;       %in eV/K
T=T_celsius+273;      %in Kelvin
D=D0*exp(-Ea/(k*T));
t=[t_final/50:t_final/50:t_final];
x=linspace(0,x_final,x_resolution);

% find the initial_Csurf or Q
if Q~=0 && initial_Csurf~=0
    error('One of Q or initial_Csurf should be zero')
elseif Q==0 && initial_Csurf==0
    error('One of Q or initial_Csurf should be zero')
elseif Q==0
     Q=2*initial_Csurf*sqrt(D*predep_time);
elseif initial_Csurf==0
    initial_Csurf=Q/2*sqrt(pi/D/predep_time);
end

annotation_title = ['Drive IN Boron ions with Dose=' num2str(Q,'%03.2E') '/cm^2 at temp ' num2str(T_celsius) '\circC '];

if initial_Csurf<Csub
    error('Please make sure that the initial surface concentration is more than substrate concentration')
end

% Y-limit for semilogy
y_lower=10^floor(log10(Csub/10));
y_upper=10^ceil(log10(initial_Csurf));
y_limit=[y_lower y_upper];
yticks=10.^(log10(y_lower):log10(y_upper));

% Plotting
figure;

for i=1:length(t)
    C=Q/sqrt(pi*D*t(i))*exp(-(x.^2)./(4*D*t(i)));
    subplot(2,1,1);
    semilogy(x*1E4,C);
    hax=gca;
    line([min(get(hax,'XTick')) max(get(hax,'XTick'))], [Csub Csub],'LineStyle','--','Color','red');
    
    % Annotations
    title([annotation_title ' at ' num2str(t(i)) ' seconds'])
    xlabel('x (\mum)')
    ylabel('Concentration (/cm^3)')
    legend('Deposited Conc','Substrate Conc')
    ylim(y_limit);

    % Generate New YTick
    set(gca,'YMinorTick','on')
    hax.YTick=yticks;
    % Generate New YTick
    yTickLabel = cellstr(num2str(round(log10(yticks(:))), '10^{%d}'));
    hax.YTickLabel=yTickLabel;
    
    grid on;
    %hold on;
    
    % Net concentration
    subplot(2,1,2)
     
    net_C=abs(C-Csub);
    % Showing exact zero
    min_index=find(net_C==min(net_C));
    net_C(min_index)=y_lower;
    
    % Plotting graph
    semilogy(x(1:min_index)*1E4,net_C(1:min_index),'b');
    hold on;
    semilogy(x(min_index:end)*1E4,net_C(min_index:end),'r--');

    hax=gca;
    % Junction Depth
    xj=2*sqrt(D*t(i)*log(C(1)/Csub));
    
    % Annotations
    xlabel('x (\mum)')
    ylabel('Net Concentration (/cm^3)')
    %hold on;
%     legend(['Junction depth =' num2str(xj*1E4,'%04.2f') '\mum'])
    title(hax, ['Junction depth =' num2str(xj*1E4,'%04.2f') '\mum'])
    ylim(y_limit);

    % Generate New YTick
    set(gca,'YMinorTick','on')
    hax.YTick=yticks;
    % Generate New YTick
    yTickLabel = cellstr(num2str(round(log10(yticks(:))), '10^{%d}'));
    hax.YTickLabel=yTickLabel;

    grid on;
    hold off;
    
    % Animation options
    drawnow
    pause(animation_delay)
end




