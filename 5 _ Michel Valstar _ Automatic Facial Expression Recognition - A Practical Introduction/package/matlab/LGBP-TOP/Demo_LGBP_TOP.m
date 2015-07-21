clc;
sfullpath = mfilename('fullpath');
[spath, ~, ~] = fileparts(sfullpath);
ipath = strcat(spath, '/*.png');
ilist = dir(ipath);

blocks = [4 4];
matrix = [];

fprintf('\n *** Peforming LGBP-TOP feature extraction on the following block of images: \n');
for n = 1:numel(ilist)
	filename = strcat(spath, '/', ilist(n).name);
	fprintf('\t *** %s \n', filename);
	img = imread(filename);
	img = rgb2gray(img);
	matrix = cat(3, matrix, img);
end
fprintf(' *** %d x %d x %d matrix composed \n', size(matrix, 1), size(matrix, 2), size(matrix, 3));

features = LGBP_TOP(matrix, blocks);
fprintf(' *** %d by %d feature vector produced \n', size(features, 1), size(features, 2));