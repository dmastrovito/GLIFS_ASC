type = "km";

if strcmp(type, "thresh")
    losses = xlsread("results_wkof_080121/brnn_learnrealizable-thresh-agn-1units-losses.csv");
    final_outputs = xlsread("results_wkof_080121/brnn_learnrealizable-thresh-agn-finaloutputs.csv");
    targets = xlsread("results_wkof_080121/brnn_learnrealizable-thresh-agn-targets.csv");
    initial_outputs = xlsread("results_wkof_080121/brnn_learnrealizable-thresh-agn-initialoutputs.csv");
elseif strcmp(type, "km")
    losses = xlsread("results_wkof_080121/brnn_learnrealizable-km-1units-losses.csv");
    final_outputs = xlsread("results_wkof_080121/brnn_learnrealizable-km-finaloutputs.csv");
    targets = xlsread("results_wkof_080121/brnn_learnrealizable-km-targets.csv");
    initial_outputs = xlsread("results_wkof_080121/brnn_learnrealizable-km-initialoutputs.csv");
end
thresh_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-threshes.csv");
km_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-kms.csv");
asck_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-asck.csv");
ascr_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-ascr.csv");
ascamp_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-ascamp.csv");

linewidth = 2;
simtime = 4
fontsize=24;

figure;
subplot(1,2,1);
plot(losses, 'Color', "#332288", 'LineWidth', linewidth);
xlabel('epoch #', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);

subplot(1,2,2);
plot([0:0.05:simtime-0.05], initial_outputs, 'Color', "#332288", 'LineWidth', linewidth, 'DisplayName', "initial");
xlabel('time (ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('firing probability', 'FontName', 'helvetica', 'FontSize', fontsize);
hold on
plot([0:0.05:simtime-0.05], final_outputs, 'Color', "#117733", 'LineWidth', linewidth, 'DisplayName', "learned");
xlabel('time (ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('firing probability', 'FontName', 'helvetica', 'FontSize', fontsize);
hold on
plot([0:0.05:simtime - 0.05], targets, 'Color', "#44AA99", 'LineWidth', linewidth, 'DisplayName', "target");
xlabel('time (ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('firing probability', 'FontName', 'helvetica', 'FontSize', fontsize);

legend('FontName', 'helvetica', 'FontSize', fontsize, 'Location', 'southeast')

% figure;
% plot(thresh_losses(:,1), thresh_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
% xlabel('threshold (mV)', 'FontName', 'helvetica', 'FontSize', fontsize);
% ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);
% 
% figure;
% plot(km_losses(:,1), km_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
% xlabel('membrane k (1/ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
% ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);
% 
% figure;
% plot(asck_losses(:,1), asck_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
% xlabel('ASC k (1/ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
% ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);
% 
% figure;
% plot(ascr_losses(:,1), ascr_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
% xlabel('ASC mult.', 'FontName', 'helvetica', 'FontSize', fontsize);
% ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);
% 
% figure;
% plot(ascamp_losses(:,1), ascamp_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
% xlabel('ASC additive (pA)', 'FontName', 'helvetica', 'FontSize', fontsize);
% ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);