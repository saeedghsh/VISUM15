function [Rath_feat] = f_calcula_DTW_Rath(nom_im)

    draw_figure = 0; % if 1 -> show a figure
    do_opening = 1; % morphological opening

    elem_struct = [1;1;1;1;1];

    im_orig = imread(nom_im);
    im_orig = ~(im_orig>0);  % binary image

    im = f_enquadra_im(im_orig);  % remove borders

    % morphological closing !!!
    se = strel('disk',4);
    im_rellenada = imclose(im,se);

    [minims_i,minims_j_norm,maxims_i,maxims_j_norm, sum_vert, nforats_norm, imrot, centr_col] = f_perfil_sup_inf_sum_2im_zoning_forats(im, im_rellenada);


    if(do_opening)
        maxims_j_norm = imdilate(imerode(maxims_j_norm,elem_struct),elem_struct);
        minims_j_norm = imdilate(imerode(minims_j_norm,elem_struct),elem_struct);
    end   
         
    
    if(draw_figure==1)
        figure, imshow(im);
        figure, hold on,
        plot(maxims_j_norm,'b');  % upper
        plot(minims_j_norm,'r');  % lower
    end

    % 'im_all_info' is a matrix that stores the information
    % Dimension 1 = column of the image
    % Dimension 2 = feature vector of the column: f1,f2,f3,f4

    llarg=length(maxims_j_norm);

    Rath_feat(1:llarg, 1)= maxims_j_norm(:); % Profile sup, values (0-100)
    Rath_feat(1:llarg, 2)= minims_j_norm(:); % Profile inf, values (0-100)  
    Rath_feat(1:llarg, 3)= sum_vert(:); % Num foreground pixels, normalized(0-100)
    Rath_feat(1:llarg, 4)= nforats_norm(:); % Num holes, normalized(0-100)

