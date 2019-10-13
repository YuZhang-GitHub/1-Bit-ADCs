SNR = 10^(.1*0);
ch = [2 3 4 5 6 7 10 20 30 50 70 100];
ch_num = size(ch,2);
pilotList = [2 5 10];
p_num = size(pilotList,2);

SNR_per_ant_pred = zeros(p_num, ch_num);
SNR_per_ant_target = zeros(p_num, ch_num);
diff = zeros(p_num, ch_num);

SNR_pred_all = zeros(p_num, ch_num);
SNR_target_all = zeros(p_num, ch_num);
diff_all = zeros(p_num, ch_num);

for ii = 1:p_num
    fprintf('Track: pilots = %d \n', pilotList(ii));
    for jj = 1:ch_num
        
        S = load(['.\Data\','antNum=',num2str(ch(jj)),'_pilots=',num2str(pilotList(ii)),'.mat']);
        train_ch = S.dataset.train_ch(1:ch(ch_num),:,:);
        Pr_avg = mean(abs(train_ch(:)).^2);
        Pn = Pr_avg/SNR;
        
        N_val = size(S.Ch_pred,2);
        cor_pred = zeros(1, N_val);
        cor_target = zeros(1, N_val);
        for kk = 1:N_val
            cor_pred(kk) = abs(S.Ch_target(:,kk)'*S.Ch_pred(:,kk)/norm(S.Ch_pred(:,kk)))^2;
            cor_target(kk) = abs(S.Ch_target(:,kk)'*S.Ch_target(:,kk)/norm(S.Ch_target(:,kk)))^2;
        end
        
        SNR_pred_all(ii, jj) = (1/Pn)*SNR*mean(cor_pred);
        SNR_target_all(ii, jj) = (1/Pn)*SNR*mean(cor_target);
        
        diff_all(ii,jj) = SNR_target_all(ii,jj) - SNR_pred_all(ii,jj);
        
        SNR_per_ant_pred(ii,jj) = (1/Pn)*SNR*mean(cor_pred)/ch(jj);
        SNR_per_ant_target(ii,jj) = (1/Pn)*SNR*mean(cor_target)/ch(jj);
        
        diff(ii,jj) = SNR_per_ant_target(ii,jj) - SNR_per_ant_pred(ii,jj);
    end
end
%% Plotting
figure(1);
color = ['r','b','k'];
marker = ['d','^','*'];
for pp = 1:p_num
    plot(1:size(SNR_per_ant_pred,2), SNR_per_ant_pred(pp,:), [color(pp),marker(pp),'-'])
    hold on
end
for pp = 1:p_num
    plot(1:size(SNR_per_ant_target,2), SNR_per_ant_target(pp,:), 'k--')
    hold on
end
xticks(1:size(SNR_pred_all,2));
xticklabels({'2','3','4','5','6','7','10','20','30','50','70','100'});
xlabel('Number of Antennas');
ylabel('SNR per Antenna');
legend('Pilot length = 2','Pilot length = 5','Pilot length = 10','Upper Bound');
grid on
hold off
