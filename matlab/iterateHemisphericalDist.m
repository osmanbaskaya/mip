function allWeightedResult = iterateHemisphericalDist(distAll, suffix)
% ITERATEHEMISPHERICALDIST 


dataFile = fopen('/home/tyra/Desktop/HemipspWeightedRes.txt', 'a+');

interval1 = linspace(0.1,0.7,61);
allWeightedResult = [];
if strcmp(suffix, 'sulcal')
    expertResults = [5,4,6,6,6,5,6,8,6,5]';
else
    expertResults = [];
end

for w1=interval1
    if (mod(w1,0.1) == 0)
        disp(num2str(w1));
    end

    for w2=interval1
        for w3=interval1

            averageDistAll = [];


            if (w1+w2+w3 > 1.0)
                continue;
            end
            for i=1:10
                averageDistAll = [averageDistAll; distAll(i,:) .* [w1, w2, w3]];
            end
            averageDistAll = averageDistAll * 10;
            weightedDistAll = sum(averageDistAll, 2);
            weightedDistAll = [weightedDistAll, expertResults];
            corrDist = corr(weightedDistAll);
            corrB = corrDist(2);
            weightedResult = [w1, w2, w3, corrB];
            fprintf(dataFile, '%f, %f, %f -> %f\n', weightedResult);
            allWeightedResult = [allWeightedResult; weightedResult];

        end
    end
end
end