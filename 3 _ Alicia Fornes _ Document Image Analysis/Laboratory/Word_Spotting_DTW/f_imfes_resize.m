
function [im] = f_imfes_resize(im_in, znfil, zncol);

[resize_fil,resize_col] = size(im_in);

mod_col = mod(resize_col,zncol);
mod_fil = mod(resize_fil,znfil);

if(mod_col > 0)
    resize_col = resize_col + zncol - mod_col;
end

if(mod_fil > 0)
    resize_fil = resize_fil + znfil - mod_fil;
end

im = imresize(im_in,[resize_fil,resize_col]);


