function [bs posemap] = zrdetectface(im, model, show)
%PRE: path should be set up correctly, so model is found

    if (~exist('show', 'var'))
        show = 1;
    end

    % 5 levels for each octave
    model.interval = 5;
    % set up the threshold
    model.thresh = min(-0.65, model.thresh);

    % define the mapping from view-specific mixture id to viewpoint
    if length(model.components)==13
        posemap = 90:-15:-90;
    elseif length(model.components)==18
        posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
    else
        error('Can not recognize this model');
    end

    bs = detect(im, model, model.thresh);
    bs = clipboxes(im, bs);
    bs = nms_face(bs,0.3);
    
    if show
        figure,showboxes(im, bs(1),posemap),title('Highest scoring detection');
    end
    
    % - Some post-processing to simplify output for tutorial
    bs = bs(1);
    bs.xy = round(bs.xy);
end