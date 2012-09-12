function [corr_score, n_sample] = get_correlation(D, S, type)

% NaN Check
i = find(isnan(D));

% Remove NaN rows
D = removerows(D, i);
n_sample = length(D);
if n_sample == 0
   corr_score = NaN;
   return
end

scores = removerows(S, i);
% Calculate the correlation
corr_score = corr(D, scores, 'type', type);



end


