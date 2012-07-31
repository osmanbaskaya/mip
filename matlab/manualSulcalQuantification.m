function manualDepths = manualSulcalQuantification()

%MANUALSULCALQUANTIFICATION This function calculates lengths of 
% which sulci region that are not be able to calculate with automatically.
% It also draws a yellow solid line between manually given points and 
% saves the obtaining figures.
% 
% Author: Osman Baskaya <osman.baskaya@computer.org>
% Date: 2012/05/28


figurePath = '/home/tyr/Programs/matlab12a/Library/MIP/figures/miccai12';
cd(figurePath);

% for ref datasets
% leftcoord = {{[103, 106], [342, 348]}; ...
%              {[132, 137, 148, 149], [312, 311, 301, 301 ]};  ... %baharda sorun.
%              {[137, 141], [311, 313]}; ...
%              {[91, 88], [200, 197]}; ...
%              {[157, 166, 184, 188], [300, 311, 311, 315]}; ...
%              {[85, 87], [169, 169]}; ...
%              {[74, 77], [163, 164]}; ...
%              {[82, 85], [166, 164]}};
%        
%        
% rightcoord = {{[286, 287], [319, 324]}; ...
%               {[271, 276], [288, 292]}; ...
%               {[308, 306], [311, 313]}; ...
%               {[204, 204, 196, 181, 173, 171 ], [192, 202, 206, 206, 214, 214]};... % mahir problem
%               {[288, 282, 261], [296, 296, 313]}; ...
%               {[162, 158], [156, 160]}; ...
%               {[121, 123], [166, 165]}; ...
%               {[147, 146, 144], [162, 162, 163]}};

% for miccai12 dataset
leftcoord = {{[137, 141], [311, 313]}; ...
             {[91, 88], [200, 197]}; ...
             {[157, 166, 184, 188], [300, 311, 311, 315]}; ...
             {[131, 133], [289, 291]}; ...
             {[69, 71], [195, 196]}; ...
             {[82, 85], [166, 164]}; ...
             {[102, 108], [341, 346]}};
       
       
rightcoord = {{[308, 306], [311, 313]}; ...
              {[204, 204, 196, 181, 173, 171 ], [192, 202, 206, 206, 214, 214]};... % mahir problem
              {[288, 282, 261], [296, 296, 313]}; ...
              {[294, 291], [299, 301]};...
              {[165, 164, 166, 166], [196, 199, 206, 211]}; ...
              {[147, 146, 144], [162, 162, 163]}; ...
              {[294, 290], [320, 321]}};
          
          
manualDepths = [];

[my_str, oldPath] = getData('sulcal.fig', figurePath);
number_of_data = length(my_str);

for k=1:number_of_data
    
    dataName = my_str(k).name;
    fprintf('%i) Data is %s\n', k, dataName );
    uiopen(dataName, 1)
    hold on;
    sL = leftcoord{k, :};
    sR = rightcoord{k, :};
    
    x = sL{1};
    y = sL{2};
    
    m = length(sL{1});
    lengthL = 0;
    for i=1:m-1
        startp = x(i:i+1);
        endp = y(i:i+1);
        plot(startp, endp, '-y', 'LineWidth', 2);
        lengthL = lengthL + sqrt((startp(1) - startp(2))^2 + ...
                                        (endp(1) - endp(2))^2);
    end
    
    x = sR{1};
    y = sR{2};
    
    m = length(sR{1});
    lengthR = 0;
    for i=1:m-1
        startp = x(i:i+1);
        endp = y(i:i+1);
        plot(startp, endp, '-y', 'LineWidth', 2);
        lengthR = lengthR + sqrt((startp(1) - startp(2))^2 + ...
                                        (endp(1) - endp(2))^2);
        
    end

    saveas(gcf, strcat(dataName(1:end-4), 'WithManual.fig'));
    manualDepths = [manualDepths; [lengthL, lengthR]];
    
end

