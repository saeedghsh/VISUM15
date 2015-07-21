load face_p146_small.mat;

% -- 5 levels for each octave
model.interval = 5;
% -- set up the threshold
model.thresh = min(-0.65, model.thresh);

% -- define the mapping from view-specific mixture id to viewpoint
if length(model.components)==13 
    posemap = 90:-15:-90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognise this model');
end

bs = detect(cim, model, model.thresh);
bs = clipboxes(cim, bs);
bs = nms_face(bs,0.3);

figure,showboxes(cim, bs(1),posemap),title('Highest scoring detection');