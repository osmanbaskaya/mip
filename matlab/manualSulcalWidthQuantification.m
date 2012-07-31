function [manualWidthL, manualWidthR] = manualSulcalWidthQuantification()

%MANUALSULCALWIDTHQUANTIFICATION 
% 
% Author: Osman Baskaya <osman.baskaya@computer.org>
% Date: 2012/06/01

DEPLOYPATH = '/home/tyr/Documents/datasets/mipdatasets/';
path = strcat(DEPLOYPATH, 'raw_brains/miccai12');


% for miccai12 dataset
leftcoord = {
               {[105, 295, 108, 293];  % Erdal Ayhan
                [111, 299, 115, 296];
                [116, 302, 119, 298];
                [126, 305, 133, 301];
                [134, 310, 137, 309];
                [156, 312, 159, 307];
                [155, 322, 160, 321];};
               
               {[60, 167, 63, 165];   % Mahir Burhan
                [66, 173, 69, 171];
                [69, 178, 72, 175];
                [76, 183, 79, 180];
                [85, 187, 90, 183];
                [87, 197, 89, 197];
                [104, 204, 106, 203];};
               
               {[104, 279, 107, 274];  % Nesrin Irgi
                [120, 285, 123, 280];
                [126, 286, 139, 283];
                [123, 303, 129, 298];
                [137, 310, 140, 305];
                [160, 312, 165, 309];
                [185, 311, 189, 309];};
                
               {[72, 263, 68, 268];  % Nuran Aydinoglu
                [81, 279, 84, 275];
                [110, 278, 107, 284];
                [119, 281, 117, 287];
                [133, 288, 130, 292];
                [125, 302, 123, 303];
                [74, 277, 78, 272];};
                
               {[53, 188, 51, 191];  % Servet Demirel
                [56, 193, 57, 191];
                [59, 194, 61, 192];
                [68, 193, 66, 195];
                [73, 217, 74, 215];
                [80, 214, 78, 213];
                [86, 218, 88, 216];};
                
               {[45, 159, 52, 151];  % Turkan Gencoglu
                [57, 153, 54, 160];
                [60, 160, 61, 155];
                [68, 155, 64, 160];
                [67, 161, 72, 157];
                [64, 166, 69, 165];
                [78, 167, 80, 170];};
                
               {[83, 316, 76, 327];  % Yuksel Ilk
                [89, 320, 83, 329];
                [101, 324, 95, 330];
                [106, 341, 103, 345];
                [116, 345, 116, 348];
                [124, 343, 127, 347];
                [134, 339, 136, 343];};           
                
                
           };
       
       
rightcoord = {
               {[346, 291, 341, 286];  % Erdal Ayhan
                [333, 292, 336, 296];
                [330, 300, 325, 295];
                [311, 295, 317, 302];
                [312, 309, 310, 307];
                [307, 313, 305, 311];
                [296, 330, 290, 326];};
               
               {[223, 184, 220, 182];  % Mahir
                [212, 187, 214, 190];
                [200, 191, 206, 191];
                [196, 205, 197, 207];
                [186, 204, 187, 207];
                [180, 206, 180, 209];
                [175, 210, 177, 212];};
                
               {[325, 250, 329, 257];  % Nesrin Irgi
                [317, 261, 325, 261];
                [318, 272, 330, 273];
                [299, 296, 299, 300];
                [278, 290, 282, 298];
                [305, 294, 306, 300];
                [266, 308, 268, 312];};
                
               {[312, 258, 316, 265];  % Nuran Aydinoglu
                [306, 270, 311, 273];
                [299, 275, 303, 280];
                [291, 279, 302, 283];
                [296, 291, 302, 294];
                [275, 301, 274, 305];
                [262, 294, 262, 300];};
                
               {[194, 178, 196, 180];  % Servet Demirel
                [188, 181, 191, 184];
                [179, 189, 181, 191];
                [175, 193, 178, 196];
                [166, 194, 166, 198];
                [162, 206, 166, 204];
                [156, 214, 155, 216];};
                
               {[176, 132, 181, 138];  % Turkan Gencoglu
                [171, 136, 177, 140];
                [165, 141, 169, 146];
                [156, 145, 163, 149];
                [161, 156, 165, 156];
                [155, 160, 155, 163];
                [143, 163, 145, 164];};
                
               {[325, 286, 330, 292];  % Erdal Ayhan
                [312, 292, 316, 297];
                [302, 305, 309, 305];
                [296, 293, 309, 300];
                [300, 315, 303, 318];
                [286, 321, 290, 324];
                [266, 334, 266, 338];};
               
                
           };
          
[my_str, oldPath] = getData('sulcal', path);

number_of_data = length(my_str);
number_of_method = 3; % avg, median, max

manualWidthL = zeros(number_of_data, number_of_method);
manualWidthR = zeros(number_of_data, number_of_method);

for k=1:number_of_data
    
    dataName = my_str(k).name;
    fprintf('%i) Data is %s\n', k, dataName );
    imshow(dataName); title(dataName);
    hold on;
    
    sL = leftcoord{k, :};
    sR = rightcoord{k, :};

    m = length(sL);
    distances = zeros(1, m);
    
    for i=1:m
        
        pL = sL{i};
        plot(pL([1,3]), pL([2,4]), '-y', 'LineWidth', 2);
        distances(i) = sqrt((pL(1) - pL(3))^2 + ...
                                        (pL(2) - pL(4))^2);
    end
    
    distances = sort(distances);
    manualWidthL(k, 1) = sum(distances) / m; %avg
    manualWidthL(k, 2) = distances(round(m/2)); %median
    manualWidthL(k, 3) = distances(m); %max
    
    
    m = length(sR);
    distances = zeros(1, m);
    
    for i=1:m
        pR = sR{i};
        plot(pR([1,3]), pR([2,4]), '-y', 'LineWidth', 2);
        
        distances(i) = sqrt((pR(1) - pR(3))^2 + ...
                                        (pR(2) - pR(4))^2);
    end
    
    distances = sort(distances);
    manualWidthR(k, 1) = sum(distances) / m; %avg
    manualWidthR(k, 2) = distances(round(m/2)); %median
    manualWidthR(k, 3) = distances(m); %max
    cd('/home/tyr/Programs/matlab12a/Library/MIP/figures/miccai12/width/')
    saveas(gcf, strcat(dataName(1:end-4), 'WidthQuantificationManual.fig'));
    close all;
    cd(path)
    
end

cd(oldPath);


end