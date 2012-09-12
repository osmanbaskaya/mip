function get_all_correlations(D)

% Data
IHA = D(:,2);
HCA = D(:,3);
Total = D(:,4);
expert_scores = D(:,5);

[corr_IHA_K, num] = get_correlation(IHA, expert_scores, 'Kendall')
[corr_IHA_P, num] = get_correlation(IHA, expert_scores, 'Pearson')
[corr_HCA_K, num] = get_correlation(HCA, expert_scores, 'Kendall')
[corr_HCA_P, num] = get_correlation(HCA, expert_scores, 'Pearson')



end
