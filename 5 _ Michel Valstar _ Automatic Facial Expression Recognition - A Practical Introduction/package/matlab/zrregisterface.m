function f = zrregisterface(im, bs)
%Register face using Zhu and Ramanan's face detection results
%POST: this implementation will result in rotation artefacts, but it makes
%the code more clear. Consider it an exercise to remove the black
%triangular areas created by imrotate

    % -- Get right and left eye coordinates from the boxes
    re = [mean(bs.xy(15,[1, 3])), mean(bs.xy(15,[2,4]))];
    le = [mean(bs.xy(26,[1, 3])), mean(bs.xy(26,[2,4]))];
    nose = [mean(bs.xy(1,[1, 3])), mean(bs.xy(1,[2,4]))];
    
    % -- Scale the face
    d = sqrt(sum((re-le).^2));
    s = 100/d;
    f = imresize(im, s);
    re = s*re; % - right/left eye coords in new space
    le = s*le;
    nose = round(s*nose);
    
    % -- Center face on the nose
    f = f(nose(2)-100:nose(2)+99, nose(1)-100:nose(1)+99);
    
    % -- Determine angle with horizontal and rotate image
    alpha = atan2(-(le(2)-re(2)), le(1)-re(1));
    f = imrotate(f, -alpha*57.2958, 'crop'); % - Specify 'crop' to not change point coords
    
  
end