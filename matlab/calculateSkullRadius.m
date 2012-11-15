function skullRadius = calculateSkullRadius(outSkull)

    skullPerimeter = sum(sum(logical(bwperim(outSkull))));
    skullRadius = skullPerimeter / (2 * pi);

end