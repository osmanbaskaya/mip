function get_all_slice_scores()

% Bu fonksiyon verilen kesit degerlerindeki tum atrophy degerlerini bulur.
% Dosyaya yazdirmak icin ise altta bulunan fonksiyonu kullanir.
% Bu sonuclar daha sonra korelasyon degerleri olculmek icin kullanilacak.


%% Initialization

clear
close all

%dataset = 'register/MNI/1mm';
%fileID = fopen('~/Desktop/register-MNI-1mm.txt', 'w+');

dataset = 'whole';
fileID = fopen('~/Desktop/whole.txt', 'w+');

IMAGE_PATH = '~/Documents/datasets/mipdatasets/test_images';
path = strcat(IMAGE_PATH, '/', dataset, '/'); % path for specific slice dir.
slices = [100, 150]; % bottom and top slice numbers.

fprintf(fileID, 'TEST RESULTS: %s\n', dataset);
fprintf(fileID, 'Atrophy type can be 2, 3 and 4.\n');
fprintf(fileID, '2 denotes IHA, 3 denotes HCA, and 4 denotes total atrophy.\n');
fprintf(fileID, 'Slice number\tAtrophyType\tAtrophy Score\n\n');
fprintf(fileID, 'SN\tAT\tAS\n\n');

for slice_num=slices(1):slices(2) 

    close all
    cd(path);
    folder_name = int2str(slice_num);
    try
        cd(folder_name);
    catch err
        mkdir(folder_name);
        cd(folder_name);
    end

    D = atrophy_quantification('nii', dataset, slice_num, 'verboses');
    write_atrophy_scores2file(fileID, D, slice_num)
end

%expert scores
%1 7 4 2 6 8 3 5

end



function write_atrophy_scores2file(fileID, D, slice_num)

% Sutun isimleri asagidaki gibi.
% 2- IHA, 3-HCA, 4-Total 5-Expert Score
columns = [2,3,4]; % yazilmasi gereken sutun degerleri.

for i=1:length(columns)
    atrophy_type = columns(i); 
    I = D(:, atrophy_type); % assing ith column.
    for j=1:length(I)
        fprintf(fileID, '%d\t%d\t%.10f\t\n', slice_num, atrophy_type, I(j));
    end
    %fprintf(fileID, '\n');
end



end
