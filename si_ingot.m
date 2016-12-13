% Silicon Ingot
close all;
clear all;

% Parameters to edit
animation_delay=1;    % in seconds
% to maintain resolution
f_interval=0.05;     %should be 0.1 or 0.2, so that 1/f_interval is a integer
% wafer size
wafer_diameter=8;       %in inches

% Initial impurity Concentration in silicon melt
% Boron
p_initial_conc=1E16;
p_k0=0.8
% Phosphorous
n_initial_conc=1E16;
n_k0=0.35



%Constants-----------------------
f=[0:f_interval:0.9];




%---------------------------------

% Checks before animations
% if is


wafer_diameter_mm=wafer_diameter*25.4;
wafer_radius_mm=wafer_diameter_mm/2;
% Equations
p_Cs=p_initial_conc*p_k0*(1-f).^(p_k0-1);

n_Cs=n_initial_conc*n_k0*(1-f).^(n_k0-1);

abs_Cs=n_Cs-p_Cs;
% abs_Cs is positive for n-type and negative for p-type
ntype_region=find(abs_Cs>0);

%n-type
% if n_Cs>p_Cs
%     abs_Cs=n_Cs-p_Cs;
% elseif n_Cs<p_Cs
%     abs_Cs=n_Cs-p_Cs;
    

% Generating cylinder
[X_cylinder,Y_cylinder,Z]=cylinder(wafer_radius_mm);
% recreating the X,Y meshgrid for each step of f
X=repmat(X_cylinder(1,:),1+1/f_interval,1);
Y=repmat(Y_cylinder(1,:),1+1/f_interval,1);
X_size=size(X);
% Flip the array; so that the cylinder looks pulling up
Z=repmat(-fliplr(f)',1,X_size(2));
p_Cs_color=repmat(fliplr(p_Cs)',1,X_size(2));
n_Cs_color=repmat(fliplr(n_Cs)',1,X_size(2));
abs_Cs_color=repmat(fliplr(abs_Cs)',1,X_size(2));

figure;
for t=2:(length(f)-1)
    ax1=subplot(1,3,1);
    surf(ax1,X(1:t,:),Y(1:t,:),Z(1:t,:),p_Cs_color(1:t,:), 'linestyle', 'none');
    view(0,0)
    hold on;
    zlim([-0.9 0]);
    colormap(ax1,winter);
    colorbar
    
    ax2=subplot(1,3,2);
    surf(ax2,X(1:t,:),Y(1:t,:),Z(1:t,:),n_Cs_color(1:t,:), 'linestyle', 'none');
    view(0,0)
    hold on;
    zlim([-0.9 0]);
    colormap(ax2,autumn)
    colorbar
    
    ax3=subplot(1,3,3);
    surf(ax3,X(1:t,:),Y(1:t,:),Z(1:t,:),abs_Cs_color(1:t,:), 'linestyle', 'none');
    view(0,0)
    hold on;
    zlim([-0.9 0]);
    colormap(ax3,jet)
    colorbar
    
    % Animation options
    drawnow;
    pause(animation_delay);
end