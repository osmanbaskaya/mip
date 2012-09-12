function skullRadius = calculateSkullRadius1(dataName, path)

oldPath = cd;
cd(path);
outSkull = imread(dataName);
outSkull = outSkull(:,:,1);
outSkull = bwfill(outSkull);
outSkull = bwperim(outSkull, 8);
skullPerimeter = sum(sum(outSkull));
skullRadius = skullPerimeter / (2 * pi);
cd(oldPath)

end