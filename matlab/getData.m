function my_str = getData(suffix, path)

oldPath = cd;
cd(path);

my_str = dir(['*', suffix, '*']);
cd(oldPath);


end