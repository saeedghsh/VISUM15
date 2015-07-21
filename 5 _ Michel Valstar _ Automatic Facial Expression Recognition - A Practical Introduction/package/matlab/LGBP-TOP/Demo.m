clc;
sfullpath = mfilename('fullpath');
[spath, ~, ~] = fileparts(sfullpath);
filename = strcat(spath, '/sample.png');
img = imread(filename);
imshow(img)
blocks = [4 4];
fprintf('\n *** Peforming LGBP feature extraction on %s split into %d by %d blocks \n', filename, blocks(1), blocks(2));
features = LGBP(rgb2gray(img), blocks);
fprintf(' *** %d by %d feature vector produced\n', size(features, 1), size(features, 2));