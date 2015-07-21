function [x, y] = collectTrainingSet(d)
%PRE - d is the directory with training data, organised by having all
%positive examples in a sub-directory called 'Positive', and the negative
%examples in a sub-directory called 'Negative'

    dpos = [d, '/Positive/'];
    dneg = [d, '/Negative/'];
    
    dir_pos = dir([dpos, '*.png']);
    dir_neg = dir([dneg, '*.png']);

    % -- Load model for face detection
    load face_p146_small.mat;
    fig = figure;
    set(fig, 'Position', [216 335 1093 420]);
    
    % -- Set Gabor filter options:
    gb = [2, 3, 3, 2.1, 0.55, 1.2];
    
    n = 5664; % - Dimensionality of our features (hardcoded for speed)
    m = length(dir_pos) + length(dir_neg);
    x = zeros(m,n); % - Empty feature matrix
    y = zeros(m,1); % - Empty label matrix
    j = 0;
    for i = 1:length(dir_pos)
        j = j+1;
        fn = [dpos, dir_pos(i).name];
        cim = imread(fn);
        subplot(1, 3, 1), imshow(cim), title('Input image');
        im = rgb2gray(cim);
        [bs, posemap] = zrdetectface(cim, model, 0);   % - Don't visualise face det
        subplot(1,3,2); 
        showboxes(cim, bs(1),posemap),title('Zhu & Ramanan face detection');
        f = zrregisterface(im, bs);
        subplot(1,3,3), imshow(f), title('Registered image');        
        hold on;
        M = size(f,1);
        N = size(f,2);
        for k = 1:50:M
            Ix = [1 N];
            Iy = [k k];
            plot(Ix,Iy,'Color','w','LineStyle','-');
            plot(Ix,Iy,'Color','k','LineStyle',':');
        end

        for k = 1:50:N
            Ix = [k k];
            Iy = [1 M];
            plot(Ix,Iy,'Color','w','LineStyle','-');
            plot(Ix,Iy,'Color','k','LineStyle',':');
        end
        hold off;
        drawnow;
        x(j,:) = LGBP(f, [4 4], gb);
        y(j,1) = 1;
    end
    
    for i = 1:length(dir_neg)
        j = j+1;
        fn = [dneg, dir_neg(i).name];
        cim = imread(fn);
        subplot(1, 3, 1), imshow(cim), title('Input image');
        im = rgb2gray(cim);
        bs = zrdetectface(cim, model, 0);   % - Don't visualise face det
        subplot(1,3,2); 
        showboxes(cim, bs(1),posemap),title('Zhu & Ramanan face detection');
        f = zrregisterface(im, bs);
        subplot(1,3,3), imshow(f), title('Registered image');
        hold on;
        M = size(f,1);
        N = size(f,2);
        for k = 1:50:M
            Ix = [1 N];
            Iy = [k k];
            plot(Ix,Iy,'Color','w','LineStyle','-');
            plot(Ix,Iy,'Color','k','LineStyle',':');
        end

        for k = 1:50:N
            Ix = [k k];
            Iy = [1 M];
            plot(Ix,Iy,'Color','w','LineStyle','-');
            plot(Ix,Iy,'Color','k','LineStyle',':');
        end
        hold off;
        drawnow;
        x(j,:) = LGBP(f, [4 4], gb);
        y(j,1) = -1;
    end
    
end