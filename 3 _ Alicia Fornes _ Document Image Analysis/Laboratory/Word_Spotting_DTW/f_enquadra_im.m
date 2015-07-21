function [ im_retall ] = f_enquadra_im(im_in)
% Remove black borders


    suma_vertical = sum(im_in,1); posicions_vertical = find(suma_vertical>0);
    suma_horizontal = sum(im_in,2);posicions_horizontal = find(suma_horizontal>0);
    im_retall = im_in(posicions_horizontal(1):posicions_horizontal(length(posicions_horizontal)), posicions_vertical(1):posicions_vertical(length(posicions_vertical)));    

