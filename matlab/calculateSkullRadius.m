function skullRadius = calculateSkullRadius(outSkull)

    skullPerimeter = sum(sum(logical(outSkull)));
    skullRadius = skullPerimeter / (2 * pi);

end