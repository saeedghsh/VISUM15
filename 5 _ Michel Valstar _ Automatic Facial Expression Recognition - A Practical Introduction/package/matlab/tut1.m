cim = imread('../data/AU12/Positive/6-50.png');
im = rgb2gray(cim);

fig = figure;
subplot(1,2,1);
imshow(cim);
subplot(1,2,2);
imshow(im);