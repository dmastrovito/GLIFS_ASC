fig = figure
fig.Renderer='Painters';

task = "smnist"; % smnist or pattern

results_file = fopen("stats_pattern.txt", 'w');
fontsize = 24;

if strcmp(task, "smnist")
    results_file = fopen("stats_smnist.txt", 'w');
    data_rnn = xlsread("results_wkof_080121/smnist-rnn-259units-0itr-ablation.csv");
    data_lstm = xlsread("results_wkof_080121/smnist-lstm-123units-0itr-ablation.csv");
    data_rglif = xlsread("results_wkof_080121/smnist-rglif-2asc-256units-0itr-ablation.csv");
    data_rglif_noasc = xlsread("results_wkof_080121/smnist-rglif-noasc-258units-0itr-ablation.csv");
    data_rglif_wtonly = xlsread("results_wkof_080121/smnist-rglif-wtonly-259units-0itr-ablation.csv");
    
    ylabel_text = "accuracy";
else
    results_file = fopen("stats_pattern.txt", 'w');
    data_rnn = xlsread("results_wkof_080121/pattern-rnn-131units-0itr-ablation.csv");
    data_lstm = xlsread("results_wkof_080121/pattern-lstm-64units-0itr-ablation.csv");
    data_rglif = xlsread("results_wkof_080121/pattern-rglif-2asc-128units-0itr-ablation.csv");
    data_rglif_noasc = xlsread("results_wkof_080121/pattern-rglif-noasc-130units-0itr-ablation.csv");
    data_rglif_wtonly = xlsread("results_wkof_080121/pattern-rglif-wtonly-131units-0itr-ablation.csv");
    ylabel_text = "MSE";
end

silence_props = linspace(0,1,6);

% RUN T-TESTS
for i = 1:size(data_rnn, 1)
    fprintf(results_file, sprintf('%.1f',100 * silence_props(i)));
    
    [h,p] = ttest2(data_rnn(i, :), data_lstm(i, :));
    fprintf(results_file, strcat('LSTM: ', sprintf('%e', p)));
    fprintf(results_file, '\n');
    
    [h,p] = ttest2(data_rnn(i, :), data_rglif(i, :));
    fprintf(results_file, strcat("RGLIF: ", sprintf('%e', p)));
    fprintf(results_file, '\n');
    
    [h,p] = ttest2(data_rnn(i, :), data_rglif_noasc(i, :));
    fprintf(results_file, strcat("RGLIF_NoASC: ", sprintf('%e', p)));
    fprintf(results_file, '\n');
    
    [h,p] = ttest2(data_rnn(i, :), data_rglif_wtonly(i, :));
    fprintf(results_file, strcat("RGLIF_WtOnly: ", sprintf('%e', p)));
    fprintf(results_file, '\n');
    
    fprintf(results_file, '\n');
end
fclose(results_file);

% PLOT DATA

mean_rnn = mean(data_rnn, 2);
mean_lstm = mean(data_lstm, 2);
mean_rglif = mean(data_rglif, 2);
mean_rglif_noasc = mean(data_rglif_noasc, 2);
mean_rglif_wtonly = mean(data_rglif_wtonly, 2);

stds_rnn = std(data_rnn, [], 2);
stds_lstm = std(data_lstm, [], 2);
stds_rglif = std(data_rglif, [], 2);
stds_rglif_noasc = std(data_rglif_noasc, [], 2);
stds_rglif_wtonly = std(data_rglif_wtonly, [], 2);

means = [mean_rnn.'; mean_lstm.'; mean_rglif.'; mean_rglif_noasc.'; mean_rglif_wtonly.'].';
stds = [stds_rnn.'; stds_lstm.'; stds_rglif.'; stds_rglif_noasc.'; stds_rglif_wtonly.'].';
b = bar(means)

hold on

ngroups = size(data_rnn, 1);
nbars = size(means, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));

for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, means(:,i), stds(:,i), 'k', 'LineWidth', 0.5, 'linestyle', 'none', 'HandleVisibility','off');
    hold on
end

colors = ["#332288", "#117733", "#44AA99", "#88CCEE", "#DDCC77", "#CC6677", "#AA4499", "#882255"];

for i = 1:nbars
    b(i).FaceColor = colors(i);
end

set(gca,'XTick', 1:ngroups, 'xticklabel',silence_props, 'FontName', 'helvetica', 'FontSize', fontsize);
legend("RNN", "LSTM", "RGLIF", "RLIF", "RGLIF-WT", 'FontSize', fontsize);
xlabel("% silenced", 'FontSize', fontsize);
ylabel(ylabel_text);