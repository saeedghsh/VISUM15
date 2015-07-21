function [ f ] = LGBP( I, blocks, gb )
%LGBP - Calculates LGBP features from image I
%IN: I: grey-scale image
%    blocks: row-vector of dimension two, [nrRows nrCols] to divide image
%    into
%    gb: optional: provide gabor filter parameters (see gaborconvolve)

if ~exist('gb')
    gb = [3, 6, 3, 2.1, 0.55, 1.2];
end

mapping = getmapping(8,'u2');
gaborIms = gaborconvolve(I, gb(1), gb(2), gb(3), gb(4), gb(5), gb(6), 0);
    start = 1;
    for i = 1:size(gaborIms,1)
        for j = 1:size(gaborIms,2)
            ge = (abs(gaborIms{i,j})).^2;
            feat = blockFeatures(ge, blocks(1), blocks(2), 'lbp', mapping);
            f(start:start+length(feat)-1) = feat;
            start = start+length(feat);
        end
    end
end

