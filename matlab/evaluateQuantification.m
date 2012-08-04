function [distances, s_distances, hem_corrK, cra_corrK, hem_corrP, ...
    cra_corrP, patients] = evaluateQuantification(suffix, datapath, slice_num, option)
%   EVALUATEQUANTIFICATION It evaluates HCA and IHA. First two results
%   are in terms of Kendall Corr. while next two rows shows Pearson
%   Correlations.
%
%   Call Example:
%       [distances, s_distances, hem_corrK, cra_corrK, hem_corrP, cra_corrP, patients] = evaluateQuantification('png', 'yue', 'noverbose')
%
%   Author: Osman Baskaya <osman.baskaya@computer.org>
%   1. Revision: 2012/07/30

format long            
[distances, patients] = craniumQuantification(suffix, datapath, slice_num, option);
s_distances = sortrows(distances, 5)
hem_corrK = corr(distances(:,2), distances(:,5), 'type', 'Kendall')
cra_corrK = corr(distances(:,3), distances(:,5), 'type', 'Kendall')
hem_corrP = corr(distances(:,2), distances(:,5), 'type', 'Pearson')
cra_corrP = corr(distances(:,3), distances(:,5), 'type', 'Pearson')


%corr(yueIHA', doc', 'type', 'Pearson') : 0.9587
%corr(yueCA', doc', 'type', 'Pearson') : 0.7891
%corr(ourIHA', doc', 'type', 'Pearson') : 0.4561
%corr(ourCA', doc', 'type', 'Pearson') : 0.4993