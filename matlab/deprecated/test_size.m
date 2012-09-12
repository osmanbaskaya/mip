all = [];
for i=50:50:800
    
[d, distances, patients] = craniumQuantification('sulcal', 'unutkanlik', 'b', i);
s_distances = sortrows(distances, 5);
hem_corr = corr2(distances(:,2), distances(:,5));
all = [all; [i, hem_corr]];
end