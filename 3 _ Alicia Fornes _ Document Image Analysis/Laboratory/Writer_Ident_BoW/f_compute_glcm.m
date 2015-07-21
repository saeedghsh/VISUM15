function glcm_values = f_compute_glcm(name_im)

% Compute the Gray-level co-occurrence matrix from the 
% connected components of the image

compute_glcm = 1;  % compute GLCM? if 0 then compute Zoning

% PARAMETERS
minimum_area = 50; % elements with small area will be removed
%glcm_offset = [0 1; -1 1; -1 0; -1 -1]; % vertical and diagonal
glcm_offset = [0 1; -1,2; -1 1; -2,1; -1 0; -1 -1; -2,-1]; %MORE ANGLES

im_in=imread(name_im);

% remove small components
im = (bwareaopen(im_in,minimum_area));

% detect the connected components
cc = bwlabel(im);
stats = regionprops(cc, 'BoundingBox');
for(i=1:max(max(cc)))
    pos = stats(i).BoundingBox;
    pos = floor(pos);
    y1=pos(1); if(y1<1) y1=1; end
    y2=pos(1)+pos(3);
    x1=pos(2); if(x1<1) x1=1; end
    x2=pos(2)+pos(4);
    
    %figure, imshow(im_in(x1:x2,y1:y2)); % plot the connected component
     
    if(compute_glcm==1)
        % Compute GLCM
        glcm = graycomatrix(im_in(x1:x2,y1:y2),'NumLevels',2,'Offset',glcm_offset);
   
        % transform matrix into a vector
        glcm_reshaped = reshape(glcm,[1,numel(glcm)]);
    	
        % normalize (sum vector =100)
        sum_vector = sum(sum(glcm_reshaped));
        glcm_reshaped_norm = 100*glcm_reshaped/sum_vector;
        glcm_values(i,1:numel(glcm)) = glcm_reshaped_norm;
       
    else
        % Compute zoning instead
        znfil = 5; zncol = 5;  % ZONING
        glcm_values(i,1:znfil*zncol) = f_zoning( im_in(x1:x2,y1:y2), znfil, zncol );
       
    end
     
end
     
