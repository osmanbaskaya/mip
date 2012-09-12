function totalDist =  findCraniumDistance (sourceIm, centerP)

temp = sourceIm;
angle = 0;
totalDist = 0;

while angle < 40
    kk = find(bwdist(temp(centerP(2),:) ~= 0) == 0); % 0 geleni yakalamak.
    arr1 = kk(kk < centerP(1));
    arr2 = kk(kk > centerP(1)); % arr2[end] = min
    if isempty(arr1) || isempty(arr2)
        angle = angle + 2;
        continue; % midline'in önünde arkasında kalanlardan biri bile boş kümeyse doğru çizilemez.
    end

    
    minAxis = [arr1(1) arr1(2)];
    maxAxis = [arr2(end-1) arr2(end)];
    westDist = dist(minAxis(1),minAxis(2));
    eastDist = dist(maxAxis(1)-maxAxis(2));
    if(eastDist <= 1) % It can be 'PseudoDistance'. Threshold is 5.
        eastDist = 0;
    end
    if (westDist <= 1)
        westDist = 0;
    end
    
    totalDist = eastDist + westDist + totalDist;
    figure, imshow(temp);
    hold on;
    disp(['angle is: ',num2str(angle)]);
    plot(minAxis, [centerP(2), centerP(2)], 'g-');
    plot(maxAxis, [centerP(2), centerP(2)], 'g-');
    plot(centerP(1),centerP(2),'ro');
    angle = angle + 2;
    temp = imrotate(sourceIm, angle, 'bicubic', 'crop');
    
end