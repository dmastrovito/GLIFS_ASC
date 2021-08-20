type = "all";

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
elseif strcmp(type, "all")
    losses = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-1units-losses.csv");
    final_outputs = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-finaloutputs.csv");
    targets = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-targets.csv");
    initial_outputs = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-initialoutputs.csv");
    
    threshes = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-1units-threshoverlearning.csv");
    kms = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-1units-kmoverlearning.csv");
    ascks = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-1units-asckoverlearning.csv");
    ascrs = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-1units-ascroverlearning.csv");
    ascamps = xlsread("results_wkof_080121/brnn_learnrealizable-allparams-1units-ascampoverlearning.csv");
end

thresh_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-threshes.csv");
km_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-kms.csv");
asck_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-asck.csv");
ascr_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-ascr.csv");
ascamp_losses = xlsread("results_wkof_080121/brnn_learnrealizable-losses-ascamp.csv");

linewidth = 2;
simtime = 10;
fontsize=24;

fig = figure
fig.Renderer='Painters';
subplot(1,2,1);
plot(losses, 'Color', "#332288", 'LineWidth', linewidth);
xlabel('epoch #', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);
set(gca,'FontSize', fontsize);

subplot(1,2,2);
plot([0:0.05:simtime-0.05], initial_outputs, 'Color', "#332288", 'LineWidth', linewidth, 'DisplayName', "initial");
xlabel('time (ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('firing probability', 'FontName', 'helvetica', 'FontSize', fontsize);
hold on
plot([0:0.05:simtime-0.05], final_outputs, 'Color', "#117733", 'LineWidth', linewidth, 'DisplayName', "learned");
xlabel('time (ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('firing probability', 'FontName', 'helvetica', 'FontSize', fontsize);
hold on
plot([0:0.05:simtime - 0.05], targets, 'Color', "#88CCEE", 'LineWidth', linewidth, 'DisplayName', "target");
xlabel('time (ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('firing probability', 'FontName', 'helvetica', 'FontSize', fontsize);
set(gca,'FontSize', fontsize);


legend('FontName', 'helvetica', 'FontSize', fontsize, 'Location', 'best')


fig = figure
fig.Renderer='Painters';
colors = ["#332288", "#117733", "#44AA99", "#88CCEE", "#DDCC77", "#CC6677", "#AA4499", "#882255"];
plot(threshes, 'Color', colors(1), 'LineWidth', linewidth, 'DisplayName', "thresh (mV)")
hold on
plot(kms, 'Color', colors(2), 'LineWidth', linewidth, 'DisplayName', "k_m (1/ms)")
hold on
plot(ascks(:,1), 'Color', colors(3), 'LineWidth', linewidth, 'DisplayName', "k_j (mV)")
plot(ascks(:,2), 'Color', colors(3), 'LineWidth', linewidth, 'HandleVisibility', "off")
hold on
plot(ascamps(:,1), 'Color', colors(4), 'LineWidth', linewidth, 'DisplayName', "a_j (mV)")
plot(ascamps(:,2), 'Color', colors(4), 'LineWidth', linewidth, 'HandleVisibility', "off")
hold on
plot(ascrs(:,1), 'Color', colors(5), 'LineWidth', linewidth, 'DisplayName', "r_j (mV)")
plot(ascrs(:,2), 'Color', colors(5), 'LineWidth', linewidth, 'HandleVisibility', "off")
hold on
yline(0, 'LineWidth', linewidth, 'HandleVisibility', "off")
xlabel('epoch #', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('difference from target', 'FontName', 'helvetica', 'FontSize', fontsize);
set(gca,'FontSize', fontsize);
legend('FontName', 'helvetica', 'FontSize', fontsize, 'Location', 'best')

figure;
plot(thresh_losses(:,1), thresh_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
xlabel('threshold (mV)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);

figure;
plot(km_losses(:,1), km_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
xlabel('membrane k (1/ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);

figure;
plot(asck_losses(:,1), asck_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
xlabel('ASC k (1/ms)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);

figure;
plot(ascr_losses(:,1), ascr_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
xlabel('ASC mult.', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);

figure;
plot(ascamp_losses(:,1), ascamp_losses(:,2), 'Color', "#332288", 'LineWidth', linewidth);
xlabel('ASC additive (pA)', 'FontName', 'helvetica', 'FontSize', fontsize);
ylabel('MSE', 'FontName', 'helvetica', 'FontSize', fontsize);