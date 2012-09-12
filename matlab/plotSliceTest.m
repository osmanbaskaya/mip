%PATH = '/home/tyr/Desktop/plot/register-MNI-1mm-5/';
PATH = '/home/tyr/Desktop/plot/whole-MNI-1mm-3/';

data = getData('txt', PATH);

for i=1:length(data)
    filename = data(i).name;
    fid = fopen(strcat(PATH, filename));
    C = textscan(fid, '%d,%d,%d,%f');
    startingSlice = C{1};
    endingSlice = C{2};
    numberOfPatient = C{3};
    corrScore = C{4};
    fclose(fid);
    
    
    x = (startingSlice + endingSlice) / 2;
    y1 = corrScore;
    y2 = numberOfPatient;
    plotyy(x,y1,x,y2,'plot');
    %axis([0 pi/2 0 1])
    axis auto
    set(gca,'YTick',-0.7:0.1:1)
    %set(gca,'XTick', 105:3:140)
    xlabel('Slice Number')
    ylabel('Pearson Correlation')
    grid on
    title(filename(1:end-4));
    saveas(gcf, strcat(PATH, filename(1:end-4), '.png'), 'png');
end


