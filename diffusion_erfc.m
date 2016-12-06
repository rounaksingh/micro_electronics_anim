% Error function profile 
% Constant source
% Assumptions: one different carrier is depositing

close all;
clear all;

%%
% Variables
animation_delay=0.5;    % in seconds
Csurf=2.8E20;     % surface concentration (Note: Required Csurf>Csub)
Csub=0.9E19;      % substrate concentration
t_final=600;      % in sec
x_final=1E-4;      % Last depth into substrate (in cm)
x_resolution=200;       % number of points between 0 and x_final
% For Boron
D0=10.5;            % in cm^2/sec
Ea=3.69;             %in eV
T_celsius=1050;  % in deg celsius

%% Donot change anything below, unless you know what you are doing
% Feel free to learn Matlab animation
k=8.617E-5;       %in eV/K
T=T_celsius+273;      %in Kelvin
D=D0*exp(-Ea/(k*T));
t=[t_final/50:t_final/50:t_final];
x=linspace(0,x_final,x_resolution);

figure;

% Y-limit for semilogy
% Y-limit for semilogy
y_lower=10^floor(log10(Csub/10));
y_upper=10^ceil(log10(Csurf));
y_limit=[y_lower y_upper];
yticks=10.^(log10(y_lower):log10(y_upper));

%
annotation_title = ['Predeposition of Boron ions (const. surf conc=' num2str(Csurf,'%03.2E') '/cm^2) at temp ' num2str(T_celsius) '\circC'];

if Csurf<Csub
    error('Please make sure that the surface concentration is more than substrate concentration')
end

for i=1:length(t)
    C=Csurf*erfc(x./(2*sqrt(D*t(i))));
    subplot(2,1,1);
    semilogy(x*1E4,C);
    hax=gca;
    line([min(get(hax,'XTick')) max(get(hax,'XTick'))], [Csub Csub],'LineStyle','--','Color','red');
    
    % Annotations
    title([annotation_title ' at time= ' num2str(t(i))  ' seconds'])
    xlabel('x (\mum)')
    ylabel('Concentration (/cm^3)')
    ylim(hax,y_limit);
    legend('Deposited Conc','Substrate Conc')
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
    xj=2*sqrt(D*t(i))*erfcinv(Csub/Csurf);
    
    % Annotations
    xlabel('x (\mum)');
    ylabel('Net Concentration (/cm^3)');
    %hold on;
%     text(x(end-1)*1E4,Csub,['junction depth =' num2str(xj*1E4,'%04.2f') '\mum'],'HorizontalAlignment','right','VerticalAlignment','bottom')
    title(hax, ['Junction depth =' num2str(xj*1E4,'%04.2f') '\mum'])
    legend('Doped side','Substrate side');
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


% % Y-limit for semilogy
% y_limit=[10^floor(log10(Csub)) 10^ceil(log10(Csurf))];
% yticks=10.^[floor(log10(Csub)):ceil(log10(Csurf))];
%    set(gca,'YMinorTick','on')
%     % Generate New YTick
%     ytickLabel={};
% %     yTickLabel = cellstr(num2str(round(log10(ytick(:))), '10^{%d}'));
%     ytick = unique([yticks,Csurf,Csub]);
%     ytick=sort(ytick);
% %     yTickLabel=cellstr(num2str(ytick(:),'%03.2e'));
%     set(gca,'YTick',ytick);
%     for i=1:length(ytick)
%         ytickLabel={ytickLabel{:} sprintf('%03.2fx10^{%d}',ytick(i)/10^floor(log10(ytick(i))),floor(log10(ytick(i))))};
%     end
%     hax.YTickLabel=ytickLabel;
%  
