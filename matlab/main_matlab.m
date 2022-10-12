%% main_matlab.m
% *Summary:* Runs a simulation within matlab / simulink.
%
% -----------
%
% Editor:
%   OMAINSKA Marco - Doctoral Student, Cybernetics
%       <marcoomainska@g.ecc.u-tokyo.ac.jp>
% Property of: Fujita-Yamauchi Lab, The University of Tokyo, 2022
% Website: https://www.scl.ipc.i.u-tokyo.ac.jp

% ------------- BEGIN CODE -------------


%% load data and set simulation parameters

% load general simulation parameters
init;

% trajectory settings
center1 = [0 0 0];
center2 = [0 0 0];
center3 = [0 0 0];
scale1 = 1;
scale2 = 1;
scale3 = 1;
epsilon1 = 0.5; v1 = 1;
epsilon2 = 1.0; v2 = 0.5;
% epsilon2 = 1.5; v2 = 0.5;
% epsilon2 = 0.3; v2 = 0.5;
epsilon3 = 0.3; v3 = 0.7;
switchingWidth = 0.1;
switchingPoints = [-2 0 0; 2 0 0];
psi0 = 2;
% datatype = 'VF';
datatype = 'TJ';

% load GP models
M = 25;
% M = 100;
[X_GP,Y_GP,kernel_GP,hyp_GP,sn_GP] = unpackGPdata(['data/GP/' datatype '_vdp_eps' erase(sprintf('%g',epsilon1),'.') 'v' erase(sprintf('%g',v1),'.') '_eps' erase(sprintf('%g',epsilon2),'.') 'v' erase(sprintf('%g',v2),'.') '_eps' erase(sprintf('%g',epsilon3),'.') 'v' erase(sprintf('%g',v3),'.') '_SEARD_M' sprintf('%g',3*M)]);
[X_switchedGP1,Y_switchedGP1,kernel_switchedGP1,hyp_switchedGP1,sn_switchedGP1] = unpackGPdata(['data/GP/' datatype '_vdp_eps' erase(sprintf('%g',epsilon1),'.') 'v' erase(sprintf('%g',v1),'.') '_SEARD_M' sprintf('%g',M)]);
[X_switchedGP2,Y_switchedGP2,kernel_switchedGP2,hyp_switchedGP2,sn_switchedGP2] = unpackGPdata(['data/GP/' datatype '_vdp_eps' erase(sprintf('%g',epsilon2),'.') 'v' erase(sprintf('%g',v2),'.') '_SEARD_M' sprintf('%g',M)]);
[X_switchedGP3,Y_switchedGP3,kernel_switchedGP3,hyp_switchedGP3,sn_switchedGP3] = unpackGPdata(['data/GP/' datatype '_vdp_eps' erase(sprintf('%g',epsilon3),'.') 'v' erase(sprintf('%g',v3),'.') '_SEARD_M' sprintf('%g',M)]);
[X_switchedRMGPvisual1,Y_switchedRMGPvisual1,kernel_switchedRMGPvisual1,hyp_switchedRMGPvisual1,sn_switchedRMGPvisual1] = unpackGPdata(['data/GP/' datatype '_vdp_eps' erase(sprintf('%g',epsilon1),'.') 'v' erase(sprintf('%g',v1),'.') '_SE3_M' sprintf('%g',M)]);
[X_switchedRMGPvisual2,Y_switchedRMGPvisual2,kernel_switchedRMGPvisual2,hyp_switchedRMGPvisual2,sn_switchedRMGPvisual2] = unpackGPdata(['data/GP/' datatype '_vdp_eps' erase(sprintf('%g',epsilon2),'.') 'v' erase(sprintf('%g',v2),'.') '_SE3_M' sprintf('%g',M)]);
[X_switchedRMGPvisual3,Y_switchedRMGPvisual3,kernel_switchedRMGPvisual3,hyp_switchedRMGPvisual3,sn_switchedRMGPvisual3] = unpackGPdata(['data/GP/' datatype '_vdp_eps' erase(sprintf('%g',epsilon3),'.') 'v' erase(sprintf('%g',v3),'.') '_SE3_M' sprintf('%g',M)]);

% calculate normed maximum variance
alpha = [0 1 0 0 0 0];
[~, cov1] = gp_calc([100 100 100 100 100 100], X_switchedGP1, Y_switchedGP1, kernel_switchedGP1, hyp_switchedGP1, sn_switchedGP1);
[~, cov2] = gp_calc([100 100 100 100 100 100], X_switchedGP2, Y_switchedGP2, kernel_switchedGP2, hyp_switchedGP2, sn_switchedGP2);
[~, cov3] = gp_calc([100 100 100 100 100 100], X_switchedGP3, Y_switchedGP3, kernel_switchedGP3, hyp_switchedGP3, sn_switchedGP3);
var_max = [norm(alpha*sqrt(diag(cov1)),2), norm(alpha*sqrt(diag(cov2)),2) norm(alpha*sqrt(diag(cov3)),2)];


%% run simulation
% hyp_switchedRMGPvisual1 = ones(6,2);
% hyp_switchedRMGPvisual2 = ones(6,2);

tend = 30;
simout = sim('vfs_matlab');


%% animations

% unpack data
gwo = simout.gwo.signals.values;
gwc1 = simout.gwc1.signals.values;
gwc2 = simout.gwc2.signals.values;
gwc3 = simout.gwc3.signals.values;
gwc4 = simout.gwc4.signals.values;
gcobar1 = simout.gcobar1.signals.values;
gcobar2 = simout.gcobar2.signals.values;
gcobar3 = simout.gcobar3.signals.values;
gcobar4 = simout.gcobar4.signals.values;
tout = simout.tout;
[~, pwo] = splitpose(gwo);

% plot animation
figure('Name','Animation','NumberTitle','off',...
    'Units','normalized','Position',[.05 0.05 .8 .8]);
ax = gca;
hold(ax,'on')
animate(ax,tout,...
      {gwo,agentdesign('target','show_trajectory','on','blocksize',0.7*ones(1,3))},...
      {gwc1,agentdesign('agent','color',[0 0 0],'blocksize',0.7*ones(1,3)),gcobar1,agentdesign('estimate','color',[0 0 0],'blocksize',0.7*ones(1,3))},...
      {gwc2,agentdesign('agent','color',hex2rgb('#fb8500'),'blocksize',0.7*ones(1,3)),gcobar2,agentdesign('estimate','color',hex2rgb('#fb8500'),'blocksize',0.7*ones(1,3))},...
      {gwc3,agentdesign('agent','color',hex2rgb('#0077b6'),'blocksize',0.7*ones(1,3)),gcobar3,agentdesign('estimate','color',hex2rgb('#0077b6'),'blocksize',0.7*ones(1,3))},...
      {gwc4,agentdesign('agent','color',hex2rgb('#e63946'),'blocksize',0.7*ones(1,3)),gcobar4,agentdesign('estimate','color',hex2rgb('#e63946'),'blocksize',0.7*ones(1,3))}...
      ...%'bound', 2*[-5 5; -5 5; -5 5]...
)


%% make plots
% set(groot,'defaultAxesTickLabelInterpreter','latex');

% unpack some data
e1 = simout.e1.signals.values;
e2 = simout.e2.signals.values;
e3 = simout.e3.signals.values;
e4 = simout.e4.signals.values;
s = simout.psi.signals.values;
s_est = simout.switchedGP_psi.signals.values;
s_est_visual = simout.switchedRMGPvisual_psi.signals.values;
tout = simout.tout;

% obtain RMSE
RMSE = rmse(e1);
RMSE_GP = rmse(e2);
RMSE_switchedGP = rmse(e3);
RMSE_switchedRMGPvisual = rmse(e4);
disp(['RMSE (VPC)              : ' num2str(RMSE)])
disp(['RMSE (VPC+GPfull)       : ' num2str(RMSE_GP)])
disp(['RMSE (VPC+switchedGP)   : ' num2str(RMSE_switchedGP)])
disp(['RMSE (VPC+switchedRMGP) : ' num2str(RMSE_switchedRMGPvisual)])

% obtain precision
precision_switchedGP = precisionMeasure(s,s_est)*100;
precision_switchedRMGPvisual = precisionMeasure(s,s_est_visual)*100;
disp(['Precision (VPC+switchedGP)   : ' num2str(precision_switchedGP,'%.2f') '%'])
disp(['Precision (VPC+switchedRMGP) : ' num2str(precision_switchedRMGPvisual,'%.2f') '%'])


fig = figure('Name','Error','NumberTitle','off',...
    'Units','normalized','Position',[0.1 .2 .8 .7]);
% tiledlayout(4,1);
t = tiledlayout(4,1,'TileSpacing','Compact','Padding','Compact');

% error plot
lw = 8;
ax = nexttile(1,[3 1]);
hold(ax,'on')
grid(ax,'on')
p1=plot(tout,vecnorm(e1,2,2),'LineWidth',lw,'color',[0 0 0]);
p2=plot(tout,vecnorm(e2,2,2),'LineWidth',lw,'color','#fb8500');
p3=plot(tout,vecnorm(e3,2,2),'LineWidth',lw,'color','#0077b6');
p4=plot(tout,vecnorm(e4,2,2),'LineWidth',lw,'color','#e63946');
xlim(ax,[0 tout(end)])
ylim(ax,[0 0.9])
% xlabel(ax,'Time $t$ [s]','interpreter', 'latex')
ylabel(ax,'$\|${\boldmath${e}$}$\|$','interpreter', 'latex')
lg=legend(ax,[p1 p2 p3 p4],...
    sprintf('\\textit{Standard} (MSE: %.3f)',RMSE),...
    sprintf('\\textit{GP} (MSE: %.3f)',RMSE_GP),...
    sprintf('\\textit{Switched GP} (MSE: %.3f)',RMSE_switchedGP),...
    sprintf('\\textit{Switched Visual RMGP} (MSE: %.3f)',RMSE_switchedRMGPvisual),...
    'interpreter', 'latex', ...
    'NumColumns',2);
ax.FontSize = 35;

% switching plot
lw = 8;
ax = nexttile;
hold(ax,'on')
grid(ax,'on')
p1=plot(tout,s,'LineStyle','-','LineWidth',lw,'color','#2b2d42'); %#0b3954
p2=plot(tout,s_est,'LineStyle',':','LineWidth',0.8*lw,'color','#0077b6');
p3=plot(tout,s_est_visual,'LineStyle',':','LineWidth',0.8*lw,'color','#e63946');
xlim(ax,[0 tout(end)])
ylim(ax,[1 max(s)])
yticks(ax,1:max(s))
xlabel(ax,'Time $t$ [s]','interpreter', 'latex')
ylabel(ax,'$s(t)$','interpreter','latex')
lg = legend(ax,[p1 p2 p3],'Real\hspace{0.3em}','$\bar{\psi}$ (GP error)\hspace{0.3em}','$\bar{\psi}$ (Visual)','interpreter','latex');%,'NumColumns',3);
ax.FontSize = 35;
HeightScaleFactor = 1;%1.2;
NewHeight = lg.Position(4) * HeightScaleFactor;
lg.Position(2) = lg.Position(2) - (NewHeight - lg.Position(4));
lg.Position(4) = NewHeight;

% save plots
% exportgraphics(t,'error.pdf','BackgroundColor','none')
