function y = detectSmile(fn, model, m)
%DETECTSMILE - loads an image from path fn and detects a smile
%PRE: fn is the filename of a colour image
%     m is a trained mSvm model
    cim = imread(fn);
    im = rgb2gray(cim);
    bs = zrdetectface(cim, model, 0);   % - Don't visualise face det
    f = zrregisterface(im, bs);
    imshow(f);
    drawnow;
    x = LGBP(f, [4 4]);
    
    y = test(m, data(x));

end